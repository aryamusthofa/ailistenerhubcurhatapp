# STEP 4: State Management (Riverpod)

**Objective:** Create Providers to manage the app state using Riverpod 2.0+ (Annotation syntax preferred if you can, otherwise standard StateNotifier).

**Tasks for AI:**
1.  **Chat Provider (`lib/presentation/providers/chat_provider.dart`):**
    * Create a `ChatState` class (properties: `isLoading`, `messages` List, `errorMessage`).
    * Create `ChatNotifier` (extends `StateNotifier` or `AsyncNotifier`).
    * *Methods:*
        * `sendMessage(String text)`: Update state to loading -> call UseCase -> update state with new message -> handle error.
        * `loadHistory()`: Fetch messages from Repository on init.
        * `clearChat()`: Wipe history.

2.  **Mood Provider (`lib/presentation/providers/mood_provider.dart`):**
    * Manage the currently selected "Vibe" (Empathetic, Logical, etc.).
    * Save user's daily mood.

3.  **Theme Provider (`lib/presentation/providers/theme_provider.dart`):**
    * Manage toggle between Dark, Light, and "Calming Grey" modes.
    * Persist this choice using `SharedPreferences`.

**Constraint:**
* Separation of concerns: The UI (Widgets) should NEVER call the Repository directly. They must talk to the Provider/Controller.
* Use `AsyncValue` to handle loading/error states in the UI easily.