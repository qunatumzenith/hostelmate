enum ComplaintStatus { pending, inProgress, resolved }

class ComplaintMessage {
  final String id;
  final String senderId;
  final String message;
  final DateTime timestamp;
  final String? imageUrl;

  ComplaintMessage({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timestamp,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory ComplaintMessage.fromMap(Map<String, dynamic> map) {
    return ComplaintMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      imageUrl: map['imageUrl'],
    );
  }
}

class ComplaintModel {
  final String id;
  final String userId;
  final String title;
  final String category; // e.g., 'maintenance', 'cleanliness', 'security'
  final ComplaintStatus status;
  final DateTime createdAt;
  final String? roomNumber;
  final String? assignedTo;
  final List<ComplaintMessage> messages;

  ComplaintModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.status,
    required this.createdAt,
    this.roomNumber,
    this.assignedTo,
    this.messages = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'roomNumber': roomNumber,
      'assignedTo': assignedTo,
    };
  }

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      status: ComplaintStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => ComplaintStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      roomNumber: map['roomNumber'],
      assignedTo: map['assignedTo'],
    );
  }
} 