// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/models/course.dart

class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  // Mengubah JSON (Map) dari API menjadi objek Course
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: int.tryParse('${json['id']}'),
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] as String?) ?? 'planned',
    );
  }

  // id tidak dikirim: dibuat oleh server/database
  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };
}