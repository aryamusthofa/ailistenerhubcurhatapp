# 📂 Struktur Project: AI Curhat App

Dokumen ini menjelaskan struktur folder, arsitektur, dan komponen utama dari aplikasi **AI Curhat App**.

## 🏗️ Arsitektur

Aplikasi ini menggunakan pendekatan **Clean Architecture** yang dimodifikasi untuk Flutter, dengan **Riverpod** sebagai state management.

### Layer Utama:
1.  **Presentation Layer** (`lib/presentation/`): Kode UI (Screen, Widget) dan Logic UI (Notifier/Provider).
2.  **Domain Layer** (`lib/domain/`): Bisnis logic murni. Entity dan Interface Repository. Tidak boleh ada dependensi ke framework luar (seperti HTTP client).
3.  **Data Layer** (`lib/data/`): Implementasi repository, pemanggilan API (Datasource), dan model data (DTO).
4.  **Core** (`lib/core/`): Komponen utilitas yang dipakai di semua layer (Config, Constants, Extensions).

---

## 📁 Penjelasan Folder (`lib/`)

```plaintext
lib/
├── core/
│   ├── config/           # Konfigurasi aplikasi (Env, AI Config)
│   │   └── ai_config.dart # Parsing API Keys & Provider Config
│   ├── constants/        # Konstanta warna, text, ukuran
│   └── utils/            # Fungsi bantuan umum
│
├── data/
│   ├── datasources/
│   │   ├── local/        # Database lokal (Hive/SharedPreferences)
│   │   └── remote/       # API call ke provider AI
│   │       ├── ai_provider.dart       # Interface & Implementasi Provider (Gemini, Groq, dll)
│   │   │   └── ai_remote_service.dart # Orchestrator utama AI (Fallback Logic)
│   ├── models/           # Data Transfer Objects (DTO) - mapping JSON
│   └── repositories/     # Implementasi Repository (menghubungkan data & domain)
│
├── domain/
│   ├── entities/         # Object bisnis utama (ChatMessage, User)
│   └── repositories/     # Interface kontrak repository
│
├── presentation/
│   ├── navigation/       # Routing (GoRouter)
│   ├── providers/        # State Management (Riverpod Providers)
│   │   └── chat_provider.dart # Logic utama chat
│   ├── screens/          # Halaman-halaman aplikasi (ChatScreen, Settings)
│   └── widgets/          # Komponen UI reusable (MessageBubble, InputField)
│
└── main.dart             # Entry point aplikasi
```

---

## 🧠 Komponen Kunci (AI System)

### 1. `AIRemoteService` (`lib/data/datasources/remote/ai_remote_service.dart`)
Ini adalah "otak" dari orkestrasi AI.
- **Fungsi**: Mengelola daftar provider AI dan menangani logika fallback.
- **Logika**: Mencoba provider secara berurutan. Jika Provider A gagal, otomatis lanjut ke Provider B, dst.
- **Urutan Fallback**:
  1. Gemini
  2. Groq
  3. SambaNova
  4. Together AI
  5. HuggingFace
  6. OpenAI

### 2. `AIProvider` (`lib/data/datasources/remote/ai_provider.dart`)
Interface untuk semua provider AI.
- **Multi-Key Support**: Setiap implementasi provider (misal `GeminiProvider`, `GroqProvider`) memiliki logika rotasi kunci API internal. Jika kunci 1 limit/error, otomatis coba kunci 2.
- **ProviderName**: Mengembalikan nama provider yang nantinya ditampilkan di UI ("Answered by ...").

### 3. `ModelConfig` (`lib/core/config/ai_config.dart`)
Helper class untuk membaca konfigurasi dari file `.env`.
- Mampu memparsing satu kunci atau **daftar kunci** (comma-separated).
- Contoh: `getSambaNovaKeys()` mengembalikan `['key1', 'key2']`.

---

## 🔐 Environment Variables (`.env`)

File ini SANGAT PENTING dan tidak boleh di-commit ke Git. Gunakan `.env.example` sebagai referensi.

Key yang didukung (Format List CSV):
- `GEMINI_KEYS`
- `GROQ_KEYS`
- `SAMBANOVA_KEYS`
- `TOGETHER_KEYS`
- `HUGGINGFACE_KEYS`
- `OPENAI_KEYS`

---

## 🚀 Cara Menjalankan

1.  Pastikan Flutter SDK terinstall.
2.  Buat file `.env` di root project, copy isi dari `.env.example` dan isi API Key.
3.  Jalankan:
    ```bash
    flutter pub get
    flutter run
    ```
---

## 🔁 Perubahan Terbaru (Ringkasan dari Repo saat ini)

Dokumentasi struktur di atas masih valid secara konseptual (Clean Architecture: core/data/domain/presentation). Namun ada beberapa perubahan implementasi dan file baru sejak dokumen ini dibuat. Ringkasan perubahan penting:

- File/Folder baru atau yang ditambahkan ke repo:
  - `lib/firebase_options.dart` (auto-generated oleh `flutterfire configure`)
  - `firebase.json` dan `android/app/google-services.json` (Firebase setup)
  - `REKAP_LENGKAP_PROJECT.md` (rekap lengkap & status terbaru)
  - `test_env.dart` (script kecil untuk verifikasi .env)
  - `lib/presentation/providers/personalization_provider.dart`
  - New auth screens under `lib/presentation/screens/auth/` (login, register, welcome)
  - `lib/presentation/widgets/fx/rgb_animated_background.dart`
  - Generated model: `lib/data/models/conversation_model.g.dart`

- File/Folder yang dihapus atau digantikan:
  - `lib/presentation/screens/login_screen.dart`, `register_screen.dart`, `welcome_screen.dart` — dipindah/di-refactor ke `lib/presentation/screens/auth/`
  - `lib/presentation/providers/auth/auth_notifier.dart` — di-refactor/diintegrasikan ke provider lain

- Perubahan fungsi/implementasi signifikan:
  - `lib/data/datasources/remote/ai_remote_service.dart` diperbarui sebagai AI orchestrator (fallback & multi-key rotation).
  - `lib/core/security/encryption_service.dart` dan `screen_shield.dart` dikembangkan untuk enkripsi AES + screen protection.
  - `lib/presentation/providers/*` (chat, security, theme, di_providers) diperbarui untuk mendukung Firebase, Hive, dan dependency injection.
  - `lib/main.dart` sekarang menginisialisasi `dotenv`, `Firebase`, `Hive` dan `ProviderContainer`.

Untuk detail lengkap perubahan dan status eksekusi lihat: `REKAP_LENGKAP_PROJECT.md` (root project).

