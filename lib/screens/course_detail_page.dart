// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/screens/course_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_form_page.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daftar Materi Ini?'),
        content: Text('Apakah Anda ingin mendaftar kelas ${course.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pendaftaran Berhasil!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: const Text('Daftar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Course target) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Hapus Course?'),
      content: Text('Course "${target.title}" akan dihapus permanen.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );

  if (confirmed != true) return;
  if (!context.mounted) return;

  final provider = context.read<CourseProvider>();
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);

  final ok = await provider.deleteCourse(target);

  if (ok) {
    navigator.pop(); // kembali ke list (course sudah tidak ada)
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Course berhasil dihapus'),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    messenger.showSnackBar(
      SnackBar(
        content: Text(provider.saveError ?? 'Gagal menghapus course'),
        backgroundColor: Colors.red,
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String courseCode = course.code;
    
    // PERBAIKAN: Ubah nama variabel menjadi currentCourse agar tidak bentrok dengan this.course
    final currentCourse = context.watch<CourseProvider>().courses.firstWhere(
      (c) => c.code == courseCode,
      orElse: () => course,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(currentCourse.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseFormPage(course: currentCourse),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, currentCourse),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    currentCourse.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Consumer<CourseProvider>(
                  builder: (context, provider, child) {
                    final isFav = provider.isFavorite(courseCode);
                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 32,
                      ),
                      onPressed: () {
                        context
                            .read<CourseProvider>()
                            .toggleFavorite(courseCode);
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Kode: ${currentCourse.code}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('SKS: ${currentCourse.credits}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Status: ${currentCourse.status}',
                style: const TextStyle(fontSize: 18, color: Colors.blue)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showConfirmDialog(context),
                icon: const Icon(Icons.app_registration),
                label: const Text('Daftar Kelas Ini'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}