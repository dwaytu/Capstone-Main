package com.sentinel.app;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.PluginMethod;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

@CapacitorPlugin(name = "BackgroundLocation")
public class BackgroundLocationPlugin extends Plugin {
    private static final int BACKGROUND_LOCATION_REQUEST = 4101;
    private static final int NOTIFICATION_REQUEST = 4102;
    private BroadcastReceiver eventReceiver;

    @Override
    public void load() {
        super.load();
        eventReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String eventName = intent.getStringExtra(BackgroundLocationService.EXTRA_EVENT_NAME);
                String rawPayload = intent.getStringExtra(BackgroundLocationService.EXTRA_PAYLOAD);
                if (eventName == null || rawPayload == null) return;
                notifyListeners(eventName, parsePayload(rawPayload));
            }
        };

        IntentFilter filter = new IntentFilter(BackgroundLocationService.ACTION_EVENT);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            getContext().registerReceiver(eventReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
        } else {
            getContext().registerReceiver(eventReceiver, filter);
        }
    }

    @Override
    protected void handleOnDestroy() {
        if (eventReceiver != null) {
            try {
                getContext().unregisterReceiver(eventReceiver);
            } catch (IllegalArgumentException ignored) {
                // The receiver may already have been removed during activity teardown.
            }
            eventReceiver = null;
        }
        super.handleOnDestroy();
    }

    @PluginMethod
    public void start(PluginCall call) {
        String apiBaseUrl = call.getString("apiBaseUrl", "").trim();
        String token = call.getString("token", "").trim();
        String userId = call.getString("userId", "").trim();
        String label = call.getString("label", "SENTINEL user").trim();
        double requiredAccuracyMeters = call.getDouble("requiredAccuracyMeters", 35.0);
        int intervalMs = call.getInt("intervalMs", 20000);

        if (apiBaseUrl.isEmpty() || token.isEmpty() || userId.isEmpty()) {
            call.reject("Background tracking requires an authenticated API configuration.", "tracking_configuration_invalid");
            return;
        }

        if (ContextCompat.checkSelfPermission(getContext(), Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            call.reject("Precise location permission is required for background tracking.", "location_permission_required");
            return;
        }

        Intent serviceIntent = new Intent(getContext(), BackgroundLocationService.class)
                .setAction(BackgroundLocationService.ACTION_START)
                .putExtra(BackgroundLocationService.EXTRA_API_BASE_URL, apiBaseUrl)
                .putExtra(BackgroundLocationService.EXTRA_TOKEN, token)
                .putExtra(BackgroundLocationService.EXTRA_USER_ID, userId)
                .putExtra(BackgroundLocationService.EXTRA_LABEL, label.isEmpty() ? "SENTINEL user" : label)
                .putExtra(BackgroundLocationService.EXTRA_REQUIRED_ACCURACY, requiredAccuracyMeters)
                .putExtra(BackgroundLocationService.EXTRA_INTERVAL_MS, Math.max(intervalMs, 15000));

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                ContextCompat.startForegroundService(getContext(), serviceIntent);
            } else {
                getContext().startService(serviceIntent);
            }
            call.resolve(BackgroundLocationService.getStatus(getContext()));
        } catch (Exception error) {
            call.reject("Unable to start Android background location service.", "tracking_service_start_failed", error);
        }
    }

    @PluginMethod
    public void stop(PluginCall call) {
        getContext().stopService(new Intent(getContext(), BackgroundLocationService.class));
        BackgroundLocationService.clearStatus(getContext());
        call.resolve();
    }

    @PluginMethod
    public void getStatus(PluginCall call) {
        call.resolve(BackgroundLocationService.getStatus(getContext()));
    }

    @PluginMethod
    public void requestBackgroundPermission(PluginCall call) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q
                || ContextCompat.checkSelfPermission(getContext(), Manifest.permission.ACCESS_BACKGROUND_LOCATION)
                == PackageManager.PERMISSION_GRANTED) {
            JSObject result = new JSObject();
            result.put("status", "granted");
            call.resolve(result);
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Intent settingsIntent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                    Uri.parse("package:" + getContext().getPackageName()));
            getActivity().startActivity(settingsIntent);
            JSObject result = new JSObject();
            result.put("status", "settings");
            call.resolve(result);
            return;
        }

        ActivityCompat.requestPermissions(getActivity(),
                new String[]{Manifest.permission.ACCESS_BACKGROUND_LOCATION},
                BACKGROUND_LOCATION_REQUEST);
        JSObject result = new JSObject();
        result.put("status", "requested");
        call.resolve(result);
    }

    @PluginMethod
    public void requestNotificationPermission(PluginCall call) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU
                || ContextCompat.checkSelfPermission(getContext(), Manifest.permission.POST_NOTIFICATIONS)
                == PackageManager.PERMISSION_GRANTED) {
            JSObject result = new JSObject();
            result.put("status", "granted");
            call.resolve(result);
            return;
        }

        ActivityCompat.requestPermissions(getActivity(),
                new String[]{Manifest.permission.POST_NOTIFICATIONS},
                NOTIFICATION_REQUEST);
        JSObject result = new JSObject();
        result.put("status", "requested");
        call.resolve(result);
    }

    private JSObject parsePayload(String rawPayload) {
        JSObject payload = new JSObject();
        try {
            JSONObject source = new JSONObject(rawPayload);
            Iterator<String> keys = source.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = source.opt(key);
                payload.put(key, value == JSONObject.NULL ? null : value);
            }
        } catch (JSONException ignored) {
            payload.put("state", "error");
            payload.put("message", "Invalid background location service event.");
        }
        return payload;
    }
}
