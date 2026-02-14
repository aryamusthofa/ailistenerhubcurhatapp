*(Gunakan ini untuk generate struktur folder, tema, dan routing dasar. Ini fondasi tiang pancangnya.)*

```markdown
# STEP 1: Foundation & Core Setup

**Objective:** Initialize the project structure, theme, and basic routing based on `00_MASTER_BLUEPRINT.md`.

**Tasks for AI:**
1.  **Folder Creation:** Confirm the creation of the `lib/core`, `lib/data`, `lib/domain`, `lib/presentation` structure.
2.  **Dependencies:** List the required packages for `pubspec.yaml` (riverpod, go_router, google_fonts, flutter_dotenv, etc.).
3.  **Core Files Implementation:**
    * `lib/core/theme/app_theme.dart`: Create a standard `ThemeData` factory.
        * *Requirement:* Define 3 modes: Light, Dark, and a specific "Calming Grey" mode.
        * *Font:* Use `GoogleFonts.poppins`.
    * `lib/core/constants/app_constants.dart`: Define collection names (e.g., 'users', 'chat_logs') and UI strings.
    * `lib/presentation/navigation/app_router.dart`: Setup `GoRouter` with basic routes:
        * `/` (Splash/Loading)
        * `/onboarding` (For first time users)
        * `/home` (Main dashboard)
        * `/chat` (Venting room)
    * `lib/main.dart`: Wire everything up. Initialize Riverpod `ProviderScope` and use `MaterialApp.router`.

**Constraint:**
* Do not build the actual Chat UI yet. Just placeholders (Scaffold with "Page Name" text).
* Ensure the code compiles without errors.