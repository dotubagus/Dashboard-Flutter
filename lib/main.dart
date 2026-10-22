// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_root.dart';
import 'services/student_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          CourseProvider(CourseRepository(StudentService()))..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
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
      home: const CourseRoot(),
    );
  }
}