// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/screens/course_form_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  const CourseFormPage({super.key});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _creditsCtrl = TextEditingController();
  String _status = 'planned';

  @override
  void dispose() {
    _codeCtrl.dispose();
    _titleCtrl.dispose();
    _creditsCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

// Dewa Putu Bagus Mahadinata
// NIM: 2415051023
    final provider = context.read<CourseProvider>();
    final ok = await provider.createCourse(
      Course(
        code: _codeCtrl.text.trim(),
        title: _titleCtrl.text.trim(),
        credits: int.parse(_creditsCtrl.text.trim()),
        status: _status,
      ),
    );

    if (!context.mounted) return; // wajib setelah await

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.saveError ?? 'Gagal menyimpan course'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Course'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '$studentName • $studentId',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Kode (mis. MOB05)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Kode wajib diisi';
                  final exists = context
                      .read<CourseProvider>()
                      .courses
                      .any((c) => c.code == value);
                  if (exists) return 'Kode sudah dipakai';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _creditsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'SKS / Credits',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'SKS wajib diisi';
                  if (int.tryParse(value) == null) return 'SKS harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('planned')),
                  DropdownMenuItem(value: 'active', child: Text('active')),
                  DropdownMenuItem(value: 'done', child: Text('done')),
                ],
                onChanged: (v) => setState(() => _status = v ?? 'planned'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _submit, // nonaktif saat request
                  child: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}