import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:hostelmate/core/services/auth_service.dart';
import 'dart:math';

class RoomAllocationScreen extends StatefulWidget {
  const RoomAllocationScreen({Key? key}) : super(key: key);

  @override
  State<RoomAllocationScreen> createState() => _RoomAllocationScreenState();
}

class _RoomAllocationScreenState extends State<RoomAllocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _regNoController = TextEditingController();
  final _yearController = TextEditingController();
  final _deptController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _nominee1NameController = TextEditingController();
  final _nominee1NumberController = TextEditingController();
  final _nominee2NameController = TextEditingController();
  final _nominee2NumberController = TextEditingController();
  
  String _selectedGender = 'male';
  String _selectedHostel = 'Men Hostel 1';
  String _selectedRoomType = 'single';

  List<String> _getHostelOptions() {
    return _selectedGender == 'male' 
      ? ['Men Hostel 1', 'Men Hostel 2']
      : ['Girls Hostel 1', 'Girls Hostel 2'];
  }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Personal Details Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _regNoController,
                          decoration: const InputDecoration(
                            labelText: 'Registration Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your registration number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _yearController,
                          decoration: const InputDecoration(
                            labelText: 'Year of Study',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your year';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _deptController,
                          decoration: const InputDecoration(
                            labelText: 'Department',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your department';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Hostel Selection Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hostel Selection',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          items: ['male', 'female'].map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                              _selectedHostel = _getHostelOptions().first;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedHostel,
                          decoration: const InputDecoration(
                            labelText: 'Hostel',
                            border: OutlineInputBorder(),
                          ),
                          items: _getHostelOptions().map((hostel) {
                            return DropdownMenuItem(
                              value: hostel,
                              child: Text(hostel),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedHostel = value!;
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
                          items: ['single', 'double', 'triple'].map((type) {
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Nominee Details Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nominee Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nominee1NameController,
                          decoration: const InputDecoration(
                            labelText: 'Nominee 1 Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter nominee 1 name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nominee1NumberController,
                          decoration: const InputDecoration(
                            labelText: 'Nominee 1 Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter nominee 1 phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nominee2NameController,
                          decoration: const InputDecoration(
                            labelText: 'Nominee 2 Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter nominee 2 name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nominee2NumberController,
                          decoration: const InputDecoration(
                            labelText: 'Nominee 2 Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter nominee 2 phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
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
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final currentUser = context.read<AuthService>().currentUser;
      if (currentUser == null) return;

      // Generate a room number if not specified
      final roomNumber = _roomNumberController.text.isEmpty 
          ? '${_selectedHostel[0]}${Random().nextInt(999) + 1}' 
          : _roomNumberController.text;

      final requestData = {
        'userId': currentUser.uid,
        'name': _nameController.text,
        'registrationNumber': _regNoController.text,
        'year': int.parse(_yearController.text),
        'department': _deptController.text,
        'gender': _selectedGender,
        'hostelType': _selectedHostel,
        'roomType': _selectedRoomType,
        'roomNumber': roomNumber,
        'nominee1': {
          'name': _nominee1NameController.text,
          'phoneNumber': _nominee1NumberController.text,
        },
        'nominee2': {
          'name': _nominee2NameController.text,
          'phoneNumber': _nominee2NumberController.text,
        },
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      };

      await FirebaseFirestore.instance
          .collection('room_requests')
          .add(requestData);

      if (!mounted) return;

      // Show success dialog with details
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Registration Successful'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${_nameController.text}'),
                const SizedBox(height: 8),
                Text('Registration No: ${_regNoController.text}'),
                const SizedBox(height: 8),
                Text('Hostel: $_selectedHostel'),
                const SizedBox(height: 8),
                Text('Room Number: $roomNumber'),
                const SizedBox(height: 8),
                Text('Room Type: ${_selectedRoomType.toUpperCase()}'),
                const SizedBox(height: 16),
                const Text(
                  'Your hostel registration has been submitted successfully. The warden will review your request.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Clear all form fields
                  _nameController.clear();
                  _regNoController.clear();
                  _yearController.clear();
                  _deptController.clear();
                  _roomNumberController.clear();
                  _nominee1NameController.clear();
                  _nominee1NumberController.clear();
                  _nominee2NameController.clear();
                  _nominee2NumberController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regNoController.dispose();
    _yearController.dispose();
    _deptController.dispose();
    _roomNumberController.dispose();
    _nominee1NameController.dispose();
    _nominee1NumberController.dispose();
    _nominee2NameController.dispose();
    _nominee2NumberController.dispose();
    super.dispose();
  }
} 