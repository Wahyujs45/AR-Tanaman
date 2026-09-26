# Kebun Pewarna AR — paket aplikasi Play Store

Pengunjung cukup memasang aplikasi dari Play Store lalu membukanya. Tanpa akun, tanpa pengaturan, tanpa internet. Kamera langsung menyala setelah panduan singkat tiga langkah (yang hanya tampil sekali), dan infografis muncul sendiri begitu tanaman atau label QR dikenali.

## Isi folder

| Folder | Isi |
|---|---|
| `docs/` | Aplikasi web untuk **admin** (melatih, mengisi infografis, mencetak QR) dan halaman kebijakan privasi. Diunggah ke hosting ber-HTTPS. |
| `android/` | Proyek Android. Saat di-build, isi `docs/`, pustaka, dan model jaringan saraf diunduh dan dikemas ke dalam aplikasi sehingga berjalan penuh tanpa internet. |
| `play-store/` | Ikon 512 px, grafis fitur 1024×500, tangkapan layar, teks listing, dan jawaban formulir Play Console. |
| `.github/workflows/` | Build otomatis di GitHub (opsional; tidak perlu memasang apa pun di komputer). |

## Pembagian peran

- **Admin (Bapak/tim)** memakai versi web di `docs/` untuk melatih pengenalan 8 tanaman di kebun, lalu mengunduh `paket-ar.json`.
- **Pengunjung** memakai aplikasi Play Store. Menu Admin tidak ada di aplikasi, sehingga yang terlihat hanya **Pindai** dan **Koleksi**.

---

## Langkah 1 — Pasang situs admin

Pilih salah satu:

- **Netlify Drop (paling mudah):** buka app.netlify.com/drop, lalu seret folder `docs` ke halaman itu. Hasilnya berupa alamat `https://….netlify.app`.
- **GitHub Pages:** unggah seluruh folder proyek ini ke repositori GitHub, lalu buka Settings › Pages › Branch `main`, folder `/docs`.

Catat dua alamat berikut:
- Kebijakan privasi: `https://ALAMAT-SITUS/kebijakan-privasi.html`. Sebelumnya, ganti tulisan `EMAIL_KONTAK` di berkas tersebut.
- Paket daring: `https://ALAMAT-SITUS/paket-ar.json`

## Langkah 2 — Latih di kebun

1. Buka alamat situs di HP, masuk menu **Admin** (PIN awal `1234`, ganti di Paket & setelan).
2. **Latih**: rekam tiap tanaman minimal 3 sesi (daun dekat, tajuk, batang, di jam berbeda), sekitar 30 contoh per tanaman. Isi juga kelas **Latar**.
3. **Uji akurasi**: terapkan ambang yang disarankan sampai "Salah kenali" = 0.
4. **Label QR**: cetak dan pasang di papan nama. Isi kolom alamat dengan alamat situs agar QR juga bisa dibuka dari kamera HP biasa.
5. **Paket & setelan › Unduh paket-ar.json**, lalu letakkan berkasnya di folder `docs/` (dan unggah ulang ke situs).

## Langkah 3 — Isi pengaturan aplikasi

Buka `android/gradle.properties`:

```
kebun.applicationId=id.ac.poltekkes_smg.kebunpewarna   ← ID unik, tidak bisa diganti setelah terbit
kebun.versionCode=1
kebun.versionName=1.0
kebun.paketUrl=https://ALAMAT-SITUS/paket-ar.json       ← agar aplikasi memperbarui dirinya sendiri
```

Dengan `paketUrl` terisi, setiap kali admin mengunggah `paket-ar.json` baru ke situs, HP pengunjung ikut memperbarui pengenalan tanaman begitu tersambung internet. Tidak perlu menerbitkan versi baru di Play Store.

## Langkah 4 — Build berkas AAB

### Cara A: Android Studio (disarankan)
1. Pasang Android Studio (gratis) dari developer.android.com/studio.
2. **File › Open** lalu pilih folder `android`. Tunggu proses "Gradle sync" selesai. Pada build pertama, komputer harus tersambung internet karena pustaka dan model (±15 MB) diunduh sekali lalu dikemas ke aplikasi.
3. Uji di HP: sambungkan HP (aktifkan *USB debugging*), lalu tekan tombol ▶ Run.
4. **Build › Generate Signed App Bundle or APK › Android App Bundle › Create new…** untuk membuat kunci. Simpan berkas `.jks` dan kata sandinya baik-baik; kunci yang sama wajib dipakai untuk setiap pembaruan.
5. Pilih **release**, lalu tunggu. Berkas `app-release.aab` ada di `android/app/release/`.

### Cara B: GitHub Actions (tanpa memasang apa pun)
1. Unggah proyek ini ke repositori GitHub **privat**.
2. Tab **Actions › Buat kunci tanda tangan › Run workflow**. Unduh artefak `kunci-rilis-RAHASIA`, lalu ikuti isi `RAHASIA-simpan-baik-baik.txt` untuk mengisi 4 rahasia di Settings › Secrets and variables › Actions.
3. Tab **Actions › Bangun aplikasi Android › Run workflow**. Setelah selesai, unduh:
   - `apk-uji`: pasang langsung di HP untuk mencoba.
   - `aab-play-store`: berkas untuk diunggah ke Play Console.

## Langkah 5 — Terbitkan di Google Play

1. Daftar akun developer di play.google.com/console (biaya sekali US$25). Bila memungkinkan, daftar atas nama **organisasi** (Poltekkes, memerlukan nomor D-U-N-S). Akun **pribadi** baru wajib menjalankan *closed testing* dengan minimal 12 penguji selama 14 hari berturut-turut sebelum boleh terbit ke publik.
2. **Buat aplikasi** dengan bahasa default Indonesia, jenis Aplikasi, gratis.
3. Isi **Listing toko** dari `play-store/teks-listing.txt`, lalu unggah `ikon-512.png`, `grafis-fitur-1024x500.png`, dan tangkapan layar. Sebaiknya tambahkan satu tangkapan layar asli saat memindai tanaman di kebun.
4. Isi **Konten aplikasi** (kebijakan privasi, keamanan data, rating, target audiens) memakai jawaban di `teks-listing.txt`.
5. **Pengujian › Pengujian tertutup** (akun pribadi) atau **Produksi** (akun organisasi), lalu unggah `app-release.aab` dan kirim untuk ditinjau.

## Memperbarui aplikasi

- **Pengenalan atau infografis berubah:** cukup unggah `paket-ar.json` baru ke situs (bila `paketUrl` diisi).
- **Tampilan atau fitur berubah:** ganti `docs/index.html`, naikkan `kebun.versionCode` (+1), build ulang, lalu unggah AAB baru.
