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
import android.os.Build;
import android.os.IBinder;
import android.os.Looper;

import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import com.getcapacitor.JSObject;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

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

    private LocationManager locationManager;
    private ExecutorService networkExecutor;
    private SharedPreferences preferences;
    private long lastSentAt;
    private volatile boolean stopping;

    @Override
    public void onCreate() {
        super.onCreate();
        preferences = getSharedPreferences(PREFS, MODE_PRIVATE);
        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        networkExecutor = Executors.newSingleThreadExecutor();
        createNotificationChannel();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && ACTION_START.equals(intent.getAction())) {
            saveConfiguration(intent);
        }

        if (!hasConfiguration()) {
            publish("error", "Background location configuration is missing.");
            stopSelf();
            return START_NOT_STICKY;
        }

        try {
            Notification notification = buildNotification("Live location tracking is active");
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION);
            } else {
                startForeground(NOTIFICATION_ID, notification);
            }
            requestLocationUpdates();
            preferences.edit().putBoolean("running", true).putString("state", "starting").remove("message").apply();
            publish("state", null);
        } catch (SecurityException error) {
            publish("error", "Precise location permission is required for background tracking.");
            stopSelf();
        } catch (Exception error) {
            publish("error", "Android background location service could not start.");
            stopSelf();
        }

        return START_NOT_STICKY;
    }

    private void saveConfiguration(Intent intent) {
        preferences.edit()
                .putString("apiBaseUrl", intent.getStringExtra(EXTRA_API_BASE_URL))
                .putString("token", intent.getStringExtra(EXTRA_TOKEN))
                .putString("userId", intent.getStringExtra(EXTRA_USER_ID))
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
        if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
            locationManager.requestLocationUpdates(
                    LocationManager.GPS_PROVIDER, intervalMs, 0f, this, Looper.getMainLooper());
            requested = true;
        }
        if (locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
            locationManager.requestLocationUpdates(
                    LocationManager.NETWORK_PROVIDER, intervalMs, 0f, this, Looper.getMainLooper());
            requested = true;
        }

        if (!requested) {
            throw new IllegalStateException("Device location is disabled.");
        }
    }

    @Override
    public void onLocationChanged(Location location) {
        if (stopping || location == null) return;

        float accuracy = location.hasAccuracy() ? location.getAccuracy() : Float.POSITIVE_INFINITY;
        double requiredAccuracy = preferences.getFloat("requiredAccuracyMeters", 35.0f);
        long now = System.currentTimeMillis();
        if (accuracy > requiredAccuracy) {
            updateLastLocation(location, accuracy);
            publish("error", String.format(Locale.US,
                    "Location fix is too broad for precise tracking (%dm; required <= %dm).",
                    Math.round(accuracy), Math.round(requiredAccuracy)));
            return;
        }
        if (now - lastSentAt < preferences.getLong("intervalMs", 20000)) return;

        lastSentAt = now;
        updateLastLocation(location, accuracy);
        networkExecutor.execute(() -> sendHeartbeat(location, accuracy));
    }

    private void sendHeartbeat(Location location, float accuracy) {
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
            payload.put("status", "active");
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
            connection.setRequestProperty("Authorization", "Bearer " + preferences.getString("token", ""));
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");

            byte[] body = payload.toString().getBytes(StandardCharsets.UTF_8);
            try (OutputStream output = connection.getOutputStream()) {
                output.write(body);
            }

            int responseCode = connection.getResponseCode();
            String responseBody = readResponse(responseCode >= 400 ? connection.getErrorStream() : connection.getInputStream());
            JSONObject response = responseBody.isEmpty() ? new JSONObject() : new JSONObject(responseBody);

            if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED
                    || responseCode == HttpURLConnection.HTTP_FORBIDDEN) {
                publish("error", "Background tracking paused because authorization or location consent is no longer valid.");
                clearStatus(this);
                stopSelf();
                return;
            }

            if (responseCode < 200 || responseCode >= 300) {
                publish("error", "Background location heartbeat could not be delivered; retrying on the next fix.");
                return;
            }

            if (!response.optBoolean("accepted", true)) {
                publish("error", "Location sample was rejected because its precision is insufficient.");
                return;
            }

            String timestamp = Instant.now().toString();
            preferences.edit().putString("lastHeartbeatAt", timestamp).putString("state", "active").remove("message").apply();
            updateNotification("Last location update " + timestamp.substring(11, 19) + " UTC");
            publish("heartbeat", null);
        } catch (Exception error) {
            publish("error", "Background location heartbeat is temporarily unavailable; retrying.");
        } finally {
            if (connection != null) connection.disconnect();
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
        result.put("message", prefs.getString("message", null));
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
        if (locationManager != null) locationManager.removeUpdates(this);
        if (networkExecutor != null) networkExecutor.shutdownNow();
        if (preferences != null) preferences.edit().putBoolean("running", false).putString("state", "stopped").apply();
        stopForeground(true);
        publish("state", null);
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
