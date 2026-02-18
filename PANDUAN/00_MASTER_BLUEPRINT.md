# MASTER BLUEPRINT: AI Listener Hub (Project Curhat)

## 1. Project Identity
* **App Name:** AI Listener Hub
* **Core Philosophy:** A safe, private, anonymous space for venting. Mood-first approach.
* **Target Device:** Mid-range Android (Optimized for 4GB-8GB RAM dev environment).
* **Tone of Voice:** Calming, Empathetic, Non-judgmental.

## 2. Technical Stack (LOCKED - DO NOT CHANGE)
* **Language:** Dart (Latest Stable)
* **Framework:** Flutter (Latest Stable)
* **Architecture:** Clean Architecture (Data, Domain, Presentation layers).
* **State Management:** Flutter Riverpod (latest version with Code Generation/Annotations if possible, or standard Provider).
* **Routing:** GoRouter.
* **Backend:** Firebase (Auth, Firestore, Cloud Functions).
* **AI Integration:** Backend-side AI Router (Gemini/Grok fallback system). **NO API KEYS IN FLUTTER CODE.**

## 3. Directory Structure (Strict Enforcement)
```text
lib/
├── core/               # App-wide constants, themes, utils, failures
│   ├── constants/      # Strings, API endpoints (base urls only)
│   ├── theme/          # AppTheme, Colors, TextStyles (Google Fonts)
│   └── utils/          # Date formatters, Validators
├── data/               # Implementation of repositories & data sources
│   ├── datasources/    # Remote (Firebase/API) & Local (Hive/SharedPreferences)
│   ├── models/         # JSON serializable classes (extending Domain Entities)
│   └── repositories/   # Implementation of Domain Repositories
├── domain/             # Pure business logic (No Flutter UI code here)
│   ├── entities/       # Plain Dart objects (e.g., ChatMessage, UserMood)
│   ├── repositories/   # Abstract Interfaces
│   └── usecases/       # Single responsibility business logic classes
└── presentation/       # UI & State
    ├── providers/      # Riverpod Providers
    ├── screens/        # Full Page Widgets (Home, Chat, Settings)
    ├── widgets/        # Reusable UI Components
    └── navigation/     # GoRouter configuration

## AI Robustness Strategy (CRITICAL)
* **Multi-Engine Support:** The app must support switching between AI Models (e.g., Gemini -> Grok) seamlessly.
* **Fallback Logic:** If the primary AI fails or times out, the `Repository` must automatically try the secondary AI without the user noticing.
* **Latency Handling:** Show a "Thinking..." animation while waiting for the AI response to keep the user calm.