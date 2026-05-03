# Concerns and Risks

## Operational Risks

- Backend endpoint parity may differ across deployments for some features (ex: shift-swap feeds).
- Auth/rate-limit/proxy configuration drift can break smoke checks if not environment-aligned.

## UX Risks

- Mobile shell/layout regressions can impact elevated-role usability.
- Guard-critical surfaces (SOS/contact/map/offline queue) require strict accessibility and reliability.

## Delivery Risks

- Cross-platform release artifacts depend on platform-specific toolchains and signing configs.
- Incomplete objective evidence mapping can weaken capstone defense even when code works.

## Process Risks

- Feature creep beyond capstone objectives introduces instability and proposal misalignment.
