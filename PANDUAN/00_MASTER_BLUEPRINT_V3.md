# MASTER BLUEPRINT V3: AI Listener Hub (Secure Edition)

## 1. Project Identity
* **App Name:** AI Listener Hub
* **Security Philosophy:** **"Zero-Knowledge & Ephemeral."**
    * Even the developer cannot read user chats.
    * No chat logs are stored on the Backend/Server.
    * All history is Local-Only and Encrypted (AES-256).
* **Visual Style:** Aurora & Glassmorphism (Living UI).

## 2. Technical Stack (Security Locked)
* **Storage:** `hive` (NoSQL) with `hive_flutter` + **AES-256 Encryption**.
* **Key Management:** `flutter_secure_storage` (to store the encryption key safely in Android Keystore/iOS Keychain).
* **API Security:** All AI requests go through a Firebase Cloud Function that is **Stateless** (No logging of payload).
* **App Shield:** `flutter_windowmanager` (to block screenshots & blur app in multitasking view).

## 3. The "Paranoid" Protocol
1.  **Local-First:** Chat history lives ONLY on the device.
2.  **No Server Persistence:** Firestore is ONLY used for User Profile (Theme/Coins) and Auth. **NEVER** for Chat Logs.
3.  **Ram-Only Processing:** When sending a message to AI, the text exists in the Cloud Function's RAM for milliseconds, then is wiped.

## 4. Directory Structure Updates
* `lib/core/security/`: New folder for EncryptionService and BiometricAuth.