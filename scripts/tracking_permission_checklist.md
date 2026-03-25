# Tracking Permission Checklist

Use this quick checklist for manual geolocation permission validation.

1. Open the HTTPS app URL on the target device.
2. Log in with a test account.
3. Verify the banner shows when location is not granted:
   - `Location access is not active.`
   - `Prompt Location Access` button present.
4. Tap `Prompt Location Access`.
5. Confirm browser OS prompt appears and grant permission.
6. Verify banner disappears after permission becomes `granted`.
7. Open Operational Map and confirm marker popup trust indicators:
   - `Source`
   - `Accuracy`
   - `Updated: Xs ago`
8. Confirm stale points are auto-hidden and `stale hidden` count is shown when applicable.
