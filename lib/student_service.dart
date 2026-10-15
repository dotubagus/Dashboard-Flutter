// lib/student_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'models/course.dart';

class StudentService {
  // Fungsi untuk memuat dan memparsing data JSON mentah menjadi Model
  static Future<Map<String, dynamic>> loadStudentData() async {
    final jsonString = await rootBundle.loadString('assets/data/student_data.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  // (Opsional/Pengembangan) Fungsi khusus untuk mengambil list Course secara langsung
  static Future<List<Course>> loadCourses() async {
    final data = await loadStudentData();
    final courseListJson = data['courses'] as List<dynamic>;
    return courseListJson
        .map((json) => Course.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}