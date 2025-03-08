import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/medical_assistance_model.dart';

class MedicalService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> requestAssistance(MedicalAssistance request) async {
    try {
      await _firestore
          .collection('medical_requests')
          .doc(request.id)
          .set(request.toMap());
    } catch (e) {
      debugPrint('Error requesting medical assistance: $e');
      rethrow;
    }
  }

  Stream<List<MedicalAssistance>> getAssistanceRequests(String userId) {
    return _firestore
        .collection('medical_assistance')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MedicalAssistance.fromMap(doc.data()))
            .toList());
  }
} 