# SENTINEL Desktop (Tauri)

This app wraps the existing React frontend from ../../DasiaAIO-Frontend.

## Prerequisites

- Rust toolchain (stable)
- Node.js 20+
- Visual Studio C++ Build Tools (for Windows bundles)

## Build flow

1. Build frontend desktop assets:
   npm run build:desktop --prefix ../../DasiaAIO-Frontend
2. Build desktop installer:
   npm run tauri:build

## Development flow

1. Start frontend dev server in another terminal:
   npm run dev --prefix ../../DasiaAIO-Frontend
2. Start Tauri shell:
   npm run tauri:dev

## Environment

Desktop API host comes from ../../DasiaAIO-Frontend/.env.desktop.

## Auto-Update Configuration

Tauri updater is enabled for production builds.

Set these environment variables before packaging:

- `TAURI_UPDATER_PUBLIC_KEY`: updater signing public key
- `TAURI_UPDATER_ENDPOINT`: updater manifest endpoint URL

During runtime, SENTINEL checks for new versions and allows one-click install with automatic app relaunch.
