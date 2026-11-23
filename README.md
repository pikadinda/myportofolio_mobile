# myportofolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Tugas 8
1. Ketiga metode tersebut digunakan untuk mengatur perpindahan halaman di Flutter, tetapi cara kerjanya berbeda, sebagai berikut:
- `Navigator.push()` digunakan untuk membuka halaman baru tanpa menghapus halaman sebelumnya dari navigation stack. Jadi, pengguna masih bisa kembali ke halaman sebelumnya menggunakan tombol Back.
- `Navigator.pushReplacement()` digunakan untuk mengganti halaman yang sedang dibuka dengan halaman baru. Halaman sebelumnya digantikan sehingga tidak lagi menjadi halaman yang bisa dikunjungi kembali melalui tombol Back.
- `Navigator.pop()` digunakan untuk menutup halaman atau dialog yang sedang aktif dan kembali ke halaman sebelumnya.
Pada aplikasi ini, `Navigator.push()` digunakan ketika pengguna menekan kartu **Tambah Experience** di halaman Home untuk membuka halaman Experience Form. Metode yang sama juga digunakan untuk membuka halaman Add Project dari kartu aksinya.
Sementara itu, opsi **Home** pada Drawer menggunakan `Navigator.pushReplacement()` untuk mengganti halaman yang sedang dibuka dengan halaman Home (`MyHomePage`). JAdi, pengguna bisa kembali ke halaman utama dari halaman formulir tanpa harus menekan tombol Back berkali-kali. `Navigator.pop()` digunakan untuk menutup AlertDialog setelah pengguna menekan tombol OK.

2. `Scaffold` berfungsi sebagai kerangka utama setiap halaman Flutter. Di dalamnya terdapat komponen seperti `AppBar`, `Drawer`, dan `body` yang berisi konten utama halaman. Dengan menggunakan susunan tersebut, setiap halaman memiliki struktur yang konsisten dan mudah dinavigasi.
Pada aplikasi ini, halaman Home, Add Project, dan Experience Form menggunakan `Scaffold` serta `AppBar`. Drawer juga dibuat dalam satu widget terpisah, yaitu `LeftDrawer`, kemudian digunakan kembali pada halaman-halaman tersebut. Dengan cara ini, menu navigasi tidak perlu dibuat ulang untuk setiap halaman dan tampilannya tetap sama.
Warna tema portofolio yang digunakan adalah indigo. Contohnya, warna ini digunakan pada kartu aksi di halaman Home dan bagian `DrawerHeader` pada Drawer yang dapat diakses dari beberapa halaman. Penggunaan warna yang sama membantu menjaga tampilan aplikasi agar tetap seragam.

3. Form Experience menggunakan susunan vertikal dengan `Column` agar setiap kolom input ditampilkan secara berurutan dan mudah diisi. PEmilihan tata letak ini karena formulir memiliki beberapa input, sehingga lebih nyaman jika pengguna mengisinya dari atas ke bawah.
Widget `Padding` dan `SizedBox` digunakan untuk mengatur jarak antarbagian formulir agar setiap input tidak terlalu berdempetan dan tampilan lebih rapi.
Selain itu, `SingleChildScrollView` digunakan agar formulir tetap bisa digulir ketika tinggi layar terbatas. Widget ini membantu pengguna mengakses seluruh kolom input sampai tombol Save, termasuk ketika formulir tidak muat ditampilkan sekaligus pada layar atau ketika keyboard sedang terbuka.
Dengan kombinasi widget tersebut, formulir tetap nyaman digunakan pada ukuran layar yang berbeda.

4. `GlobalKey<FormState>` digunakan untuk menghubungkan kode dengan state dari widget `Form`. Dengan key ini, aplikasi dapat mengakses dan menjalankan fungsi validasi pada formulir.
`validator` merupakan fungsi yang digunakan untuk memeriksa apakah nilai pada suatu kolom sudah sesuai dengan ketentuan. Jika nilai tidak valid, validator akan mengembalikan pesan kesalahan yang ditampilkan pada kolom tersebut.
Sementara itu, `validate()` digunakan untuk menjalankan seluruh validator pada formulir ketika pengguna menekan tombol Save. Jika semua input valid, aplikasi akan menampilkan AlertDialog yang berisi ringkasan data. Jika masih ada input yang tidak valid, proses tersebut tidak dilanjutkan dan pesan kesalahan akan ditampilkan pada kolom yang bermasalah.
Contoh nilai yang ditolak oleh validasi adalah:
- Experience Title yang kosong atau hanya berisi spasi.
- Description yang kosong atau hanya berisi spasi.
- Thumbnail URL yang diisi dengan teks tidak valid.
Memilih jenis input atau papan ketik saja belum cukup untuk memastikan data valid. Contohnya, penggunaan `TextInputType.url` memang menampilkan papan ketik yang sesuai untuk memasukkan URL, tetapi pengguna tetap bisa mengetik teks biasa yang bukan URL. Oleh karena itu, diperlukan `validator` untuk memeriksa nilai yang benar-benar dimasukkan oleh pengguna.

### AI Disclosure Tugas 8
Dalam pengerjaan Tugas 8 ini, saya menggunakan ChatGPT sebagai alat bantu untuk mempelajari konsep navigasi dan validasi form di Flutter, serta membantu menemukan dan memperbaiki kesalahan selama proses pengembangan.

Bentuk bantuan AI yang saya gunakan antara lain:
- Membantu memahami deskripsi Tugas 8 dan menentukan field Experience Form berdasarkan model `Experience` pada proyek portofolio.
- Membantu menganalisis pesan error, memeriksa struktur file, dan memperbaiki kode agar dapat dijalankan tanpa masalah.

Dalam menggunakan AI, saya membagikan potongan kode dan pesan error dari terminal, kemudian meminta penjelasan atau saran perbaikan secara bertahap. Saya juga menggunakan bantuan AI untuk memahami fungsi dari kode yang digunakan, bukan hanya menyalin hasilnya.

Keterbatasan AI adalah AI tidak dapat memastikan secara langsung bahwa kode sudah berjalan dengan benar pada lingkungan lokal saya. Karena itu, saya melakukan pengujian secara langsung dan memastikan setiap fitur berjalan sesuai kebutuhan tugas.