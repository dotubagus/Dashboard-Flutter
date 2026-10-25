// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/services/course_supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase.from('courses').select().order('id');
    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

// Dewa Putu Bagus Mahadinata
// NIM: 2415051023
  @override
Future<Course> createCourse(Course course) async {
  final row = await supabase
      .from('courses')
      .insert(course.toJson())
      .select()
      .single();
  return Course.fromJson(row);
}

  @override
  Future<void> updateCourse(int id, Course course) =>
      throw UnimplementedError();

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}