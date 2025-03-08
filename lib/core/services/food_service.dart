import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/food_system_model.dart';

class FoodService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MenuItem>> getMenuItems(String category) {
    return _firestore
        .collection('menu_items')
        .where('category', isEqualTo: category)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MenuItem.fromMap(doc.data())).toList());
  }

  Future<void> placeMealOrder(MealOrder order) async {
    try {
      await _firestore
          .collection('meal_orders')
          .doc(order.id)
          .set(order.toMap());
    } catch (e) {
      debugPrint('Error placing meal order: $e');
      rethrow;
    }
  }

  Future<void> submitFoodRequest(FoodRequest request) async {
    try {
      await _firestore
          .collection('food_requests')
          .doc(request.id)
          .set(request.toMap());
    } catch (e) {
      debugPrint('Error submitting food request: $e');
      rethrow;
    }
  }
} 