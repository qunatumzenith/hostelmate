enum HealthIssueType {
  fever,
  headache,
  stomachache,
  injury,
  other
}

class MedicalAssistance {
  final String id;
  final String userId;
  final String userName;
  final String hostelNumber;
  final String roomNumber;
  final HealthIssueType issueType;
  final String description;
  final DateTime timestamp;
  final String status; // pending, inProgress, resolved
  final String? wardenResponse;
  final String? assignedWarden;

  MedicalAssistance({
    required this.id,
    required this.userId,
    required this.userName,
    required this.hostelNumber,
    required this.roomNumber,
    required this.issueType,
    required this.description,
    required this.timestamp,
    this.status = 'pending',
    this.wardenResponse,
    this.assignedWarden,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'hostelNumber': hostelNumber,
    'roomNumber': roomNumber,
    'issueType': issueType.toString().split('.').last,
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'status': status,
    'wardenResponse': wardenResponse,
    'assignedWarden': assignedWarden,
  };

  factory MedicalAssistance.fromMap(Map<String, dynamic> map) {
    return MedicalAssistance(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      hostelNumber: map['hostelNumber'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      issueType: HealthIssueType.values.firstWhere(
        (e) => e.toString().split('.').last == map['issueType'],
        orElse: () => HealthIssueType.other,
      ),
      description: map['description'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'] ?? 'pending',
      wardenResponse: map['wardenResponse'],
      assignedWarden: map['assignedWarden'],
    );
  }
} 