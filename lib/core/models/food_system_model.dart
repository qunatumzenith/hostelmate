import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.isAvailable,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  static MenuItem fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      category: map['category'],
      isAvailable: map['isAvailable'],
    );
  }
}

class MealOrder {
  final String id;
  final String userId;
  final String itemId;
  final int quantity;
  final double totalPrice;
  final String status;
  final DateTime timestamp;

  MealOrder({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'itemId': itemId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static MealOrder fromMap(Map<String, dynamic> map) {
    return MealOrder(
      id: map['id'],
      userId: map['userId'],
      itemId: map['itemId'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
      status: map['status'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class FoodRequest {
  final String id;
  final String userId;
  final String description;
  final String status;
  final DateTime timestamp;

  FoodRequest({
    required this.id,
    required this.userId,
    required this.description,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static FoodRequest fromMap(Map<String, dynamic> map) {
    return FoodRequest(
      id: map['id'],
      userId: map['userId'],
      description: map['description'],
      status: map['status'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
} 