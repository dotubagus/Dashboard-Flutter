// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/widgets/course_item_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';

class CourseItemCard extends StatelessWidget {
  final Course course;

  const CourseItemCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        (course.status == 'done') ? Colors.green : Colors.orange;
    final String courseCode = course.code;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withAlpha(76)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
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
                      course.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$courseCode • ${course.credits} SKS',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Consumer membatasi rebuild hanya pada tombol ini
              Consumer<CourseProvider>(
                builder: (context, provider, child) {
                  final isFav = provider.isFavorite(courseCode);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      // context.read() untuk memanggil aksi
                      context.read<CourseProvider>().toggleFavorite(courseCode);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
