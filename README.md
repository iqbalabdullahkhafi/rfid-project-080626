# Smart Door Security System

Sistem manajemen akses pintu berbasis RFID dan web yang dirancang untuk memberikan kontrol keamanan yang terpusat, fleksibel, dan mudah dipantau. Proyek ini menggabungkan perangkat keras (NodeMCU ESP8266 & RFID Reader) dengan aplikasi web (PHP & MySQL) melalui REST API, memungkinkan administrasi perangkat, pengguna, dan hak akses secara *real-time*.

Sistem ini cocok untuk diimplementasikan pada pintu ruang server, kantor, laboratorium, atau area terbatas lainnya yang membutuhkan pencatatan dan kontrol akses yang ketat.

---

## ✨ Fitur Utama

- **Manajemen Perangkat Terpusat**: Tambah, edit, dan hapus perangkat pintu dari satu dasbor.
- **Manajemen Pengguna Fleksibel**: Mendukung tiga tipe pengguna:
  - **RFID**: Akses hanya menggunakan kartu RFID.
  - **WEB**: Akses hanya melalui login web (fitur masa depan atau untuk tipe user lain).
  - **BOTH**: Akses bisa menggunakan kartu RFID maupun login web.
- **Kontrol Akses Granular**: Atur hak akses setiap pengguna RFID untuk pintu-pintu tertentu.
- **Remote Unlock**: Buka pintu dari jarak jauh melalui Control Panel web.
- **Riwayat Akses (Access Log)**: Pantau semua aktivitas akses (diterima/ditolak) secara *real-time* dengan filter pencarian.
- **Mode Sistem Ganda**:
  - **Online**: Validasi akses selalu melalui server, memberikan keamanan maksimal.
  - **Hybrid**: Validasi akses utamanya ke server, namun memiliki *fallback* ke daftar UID lokal di perangkat jika koneksi terputus, memastikan operasionalitas.
- **REST API**: Komunikasi yang andal antara perangkat keras (NodeMCU) dan server.
- **Dasbor Intuitif**: Antarmuka web yang bersih dan responsif untuk kemudahan administrasi.

---

## 🏗️ Arsitektur Sistem

Sistem ini terdiri dari tiga komponen utama yang saling berinteraksi:

1.  **Perangkat Keras (NodeMCU)**: Bertugas membaca UID kartu RFID, mengontrol kunci pintu (solenoid/electric strike), dan berkomunikasi dengan Backend melalui WiFi.
2.  **Backend & REST API (Server PHP)**: Menjadi otak dari sistem. Menerima permintaan dari NodeMCU dan Frontend, memvalidasi data ke database, mencatat log, dan mengirimkan perintah.
3.  **Frontend (Aplikasi Web)**: Antarmuka bagi administrator untuk mengelola seluruh sistem.

```
+-----------------+        +----------------------+        +-----------------+
|  Perangkat Pintu|        |     Server (Web & API) |        |  Administrator  |
| (NodeMCU, RFID) |        |      (PHP, MySQL)      |        |   (Browser)     |
+-----------------+        +----------------------+        +-----------------+
        ^                          ^     ^                           ^
        | (1) Tap Kartu            |     | (3) Kirim Perintah        |
        +------------------------->|     +---------------------------+
        | (2) Validasi UID         |     |                           |
        |                          |     | (4) Kelola Sistem         |
        | <------------------------+     +<--------------------------+
        | (5) Kirim Status         |
        |                          |
        | (6) Ambil Perintah       |
        +------------------------->|
        | (7) Kirim Perintah       |
        | <------------------------+
```

### Alur Kerja

1.  **Akses via RFID**:
    - Pengguna menempelkan kartu RFID pada reader.
    - NodeMCU membaca UID dan mengirimkannya ke `POST /api/access.php`.
    - API memvalidasi UID dan hak akses pintu di database.
    - API mencatat aktivitas ke tabel `logs` dan mengembalikan status `GRANTED` atau `DENIED`.
    - NodeMCU menerima status, lalu membuka kunci jika `GRANTED` atau memberi notifikasi gagal jika `DENIED`.

2.  **Remote Unlock via Web**:
    - Administrator menekan tombol "Unlock" pada Control Panel.
    - Aplikasi web mengirimkan perintah `OPEN` untuk `device_id` terkait ke tabel `commands`.
    - NodeMCU secara periodik melakukan *polling* ke `GET /api/commands.php`.
    - Jika ada perintah, API mengirimkannya ke NodeMCU.
    - NodeMCU menerima perintah, membuka kunci, lalu mengirim konfirmasi bahwa perintah telah dieksekusi.

