# STEP 1: Foundation & Core Setup (V2 - Visual Upgrade)

**Objective:** Initialize the project structure with support for High-Fidelity UI (Animations & Gradients).

**Tasks for AI:**
1.  **Dependencies (`pubspec.yaml`):**
    * Add standard: `flutter_riverpod`, `riverpod_annotation`, `go_router`, `google_fonts`, `shared_preferences`, `flutter_dotenv`.
    * **Add Visual FX:**
        * `flutter_animate`: For simple declarative animations (fade, scale, shimmer).
        * `mesh_gradient` (or `simple_gradient_text`): For the Aurora background effects.
        * `glassmorphism_ui` (optional, or manual implementation): For frosted glass effect.

2.  **Core Files Implementation:**
    * `lib/core/theme/app_theme.dart`:
        * Setup `ThemeData` but focus on **TextStyles** (Poppins).
        * Define `AppColors` that support the "Psychological Palettes" (Sage Green, Lavender, Warm Grey).
    * `lib/core/utils/device_utils.dart`:
        * Create a utility to check Device Performance (Low Power Mode / Low RAM simulation) to toggle animations later.

3.  **Folder Structure Expansion:**
    * Create `lib/presentation/widgets/fx/` (For Aurora/Glass components).
    * Create `lib/presentation/providers/theme/` (Separated theme logic).

**Constraint:**
* Ensure `flutter doctor` runs clean after adding dependencies.
* Set `useMaterial3: true` in `ThemeData`.