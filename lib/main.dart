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
    final jsonString = await rootBundle.loadString('assets/data/student_data.json');
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
    _futureData = StudentService.loadStudentData(); // Memuat data JSON saat awal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Feedback Loading
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data JSON: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          // Melempar data JSON ke Shell Navigasi Adaptif
          return ResponsiveShell(
            student: data['student'] as Map<String, dynamic>,
            courses: data['courses'] as List<dynamic>,
          );
        },
      ),
    );
  }
}

class ResponsiveShell extends StatefulWidget {
  final Map<String, dynamic> student;
  final List<dynamic> courses;

  const ResponsiveShell({super.key, required this.student, required this.courses});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Menyiapkan daftar halaman yang akan ditampilkan
    final List<Widget> pages = [
      HomePage(student: widget.student, courses: widget.courses),
      CoursesPage(courses: widget.courses),
      ProfileFeedbackPage(student: widget.student),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // --- LAYOUT EXPANDED (Layar Lebar / Desktop / Tablet Landscape) ---
        if (constraints.maxWidth >= 840) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.indigo.shade50,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: Text('Courses')),
                    NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: pages[_selectedIndex]),
              ],
            ),
          );
        }
        // --- LAYOUT COMPACT / MEDIUM (Layar HP Portrait) ---
        else {
          return Scaffold(
            body: pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
                NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          );
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final Map<String, dynamic> student;
  final List<dynamic> courses;

  const HomePage({super.key, required this.student, required this.courses});

  @override
  Widget build(BuildContext context) {
    int totalSks = 0;
    int completedTopics = 0;
    for (var course in courses) {
      totalSks += (course['credits'] as int);
      if (course['status'] == 'done') completedTopics++;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IdentityHeader(student: student), // Memanggil Reusable Widget
            const SizedBox(height: 24),
            const Text('Ringkasan Belajar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: SummaryCard(title: 'Topik Selesai', value: '$completedTopics/${courses.length}', icon: Icons.task_alt, color: Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: SummaryCard(title: 'Total SKS', value: '$totalSks SKS', icon: Icons.menu_book, color: Colors.orange)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CoursesPage extends StatelessWidget {
  final List<dynamic> courses;
  const CoursesPage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Materi'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Jika layar cukup lebar (Medium/Expanded), gunakan GridView
          if (constraints.maxWidth >= 600) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth >= 840 ? 3 : 2, // 3 kolom di layar sangat lebar, 2 kolom di medium
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) => CourseItemCard(course: courses[index] as Map<String, dynamic>),
            );
          }
          // Jika layar Compact (HP biasa), gunakan ListView
          else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) => CourseItemCard(course: courses[index] as Map<String, dynamic>),
            );
          }
        },
      ),
    );
  }
}

class ProfileFeedbackPage extends StatefulWidget {
  final Map<String, dynamic> student;
  const ProfileFeedbackPage({super.key, required this.student});

  @override
  State<ProfileFeedbackPage> createState() => _ProfileFeedbackPageState();
}

class _ProfileFeedbackPageState extends State<ProfileFeedbackPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil & Feedback'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IdentityHeader(student: widget.student),
            const SizedBox(height: 30),
            const Text('Berikan Feedback Pembelajaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Feedback / Saran', border: OutlineInputBorder()),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Feedback tidak boleh kosong';
                      if (value.trim().length < 5) return 'Minimal berisi 5 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Memvalidasi input form
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Feedback berhasil dikirim!'), backgroundColor: Colors.green),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Kirim Data', style: TextStyle(fontSize: 16)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;
  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool _isFavorite = false;

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daftar Materi Ini?'),
        content: Text('Apakah Anda ingin mendaftar kelas ${widget.course['title']}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              // Tampilkan SnackBar sukses
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pendaftaran Berhasil!'), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            child: const Text('Daftar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.course['title']), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(widget.course['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                // Interaksi Inkwell/IconButton
                IconButton(
                  icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 32),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Kode: ${widget.course['code']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('SKS: ${widget.course['credits']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Status: ${widget.course['status']}', style: const TextStyle(fontSize: 18, color: Colors.blue)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showConfirmDialog, // Memanggil Dialog
                icon: const Icon(Icons.app_registration),
                label: const Text('Daftar Kelas Ini'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Reusable 1: Identitas Mahasiswa
class IdentityHeader extends StatelessWidget {
  final Map<String, dynamic> student;
  const IdentityHeader({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(student['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
          const SizedBox(height: 4),
          Text('NIM: ${student['nim']}', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Reusable 2: Kartu Summary / Ringkasan
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({super.key, required this.title, required this.value, required this.icon, required this.color});

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
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Reusable 3: Item List/Grid Materi
class CourseItemCard extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseItemCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    Color statusColor = (course['status'] == 'done') ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: statusColor.withOpacity(0.3))),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigasi ke Detail
          Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailPage(course: course)));
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
                    Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('${course['code']} • ${course['credits']} SKS', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}