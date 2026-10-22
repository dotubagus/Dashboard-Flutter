// Nama: Dewa Putu Bagus Mahadinata
// NIM: 2415051023
// lib/models/course.dart

class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  // Factory untuk mengubah data JSON (Map) menjadi Objek Course
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };
}
