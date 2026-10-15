// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/course_provider.dart

import 'package:flutter/material.dart';

import 'models/course.dart';
import 'repositories/course_repository.dart'; // TAHAP 10 (ganti import student_service)

class CourseProvider extends ChangeNotifier {
  // TAHAP 10: dependency ke repository
  final CourseRepository repository;
  CourseProvider(this.repository);

  List<Course> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;

  final Set<String> _favorites = {};

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Set<String> get favorites => _favorites;

  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }

  Future<void> fetchCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TAHAP 10: Provider hanya bicara dengan repository.
      // Tidak ada lagi rootBundle, jsonDecode, atau parsing di sini.
      _courses = await repository.getCourses();

      // Log sementara untuk bukti Tahap 10 (boleh dihapus di Tahap 11)
      debugPrint(
        '[Tahap 10] ${_courses.length} course dimuat via Repository '
        '- Dewa Putu Bagus Mahadinata / 2415051023',
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}