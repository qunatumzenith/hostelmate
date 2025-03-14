import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:hostelmate/core/services/auth_service.dart';

class MedicalAssistanceScreen extends StatefulWidget {
  const MedicalAssistanceScreen({Key? key}) : super(key: key);

  @override
  State<MedicalAssistanceScreen> createState() => _MedicalAssistanceScreenState();
}

class _MedicalAssistanceScreenState extends State<MedicalAssistanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _regNoController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedIssueType = 'fever';
  String _selectedHostel = 'Men Hostel 1';

  List<String> _getHostelOptions() {
    return ['Men Hostel 1', 'Men Hostel 2', 'Girls Hostel 1', 'Girls Hostel 2'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Assistance'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/medical.jpg'),
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
            image: AssetImage('assets/medical.jpg'),
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
                // Personal Details Card
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Hostel Details Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hostel Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your hostel';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _roomNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Room Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your room number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Medical Issue Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Medical Issue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedIssueType,
                          decoration: const InputDecoration(
                            labelText: 'Health Issue Type',
                            border: OutlineInputBorder(),
                          ),
                          items: ['fever', 'injury', 'allergy', 'other']
                              .map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedIssueType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            hintText: 'Please describe your symptoms or issue in detail',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
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
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to submit a request')),
        );
        return;
      }

      // Show confirmation dialog
      if (!mounted) return;
      final shouldSubmit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.medical_services, color: Colors.blue),
              SizedBox(width: 8),
              Text('Confirm Request'),
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
              Text('Room Number: ${_roomNumberController.text}'),
              const SizedBox(height: 8),
              Text('Issue Type: ${_selectedIssueType.toUpperCase()}'),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to submit this medical assistance request?',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

      if (shouldSubmit != true) return;

      await FirebaseFirestore.instance.collection('medical_requests').add({
        'userId': currentUser.uid,
        'userName': _nameController.text,
        'registrationNumber': _regNoController.text,
        'hostelName': _selectedHostel,
        'roomNumber': _roomNumberController.text,
        'issueType': _selectedIssueType,
        'description': _descriptionController.text,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medical request submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear all form fields
      _nameController.clear();
      _regNoController.clear();
      _roomNumberController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedIssueType = 'fever';
        _selectedHostel = 'Men Hostel 1';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regNoController.dispose();
    _roomNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 