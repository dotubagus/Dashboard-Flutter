// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/screens/course_root.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../providers/course_provider.dart';
import 'responsive_shell.dart';

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

    // State: Error
    if (provider.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                const Text(
                  'Gagal memuat data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(provider.errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<CourseProvider>().loadCourses(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
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
