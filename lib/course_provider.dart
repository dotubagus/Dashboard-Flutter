// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// Tahap 5: Pembuatan ChangeNotifier

import 'package:flutter/material.dart';

class CourseProvider extends ChangeNotifier {
  // 1. STATE: Menyimpan daftar ID/Code materi yang difavoritkan
  final Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  // 2. ACTION: Fungsi untuk memanipulasi state
  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    
    notifyListeners();
  }
}