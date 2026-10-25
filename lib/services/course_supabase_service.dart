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
Future<void> updateCourse(int id, Course course) async {
  final rows = await supabase
      .from('courses')
      .update(course.toJson())
      .eq('id', id)
      .select();
  if (rows.isEmpty) {
    throw Exception('Data tidak berubah. Cek policy UPDATE atau id.');
  }
}

@override
Future<void> deleteCourse(int id) async {
  final rows = await supabase
      .from('courses')
      .delete()
      .eq('id', id)
      .select();
  if (rows.isEmpty) {
    throw Exception('Data tidak terhapus. Cek policy DELETE atau id.');
  }
}
}