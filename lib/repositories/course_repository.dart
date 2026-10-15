// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/repositories/course_repository.dart

import '../models/course.dart';
import '../services/student_service.dart';

class CourseRepository {
  final StudentService service;

  // Service diterima lewat constructor (dependency injection)
  CourseRepository(this.service);

  // API sederhana untuk Provider. Provider tidak perlu tahu
  // data berasal dari JSON, REST API, atau database.
  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}
