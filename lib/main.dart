import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const CourseExplorerApp());
}

const String studentName = 'Dewa Putu Bagus Mahadinata';
const String studentId = '2415051023';

class StudentService {
  static Future<Map<String, dynamic>> loadStudentData() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MainDataLoader(),
    );
  }
}

class MainDataLoader extends StatefulWidget {
  const MainDataLoader({super.key});

  @override
  State<MainDataLoader> createState() => _MainDataLoaderState();
}

class _MainDataLoaderState extends State<MainDataLoader> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = StudentService.loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat data JSON: ${snapshot.error}'),
            );
          }
          final data = snapshot.data!;
          return ResponsiveShell(
            student: data['student'] as Map<String, dynamic>,
            courses: data['courses'] as List<dynamic>,
          );
        },
      ),
    );
  }
}

// ----------------------------------------------------------------------
// TAHAP 3: LIFTING STATE UP & SINGLE SOURCE OF TRUTH
// State dipindahkan ke Ancestor tertinggi yang membawahi semua halaman
// ----------------------------------------------------------------------
class ResponsiveShell extends StatefulWidget {
  final Map<String, dynamic> student;
  final List<dynamic> courses;

  const ResponsiveShell({
    super.key,
    required this.student,
    required this.courses,
  });

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  // SINGLE SOURCE OF TRUTH: Hanya ada satu state ini untuk seluruh aplikasi
  Set<String> favoriteCourseCodes = {};

  // CALLBACK: Fungsi yang akan dioper ke bawah untuk mengubah state
  void _toggleFavorite(String code) {
    setState(() {
      if (favoriteCourseCodes.contains(code)) {
        favoriteCourseCodes.remove(code);
      } else {
        favoriteCourseCodes.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Home hanya butuh menerima "jumlah" favoritnya saja
      HomePage(
        student: widget.student,
        courses: widget.courses,
        favoriteCount: favoriteCourseCodes.length,
      ),
      // Courses menerima seluruh data state dan fungsi callback-nya
      CoursesPage(
        courses: widget.courses,
        favoriteCourseCodes: favoriteCourseCodes,
        onFavoriteToggle: _toggleFavorite,
      ),
      ProfileFeedbackPage(student: widget.student),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 840) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.indigo.shade50,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: pages[_selectedIndex]),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.school_outlined),
                  selectedIcon: Icon(Icons.school),
                  label: 'Courses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// ----------------------------------------------------------------------
// HomePage dikembalikan menjadi StatelessWidget (Tidak punya state sendiri)
// ----------------------------------------------------------------------
class HomePage extends StatelessWidget {
  final Map<String, dynamic> student;
  final List<dynamic> courses;
  final int favoriteCount; // Menerima data dari Parent

  const HomePage({
    super.key,
    required this.student,
    required this.courses,
    required this.favoriteCount,
  });

  @override
  Widget build(BuildContext context) {
    int totalSks = 0;
    int completedTopics = 0;
    for (var course in courses) {
      totalSks += (course['credits'] as int);
      if (course['status'] == 'done') completedTopics++;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IdentityHeader(student: student),
            const SizedBox(height: 24),
            const Text(
              'Ringkasan Belajar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Selesai',
                    value: '$completedTopics/${courses.length}',
                    icon: Icons.task_alt,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SummaryCard(
                    title: 'SKS',
                    value: '$totalSks',
                    icon: Icons.menu_book,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                // Menampilkan jumlah berdasarkan properti yang dikirim Parent
                Expanded(
                  child: SummaryCard(
                    title: 'Favorit',
                    value: '$favoriteCount',
                    icon: Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Cek Tab "Courses" untuk mencoba fungsi Favorite',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// CoursesPage menerima state dan meneruskannya ke tiap CourseItemCard
// ----------------------------------------------------------------------
class CoursesPage extends StatelessWidget {
  final List<dynamic> courses;
  final Set<String> favoriteCourseCodes; // Data dari parent
  final void Function(String) onFavoriteToggle; // Fungsi dari parent

  const CoursesPage({
    super.key,
    required this.courses,
    required this.favoriteCourseCodes,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Materi'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth >= 840 ? 3 : 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index] as Map<String, dynamic>;
                return CourseItemCard(
                  course: course,
                  isFavorite: favoriteCourseCodes.contains(course['code']),
                  onFavoriteToggle: () => onFavoriteToggle(course['code']),
                );
              },
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index] as Map<String, dynamic>;
                return CourseItemCard(
                  course: course,
                  // Mengoper ke child terdalam
                  isFavorite: favoriteCourseCodes.contains(course['code']),
                  onFavoriteToggle: () => onFavoriteToggle(course['code']),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// ----------------------------------------------------------------------
// CourseItemCard menampilkan ikon dan men-trigger fungsi Parent
// ----------------------------------------------------------------------
class CourseItemCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CourseItemCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = (course['status'] == 'done')
        ? Colors.green
        : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withAlpha(76)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigasi ke detail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(course: course),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.library_books, color: statusColor, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course['code']} • ${course['credits']} SKS',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Tombol aksi dikembalikan ke Parent via Callback
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: onFavoriteToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Detail Disederhanakan kembali (Fokus utama pada Tab Courses)
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['title']),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(child: Text('Detail Materi: ${course['title']}')),
    );
  }
}

// ----------------------------------------------------------------------
// TAHAP 4: Eksperimen ValueNotifier pada Halaman Profil
// ----------------------------------------------------------------------
class ProfileFeedbackPage extends StatefulWidget {
  final Map<String, dynamic> student;
  const ProfileFeedbackPage({super.key, required this.student});

  @override
  State<ProfileFeedbackPage> createState() => _ProfileFeedbackPageState();
}

class _ProfileFeedbackPageState extends State<ProfileFeedbackPage> {
  // 1. Buat ValueNotifier untuk satu nilai sederhana (Target Jam Belajar)
  final ValueNotifier<int> _targetBelajar = ValueNotifier<int>(0);

  @override
  void dispose() {
    // ValueNotifier wajib di-dispose untuk mencegah kebocoran memori (memory leak)
    _targetBelajar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil & Target'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IdentityHeader(student: widget.student),
            const SizedBox(height: 30),
            const Text('Eksperimen Tahap 4: ValueNotifier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            
            // 2. Tampilkan nilai menggunakan ValueListenableBuilder
            // Hanya bagian di dalam builder ini yang akan di-rebuild saat _targetBelajar berubah!
            ValueListenableBuilder<int>(
              valueListenable: _targetBelajar,
              builder: (context, value, child) {
                return Card(
                  color: Colors.indigo.shade50,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Target Belajar Mingguan: $value Jam',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // 3. Button untuk mengubah value
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // MENGUBAH VALUE TANPA SETSTATE()
                  // Saat value ditambahkan, ValueListenableBuilder otomatis bereaksi
                  _targetBelajar.value += 1; 
                },
                icon: const Icon(Icons.add_alarm),
                label: const Text('Tambah 1 Jam Target'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IdentityHeader extends StatelessWidget {
  final Map<String, dynamic> student;
  const IdentityHeader({super.key, required this.student});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student['name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          Text('NIM: ${student['nim']}', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
