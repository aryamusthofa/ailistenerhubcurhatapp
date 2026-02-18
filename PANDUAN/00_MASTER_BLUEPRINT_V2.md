# MASTER BLUEPRINT V2: AI Listener Hub (Project Curhat)

## 1. Project Identity (UPDATED)
* **App Name:** AI Listener Hub
* **Core Philosophy:** "A Living Space." The UI breathes and adapts. It is not just a chat tool; it is an atmospheric sanctuary.
* **Visual Style:** **Aurora & Glassmorphism**.
    * *Background:* Subtle, moving gradients (Aurora) that reflect the mood.
    * *Elements:* Frosted glass effects (Blur + Translucency) for bubbles/cards to keep it airy.
    * *Animation:* "Breathing" indicators (Orb) instead of static loaders.
* **Monetization Model:** **Freemium Cosmetic.**
    * Core Features (Curhat, AI, Safety) = **FREE**.
    * Premium Features = Cyberpunk Themes, Nature Sounds, Custom Wallpapers.

## 2. Technical Stack (LOCKED)
* **Language:** Dart (Latest Stable)
* **Framework:** Flutter (Latest Stable)
* **State Management:** Flutter Riverpod (Annotation/Code Gen preferred).
* **Architecture:** Clean Architecture.
* **UI/FX Packages:** `flutter_animate` (for breathing fx), `mesh_gradient` (for aurora), `google_fonts`.
* **Backend:** Firebase (Auth, Firestore).
* **AI Engine:** Dual-Layer (Gemini Main -> Grok Fallback).

## 3. Theme & Safety Protocol (CRITICAL)
* **Theme Engine:**
    * Must support **Dynamic Vibe Switching** (Sad -> Blue/Purple, Happy -> Peach/Gold).
    * Must support **Performance Guard**: Automatically disable complex animations on low-end devices or Low Battery (<20%).
* **Privacy Guard:**
    * Custom wallpapers must be stored in `ApplicationDocumentsDirectory` (Sandbox), NEVER in public gallery.
    * No analytics on Chat Content.

## 4. Directory Structure Updates
* `lib/core/theme/`: Now includes `palettes/` and `animators/`.
* `lib/presentation/widgets/fx/`: Folder for specific visual effects (GlassContainer, AuroraBackground).