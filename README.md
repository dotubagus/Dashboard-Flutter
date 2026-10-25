# Course Data Manager (Course Explorer v2)

Aplikasi Flutter untuk mengelola data course (CRUD) yang terhubung ke backend Supabase.

- **Nama:** Dewa Putu Bagus Mahadinata
- **NIM:** 2415051023
- **Mata kuliah / Pertemuan:** Pertemuan 7 – REST API, Backend, dan Database

## Fitur

- Melihat daftar course (Read/SELECT) dalam tampilan List atau Grid yang responsif
- Menambah course lewat form dengan validasi (Create/INSERT)
- Mengubah course dari halaman detail (Update)
- Menghapus course dengan dialog konfirmasi (Delete)
- Favorites (berdasarkan `code`) yang tetap konsisten setelah refresh data
- State loading, empty, error (dengan tombol Coba Lagi), dan SnackBar untuk hasil operasi
- Navigasi responsif: NavigationBar (layar sempit) dan NavigationRail (layar lebar)

## Backend yang Digunakan

**Supabase** (PostgreSQL + REST/PostgREST), tabel `courses`:

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | bigint identity | Primary key |
| code | text | Kode course |
| title | text | Judul course |
| credits | int | Jumlah SKS |
| status | text | `planned` / `active` / `done` (CHECK constraint) |
| created_at | timestamp | Waktu pembuatan |

Skema ada di `supabase/schema.sql`. RLS aktif dengan policy permisif untuk role `anon`;
policy ini **hanya untuk laboratorium**, bukan pola produksi.

## Cara Menjalankan

1. Pastikan Flutter SDK terpasang (`flutter doctor`).
2. Clone repository:
   ```bash
   git clone https://github.com/dotubagus/Dashboard-Flutter.git
   cd Dashboard-Flutter
   ```
3. Instal dependency:
   ```bash
   flutter pub get
   ```
4. Isi `lib/supabase_config.dart` dengan Project URL dan **anon/publishable key** milik project Supabase Anda.
   Jangan memakai `service_role` key.
5. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## Arsitektur Singkat

```
UI (screens/widgets) → CourseProvider → CourseRepository → CourseDataSource → Supabase / REST
```

```
lib/
├── main.dart                      # merakit data source → repository → provider
├── constants.dart                 # identitas (nama, NIM), apiBaseUrl
├── supabase_config.dart           # Project URL + anon key
├── models/course.dart             # Course.fromJson / toJson
├── services/
│   ├── course_data_source.dart    # kontrak (abstract class)
│   ├── course_supabase_service.dart  # implementasi Supabase (aktif)
│   └── course_api_service.dart       # implementasi REST (cadangan)
├── repositories/course_repository.dart
├── providers/course_provider.dart # state: loading, error, saving, favorites
├── screens/                       # halaman aplikasi
└── widgets/                       # komponen UI reusable
```

Sumber data dipilih hanya di `main.dart`. Untuk berpindah ke REST, ganti satu baris:

```dart
final CourseDataSource dataSource = CourseSupabaseService();   // Supabase
// final CourseDataSource dataSource = CourseApiService(apiBaseUrl); // REST
```

Screen, provider, dan repository tidak perlu diubah.

## Keamanan

- Hanya anon/publishable key yang dipakai di client; tidak ada `service_role` key atau secret server.
- Keamanan data bergantung pada RLS di backend; validasi UI bukan pengganti validasi backend.
- Folder `build/` dan file `.env` tidak di-commit (lihat `.gitignore`).