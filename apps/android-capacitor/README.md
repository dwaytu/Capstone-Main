# SENTINEL Android (Capacitor)

This app wraps the existing React frontend from ../../DasiaAIO-Frontend.

## Prerequisites

- Node.js 20+
- Android Studio
- Android SDK configured

## First-time setup

1. Install dependencies:
   npm install
2. Build web assets with mobile mode:
   npm run build --prefix ../../DasiaAIO-Frontend -- --mode mobile
3. Add Android platform:
   npm run add:android
4. Sync assets:
   npm run sync
5. Open Android Studio project:
   npm run open

## Daily build flow

1. npm run build
2. npm run open

## Environment

The frontend reads API base URL from ../../DasiaAIO-Frontend/.env.mobile.
Default local emulator mapping uses http://10.0.2.2:5000 (host machine loopback).
If needed, override with LAN host in a local mode file (for example http://192.168.1.25:5000).

## Production Notes

- Android manifest includes network, precise/coarse location, background location, foreground-service location, and notification permissions. Location and notification access are requested at runtime where Android requires it.
- GPS permission is requested at runtime via Capacitor Geolocation before heartbeat tracking.
- Android background tracking runs through a visible location foreground service after the user accepts legal consent and precise location permission. The service sends heartbeat updates directly to the authenticated API, stops on logout/consent or authorization failure, and uses `START_NOT_STICKY` so stale sessions are not silently resurrected. Android may still restrict location for battery-saver/OEM policies, and the user must keep device location enabled.
- Build outputs are generated from shared frontend assets so web/mobile/desktop stay API-compatible.
