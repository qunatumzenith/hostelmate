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
  final _requestController = TextEditingController();
  String _selectedMealType = 'breakfast';

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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedMealType,
                decoration: const InputDecoration(
                  labelText: 'Meal Type',
                  border: OutlineInputBorder(),
                ),
                items: ['breakfast', 'lunch', 'dinner']
                    .map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMealType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _requestController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Special Requirements',
                  hintText: 'Enter any dietary requirements or preferences...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your requirements';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final currentUser = context.read<AuthService>().currentUser;
      if (currentUser == null) return;

      await FirebaseFirestore.instance.collection('food_requests').add({
        'userId': currentUser.uid,
        'mealType': _selectedMealType,
        'requirements': _requestController.text,
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food request submitted successfully')),
      );

      _requestController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }
} 