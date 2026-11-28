package com.sentinel.app;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.pm.ServiceInfo;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.Network;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.SystemClock;

import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import com.getcapacitor.JSObject;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;

public class BackgroundLocationService extends Service implements LocationListener {
    public static final String ACTION_START = "com.sentinel.app.background_location.START";
    public static final String ACTION_EVENT = "com.sentinel.app.background_location.EVENT";
    public static final String EXTRA_EVENT_NAME = "eventName";
    public static final String EXTRA_PAYLOAD = "payload";
    public static final String EXTRA_API_BASE_URL = "apiBaseUrl";
    public static final String EXTRA_TOKEN = "token";
    public static final String EXTRA_USER_ID = "userId";
    public static final String EXTRA_LABEL = "label";
    public static final String EXTRA_REQUIRED_ACCURACY = "requiredAccuracyMeters";
    public static final String EXTRA_INTERVAL_MS = "intervalMs";

    private static final String PREFS = "sentinel_background_location";
    private static final String CHANNEL_ID = "sentinel_location_tracking";
    private static final int NOTIFICATION_ID = 4103;
    private static final long MAX_FIX_AGE_MS = 45000;

    private LocationManager locationManager;
    private ExecutorService networkExecutor;
    private SharedPreferences preferences;
    private ConnectivityManager connectivityManager;
    private ConnectivityManager.NetworkCallback networkCallback;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final AtomicBoolean sending = new AtomicBoolean();
    private Location recentFix;
    private long lastSentAt;
    private volatile String rejectedToken;
    private volatile boolean stopping;
    private final Runnable fixMonitor = new Runnable() {
        @Override
        public void run() {
            if (stopping) return;
            if (locationEnabled() && !isFresh(recentFix) && rejectedToken == null) {
                reportProblem("gps_wait", "Waiting for a fresh GPS fix. Move to an open area and keep Precise Location enabled.");
            }
            handler.postDelayed(this, 20000);
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
        preferences = getSharedPreferences(PREFS, MODE_PRIVATE);
        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        networkExecutor = Executors.newSingleThreadExecutor();
        createNotificationChannel();
        connectivityManager = (ConnectivityManager) getSystemService(CONNECTIVITY_SERVICE);
        if (connectivityManager != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            networkCallback = new ConnectivityManager.NetworkCallback() {
                @Override
                public void onAvailable(Network network) {
                    handler.post(() -> {
                        lastSentAt = 0;
                        if (isFresh(recentFix)) onLocationChanged(recentFix);
                    });
                }
            };
            connectivityManager.registerDefaultNetworkCallback(networkCallback);
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && ACTION_START.equals(intent.getAction())) {
            saveConfiguration(intent);
            if (!preferences.getString("token", "").equals(rejectedToken)) rejectedToken = null;
            lastSentAt = 0;
        }

        if (!hasConfiguration()) {
            reportProblem("configuration_required", "Open SENTINEL and sign in to start location tracking.");
            stopSelf();
            return START_NOT_STICKY;
        }

        try {
            Notification notification = buildNotification("Waiting for a precise location update");
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION);
            } else {
                startForeground(NOTIFICATION_ID, notification);
            }
            requestLocationUpdates();
            preferences.edit().putBoolean("running", true).apply();
            if (locationEnabled()) {
                reportProblem("gps_wait", "Waiting for a fresh GPS fix. Move to an open area and keep Precise Location enabled.");
            } else {
                reportProblem("location_disabled", "Turn on device location to resume tracking.");
            }
            handler.removeCallbacks(fixMonitor);
            handler.postDelayed(fixMonitor, 20000);
        } catch (SecurityException error) {
            reportProblem("permission_required", "Allow Precise Location in Android app settings to resume tracking.");
            stopSelf();
        } catch (Exception error) {
            reportProblem("service_unavailable", "Open SENTINEL and retry location to restart Android tracking.");
            stopSelf();
        }

