import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../core/services/food_service.dart';
import '../../core/models/food_system_model.dart';
import '../../core/services/auth_service.dart';

class FoodServicesScreen extends StatefulWidget {
  const FoodServicesScreen({Key? key}) : super(key: key);

  @override
  State<FoodServicesScreen> createState() => _FoodServicesScreenState();
}

class _FoodServicesScreenState extends State<FoodServicesScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDay = 'Monday';
  String _selectedMealTime = 'Morning';
  Map<String, bool> _selectedItems = {};
  final Map<String, double> _itemPrices = {};
  double _totalBill = 0.0;

  final Map<String, List<Map<String, dynamic>>> _menuItems = {
    'Morning': [
      {'name': 'Idli', 'price': 30.0},
      {'name': 'Dosa', 'price': 40.0},
      {'name': 'Puri', 'price': 35.0},
      {'name': 'Upma', 'price': 25.0},
      {'name': 'Tea', 'price': 10.0},
      {'name': 'Coffee', 'price': 15.0},
    ],
    'Afternoon': [
      {'name': 'Meals', 'price': 60.0},
      {'name': 'Biryani', 'price': 80.0},
      {'name': 'Pulao', 'price': 70.0},
      {'name': 'Curd Rice', 'price': 40.0},
      {'name': 'Roti Curry', 'price': 50.0},
    ],
    'Night': [
      {'name': 'Chapati', 'price': 40.0},
      {'name': 'Fried Rice', 'price': 60.0},
      {'name': 'Noodles', 'price': 55.0},
      {'name': 'Parotta', 'price': 45.0},
      {'name': 'Soup', 'price': 30.0},
    ],
  };

  void _updateTotalBill() {
    double total = 0.0;
    _selectedItems.forEach((item, isSelected) {
      if (isSelected) {
        total += _itemPrices[item] ?? 0.0;
      }
    });
    setState(() {
      _totalBill = total;
    });
  }

  List<Map<String, dynamic>> _getCurrentMenuItems() {
    return _menuItems[_selectedMealTime] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Services'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/food.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/food.jpg'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Day and Time',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedDay,
                          decoration: const InputDecoration(
                            labelText: 'Day',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                            'Saturday',
                            'Sunday'
                          ].map((day) {
                            return DropdownMenuItem(
                              value: day,
                              child: Text(day),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDay = value!;
                              _selectedItems.clear();
                              _updateTotalBill();
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedMealTime,
                          decoration: const InputDecoration(
                            labelText: 'Meal Time',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Morning', 'Afternoon', 'Night'].map((time) {
                            return DropdownMenuItem(
                              value: time,
                              child: Text(time),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMealTime = value!;
                              _selectedItems.clear();
                              _updateTotalBill();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Menu Items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._getCurrentMenuItems().map((item) {
                          final itemName = item['name'] as String;
                          final itemPrice = item['price'] as double;
                          _itemPrices[itemName] = itemPrice;

                          return CheckboxListTile(
                            title: Text(itemName),
                            subtitle: Text('₹${itemPrice.toStringAsFixed(2)}'),
                            value: _selectedItems[itemName] ?? false,
                            onChanged: (bool? value) {
                              setState(() {
                                _selectedItems[itemName] = value ?? false;
                                _updateTotalBill();
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Bill',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${_totalBill.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (_selectedItems.isEmpty || !_selectedItems.containsValue(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    try {
      final currentUser = context.read<AuthService>().currentUser;
      if (currentUser == null) return;

      final selectedItemsList = _selectedItems.entries
          .where((entry) => entry.value)
          .map((entry) => {
                'name': entry.key,
                'price': _itemPrices[entry.key],
              })
          .toList();

      // Show receipt dialog
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(Icons.receipt_long, size: 40, color: Colors.green),
                const SizedBox(height: 8),
                const Text('Order Receipt'),
                Text(
                  '${_selectedDay} - ${_selectedMealTime}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  ...selectedItemsList.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['name'] as String),
                        Text('₹${(item['price'] as double).toStringAsFixed(2)}'),
                      ],
                    ),
                  )).toList(),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${_totalBill.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your order has been placed successfully. Please collect your food at the selected meal time.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      await FirebaseFirestore.instance.collection('food_orders').add({
        'userId': currentUser.uid,
        'day': _selectedDay,
        'mealTime': _selectedMealTime,
        'items': selectedItemsList,
        'totalAmount': _totalBill,
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully')),
      );

      setState(() {
        _selectedItems.clear();
        _totalBill = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
} 