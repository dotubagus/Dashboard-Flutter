// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';
import '../widgets/summary_card.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> student;
  final List<Course> courses;

  const HomePage({
    super.key,
    required this.student,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    int totalSks = 0;
    int completedTopics = 0;
    for (final course in courses) {
      totalSks += course.credits;
      if (course.status == 'done') completedTopics++;
    }

    // context.watch() untuk mendengarkan jumlah favorit
    final favoriteCount = context.watch<CourseProvider>().favorites.length;

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
              'Cek Tab "Courses" untuk mencoba fungsi Favorite (State dikelola Provider)',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
