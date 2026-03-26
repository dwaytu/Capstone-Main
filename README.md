# SENTINEL Capstone Main

SENTINEL is a full-stack security operations and asset management platform with a shared React frontend and platform wrappers for web, desktop, and Android.

## Repository Layout

- `DasiaAIO-Frontend/`: React + TypeScript + Vite application.
- `DasiaAIO-Backend/`: Rust + Axum + PostgreSQL API.
- `apps/desktop-tauri/`: Tauri desktop wrapper.
- `apps/android-capacitor/`: Capacitor Android wrapper.
- `.github/`: custom Copilot agents, instructions, and skills.

## Quick Start

### 1. Install dependencies

```bash
npm install
npm install --prefix DasiaAIO-Frontend
```

### 2. Run frontend locally

```bash
npm run dev --prefix DasiaAIO-Frontend
```

### 3. Run backend locally

```bash
cd DasiaAIO-Backend
cargo run
```

## Build and Release Commands

Run from repository root:

```bash
npm run build:web
npm run build:desktop
npm run build:android
```

Release wrappers and web build:

```bash
npm run release:web
npm run release:desktop
npm run release:android
npm run release:all
```

## Copilot Customization Notes

Desktop and mobile development support includes:

- Agent: `.github/agents/playwright-tester.agent.md`
- Skill: `.github/skills/winapp-cli/SKILL.md`
- Skill: `.github/skills/msstore-cli/SKILL.md`
- Skill: `.github/skills/scoutqa-test/SKILL.md`

## Documentation

- Main docs: https://cloudyrowdyyy.github.io/capstone-1.0
- System guide: `CHATGPT_SYSTEM_GUIDE.md`
- Capstone paper: `SENTINEL - Group 8.md`
