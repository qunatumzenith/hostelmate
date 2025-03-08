import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hostelmate/core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _ageController = TextEditingController();
  final _yearController = TextEditingController();
  final _phoneController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _parentRelationController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isRegistering = false;
  String _selectedHostelType = 'boys';
  String _selectedParentRelation = 'father';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo container with icon
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.apartment,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'HostelMate',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isRegistering ? 'Create Account' : 'Welcome Back',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (_isRegistering) Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.grey.shade50,
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
                          controller: _departmentController,
                          decoration: InputDecoration(
                            labelText: 'Department',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.school),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your department';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _yearController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Year',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.calendar_today),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  final year = int.tryParse(value);
                                  if (year == null || year < 1 || year > 4) {
                                    return 'Invalid year';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _ageController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Age',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.person_outline),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  final age = int.tryParse(value);
                                  if (age == null || age < 17 || age > 25) {
                                    return 'Invalid age';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedHostelType,
                          decoration: InputDecoration(
                            labelText: 'Hostel Type',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.home),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'boys',
                              child: Text('Boys Hostel'),
                            ),
                            DropdownMenuItem(
                              value: 'girls',
                              child: Text('Girls Hostel'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedHostelType = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a hostel type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length != 10) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text('Parent/Guardian Details',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        
                        TextFormField(
                          controller: _parentNameController,
                          decoration: InputDecoration(
                            labelText: 'Parent Name',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter parent name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedParentRelation,
                          decoration: InputDecoration(
                            labelText: 'Relation',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.family_restroom),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'father', child: Text('Father')),
                            DropdownMenuItem(value: 'mother', child: Text('Mother')),
                            DropdownMenuItem(value: 'guardian', child: Text('Guardian')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedParentRelation = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _parentPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Parent Phone Number',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter parent phone number';
                            }
                            if (value.length != 10) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'KLU Email',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'example@klu.ac.in',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.endsWith('@klu.ac.in')) {
                          return 'Please use your KLU email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (_isRegistering && value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _isRegistering ? 'Register' : 'Login',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _handleGoogleSignIn,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login),
                          SizedBox(width: 8),
                          Text('Sign in with Google'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegistering = !_isRegistering;
                        });
                      },
                      child: Text(
                        _isRegistering
                            ? 'Already have an account? Login'
                            : 'Need an account? Register',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authService = context.read<AuthService>();
        if (_isRegistering) {
          await authService.registerWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            department: _departmentController.text,
            year: int.parse(_yearController.text),
            age: int.parse(_ageController.text),
            hostelType: _selectedHostelType,
            phoneNumber: _phoneController.text,
            parentName: _parentNameController.text,
            parentRelation: _selectedParentRelation,
            parentPhone: _parentPhoneController.text,
            bloodGroup: _bloodGroupController.text,
            address: _addressController.text,
          );
        } else {
          await authService.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await context.read<AuthService>().signInWithGoogle();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _departmentController.dispose();
    _ageController.dispose();
    _yearController.dispose();
    _phoneController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _parentRelationController.dispose();
    _bloodGroupController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}