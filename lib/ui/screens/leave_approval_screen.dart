import 'package:flutter/material.dart';
import '../../core/models/leave_request.dart';
import '../../core/services/leave_service.dart';

class LeaveApprovalScreen extends StatelessWidget {
  final LeaveService _leaveService = LeaveService();

  LeaveApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings),
            SizedBox(width: 8),
            Text('Leave Approvals'),
          ],
        ),
      ),
      body: StreamBuilder<List<LeaveRequest>>(
        stream: _leaveService.getAllLeaveRequestsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
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
                  title: Text(request.name),
                  subtitle: Text('${request.registerNumber} - ${request.hostelNumber}'),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reason: ${request.reason}'),
                          const SizedBox(height: 8),
                          Text(
                            'Duration: ${request.fromDate.day}/${request.fromDate.month} - ${request.toDate.day}/${request.toDate.month}',
                          ),
                          const SizedBox(height: 16),
                          if (request.status == 'pending')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _leaveService.updateLeaveRequestStatus(
                                    request.id,
                                    'approved',
                                  ),
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  label: const Text('Approve'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.green,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _leaveService.updateLeaveRequestStatus(
                                    request.id,
                                    'rejected',
                                  ),
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  label: const Text('Reject'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
} 