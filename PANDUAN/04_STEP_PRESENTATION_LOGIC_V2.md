# STEP 4: State Management (V2 - Theme Engine Focus)

**Objective:** Create Providers, specifically focusing on the complex "Theme Engine" that handles Vibes and Premium status.

**Tasks for AI:**
1.  **Theme Provider (`lib/presentation/providers/theme_provider.dart`):**
    * **State Class:** `AppThemeState`
        * `ThemeMode mode` (Light/Dark/System)
        * `String currentPreset` (e.g., 'calm_grey', 'cyberpunk', 'ocean')
        * `Color? activeGradientColor` (Dynamic color based on mood)
        * `double blurStrength` (Glass intensity)
        * `bool isLowPowerMode` (Auto-detected)
    * **Notifier:** `ThemeNotifier`
        * `setVibe(MoodType mood)`: Smoothly transitions the `activeGradientColor`.
        * `setPreset(String presetId)`: Checks if user `isPremium` (mock bool for now). If yes, switch theme.
        * `toggleLowPower()`: Disables animations in state.

2.  **Chat Provider (Standard):**
    * Maintain the logic from previous plan (Loading/Success/Error).
    * *Add:* `isTyping` boolean to trigger the "Breathing Orb" animation.

3.  **User Provider:**
    * Simple provider to store `isPremium` status (Boolean).

**Constraint:**
* Use `riverpod_annotation` (`@riverpod`) for clean code generation.
* The `ThemeNotifier` must persist the `currentPreset` to `SharedPreferences`.