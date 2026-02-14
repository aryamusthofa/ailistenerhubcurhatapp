# STEP 3: Data Layer Implementation

**Objective:** Implement the Repositories and Data Sources defined in the Domain Layer. Connect to Firebase and the AI Router.

**Tasks for AI:**
1.  **Models (`lib/data/models/`):**
    * Create `ChatMessageModel` and `MoodEntryModel`.
    * Implement `fromJson` and `toJson` methods for Firebase/Local DB compatibility.
    * *Mapper:* Ensure generic `toEntity()` and `fromEntity()` methods exist to keep Domain layer pure.

2.  **Data Sources (`lib/data/datasources/`):**
    * `LocalDataSource`: Implement `SharedPreferences` or `Hive` to store chat history locally (Offline First approach).
    * `RemoteDataSource`: Implement `FirebaseFirestore` logic to sync encrypted backups (if enabled).
    * **AI Service (The Core):** Create `AiService`.
        * *Logic:* Input `List<ChatMessage>`, Output `String` (AI Response).
        * *Simulate:* Since we don't have the real Backend Gateway yet, create a **Mock Method** that simulates the API Call with a 2-second delay and returns a dummy empathy response.
        * *Note:* Mark where the HTTP Client (Dio/Http) will go later.

3.  **Repositories (`lib/data/repositories/`):**
    * `ChatRepositoryImpl`:
        * Implement `sendMessage`. It should:
            1. Save User Message to Local DB.
            2. Call `AiService` to get response.
            3. Catch errors! If `AiService` fails, return a specific `Failure` (e.g., `ServerFailure`).
            4. Save AI Response to Local DB.
    * `MoodRepositoryImpl`: Save and retrieve mood logs.

**Strict Constraint:**
* **NO API KEYS HERE.** Do not hardcode any string starting with `AIza` or `sk-`.
* Use `try-catch` blocks everywhere. Wrap exceptions in custom `Failure` objects (defined in Core).