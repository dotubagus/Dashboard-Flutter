// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/services/course_data_source.dart

import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(int id, Course course);
  Future<void> deleteCourse(int id);
}