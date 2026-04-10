# Corrections Log

Log reusable corrections here.

## Format

```
DATE: YYYY-MM-DD
AGENT: sentinel-*
CONTEXT: short task context
CORRECTION: what was wrong
LESSON: what to do differently next time
PROMOTE_AFTER: repeated 3x with success
```

DATE: 2026-04-10
AGENT: sentinel-qa-lead
CONTEXT: release-readiness assessment for operational tracking and map reliability
CORRECTION: Older Playwright artifacts under output/playwright were available, but they were dated 2026-04-06 and 2026-04-07 and could not be treated as evidence for the 2026-04-10 pass.
LESSON: For release-readiness calls, require current-pass browser artifacts or runtime logs tied to the exact change window; otherwise report implementation confidence only and keep release confidence blocked.
PROMOTE_AFTER: repeated 3x with success

DATE: 2026-04-10
AGENT: sentinel-security-reviewer
CONTEXT: tracking preflight review covering websocket auth, consent enforcement, and heartbeat authorization
CORRECTION: Tracking consent was enforced only in frontend localStorage/UI state, while websocket auth still accepted a query-string token fallback and the heartbeat route remained broader than the producer policy.
LESSON: For privacy-sensitive tracking flows, require server-authoritative consent for data producers, avoid query-string bearer transport on websocket upgrades, and align backend role enforcement with the real producer set instead of trusting frontend gating.
PROMOTE_AFTER: repeated 3x with success
