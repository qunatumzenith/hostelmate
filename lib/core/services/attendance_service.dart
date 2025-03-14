import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markAttendance(String name, String registerNumber, String hostelNumber) async {
    try {
      final attendance = Attendance(
        name: name,
        registerNumber: registerNumber,
        hostelNumber: hostelNumber,
        timestamp: DateTime.now(),
      );

      await _firestore.collection('attendance').add(attendance.toJson());
    } catch (e) {
      throw Exception('Failed to mark attendance: $e');
    }
  }

  Stream<List<Attendance>> getAttendanceStream() {
    return _firestore
        .collection('attendance')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Attendance.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<Attendance>> getStudentAttendanceStream(String registerNumber) {
    return _firestore
        .collection('attendance')
        .where('registerNumber', isEqualTo: registerNumber)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Attendance.fromJson(doc.data()))
          .toList();
    });
  }
} 