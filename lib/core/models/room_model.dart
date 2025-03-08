enum HostelBlock { A, B, C, D }
enum RoomType { single, double, triple }

class RoomModel {
  final String id;
  final String number;
  final RoomType type;
  final int capacity;
  final List<String> occupants; // List of user IDs
  final HostelBlock block;
  final int floor;
  final bool isAvailable;
  final String hostelType; // 'boys' or 'girls'
  final RoomAddress address;
  final double? monthlyRent;
  final List<String>? amenities;
  final String? wardenContact;

  RoomModel({
    required this.id,
    required this.number,
    required this.type,
    required this.capacity,
    required this.occupants,
    required this.block,
    required this.floor,
    required this.isAvailable,
    required this.hostelType,
    required this.address,
    this.monthlyRent,
    this.amenities,
    this.wardenContact,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'type': type.toString().split('.').last,
      'capacity': capacity,
      'occupants': occupants,
      'block': block.toString().split('.').last,
      'floor': floor,
      'isAvailable': isAvailable,
      'hostelType': hostelType,
      'address': address.toMap(),
      'monthlyRent': monthlyRent,
      'amenities': amenities,
      'wardenContact': wardenContact,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] ?? '',
      number: map['number'] ?? '',
      type: RoomType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => RoomType.double,
      ),
      capacity: map['capacity'] ?? 2,
      occupants: List<String>.from(map['occupants'] ?? []),
      block: HostelBlock.values.firstWhere(
        (e) => e.toString().split('.').last == map['block'],
        orElse: () => HostelBlock.A,
      ),
      floor: map['floor'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
      hostelType: map['hostelType'] ?? 'boys',
      address: RoomAddress.fromMap(map['address'] ?? {}),
      monthlyRent: map['monthlyRent']?.toDouble(),
      amenities: List<String>.from(map['amenities'] ?? []),
      wardenContact: map['wardenContact'],
    );
  }

  String get fullRoomNumber => '${block.toString().split('.').last}$floor$number';
  
  String get displayName => 'Room $fullRoomNumber (${type.toString().split('.').last})';
}

class RoomAddress {
  final String hostelName;
  final String street;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String? additionalInfo;

  RoomAddress({
    required this.hostelName,
    required this.street,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    this.additionalInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'hostelName': hostelName,
      'street': street,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'additionalInfo': additionalInfo,
    };
  }

  factory RoomAddress.fromMap(Map<String, dynamic> map) {
    return RoomAddress(
      hostelName: map['hostelName'] ?? '',
      street: map['street'] ?? '',
      landmark: map['landmark'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      additionalInfo: map['additionalInfo'],
    );
  }

  String get fullAddress => 
    '$hostelName, $street\n$landmark\n$city, $state - $pincode';
} 