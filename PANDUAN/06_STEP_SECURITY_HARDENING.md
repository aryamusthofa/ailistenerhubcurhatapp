# STEP 6: Security Hardening (The "Paranoid" Features)

**Objective:** Lock down the app interface and protect against physical snooping.

**Tasks for AI:**
1.  **Screen Shield (`lib/core/security/screen_shield.dart`):**
    * Use `flutter_windowmanager` (Android) to set `FLAG_SECURE`.
    * *Effect:* Prevents screenshots, screen recording, and shows a black screen when the app is viewed in the "Recent Apps" switcher.

2.  **Biometric Lock (`lib/presentation/screens/auth/biometric_gate.dart`):**
    * Use `local_auth` package.
    * Create a "Gate" widget that sits on top of the app when opened.
    * Require FaceID/Fingerprint to reveal the Chat Screen.
    * *Setting:* Allow user to toggle this in Settings.

3.  **Panic Mode / Data Wipe:**
    * Create a function `wipeEverything()` in `SecurityService`.
    * *Action:*
        1.  Delete all Hive Boxes.
        2.  Delete Encryption Keys from Secure Storage.
        3.  Logout Firebase.
    * *UI:* Add a "Danger Zone" button in settings (Red Button) to trigger this.

**Constraint:**
* The "Screen Shield" must be active by default in the `main.dart` initialization.
* Biometric auth must handle errors (e.g., user has no fingerprint set) by falling back to device PIN or asking to set one.