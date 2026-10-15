// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/screens/courses_page.dart

import 'package:flutter/material.dart';

import '../models/course.dart';
import '../widgets/course_item_card.dart';

class CoursesPage extends StatelessWidget {
  final List<Course> courses;

  const CoursesPage({
    super.key,
    required this.courses,
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
                final course = courses[index];
                return CourseItemCard(course: course);
              },
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return CourseItemCard(course: course);
              },
            );
          }
        },
      ),
    );
  }
}
