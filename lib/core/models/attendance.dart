class Attendance {
  final String name;
  final String registerNumber;
  final String hostelNumber;
  final DateTime timestamp;

  Attendance({
    required this.name,
    required this.registerNumber,
    required this.hostelNumber,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'registerNumber': registerNumber,
      'hostelNumber': hostelNumber,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      name: json['name'],
      registerNumber: json['registerNumber'],
      hostelNumber: json['hostelNumber'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
} 