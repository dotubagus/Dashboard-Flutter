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

  final Set<String> _favorites = {};

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
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

  Future<void> loadCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
