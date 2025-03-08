class ContactDetails {
  final String phoneNumber;
  final String? alternatePhone;
  final String? email;
  final String? address;

  ContactDetails({
    required this.phoneNumber,
    this.alternatePhone,
    this.email,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'alternatePhone': alternatePhone,
      'email': email,
      'address': address,
    };
  }

  factory ContactDetails.fromMap(Map<String, dynamic> map) {
    return ContactDetails(
      phoneNumber: map['phoneNumber'] ?? '',
      alternatePhone: map['alternatePhone'],
      email: map['email'],
      address: map['address'],
    );
  }
}

class ParentDetails {
  final String name;
  final String relation; // father, mother, guardian
  final ContactDetails contactDetails;
  final String? occupation;

  ParentDetails({
    required this.name,
    required this.relation,
    required this.contactDetails,
    this.occupation,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relation': relation,
      'contactDetails': contactDetails.toMap(),
      'occupation': occupation,
    };
  }

  factory ParentDetails.fromMap(Map<String, dynamic> map) {
    return ParentDetails(
      name: map['name'] ?? '',
      relation: map['relation'] ?? '',
      contactDetails: ContactDetails.fromMap(map['contactDetails'] ?? {}),
      occupation: map['occupation'],
    );
  }
} 