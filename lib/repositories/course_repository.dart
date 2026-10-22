// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/repositories/course_repository.dart

import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  CourseRepository(this.service);
  final CourseApiService service;

  Future<List<Course>> getCourses() => service.getCourses();

  Future<Course> createCourse(Course course) => service.createCourse(course);

  Future<void> updateCourse(int id, Course course) =>
    service.updateCourse(id, course);
}
