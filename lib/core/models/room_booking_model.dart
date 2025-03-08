class RoomBooking {
  final String id;
  final String userId;
  final String roomId;
  final DateTime bookingDate;
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // pending, approved, rejected
  final Map<String, dynamic> userDetails;
  final ParentDetails parentDetails;
  final ContactDetails emergencyContact;
  final String? remarks;

  RoomBooking({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.bookingDate,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.userDetails,
    required this.parentDetails,
    required this.emergencyContact,
    this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'roomId': roomId,
      'bookingDate': bookingDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'userDetails': userDetails,
      'parentDetails': parentDetails.toMap(),
      'emergencyContact': emergencyContact.toMap(),
      'remarks': remarks,
    };
  }

  factory RoomBooking.fromMap(Map<String, dynamic> map) {
    return RoomBooking(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      roomId: map['roomId'] ?? '',
      bookingDate: DateTime.parse(map['bookingDate']),
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      status: map['status'] ?? 'pending',
      userDetails: Map<String, dynamic>.from(map['userDetails'] ?? {}),
      parentDetails: ParentDetails.fromMap(map['parentDetails'] ?? {}),
      emergencyContact: ContactDetails.fromMap(map['emergencyContact'] ?? {}),
      remarks: map['remarks'],
    );
  }
} 