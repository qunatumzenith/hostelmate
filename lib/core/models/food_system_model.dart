class MenuItem {
  final String id;
  final String name;
  final double price;
  final String category; // breakfast, lunch, dinner, snacks
  final bool isAvailable;
  final String? description;
  final List<String>? allergens;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.isAvailable = true,
    this.description,
    this.allergens,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'category': category,
    'isAvailable': isAvailable,
    'description': description,
    'allergens': allergens,
  };

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      description: map['description'],
      allergens: List<String>.from(map['allergens'] ?? []),
    );
  }
}

class MealOrder {
  final String id;
  final String userId;
  final DateTime orderDate;
  final String mealType; // breakfast, lunch, dinner
  final List<MenuItem> items;
  final double totalAmount;
  final String paymentStatus; // pending, paid
  final String? transactionId;

  MealOrder({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.mealType,
    required this.items,
    required this.totalAmount,
    this.paymentStatus = 'pending',
    this.transactionId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'orderDate': orderDate.toIso8601String(),
    'mealType': mealType,
    'items': items.map((item) => item.toMap()).toList(),
    'totalAmount': totalAmount,
    'paymentStatus': paymentStatus,
    'transactionId': transactionId,
  };

  factory MealOrder.fromMap(Map<String, dynamic> map) {
    return MealOrder(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      orderDate: DateTime.parse(map['orderDate']),
      mealType: map['mealType'] ?? '',
      items: List<MenuItem>.from(
        (map['items'] ?? []).map((item) => MenuItem.fromMap(item)),
      ),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      paymentStatus: map['paymentStatus'] ?? 'pending',
      transactionId: map['transactionId'],
    );
  }
} 