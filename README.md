# Smart Door Lock — Sistem Keamanan Pintu Berbasis RFID dan Web

Sistem kontrol akses pintu berbasis IoT yang menggunakan kartu RFID sebagai kredensial utama dan Web Control Panel sebagai pusat manajemen perangkat, pengguna, hak akses, serta riwayat aktivitas. Sistem terdiri dari node pintu berbasis NodeMCU ESP8266 yang terhubung ke server backend (PHP + MySQL) melalui jaringan WiFi, sehingga setiap pintu dapat dipantau dan dikendalikan secara terpusat, termasuk fitur *remote unlock* dari jarak jauh.

Proyek ini dikembangkan sebagai Tugas Akhir dengan dua unit perangkat pintu (`door_1` — Ruang NOC, `door_2` — Ruang Meeting) yang berjalan pada arsitektur yang sama.

## Daftar Isi

1. [Fitur Utama](#fitur-utama)
2. [Arsitektur Sistem](#arsitektur-sistem)
3. [Teknologi yang Digunakan](#teknologi-yang-digunakan)
4. [Kebutuhan Perangkat Keras dan Perangkat Lunak](#kebutuhan-perangkat-keras-dan-perangkat-lunak)
5. [Wiring Perangkat Keras](#wiring-perangkat-keras)
6. [Struktur Folder Proyek](#struktur-folder-proyek)
7. [Instalasi dan Konfigurasi](#instalasi-dan-konfigurasi)
8. [Struktur Database](#struktur-database)
9. [Menjalankan Sistem](#menjalankan-sistem)
10. [Alur Penggunaan](#alur-penggunaan)
11. [Endpoint REST API](#endpoint-rest-api)
12. [Troubleshooting](#troubleshooting)
13. [Pengembangan Lanjutan](#pengembangan-lanjutan)
14. [Lisensi dan Kontak](#lisensi-dan-kontak)

## Fitur Utama

- Validasi akses menggunakan kartu/tag RFID (MFRC522, 13.56MHz).
- Dua mode operasi sistem: **Online** (validasi sepenuhnya via server) dan **Hybrid** (fallback ke daftar UID lokal saat server tidak terjangkau).
- **Remote Unlock** — administrator dapat membuka pintu dari jarak jauh melalui Web Control Panel.
- Status perangkat **real-time** (Online/Offline) pada panel web, diperbarui otomatis tanpa reload halaman.
- Manajemen pengguna dengan tiga tipe akses: RFID, WEB (login admin), atau BOTH (keduanya).
- Manajemen hak akses per pintu (satu pengguna dapat memiliki akses ke lebih dari satu pintu).
- Pencatatan **Access Log** lengkap (waktu, pintu, pengguna, UID, status, metode) dengan fitur pencarian dan filter.
- Tampilan status pada LCD 16x2 di setiap perangkat pintu (status koneksi, hasil akses, status kunci).
- Autentikasi admin berbasis sesi dengan proteksi CSRF pada setiap aksi perubahan data.

## Arsitektur Sistem

Sistem terdiri dari empat lapisan utama yang saling terhubung:

1. **Media Identifikasi** — kartu/tag RFID sebagai kredensial pengguna.
2. **Perangkat Pintu IoT** — NodeMCU ESP8266, RC522, LCD I2C 16x2, modul relay, dan solenoid door lock pada setiap titik pintu.
3. **Jaringan** — komunikasi WiFi antara perangkat pintu dan server melalui protokol HTTP/JSON.
4. **Server dan Web Control Panel** — REST API (PHP), database (MySQL), dan antarmuka administrasi berbasis web.

> **Catatan:** Tempatkan diagram arsitektur sistem (blok Media Identifikasi → Perangkat Pintu IoT → Jaringan → Server & Web Control Panel) di sini, misalnya `docs/images/arsitektur-sistem.png`.

Alur data singkat:

- **Akses RFID**: kartu ditap → NodeMCU membaca UID → dikirim ke `api/access.php` → divalidasi terhadap tabel `users` dan `access_control` → hasil dikirim balik ke perangkat → relay membuka/menolak kunci → tercatat ke tabel `logs`.
- **Remote Unlock**: administrator menekan tombol di Web Control Panel → perintah disimpan ke tabel `commands` → perangkat mengambil perintah tersebut melalui polling berkala → relay diaktifkan.

> **Catatan:** Tempatkan flowchart alur kerja akses RFID dan flowchart alur kerja remote unlock di sini, misalnya `docs/images/flowchart-rfid.png` dan `docs/images/flowchart-remote-unlock.png`.

## Teknologi yang Digunakan

| Lapisan | Teknologi |
|---|---|
| Firmware | Arduino Core untuk ESP8266 (C/C++), library `MFRC522`, `LiquidCrystal_PCF8574`, `ESP8266WiFi`, `ESP8266HTTPClient` |
| Backend | PHP 8 (prosedural, tanpa framework), ekstensi `mysqli` |
| Database | MySQL / MariaDB |
| Frontend | HTML, CSS, JavaScript (vanilla, tanpa framework) — server-rendered oleh PHP |
| Web Server | Apache (XAMPP untuk pengembangan lokal) |
| Protokol Komunikasi | HTTP/JSON (REST), SPI (RC522), I2C (LCD) |

## Kebutuhan Perangkat Keras dan Perangkat Lunak

### Perangkat Keras (per titik pintu)

- NodeMCU ESP8266 (modul ESP-12E)
- Modul RFID RC522 (MFRC522)
- LCD karakter 16x2 dengan modul I2C backpack (PCF8574, alamat default `0x27`)
- Modul relay 1 channel
- Solenoid door lock 12V
- Modul step-down LM2596
- Adaptor power supply 12V
- Dioda flyback 1N4007
- Kabel jumper, terminal blok, dan perlengkapan wiring lainnya

### Perangkat Lunak

- Arduino IDE (atau PlatformIO) dengan Board Manager ESP8266 terpasang
- XAMPP (Apache + MySQL/MariaDB + PHP 8) atau environment web server setara
- phpMyAdmin (opsional, untuk mengelola database melalui antarmuka web)
- Browser web modern (Chrome, Firefox, Edge)

## Wiring Perangkat Keras

### NodeMCU ESP8266 — RFID RC522

| Pin RC522 | Pin NodeMCU |
|---|---|
| SDA (SS) | D8 |
| SCK | D5 |
| MOSI | D7 |
| MISO | D6 |
| RST | D4 |
| VCC | 3.3V |
| GND | GND |

### NodeMCU ESP8266 — LCD I2C 16x2

| Pin LCD I2C | Pin NodeMCU |
|---|---|
| SDA | D2 |
| SCL | D1 |
| VCC | 5V (output LM2596) |
| GND | GND |

### NodeMCU ESP8266 — Modul Relay

| Pin Relay | Pin NodeMCU |
|---|---|
| IN | D3 |
| VCC | 5V (output LM2596) |
| GND | GND |

### Adaptor 12V, LM2596, dan NodeMCU

| Dari | Ke |
|---|---|
| 12V (+) Adaptor | IN+ LM2596 |
| 12V (−) Adaptor | IN− LM2596 |
| OUT+ LM2596 | VIN NodeMCU, VCC LCD, VCC Relay |
| OUT− LM2596 | GND NodeMCU (ground bersama) |

### Relay dan Solenoid Door Lock

| Dari | Ke |
|---|---|
| COM Relay | 12V (+) Adaptor |
| NO Relay | (+) Solenoid |
| (−) Solenoid | 12V (−) Adaptor |

### Dioda Flyback 1N4007

| Terminal | Terhubung ke |
|---|---|
| Katoda (+) | (+) Solenoid dan NO Relay |
| Anoda (−) | (−) Solenoid dan 12V (−) Adaptor |

> **Catatan:** Tempatkan foto/diagram wiring fisik (skematik rangkaian) di sini, misalnya `docs/images/skema-wiring.png`.

> **Penting:** RC522 hanya toleran terhadap tegangan 3.3V — jangan menyambungkan VCC RC522 ke 5V karena berisiko merusak modul secara permanen.

## Struktur Folder Proyek

```
rfid-project/
├── public/                 # Document root — Web Control Panel
│   ├── index.php           # Control Panel (kelola perangkat & pengguna, remote unlock)
│   ├── logs.php            # Access Log
│   ├── settings.php        # Pengaturan mode sistem & akun admin
│   ├── login.php           # Halaman login
│   ├── logout.php          # Proses logout
│   └── assets/
│       ├── css/app.css
│       └── js/app.js
├── api/                    # REST API — dikonsumsi firmware dan frontend
│   ├── config.php          # Bootstrap API, otentikasi device, heartbeat
│   ├── access.php          # Validasi akses RFID
│   ├── commands.php        # Antrean perintah remote unlock
│   ├── settings.php        # Mode sistem (online/hybrid)
│   ├── devices.php         # Status perangkat
│   ├── logs.php            # Riwayat log (versi API)
│   └── users.php           # Daftar pengguna & akses
├── app/                     # Modul PHP bersama (tidak diakses langsung)
│   ├── database.php         # Koneksi database (mysqli)
│   ├── helpers.php          # Fungsi bantu umum
│   ├── auth.php             # Pemeriksaan status login
│   └── session.php          # Konfigurasi sesi
├── config/
│   ├── app.php               # Konfigurasi umum aplikasi
│   └── database.php          # Kredensial database
├── firmware/
│   └── smart-door-node/
│       └── smart-door-node.ino
├── database/
│   └── rfid_db.sql           # Skema & data awal database
└── docs/                     # (disarankan) tempat menyimpan diagram/ilustrasi dokumentasi
```

## Instalasi dan Konfigurasi

### 1. Persiapan Server (Backend)

1. Salin seluruh folder proyek ke direktori `htdocs` XAMPP (atau document root web server yang digunakan).
2. Jalankan Apache dan MySQL/MariaDB melalui XAMPP Control Panel.
3. Buat database baru (misalnya `rfid_db`) melalui phpMyAdmin, lalu impor skema dari `database/rfid_db.sql`.
4. Sesuaikan kredensial koneksi database pada `config/database.php`:

```php
return [
    'host' => '127.0.0.1',
    'user' => 'root',
    'password' => '',
    'database' => 'rfid_db',
    'ports' => [3306],
];
```

5. Sesuaikan zona waktu aplikasi pada `config/app.php` bila diperlukan.
6. Buat akun administrator awal pada tabel `users` (kolom `username` dan `password` — password harus disimpan dalam bentuk hash menggunakan `password_hash()`, bukan teks polos).
7. Akses Web Control Panel melalui `http://localhost/rfid-project/public/login.php`.

### 2. Persiapan Firmware (Perangkat Pintu)

1. Buka `firmware/smart-door-node/smart-door-node.ino` menggunakan Arduino IDE.
2. Pasang Board Manager **esp8266** dan pustaka berikut melalui Library Manager: `MFRC522`, `LiquidCrystal_PCF8574`.
3. Sesuaikan konfigurasi berikut pada bagian atas kode sebelum mengunggah firmware:

```cpp
const char* WIFI_SSID = "<nama_wifi>";
const char* WIFI_PASS = "<password_wifi>";
const char* SERVER_BASE = "http://<ip_server>/rfid-project";

#define DEVICE_PROFILE 1   // 1 untuk door_1, ganti sesuai profil perangkat
```

4. Tambahkan data perangkat (`device_id`, `device_name`, `api_key`) melalui Web Control Panel terlebih dahulu, lalu salin `api_key` yang dihasilkan sistem ke firmware pada blok `DEVICE_PROFILE` yang sesuai.
5. Pilih board **NodeMCU 1.0 (ESP-12E Module)**, pilih port COM yang sesuai, lalu unggah firmware.

> **Penting untuk keamanan:** Jangan menyimpan kredensial WiFi, `api_key`, atau kredensial database sesungguhnya di repository publik. Gunakan nilai contoh/placeholder pada dokumentasi dan simpan nilai asli secara terpisah (misalnya melalui file konfigurasi lokal yang di-*ignore* oleh Git).

## Struktur Database

Database `rfid_db` terdiri dari 6 tabel utama:

| Tabel | Fungsi |
|---|---|
| `devices` | Registrasi dan status setiap perangkat pintu (`device_id`, `device_name`, `api_key`, `last_seen`, `last_ip`) |
| `users` | Identitas pemegang kartu RFID sekaligus akun login admin (`uid`, `username`, `password`, `role`, `status`) |
| `access_control` | Tabel penghubung (many-to-many) hak akses antara pengguna (`user_uid`) dan perangkat pintu (`device_id`) |
| `commands` | Antrean perintah remote unlock (`device_id`, `command`, `created_at`, `consumed_at`) |
| `app_settings` | Konfigurasi global sistem berbasis key-value (mis. `mode` = online/hybrid) |
| `logs` | Riwayat seluruh peristiwa akses (snapshot data, digunakan sebagai audit trail) |

> **Catatan:** Struktur kolom lengkap beserta tipe data dan constraint dapat dilihat pada `database/rfid_db.sql`. Tempatkan diagram ERD (Entity Relationship Diagram) di sini, misalnya `docs/images/erd-database.png`.

## Menjalankan Sistem

1. Pastikan Apache dan MySQL berjalan di server.
2. Pastikan perangkat NodeMCU dinyalakan dan berhasil terhubung ke jaringan WiFi yang sama dengan server.
3. Buka Web Control Panel, login menggunakan akun administrator.
4. Status setiap perangkat akan tampil **Online** apabila perangkat berhasil mengirim data ke server dalam 20 detik terakhir.
5. Tambahkan data pengguna dan hak akses pintu melalui menu Control Panel.
6. Sistem siap digunakan — tap kartu RFID pada perangkat pintu untuk menguji validasi akses, atau gunakan tombol **Unlock** pada Control Panel untuk menguji remote unlock.

## Alur Penggunaan

### Alur Akses RFID

1. Pengguna menempelkan kartu RFID pada modul RC522.
2. Perangkat membaca UID kartu dan mengirimkannya ke server untuk divalidasi.
3. Jika server tidak terjangkau dan mode sistem adalah **Hybrid**, perangkat memvalidasi UID terhadap daftar cadangan lokal.
4. Jika akses diterima, relay aktif membuka solenoid selama 5 detik, kemudian otomatis terkunci kembali.
5. Hasil akses (diterima/ditolak) tercatat ke Access Log.

### Alur Remote Unlock

1. Administrator memilih perangkat pintu pada Control Panel dan menekan tombol **Unlock**.
2. Perintah tersimpan di server dan diambil oleh perangkat melalui mekanisme polling berkala (interval 1 detik).
3. Perangkat menjalankan proses buka kunci yang sama seperti pada alur akses RFID.
4. Aktivitas remote unlock turut tercatat pada Access Log dengan metode `web`.

## Endpoint REST API

Seluruh endpoint berada di folder `api/` dan mengembalikan respons dalam format JSON.

| Method | Endpoint | Deskripsi | Parameter Utama |
|---|---|---|---|
| GET | `/api/access.php` | Validasi akses kartu RFID | `device_id`, `uid`, `api_key` |
| GET | `/api/commands.php` | Polling perintah remote unlock oleh perangkat | `device_id`, `api_key` |
| POST | `/api/commands.php?action=create` | Membuat perintah unlock baru (dipanggil dari sesi admin) | `device_id` |
| GET | `/api/settings.php` | Mengambil mode sistem (online/hybrid) | `device_id`, `api_key` |
| GET | `/api/devices.php` | Daftar perangkat beserta status Online/Offline | — |
| GET | `/api/logs.php` | Riwayat log akses (80 data terbaru) | — |
| GET | `/api/users.php` | Daftar pengguna beserta hak akses pintu | — |

Contoh format respons:

```json
{
  "success": true,
  "decision": "GRANTED",
  "reason": "access_ok",
  "user": { "name": "Nama Pengguna", "uid": "AABBCCDD" }
}
```

Setiap request dari perangkat wajib menyertakan `device_id` dan `api_key` yang valid; permintaan tanpa kredensial yang sesuai akan ditolak dengan status HTTP 401.

## Troubleshooting

| Gejala | Kemungkinan Penyebab | Solusi |
|---|---|---|
| Relay tidak berbunyi klik / LED indikator tidak menyala | VCC relay tersambung ke 3.3V, bukan 5V | Sambungkan VCC relay ke output 5V LM2596 |
| Serial Monitor menampilkan karakter acak terus-menerus | ESP8266 mengalami reset berulang (brown-out) | Pastikan suplai daya rail 5V mencukupi kebutuhan seluruh periferal |
| Status perangkat tetap **Offline** meski konfigurasi benar | Perangkat gagal terhubung WiFi/server sehingga heartbeat tidak terkirim | Periksa SSID/password WiFi, IP server pada `SERVER_BASE`, serta status Apache/MySQL |
| Perintah *remote unlock* tidak dieksekusi perangkat | Perangkat tidak dalam status Online, atau interval polling belum tercapai | Pastikan perangkat terhubung ke jaringan dan tunggu maksimum 1 detik siklus polling |
| Kartu RFID selalu ditolak | UID belum terdaftar, status pengguna nonaktif, atau tidak memiliki hak akses ke pintu tersebut | Periksa data pengguna dan `access_control` melalui Control Panel |
| Solenoid tetap terbuka / tidak pernah mengunci kembali | Logika relay (`HIGH`/`LOW`) tidak sesuai dengan tipe modul relay (active-high/active-low) | Sesuaikan logika `digitalWrite` pada firmware dengan tipe modul relay yang digunakan |

## Pengembangan Lanjutan

- Migrasi komunikasi dari HTTP ke **HTTPS** untuk melindungi `api_key` dan data akses dari penyadapan jaringan.
- Penerapan **role-based access control (RBAC)** yang lebih granular pada Web Control Panel (saat ini seluruh akun admin memiliki hak akses yang sama).
- Penambahan sensor posisi daun pintu (mis. reed switch) agar status terkunci/terbuka dapat diverifikasi secara fisik, tidak hanya berbasis timer firmware.
- Migrasi mekanisme polling ke **WebSocket** atau **MQTT** untuk mengurangi latensi komunikasi perintah remote unlock.
- Penambahan notifikasi (mis. Telegram/email) untuk peristiwa akses tertentu, seperti percobaan akses ditolak berulang kali.
- Dukungan pengaturan mode Online/Hybrid secara per-perangkat, bukan hanya secara global.

## Lisensi dan Kontak

Proyek ini dikembangkan sebagai bagian dari Tugas Akhir dan disediakan untuk kebutuhan akademik. Sesuaikan bagian lisensi berikut sesuai ketentuan program studi/institusi Anda (misalnya MIT License atau ketentuan khusus kampus).

**Kontak Pengembang**

- Nama:
- Email:
- Program Studi/Institusi:

---

Dokumentasi ini disusun sebagai bagian dari Tugas Akhir Sistem Keamanan Pintu Berbasis IoT menggunakan RFID dan Web Control Panel.
