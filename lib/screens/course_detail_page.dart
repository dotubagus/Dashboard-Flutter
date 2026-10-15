// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/screens/course_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final String courseCode = course.code;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
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
                    course.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Juga mendengarkan Provider di halaman detail
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
            Text('Kode: ${course.code}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('SKS: ${course.credits}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Status: ${course.status}',
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
