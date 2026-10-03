import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class StudentService {
  static Future<Map<String, dynamic>> loadStudentData() async {
    final jsonString = await rootBundle.loadString('assets/data/student_data.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap3Page(),
    );
  }
}

class LearningDashboard extends StatefulWidget {
  const LearningDashboard({super.key});

  @override
  State<LearningDashboard> createState() => _LearningDashboardState();
}

class _LearningDashboardState extends State<LearningDashboard> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = StudentService.loadStudentData();
  }

  // --- REUSABLE WIDGET 1: Profile Card ---
  Widget _buildProfileCard(Map<String, dynamic> student) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'] as String,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('NIM: ${student['nim']}'),
                  // Menampilkan field baru dari JSON
                  Text(
                    student['major'] as String,
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE WIDGET 2: Summary Card ---
  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isCompact = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureData,
          builder: (context, snapshot) {
            // Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // Error State
            if (snapshot.hasError) {
              return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
            }

            final data = snapshot.data!;
            final student = data['student'] as Map<String, dynamic>;
            final courses = data['courses'] as List<dynamic>;

            // Kalkulasi dinamis untuk Summary
            int totalSks = 0;
            int completedTopics = 0;
            for (var course in courses) {
              totalSks += (course['credits'] as int);
              if (course['status'] == 'done') completedTopics++;
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: isCompact ? Colors.blue.shade100 : Colors.green.shade100,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text(
                        '2415051023 - Dewa Putu Bagus Mahadinata',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Width: ${size.width.toStringAsFixed(0)} | Height: ${size.height.toStringAsFixed(0)}'),
                      Text('Orientation: ${orientation.name}'),
                      Text(
                        isCompact ? 'Compact' : 'Wide',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCompact ? Colors.blue.shade700 : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Sisa UI Dashboard kamu tetap aman di bawah sini ---
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProfileCard(student),
                      const SizedBox(height: 16),
                      // Summary Row
                      Row(
                        children: [
                          _buildSummaryCard('Topik Selesai', '$completedTopics/${courses.length}', Icons.task_alt, Colors.green),
                          const SizedBox(width: 12),
                          _buildSummaryCard('Total SKS', '$totalSks SKS', Icons.menu_book, Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daftar Materi',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // List View (Scrollable)
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index] as Map<String, dynamic>;
                      final status = course['status'] as String;
                      
                      Color statusColor;
                      IconData statusIcon;
                      
                      if (status == 'done') {
                        statusColor = Colors.green;
                        statusIcon = Icons.check_circle;
                      } else if (status == 'active') {
                        statusColor = Colors.blue;
                        statusIcon = Icons.play_circle_filled;
                      } else {
                        statusColor = Colors.orange;
                        statusIcon = Icons.schedule;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: statusColor.withValues(alpha: 0.3)),
                        ),
                        child: ListTile(
                          leading: Icon(statusIcon, color: statusColor, size: 32),
                          title: Text(course['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${course['code']} • ${course['credits']} SKS • ${course['type']}'),
                          trailing: Text(
                            status.toUpperCase(),
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Tahap3Page extends StatelessWidget {
  const Tahap3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3: LayoutBuilder'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // LayoutBuilder membaca batas maksimal lebar dari parent
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint: Compact (< 600)
          if (constraints.maxWidth < 600) {
            return const CompactLayout();
          } 
          // Breakpoint: Medium (600 - 839)
          else if (constraints.maxWidth < 840) {
            return const MediumLayout();
          } 
          // Breakpoint: Expanded (>= 840)
          else {
            return const ExpandedLayout();
          }
        },
      ),
    );
  }
}

class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blue.shade100,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone_android, size: 80, color: Colors.blue),
          Text('2415051023 - Dewa Putu Bagus Mahadinata', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Compact Layout (< 600px)', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.green.shade100,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.tablet_mac, size: 80, color: Colors.green),
          SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('2415051023 - Dewa Putu Bagus Mahadinata', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Medium Layout (600-839px)', style: TextStyle(fontSize: 24)),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade100,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.desktop_windows, size: 100, color: Colors.orange),
          SizedBox(width: 40),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('2415051023 - Dewa Putu Bagus Mahadinata', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text('Expanded Layout (>= 840px)', style: TextStyle(fontSize: 32)),
            ],
          ),
        ],
      ),
    );
  }
}