---

## 🛠️ Komponen & Teknologi

### Hardware
- Mikrokontroler: **NodeMCU ESP8266**
- RFID Reader: **MFRC522** (13.56 MHz)
- Kunci Elektronik: **Solenoid Lock** atau **Electric Strike Lock** (12V)
- Modul Relay: 1-Channel 5V Relay Module
- Power Supply: Adaptor 12V untuk kunci dan 5V untuk NodeMCU
- Komponen Pendukung: Buzzer, LED, Kabel Jumper

### Software
- **Backend**: PHP 8.x
- **Database**: MySQL / MariaDB
- **Frontend**: HTML, CSS, Vanilla JavaScript
- **Firmware**: C++ (Arduino Framework)
- **Web Server**: Apache (direkomendasikan)

---

## 📁 Struktur Proyek

```text
rfid-project/
├── api/          # Endpoint REST API untuk komunikasi dengan NodeMCU.
├── app/          # Logika inti aplikasi (autentikasi, database, helpers).
├── config/       # File konfigurasi (database, aplikasi).
├── database/     # File dump SQL untuk struktur dan data awal.
├── firmware/     # Kode sumber firmware untuk NodeMCU.
└── public/       # Web root, berisi file yang dapat diakses publik (CSS, JS, halaman PHP).
```

---

## 🔌 Endpoint REST API

| Method | Endpoint                | Fungsi                                                              |
| :----- | :---------------------- | :------------------------------------------------------------------ |
| `POST` | `/api/access.php`       | Menerima UID dari NodeMCU, memvalidasi, dan mencatat log.           |
| `GET`  | `/api/commands.php`     | Dihubungi oleh NodeMCU untuk mengambil perintah (misal: remote unlock). |
| `GET`  | `/api/settings.php`     | Dihubungi oleh NodeMCU untuk sinkronisasi mode sistem (Online/Hybrid). |
| `POST` | `/api/devices.php`      | Mengirimkan status `last_seen` dari NodeMCU ke server.              |

---

## 🗃️ Struktur Database

| Tabel            | Fungsi                                                                  |
| :--------------- | :---------------------------------------------------------------------- |
| `devices`        | Menyimpan data perangkat pintu (ID, nama, API key, status).             |
| `users`          | Menyimpan data pengguna (nama, UID RFID, kredensial login web).         |
| `access_control` | Tabel pivot yang menghubungkan `users` (via `user_uid`) dan `devices`.   |
| `logs`           | Mencatat semua riwayat aktivitas akses pintu.                           |
| `commands`       | Antrian perintah yang dikirim dari web ke perangkat NodeMCU.            |
| `settings`       | Menyimpan pengaturan global sistem dalam format key-value (misal: mode). |

---

## 🚀 Instalasi & Konfigurasi

### A. Instalasi di Localhost (XAMPP)

1.  **Clone Repository**:
    ```bash
    git clone https://github.com/username/rfid-project.git
    ```
    Atau unduh ZIP dan ekstrak ke folder `C:\xampp\htdocs\rfid-project`.

2.  **Database**:
    - Buka XAMPP Control Panel, jalankan **Apache** dan **MySQL**.
    - Buka `http://localhost/phpmyadmin`.
    - Buat database baru dengan nama `rfid_db`.
    - Pilih database tersebut, lalu klik tab **Import**.
    - Unggah file `database/rfid_db.sql` dan jalankan proses import.

3.  **Konfigurasi**:
    - Buka file `config/database.php`.
    - Sesuaikan konfigurasi koneksi database jika diperlukan (default sudah sesuai untuk XAMPP standar).

4.  **Akses Aplikasi**:
    - Buka browser dan akses `http://localhost/rfid-project/public/`.

### B. Konfigurasi Firmware NodeMCU

1.  **Buka Firmware**: Buka file `firmware/smart-door-node/smart-door-node.ino` menggunakan Arduino IDE.

2.  **Install Library**: Buka Library Manager (`Sketch > Include Library > Manage Libraries...`) dan install:
    - `MFRC522` by GithubCommunity
    - `ArduinoJson` by Benoit Blanchon

