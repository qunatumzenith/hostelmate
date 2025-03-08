import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelmate/core/models/room_model.dart';

class RoomAllocationScreen extends StatelessWidget {
  const RoomAllocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Allocation'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rooms = snapshot.data!.docs
              .map((doc) => RoomModel.fromMap(
                  doc.data() as Map<String, dynamic>..['id'] = doc.id))
              .toList();

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Room ${room.number}'),
                  subtitle: Text(
                      'Block ${room.block} - Floor ${room.floor}\n${room.occupants.length}/${room.capacity} occupied'),
                  trailing: room.isAvailable
                      ? const Chip(
                          label: Text('Available'),
                          backgroundColor: Colors.green,
                        )
                      : const Chip(
                          label: Text('Full'),
                          backgroundColor: Colors.red,
                        ),
                  onTap: () {
                    // Show room details dialog
                    _showRoomDetailsDialog(context, room);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showRoomDetailsDialog(BuildContext context, RoomModel room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Room ${room.number} Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Block: ${room.block}'),
            Text('Floor: ${room.floor}'),
            Text('Capacity: ${room.capacity}'),
            Text('Occupants: ${room.occupants.length}'),
            const SizedBox(height: 16),
            if (room.isAvailable)
              ElevatedButton(
                onPressed: () {
                  // Implement room booking logic
                },
                child: const Text('Request Room'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 