import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leave_request.dart';

class LeaveService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitLeaveRequest(LeaveRequest request) async {
    try {
      await _firestore.collection('leave_requests').add(request.toJson());
    } catch (e) {
      throw Exception('Failed to submit leave request: $e');
    }
  }

  Future<void> updateLeaveRequestStatus(String requestId, String status) async {
    try {
      await _firestore.collection('leave_requests').doc(requestId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update leave request status: $e');
    }
  }

  Stream<List<LeaveRequest>> getLeaveRequestsStream(String registerNumber) {
    return _firestore
        .collection('leave_requests')
        .where('registerNumber', isEqualTo: registerNumber)
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LeaveRequest.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<LeaveRequest>> getAllLeaveRequestsStream() {
    return _firestore
        .collection('leave_requests')
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LeaveRequest.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }
} 