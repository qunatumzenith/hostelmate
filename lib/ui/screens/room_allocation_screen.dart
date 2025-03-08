import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:hostelmate/core/services/auth_service.dart';

class RoomAllocationScreen extends StatefulWidget {
  const RoomAllocationScreen({Key? key}) : super(key: key);

  @override
  State<RoomAllocationScreen> createState() => _RoomAllocationScreenState();
}

class _RoomAllocationScreenState extends State<RoomAllocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  String _selectedHostelType = 'boys';
  String _selectedRoomType = 'single';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Allocation'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/room.jpg'),
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
            image: AssetImage('assets/room.jpg'),
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
                value: _selectedHostelType,
                decoration: const InputDecoration(
                  labelText: 'Hostel Type',
                  border: OutlineInputBorder(),
                ),
                items: ['boys', 'girls']
                    .map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHostelType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRoomType,
                decoration: const InputDecoration(
                  labelText: 'Room Type',
                  border: OutlineInputBorder(),
                ),
                items: ['single', 'double', 'triple']
                    .map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoomType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roomNumberController,
                decoration: const InputDecoration(
                  labelText: 'Preferred Room Number (Optional)',
                  border: OutlineInputBorder(),
                ),
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

      await FirebaseFirestore.instance.collection('room_requests').add({
        'userId': currentUser.uid,
        'hostelType': _selectedHostelType,
        'roomType': _selectedRoomType,
        'preferredRoomNumber': _roomNumberController.text,
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room request submitted successfully')),
      );

      _roomNumberController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    super.dispose();
  }
} 