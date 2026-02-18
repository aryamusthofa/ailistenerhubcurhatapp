# STEP 3: Data Layer (V3 - Encrypted)

**Objective:** Implement Repositories with Military-Grade Encryption logic.

**Tasks for AI:**
1.  **Security Core (`lib/core/security/encryption_service.dart`):**
    * Create a service that generates/retrieves a **32-byte Encryption Key** using `flutter_secure_storage`.
    * This key is NEVER sent to the server. It stays on the phone.

2.  **Local Data Source (`lib/data/datasources/local/`):**
    * **Hive Setup:** Initialize Hive boxes with the encryption key from `EncryptionService`.
    * *Constraint:* If the box cannot be opened (wrong key/corrupt), fail gracefully or prompt for biometric unlock.
    * **Chat Storage:** When saving `ChatMessageModel`, it is written to the encrypted Hive box.

3.  **Remote Data Source (`lib/data/datasources/remote/`):**
    * **AI Service:**
        * Call the Cloud Function `generateResponse`.
        * **Crucial:** Do NOT implement any Firestore `.add()` or `.set()` for chat messages here. The server is for processing only, not storage.

4.  **Repositories (`lib/data/repositories/`):**
    * `ChatRepositoryImpl`:
        * `sendMessage`:
            1.  Encrypt & Save User Message Locally.
            2.  Send to Cloud Function (Ephemeral).
            3.  Receive AI Reply.
            4.  Encrypt & Save AI Reply Locally.
            5.  Return Data to UI.

**Strict Constraint:**
* Ensure `flutter_secure_storage` is configured correctly for Android (enable `encryptedSharedPreferences: true`).