import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/room_booking_model.dart';

class RoomService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> bookRoom(RoomBooking booking) async {
    try {
      await _firestore
          .collection('room_bookings')
          .doc(booking.id)
          .set(booking.toMap());
    } catch (e) {
      debugPrint('Error booking room: $e');
      rethrow;
    }
  }

  Stream<List<RoomBooking>> getUserBookings(String userId) {
    return _firestore
        .collection('room_bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => RoomBooking.fromMap(doc.data())).toList());
  }
} 