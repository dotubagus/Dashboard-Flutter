// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/widgets/identity_header.dart

import 'package:flutter/material.dart';

class IdentityHeader extends StatelessWidget {
  final Map<String, dynamic> student;
  const IdentityHeader({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student['name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 4),
          Text('NIM: ${student['nim']}', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
