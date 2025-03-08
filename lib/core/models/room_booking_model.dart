import 'package:cloud_firestore/cloud_firestore.dart';

class RoomBooking {
  final String id;
  final String userId;
  final String hostelType;
  final String roomNumber;
  final DateTime timestamp;
  final String status;

  RoomBooking({
    required this.id,
    required this.userId,
    required this.hostelType,
    required this.roomNumber,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'hostelType': hostelType,
      'roomNumber': roomNumber,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  static RoomBooking fromMap(Map<String, dynamic> map) {
    return RoomBooking(
      id: map['id'],
      userId: map['userId'],
      hostelType: map['hostelType'],
      roomNumber: map['roomNumber'],
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'],
    );
  }
}