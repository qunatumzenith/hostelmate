import 'package:hostelmate/core/models/contact_details_model.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String department;
  final int year;
  final int age;
  final String hostelType; // 'boys' or 'girls'
  final String? roomNumber;
  final String role; // 'student' or 'admin'
  final ContactDetails contactDetails;
  final ParentDetails parentDetails;
  final String? bloodGroup;
  final String? emergencyContact;
  final LocalAddress? permanentAddress;
  final LocalAddress? currentAddress;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.department,
    required this.year,
    required this.age,
    required this.hostelType,
    this.roomNumber,
    required this.role,
    required this.contactDetails,
    required this.parentDetails,
    this.bloodGroup,
    this.emergencyContact,
    this.permanentAddress,
    this.currentAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'department': department,
      'year': year,
      'age': age,
      'hostelType': hostelType,
      'roomNumber': roomNumber,
      'role': role,
      'contactDetails': contactDetails.toMap(),
      'parentDetails': parentDetails.toMap(),
      'bloodGroup': bloodGroup,
      'emergencyContact': emergencyContact,
      'permanentAddress': permanentAddress?.toMap(),
      'currentAddress': currentAddress?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      department: map['department'] ?? '',
      year: map['year'] ?? 1,
      age: map['age'] ?? 18,
      hostelType: map['hostelType'] ?? 'boys',
      roomNumber: map['roomNumber'],
      role: map['role'] ?? 'student',
      contactDetails: ContactDetails.fromMap(map['contactDetails'] ?? {}),
      parentDetails: ParentDetails.fromMap(map['parentDetails'] ?? {}),
      bloodGroup: map['bloodGroup'],
      emergencyContact: map['emergencyContact'],
      permanentAddress: map['permanentAddress'] != null 
          ? LocalAddress.fromMap(map['permanentAddress']) 
          : null,
      currentAddress: map['currentAddress'] != null 
          ? LocalAddress.fromMap(map['currentAddress']) 
          : null,
    );
  }
}

class LocalAddress {
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;

  LocalAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
  });

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
    };
  }

  factory LocalAddress.fromMap(Map<String, dynamic> map) {
    return LocalAddress(
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      landmark: map['landmark'],
    );
  }

  String get fullAddress => 
    '$street\n${landmark != null ? '$landmark\n' : ''}$city, $state - $pincode';
} 