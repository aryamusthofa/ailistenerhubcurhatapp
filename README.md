# AI Curhat App (AI Listener Hub)

Aplikasi curhat cerdas berbasis AI yang dirancang untuk menjadi "Invincible" (Nyaris Tak Terkalahkan) dengan dukungan multi-provider AI gratis.

![Status](https://img.shields.io/badge/Status-Development-orange)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green)

---

## 🚀 Fitur Utama

- **Invincible AI System**: Menggunakan 6 layer pertahanan AI dengan fallback otomatis.
  1. **Gemini** (Primary)
  2. **Groq** (Llama 3 - Fallback Cepat)
  3. **SambaNova** (Llama 3.1 70B - High Performance)
  4. **Together AI** (Llama 3.3 - Open Source Power)
  5. **HuggingFace** (Mistral - Free Tier)
  6. **OpenAI** (Scavenger Mode / Paid Backup)
- **Multi-Key Support**: Semua provider mendukung rotasi kunci API otomatis untuk menghindari rate limit.
- **Privacy First**: Chat history disimpan secara lokal (Hive). *Enkripsi sedang dalam pengembangan.*
- **Modern UI**: Desain Glassmorphism yang menenangkan.

---

## 📚 Dokumentasi Lengkap

Semua dokumentasi teknis dan panduan pengerjaan ada di folder `PANDUAN/`:

1.  **[Eksekusi & Tugas](PANDUAN/EksecutionAndTask.md)**
    - Status proyek saat ini, log pengerjaan harian, dan roadmap fase selanjutnya.
2.  **[Struktur Project & Arsitektur](PANDUAN/StrukturProject-AiCurhatApp.md)**
    - Penjelasan detail tentang struktur folder Clean Architecture, cara kerja sistem AI, dan konfigurasi environment.

---

## 🛠️ Persiapan Awal

1.  **Clone Repo**:
    ```bash
    git clone https://github.com/username/ai_curhat_app.git
    cd ai_curhat_app
    ```

2.  **Setup Environment**:
    - Copy file `.env.example` menjadi `.env`.
    - Isi API Keys sesuai panduan di dalamnya.

3.  **Jalankan Aplikasi**:
    ```bash
    flutter pub get
    flutter run
    ```

---

## 🤝 Kontribusi

Proyek ini dikembangkan secara personal dengan bantuan AI Agent.
Silakan baca `PANDUAN/` untuk memahami alur kerja kami.
