// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/screens/course_root.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/error_view.dart';
import '../constants.dart';
import '../providers/course_provider.dart';
import 'responsive_shell.dart';
import 'course_form_page.dart';

// UI hanya membaca state dari Provider (loading/error/data)
class CourseRoot extends StatelessWidget {
  const CourseRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    // State: Loading
    if (provider.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat data course...'),
            ],
          ),
        ),
      );
    }

    // State: Error (pakai ErrorView + retry)
    if (provider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('$studentName - $studentId')),
        body: ErrorView(
          message: provider.errorMessage!,
          onRetry: provider.loadCourses,
        ),
      );
    }

    // State: Empty
    if (provider.courses.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('Data course belum tersedia'),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: provider.loadCourses,
                icon: const Icon(Icons.refresh),
                label: const Text('Muat ulang'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CourseFormPage()),
  ),
  child: const Icon(Icons.add),
),
      );
    }

    // State: Success
    return ResponsiveShell(
      student: const {'name': studentName, 'nim': studentId},
      courses: provider.courses,
    );
  }
}
