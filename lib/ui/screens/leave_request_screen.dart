import 'package:flutter/material.dart';
import '../../core/models/leave_request.dart';
import '../../core/services/leave_service.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _registerNumberController = TextEditingController();
  final _hostelNumberController = TextEditingController();
  final _reasonController = TextEditingController();
  final _leaveService = LeaveService();
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedType = 'home';

  @override
  void dispose() {
    _nameController.dispose();
    _registerNumberController.dispose();
    _hostelNumberController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate() && _fromDate != null && _toDate != null) {
      try {
        final request = LeaveRequest(
          name: _nameController.text,
          registerNumber: _registerNumberController.text,
          hostelNumber: _hostelNumberController.text,
          reason: _reasonController.text,
          fromDate: _fromDate!,
          toDate: _toDate!,
          type: _selectedType,
        );

        await _leaveService.submitLeaveRequest(request);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Leave request submitted successfully!')),
          );
          _formKey.currentState!.reset();
          setState(() {
            _fromDate = null;
            _toDate = null;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.calendar_today),
            SizedBox(width: 8),
            Text('Leave Request'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
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
                    controller: _registerNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Register Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your register number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hostelNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Hostel Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your hostel number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Leave Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'home', child: Text('Home')),
                      DropdownMenuItem(value: 'outing', child: Text('Outing')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => _selectDate(context, true),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(_fromDate == null
                              ? 'From Date'
                              : 'From: ${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => _selectDate(context, false),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(_toDate == null
                              ? 'To Date'
                              : 'To: ${_toDate!.day}/${_toDate!.month}/${_toDate!.year}'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      labelText: 'Reason',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your reason';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _submitRequest,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Request'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<LeaveRequest>>(
              stream: _leaveService.getLeaveRequestsStream(_registerNumberController.text),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final requests = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: request.status == 'approved'
                              ? Colors.green
                              : request.status == 'rejected'
                                  ? Colors.red
                                  : Colors.orange,
                          child: Icon(
                            request.type == 'home'
                                ? Icons.home
                                : Icons.directions_walk,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(request.reason),
                        subtitle: Text(
                          '${request.fromDate.day}/${request.fromDate.month} - ${request.toDate.day}/${request.toDate.month}',
                        ),
                        trailing: Chip(
                          label: Text(
                            request.status,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: request.status == 'approved'
                              ? Colors.green
                              : request.status == 'rejected'
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 