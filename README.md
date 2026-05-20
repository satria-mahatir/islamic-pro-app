# 🕌 Islamic Pro App

[![Flutter Version](https://img.shields.io/badge/Flutter-%E2%89%A5%203.10.7-02569B?logo=flutter&style=flat-square)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%E2%89%A5%203.0-0175C2?logo=dart&style=flat-square)](https://dart.dev)
[![Platform Support](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-success?style=flat-square)](#)
[![UI Design](https://img.shields.io/badge/Design-Bento%20Grid%20%26%20Glassmorphism-004D40?style=flat-square)](#)

Aplikasi mobile **Islamic Pro** adalah asisten ibadah digital modern yang dirancang khusus untuk mempermudah rutinitas ibadah harian umat Islam. Dibuat menggunakan **Flutter & Dart**, aplikasi ini mengedepankan pengalaman pengguna (UX) yang sangat premium melalui desain visual **Bento Grid** yang asimetris dan **Floating Glassmorphism Navigation Bar** ala iOS.

---

## ✨ Fitur Unggulan

Aplikasi ini dilengkapi dengan berbagai fitur esensial yang dikemas dalam antarmuka modern dan responsif:

*   **📍 Jadwal Salat Real-time & Otomatis**
    *   Mengintegrasikan **Aladhan API** untuk kalkulasi jadwal salat 5 waktu secara presisi.
    *   Mendeteksi lokasi secara otomatis menggunakan koordinat GPS perangkat (**Geolocator**).
    *   *Smart Fallback*: Jika GPS dinonaktifkan atau terjadi kendala jaringan, aplikasi secara otomatis menggunakan koordinat default Kota Bondowoso, Jawa Timur agar jadwal salat tetap tampil.
*   **📖 Al-Qur'an Digital**
    *   Daftar surah dan pembacaan ayat-ayat suci Al-Qur'an secara langsung di dalam aplikasi.
    *   Navigasi yang lancar untuk pengalaman membaca yang nyaman.
*   **🧭 Penunjuk Arah Kiblat Interaktif**
    *   Kompas kiblat real-time menggunakan sensor geomagnetik perangkat (**flutter_qiblah**).
    *   Tampilan intuitif untuk memastikan keakuratan arah hadap salat Anda.
*   **📿 Tasbih Digital**
    *   Penghitung zikir digital dengan respon ketukan yang halus dan tombol reset instan.
*   **🤲 Doa Harian Lengkap**
    *   Kumpulan doa sehari-hari dengan teks Arab, transliterasi Latin, dan terjemahan bahasa Indonesia yang jelas.
*   **📅 Kalender Hijriah & Masehi**
    *   Kalender interaktif berbasis **table_calendar** untuk memantau tanggal masehi sekaligus hari-hari penting dalam kalender Hijriah.
*   **🕌 Lokasi Masjid Terdekat**
    *   Integrasi cepat ke Google Maps menggunakan **url_launcher** untuk menunjukkan rute ke masjid terdekat di sekitar Anda secara instan.
*   **💡 Inspirasi Islami**
    *   Horizontal carousel slider yang memuat konten motivasi dan amalan harian seperti *Keutamaan Tahajud*, *Sedekah Subuh*, dan *Adab Menuntut Ilmu*.

---

## 🎨 Arsitektur Desain & Antarmuka (UI/UX)

Islamic Pro dirancang dengan standar estetika aplikasi modern kelas atas:
*   **Bento Grid Layout**: Desain grid asimetris dengan tinggi terkunci (*Fixed Height*) untuk mencegah terjadinya *overflow* layout pada berbagai ukuran layar.
*   **Glassmorphism Nav Bar**: Bilah navigasi melayang (*floating*) di bagian bawah dengan efek blur dinamis menggunakan `BackdropFilter` demi nuansa premium dan bersih ala iOS.
*   **Curated Palette**: Harmonisasi warna yang menenangkan mata:
    *   🟩 **Primary Color**: `Dark Teal (#004D40)` yang merepresentasikan nilai spiritual yang mendalam.
    *   🟢 **Secondary Color**: `Emerald Green (#00695C)` untuk gradasi yang sejuk.
    *   💛 **Accent Color**: `Amber Gold (#FFD54F)` memberikan sorotan premium pada elemen aktif.

---

## ⚙️ Spesifikasi & Dependensi Utama

Aplikasi ini menggunakan beberapa paket Flutter terbaik untuk menjamin stabilitas dan performa:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1               # Mengambil data jadwal salat dari Aladhan API
  geolocator: ^13.0.4        # Menemukan koordinat GPS pengguna secara real-time
  flutter_qiblah: ^3.1.0+1   # Mengakses sensor arah kompas untuk navigasi kiblat
  table_calendar: ^3.1.2     # Menyediakan tampilan kalender yang interaktif
  intl: ^0.19.0              # Formatter tanggal dan waktu multibahasa
  url_launcher: ^6.3.0       # Membuka Google Maps untuk pencarian masjid terdekat
```

---

## 📂 Struktur Proyek

Berikut adalah struktur folder utama pada bagian `/lib` yang menyusun logika dan UI aplikasi:

```text
lib/
├── main.dart             # Konfigurasi awal aplikasi, tema Material 3, & inisialisasi orientasi
├── home_dashboard.dart   # Dashboard utama dengan Bento Grid, Header Tanggal/Waktu, & Navigasi Glassmorphic
├── prayer_service.dart   # Handler pengambilan data API jadwal salat berdasarkan lokasi GPS
├── ayat_ayat.dart        # Modul daftar surah Al-Qur'an
├── detail_surah.dart     # Modul penampil detail isi surah dan ayat Al-Qur'an
├── doa_page.dart         # Halaman daftar doa harian lengkap
├── kiblat_page.dart      # Halaman penunjuk arah kiblat interaktif
├── tasbih_page.dart      # Halaman tasbih digital counter
└── kalender_page.dart    # Halaman kalender integrasi masehi & hijriah
```

---

## 🚀 Panduan Memulai & Instalasi

Ikuti langkah-langkah di bawah ini untuk menjalankan proyek ini di lingkungan lokal Anda:

### 1. Prasyarat
*   Sudah menginstal **Flutter SDK** (versi >= 3.10.7).
*   Sudah menginstal emulator Android/iOS atau menghubungkan perangkat fisik dengan mode USB Debugging aktif.

### 2. Kloning Repository
```bash
git clone https://github.com/satria-mahatir/islamic-pro-app.git
cd tugas_mas_iqbal
```

### 3. Instal Dependensi
Unduh semua paket pendukung yang didefinisikan dalam `pubspec.yaml`:
```bash
flutter pub get
```

### 4. Jalankan Aplikasi
Jalankan aplikasi di perangkat atau emulator pilihan Anda:
```bash
flutter run
```

---

## 🔒 Izin Penggunaan (Permissions)

Untuk memastikan fitur **Kompas Kiblat** dan **Jadwal Salat Otomatis** berjalan dengan sempurna, pastikan Anda memberikan izin akses berikut pada perangkat Anda:
*   **Akses Lokasi (GPS)**: Diperlukan untuk mendeteksi koordinat lintang dan bujur secara presisi agar jadwal salat dan arah kompas kiblat sinkron.

---

## ✍️ Kontributor & Pengembang

*   **Satria Mahatir** - *Developer Utama*
*   **Mas Iqbal** - *Project Supervisor / Mentor*

*Terima kasih kepada seluruh pihak yang telah membantu menyempurnakan aplikasi asisten ibadah ini. Semoga bermanfaat bagi umat.* 🕋✨
