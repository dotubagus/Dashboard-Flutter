// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/services/student_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

class StudentService {
  // Detail teknis membaca asset JSON hanya ada di layer ini.
  static Future<Map<String, dynamic>> loadStudentData() async {
    final jsonString =
        await rootBundle.loadString('assets/data/student_data.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

}
