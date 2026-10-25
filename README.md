# Course Explorer v2

Nama: Dewa Putu Bagus Mahadinata
NIM: 2415051023

## Arsitektur

Arah dependency: **Screen/Widget → Provider → Repository → Service (data source)**.
Layer di bawah tidak boleh meng-import layer di atasnya.

## Tanggung jawab tiap folder (`lib/`)

| Folder / file | Tanggung jawab |
|---|---|
| `main.dart` | Titik masuk aplikasi. Merakit dependency (Service → Repository → Provider), memasang `ChangeNotifierProvider`, dan mendefinisikan `MaterialApp`. |
| `constants.dart` | Konstanta global, yaitu identitas mahasiswa (`studentName`, `studentId`). |
| `models/` | Struktur data (`Course`) dan konversi JSON lewat `Course.fromJson`. Tidak berisi UI maupun akses data. |
| `services/` | Data source. Satu-satunya tempat yang memakai `rootBundle` dan `jsonDecode` untuk membaca `assets/data/student_data.json`. Tidak berisi widget. |
| `repositories/` | Perantara antara Provider dan Service. Menyediakan API data (`getCourses()`), sehingga Provider tidak tahu data berasal dari mana. |
| `providers/` | State management (`CourseProvider`, `ChangeNotifier`). Menyimpan state courses, loading, error, dan favorites, serta memanggil `notifyListeners()`. Tidak menyimpan `BuildContext`. |
| `screens/` | Halaman penuh (Root, ResponsiveShell, Home, Courses, Favorites, Detail, Profile). Membaca state dengan `context.watch()` dan memicu aksi dengan `context.read()`. |
| `widgets/` | Komponen UI kecil yang dipakai ulang (`CourseItemCard`, `SummaryCard`, `IdentityHeader`). |

Nama: Dewa Putu Bagus Mahadinata
NIM: 2415051023
## Dokumentasi REST API (Praktikum 7)
- **Endpoint URL**: `https://course-api-pearl.vercel.app/courses`
- **HTTP Method**: GET, POST, PUT/PATCH, DELETE
- **Status Code**: 200 OK
- **Resource/Data**: JSON Course
- **Field JSON yang digunakan**:
  1. `id` (Integer)
  2. `code` (String)
  3. `title` (String)
  4. `credits` (Integer)
  5. `status` (String)