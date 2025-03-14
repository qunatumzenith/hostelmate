class LeaveRequest {
  final String name;
  final String registerNumber;
  final String hostelNumber;
  final String reason;
  final DateTime fromDate;
  final DateTime toDate;
  final String type; // 'home' or 'outing'
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime requestedAt;

  LeaveRequest({
    required this.name,
    required this.registerNumber,
    required this.hostelNumber,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.type,
    this.status = 'pending',
    DateTime? requestedAt,
  }) : requestedAt = requestedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'registerNumber': registerNumber,
      'hostelNumber': hostelNumber,
      'reason': reason,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'type': type,
      'status': status,
      'requestedAt': requestedAt.toIso8601String(),
    };
  }

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      name: json['name'],
      registerNumber: json['registerNumber'],
      hostelNumber: json['hostelNumber'],
      reason: json['reason'],
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      type: json['type'],
      status: json['status'],
      requestedAt: DateTime.parse(json['requestedAt']),
    );
  }
} 