        return START_NOT_STICKY;
    }

    private void saveConfiguration(Intent intent) {
        String userId = intent.getStringExtra(EXTRA_USER_ID);
        if (!preferences.getString("userId", "").equals(userId)) {
            preferences.edit().clear().apply();
            recentFix = null;
        }
        preferences.edit()
                .putString("apiBaseUrl", intent.getStringExtra(EXTRA_API_BASE_URL))
                .putString("token", intent.getStringExtra(EXTRA_TOKEN))
                .putString("userId", userId)
                .putString("label", intent.getStringExtra(EXTRA_LABEL))
                .putFloat("requiredAccuracyMeters", (float) intent.getDoubleExtra(EXTRA_REQUIRED_ACCURACY, 35.0))
                .putLong("intervalMs", Math.max(intent.getIntExtra(EXTRA_INTERVAL_MS, 20000), 15000))
                .apply();
    }

    private boolean hasConfiguration() {
        return !preferences.getString("apiBaseUrl", "").trim().isEmpty()
                && !preferences.getString("token", "").trim().isEmpty()
                && !preferences.getString("userId", "").trim().isEmpty();
    }

    private void requestLocationUpdates() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            throw new SecurityException("Fine location permission is missing");
        }

        long intervalMs = preferences.getLong("intervalMs", 20000);
        boolean requested = false;
        locationManager.removeUpdates(this);
        if (locationManager.getAllProviders().contains(LocationManager.GPS_PROVIDER)) {
            locationManager.requestLocationUpdates(
                    LocationManager.GPS_PROVIDER, intervalMs, 0f, this, Looper.getMainLooper());
            requested = true;
        }
        if (locationManager.getAllProviders().contains(LocationManager.NETWORK_PROVIDER)) {
            locationManager.requestLocationUpdates(
                    LocationManager.NETWORK_PROVIDER, intervalMs, 0f, this, Looper.getMainLooper());
            requested = true;
        }

        if (!requested) {
            throw new IllegalStateException("Device location is disabled.");
        }
    }

    private boolean locationEnabled() {
        return locationManager != null && (
                locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
                || locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER));
    }

    private static boolean isFresh(Location location) {
        if (location == null) return false;
        long ageMs = (SystemClock.elapsedRealtimeNanos() - location.getElapsedRealtimeNanos()) / 1000000;
        return ageMs >= 0 && ageMs <= MAX_FIX_AGE_MS;
    }

    @Override
    public void onProviderDisabled(String provider) {
        if (!locationEnabled()) {
            recentFix = null;
            reportProblem("location_disabled", "Turn on device location to resume tracking.");
        }
    }

    @Override
    public void onProviderEnabled(String provider) {
        lastSentAt = 0;
        if (!isFresh(recentFix) && rejectedToken == null) {
            reportProblem("gps_wait", "Waiting for a fresh GPS fix. Move to an open area and keep Precise Location enabled.");
        }
    }

    @Override
    public void onLocationChanged(Location location) {
        if (stopping || !isFresh(location)) return;
        String token = preferences.getString("token", "");
        if (token.isEmpty() || token.equals(rejectedToken)) return;

        float accuracy = location.hasAccuracy() ? location.getAccuracy() : Float.POSITIVE_INFINITY;
        if (Float.isNaN(accuracy) || Float.isInfinite(accuracy) || accuracy <= 0 || accuracy > 5000) {
            reportProblem("low_accuracy", "The phone sent an approximate reading. Enable Precise Location and move to an open area.");
            return;
        }
        recentFix = new Location(location);
        long now = SystemClock.elapsedRealtime();
        if (lastSentAt != 0 && now - lastSentAt < preferences.getLong("intervalMs", 20000)) return;
        if (!sending.compareAndSet(false, true)) return;

        lastSentAt = now;
        updateLastLocation(location, accuracy);
        Location sample = recentFix;
        networkExecutor.execute(() -> {
            try {
                if (isFresh(sample) && !stopping && token.equals(preferences.getString("token", ""))) {
                    sendHeartbeat(sample, accuracy, token);
                }
            } finally {
                sending.set(false);
            }
        });
    }

    private void sendHeartbeat(Location location, float accuracy, String token) {
        HttpURLConnection connection = null;
        try {
            String apiBaseUrl = preferences.getString("apiBaseUrl", "").replaceAll("/+$", "");
            URL endpoint = new URL(apiBaseUrl + "/api/tracking/heartbeat");
            if (!"https".equalsIgnoreCase(endpoint.getProtocol())
                    && !"localhost".equalsIgnoreCase(endpoint.getHost())
                    && !"10.0.2.2".equals(endpoint.getHost())) {
                throw new IllegalArgumentException("Background tracking API must use HTTPS.");
            }

            JSONObject payload = new JSONObject();
            payload.put("entityType", "user");
            payload.put("entityId", preferences.getString("userId", ""));
            payload.put("label", preferences.getString("label", "SENTINEL user"));
            payload.put("status", "gps");
            payload.put("latitude", location.getLatitude());
            payload.put("longitude", location.getLongitude());
            payload.put("accuracyMeters", accuracy);
            payload.put("heading", location.hasBearing() ? location.getBearing() : JSONObject.NULL);
            payload.put("speedKph", location.hasSpeed() ? location.getSpeed() * 3.6 : JSONObject.NULL);

            connection = (HttpURLConnection) endpoint.openConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(10000);
            connection.setDoOutput(true);
            connection.setRequestProperty("Authorization", "Bearer " + token);
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");

            byte[] body = payload.toString().getBytes(StandardCharsets.UTF_8);
            try (OutputStream output = connection.getOutputStream()) {
                output.write(body);
            }

            int responseCode = connection.getResponseCode();
            String responseBody = readResponse(responseCode >= 400 ? connection.getErrorStream() : connection.getInputStream());
            if (stopping || !token.equals(preferences.getString("token", ""))) return;
            JSONObject response = parseResponse(responseBody);
            String code = response.optString("code", "");
            if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                rejectedToken = token;
                reportProblem("authentication_required", "Open SENTINEL to renew your session and resume location updates.");
                return;
            }
            if (responseCode == HttpURLConnection.HTTP_FORBIDDEN
                    && "tracking_consent_required".equals(code)) {
                reportProblem(code, "Allow location tracking in SENTINEL to resume location updates.");
                preferences.edit().remove("token").apply();
                stopSelf();
                return;
            }

            if (responseCode < 200 || responseCode >= 300) {
                reportProblem("delivery_failed", "SENTINEL could not accept your location. Check your connection and retry in the app.");
                return;
            }

            if (!response.has("accepted")) {
                reportProblem("delivery_failed", "SENTINEL returned an unexpected location response. Retry location in the app.");
                return;
            }
            if (!response.optBoolean("accepted") || response.optBoolean("approximate")) {
                double required = response.optDouble("requiredAccuracyMeters", Double.NaN);
                String message = !Double.isNaN(required) && !Double.isInfinite(required)
                        ? String.format(Locale.US, "Location accuracy is about %.0f m. SENTINEL requires %.0f m or better. Move to an open area.", accuracy, required)
                        : "SENTINEL requires a precise location. Move to an open area and check Precise Location.";
                reportProblem("low_accuracy", message);
                return;
            }

            SimpleDateFormat utc = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US);
            utc.setTimeZone(TimeZone.getTimeZone("UTC"));
            String timestamp = response.optString("recordedAt", utc.format(new Date()));
            preferences.edit().putString("lastHeartbeatAt", timestamp).putString("state", "active").remove("message").remove("code").apply();
            updateNotification("Precise location sent to SENTINEL");
            publish("heartbeat", null);
        } catch (Exception error) {
            if (!stopping && token.equals(preferences.getString("token", ""))) {
                reportProblem("network_unavailable", "Could not reach SENTINEL. Check your connection. Tracking will retry when you reconnect.");
            }
        } finally {
            if (connection != null) connection.disconnect();
        }
    }

    private JSONObject parseResponse(String body) {
        try {
            return new JSONObject(body);
        } catch (JSONException ignored) {
            return new JSONObject();
        }
    }

    private String readResponse(InputStream stream) {
        if (stream == null) return "";
        StringBuilder result = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) result.append(line);
        } catch (Exception ignored) {
            return "";
        }
        return result.toString();
    }

    private void updateLastLocation(Location location, float accuracy) {
        preferences.edit()
                .putFloat("lastLatitude", (float) location.getLatitude())
                .putFloat("lastLongitude", (float) location.getLongitude())
                .putFloat("lastAccuracyMeters", accuracy)
                .apply();
        publish("location", null);
    }

    private void publish(String eventName, String message) {
        if (message != null) preferences.edit().putString("message", message).putString("state", "error").apply();
        Intent event = new Intent(ACTION_EVENT)
                .setPackage(getPackageName())
                .putExtra(EXTRA_EVENT_NAME, eventName)
                .putExtra(EXTRA_PAYLOAD, getStatus(this).toString());
        sendBroadcast(event);
    }

    private void updateNotification(String message) {
        NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        if (manager != null) manager.notify(NOTIFICATION_ID, buildNotification(message));
    }

    private void reportProblem(String code, String message) {
        if (stopping) return;
        if ("error".equals(preferences.getString("state", ""))
                && code.equals(preferences.getString("code", "")) && message.equals(preferences.getString("message", ""))) return;
        preferences.edit().putString("code", code).apply();
        publish("error", message);
    }

    private Notification buildNotification(String message) {
        Intent launchIntent = getPackageManager().getLaunchIntentForPackage(getPackageName());
        PendingIntent pendingIntent = launchIntent == null ? null : PendingIntent.getActivity(
                this, 0, launchIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(com.sentinel.app.R.mipmap.ic_launcher)
                .setContentTitle("SENTINEL location tracking")
                .setContentText(message)
                .setOngoing(true)
                .setCategory(NotificationCompat.CATEGORY_SERVICE)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setOnlyAlertOnce(true);
        if (pendingIntent != null) builder.setContentIntent(pendingIntent);
        return builder.build();
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return;
        NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID, "Location tracking", NotificationManager.IMPORTANCE_LOW);
        channel.setDescription("Shows when SENTINEL is sending foreground location updates.");
        NotificationManager manager = getSystemService(NotificationManager.class);
        if (manager != null) manager.createNotificationChannel(channel);
    }

    public static JSObject getStatus(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS, MODE_PRIVATE);
        JSObject result = new JSObject();
        result.put("running", prefs.getBoolean("running", false));
        result.put("state", prefs.getString("state", "stopped"));
        result.put("userId", prefs.getString("userId", null));
        result.put("message", prefs.getString("message", null));
        result.put("code", prefs.getString("code", null));
        result.put("lastHeartbeatAt", prefs.getString("lastHeartbeatAt", null));
        result.put("lastLatitude", prefs.contains("lastLatitude") ? prefs.getFloat("lastLatitude", 0f) : null);
        result.put("lastLongitude", prefs.contains("lastLongitude") ? prefs.getFloat("lastLongitude", 0f) : null);
        result.put("lastAccuracyMeters", prefs.contains("lastAccuracyMeters") ? prefs.getFloat("lastAccuracyMeters", 0f) : null);
        return result;
    }

    public static void clearStatus(Context context) {
        context.getSharedPreferences(PREFS, MODE_PRIVATE).edit().clear().apply();
    }

    @Override
    public void onDestroy() {
        stopping = true;
        handler.removeCallbacksAndMessages(null);
        if (connectivityManager != null && networkCallback != null) connectivityManager.unregisterNetworkCallback(networkCallback);
        if (locationManager != null) locationManager.removeUpdates(this);
        if (networkExecutor != null) networkExecutor.shutdownNow();
        if (preferences != null) {
            boolean errored = "error".equals(preferences.getString("state", ""));
            preferences.edit().putBoolean("running", false).putString("state", errored ? "error" : "stopped").apply();
        }
        stopForeground(true);
        publish("state", null);
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
