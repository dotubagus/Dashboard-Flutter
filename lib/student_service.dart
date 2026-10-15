// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/student_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'models/course.dart';

class StudentService {
  // Tetap static: masih dipakai main.dart (FutureBuilder)
  static Future<Map<String, dynamic>> loadStudentData() async {
    final jsonString =
        await rootBundle.loadString('assets/data/student_data.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<List<Course>> loadCourses() async {
    final data = await loadStudentData();
    final courseListJson = data['courses'] as List<dynamic>;
    return courseListJson
        .map((json) => Course.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}