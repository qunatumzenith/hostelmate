import 'package:cloud_firestore/cloud_firestore.dart';

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
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: map['imageUrl'],
    );
  }
}

class ComplaintModel {
  final String id;
  final String userId;
  final String title;
  final String description;
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
    required this.description,
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
      'description': description,
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
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      status: ComplaintStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (map['status'] ?? 'pending'),
        orElse: () => ComplaintStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      roomNumber: map['roomNumber'],
      assignedTo: map['assignedTo'],
      messages: (map['messages'] as List<dynamic>?)
          ?.map((m) => ComplaintMessage.fromMap(m as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
} 