3.  **Konfigurasi**: Sesuaikan parameter berikut di dalam kode:
    ```cpp
    // Konfigurasi WiFi
    const char* ssid = "NAMA_WIFI_ANDA";
    const char* password = "PASSWORD_WIFI_ANDA";

    // Konfigurasi Server
    const char* serverUrl = "http://ALAMAT_IP_SERVER_ANDA/rfid-project/api";

    // Konfigurasi Perangkat (sesuaikan dengan data di database)
    const char* deviceId = "door_1";
    const char* apiKey = "API_KEY_DARI_DATABASE";
    ```
    > **Penting**: `deviceId` dan `apiKey` harus sama persis dengan yang ada di tabel `devices` pada database Anda.

4.  **Wiring**: Hubungkan komponen ke pin NodeMCU sesuai skema atau kebutuhan.

5.  **Upload**: Pilih board "NodeMCU 1.0 (ESP-12E Module)", pilih port yang benar, lalu upload firmware.

---

## ⚙️ Penggunaan Sistem

1.  **Login**: Buka halaman login dan masuk menggunakan akun administrator.
    - **Username**: `admin`
    - **Password**: `admin123`

2.  **Tambah Perangkat**: Di Control Panel, klik tombol `+ Add Door`, isi nama dan Device ID yang unik. Device ID ini akan digunakan di firmware.

3.  **Tambah Pengguna**: Klik `+ Add User`, isi nama, pilih tipe, dan masukkan UID kartu RFID (dapat dilihat di Serial Monitor Arduino saat kartu di-tap pertama kali).

4.  **Atur Hak Akses**: Saat menambah/mengedit pengguna RFID, centang pintu mana saja yang dapat diakses oleh pengguna tersebut.

5.  **Remote Unlock**: Pada daftar perangkat, klik tombol `Unlock` untuk membuka pintu dari jarak jauh. Tombol ini hanya aktif jika perangkat berstatus `ONLINE`.

### Penjelasan Mode Sistem

- **Online**: Mode paling aman. NodeMCU akan selalu bertanya ke server untuk setiap tap kartu. Jika koneksi ke server gagal, akses akan ditolak.
- **Hybrid**: Mode paling andal. NodeMCU akan mencoba validasi ke server. Jika gagal, ia akan memeriksa UID pada daftar akses yang telah disinkronisasi sebelumnya. Ini memastikan pintu tetap bisa diakses meskipun koneksi internet terputus.

---

## 🧪 Pengujian

Untuk memastikan sistem berjalan dengan baik, lakukan pengujian berikut:

- **Akses Diterima**: Daftarkan kartu dan berikan akses ke satu pintu. Tap kartu tersebut dan pastikan pintu terbuka serta log `GRANTED` tercatat.
- **Akses Ditolak (UID tidak terdaftar)**: Tap kartu yang belum terdaftar. Pastikan pintu tidak terbuka dan log `DENIED` tercatat.
- **Akses Ditolak (Hak Akses tidak ada)**: Daftarkan kartu namun jangan berikan akses ke pintu manapun. Tap kartu dan pastikan pintu tidak terbuka.
- **Remote Unlock**: Pastikan perangkat `ONLINE`, lalu klik tombol `Unlock`. Pintu harus terbuka.
- **Status Perangkat**: Pastikan status perangkat berubah dari `OFFLINE` ke `ONLINE` beberapa saat setelah NodeMCU dinyalakan.

---

## 🚑 Troubleshooting

- **Perangkat selalu `OFFLINE`**:
  - Periksa koneksi WiFi (SSID & Password) di firmware.
  - Pastikan `serverUrl` di firmware dapat diakses dari jaringan yang sama dengan NodeMCU. Gunakan alamat IP lokal server, bukan `localhost`.
  - Pastikan `apiKey` dan `deviceId` di firmware cocok dengan yang ada di database.
  - Periksa firewall pada server yang mungkin memblokir koneksi masuk.

- **Akses selalu `DENIED`**:
  - Pastikan UID kartu yang terdeteksi di Serial Monitor sama dengan yang diinput di database.
  - Periksa kembali tabel `access_control` untuk memastikan hak akses sudah benar.

- **Halaman web error**:
  - Aktifkan `display_errors` di `php.ini` untuk melihat pesan error detail.
  - Periksa log error Apache.

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah **MIT License**. Lihat file `LICENSE` untuk detail lebih lanjut.

---

**Dikembangkan oleh [Nama Anda]**

*Dokumentasi ini dibuat untuk proyek Tugas Akhir/Skripsi. Diharapkan dapat membantu dalam pemahaman, pengembangan, dan presentasi sistem.*
