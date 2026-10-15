// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/screens/profile_feedback_page.dart

import 'package:flutter/material.dart';

import '../widgets/identity_header.dart';

// Eksperimen ValueNotifier pada halaman Profil (Tahap 4)
class ProfileFeedbackPage extends StatefulWidget {
  final Map<String, dynamic> student;
  const ProfileFeedbackPage({super.key, required this.student});

  @override
  State<ProfileFeedbackPage> createState() => _ProfileFeedbackPageState();
}

class _ProfileFeedbackPageState extends State<ProfileFeedbackPage> {
  final ValueNotifier<int> _targetBelajar = ValueNotifier<int>(0);

  @override
  void dispose() {
    _targetBelajar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Target'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IdentityHeader(student: widget.student),
            const SizedBox(height: 30),
            const Text(
              'Eksperimen Tahap 4: ValueNotifier',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: _targetBelajar,
              builder: (context, value, child) {
                return Card(
                  color: Colors.indigo.shade50,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Target Belajar Mingguan: $value Jam',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _targetBelajar.value += 1;
                },
                icon: const Icon(Icons.add_alarm),
                label: const Text('Tambah 1 Jam Target'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
