// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/screens/favorites_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_item_card.dart';

// TAHAP 13: hanya menampilkan course favorit.
// Data berasal dari CourseProvider yang sama dengan Home, Courses, dan Detail
// (single source of truth), sehingga otomatis konsisten.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: halaman ini harus rebuild saat favorit berubah
    final favorites = context.watch<CourseProvider>().favoriteCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada course favorit.\nTekan ikon hati pada tab Courses.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) =>
                  CourseItemCard(course: favorites[index]),
            ),
    );
  }
}
