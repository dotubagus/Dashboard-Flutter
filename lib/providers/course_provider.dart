// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/providers/course_provider.dart

import 'package:flutter/material.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;
  CourseProvider(this.repository);

  // State async: courses (data), isLoading (loading), errorMessage (error)
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool _isSaving = false;
  String? _saveError;

  final Set<String> _favorites = {};

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isSaving => _isSaving;
  String? get saveError => _saveError;

  Set<String> get favorites => _favorites;

  List<Course> get favoriteCourses =>
      _courses.where((c) => _favorites.contains(c.code)).toList();

  bool isFavorite(String code) => _favorites.contains(code);

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }

  Future<void> loadCourses({bool showLoading = true}) async {
  if (showLoading) {
    _isLoading = true;
    notifyListeners();
  }
  _errorMessage = null;

  try {
    _courses = await repository.getCourses(); // ganti isi list, bukan tambah
  } catch (e) {
    _errorMessage = e.toString().replaceFirst('Exception: ', '');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
  }

  Future<bool> createCourse(Course course) async {
  if (_isSaving) return false; // cegah submit ganda
  _isSaving = true;
  _saveError = null;
  notifyListeners();

  try {
    await repository.createCourse(course);
    await loadCourses(showLoading: false);
    return true;
  } catch (e) {
    _saveError = e.toString().replaceFirst('Exception: ', '');
    return false;
  } finally {
    _isSaving = false;
    notifyListeners();
  }
 }

 Future<bool> updateCourse(int id, Course course) async {
  if (_isSaving) return false; // cegah submit ganda
  _isSaving = true;
  _saveError = null;
  notifyListeners();

  try {
    await repository.updateCourse(id, course);
    await loadCourses(showLoading: false);
    return true;
  } catch (e) {
    _saveError = e.toString().replaceFirst('Exception: ', '');
    return false;
  } finally {
    _isSaving = false;
    notifyListeners();
  }
}

// Dewa Putu Bagus Mahadinata
// NIM: 2415051023
Future<bool> deleteCourse(Course course) async {
  if (_isSaving) return false;
  if (course.id == null) {
    _saveError = 'ID course tidak ditemukan';
    return false;
  }
  _isSaving = true;
  _saveError = null;
  notifyListeners();

  try {
    await repository.deleteCourse(course.id!);
    _favorites.remove(course.code);
    await loadCourses(showLoading: false);
    return true;
  } catch (e) {
    _saveError = e.toString().replaceFirst('Exception: ', '');
    return false;
  } finally {
    _isSaving = false;
    notifyListeners();
  }
}
}
