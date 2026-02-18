# STEP 2: Domain Layer (Business Logic)

**Objective:** Define the Entities and Use Cases. This is the "Brain" of the application.

**Tasks for AI:**
1.  **Entities (`lib/domain/entities/`):**
    * `MoodEntry`: Fields for id, timestamp, moodType (enum), note.
    * `ChatMessage`: Fields for id, content, sender (user/ai), timestamp, isEncrypted (bool).
    * `UserProfile`: Fields for id, isAnonymous, preferredTheme.
2.  **Repositories Interfaces (`lib/domain/repositories/`):**
    * `IChatRepository`: Methods like `sendMessage(String message)`, `getChatHistory()`, `clearHistory()`.
    * `IMoodRepository`: Methods like `logMood(MoodEntry entry)`, `getMoodHistory()`.
    * `IAuthRepository`: Methods like `signInAnonymously()`, `signOut()`.
3.  **Use Cases (`lib/domain/usecases/`):**
    * Create a simple use case example: `SendMessageUseCase`.

**Constraint:**
* Write PURE DART code only. No Flutter Widgets, no Firebase specific code yet.
* This layer must be independent of any external library (except standard Dart types).