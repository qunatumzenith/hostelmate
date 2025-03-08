import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelmate/core/models/complaint_model.dart';
import 'package:provider/provider.dart';
import 'package:hostelmate/core/services/auth_service.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final complaints = snapshot.data!.docs
              .map((doc) => ComplaintModel.fromMap(
                  doc.data() as Map<String, dynamic>..['id'] = doc.id))
              .toList();

          if (complaints.isEmpty) {
            return const Center(child: Text('No complaints yet'));
          }

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return ComplaintCard(complaint: complaint);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddComplaintDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddComplaintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddComplaintDialog(),
    );
  }
}

class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintCard({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(complaint.title),
        subtitle: Text('Category: ${complaint.category}'),
        trailing: _getStatusChip(complaint.status),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComplaintChatScreen(complaint: complaint),
            ),
          );
        },
      ),
    );
  }

  Widget _getStatusChip(ComplaintStatus status) {
    Color color;
    switch (status) {
      case ComplaintStatus.pending:
        color = Colors.orange;
        break;
      case ComplaintStatus.inProgress:
        color = Colors.blue;
        break;
      case ComplaintStatus.resolved:
        color = Colors.green;
        break;
    }
    return Chip(
      label: Text(status.toString().split('.').last),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }
}

class ComplaintChatScreen extends StatefulWidget {
  final ComplaintModel complaint;

  const ComplaintChatScreen({super.key, required this.complaint});

  @override
  State<ComplaintChatScreen> createState() => _ComplaintChatScreenState();
}

class _ComplaintChatScreenState extends State<ComplaintChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.complaint.title),
            Text(
              widget.complaint.category,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          _getStatusChip(widget.complaint.status),
          PopupMenuButton<ComplaintStatus>(
            onSelected: (ComplaintStatus status) {
              _updateComplaintStatus(status);
            },
            itemBuilder: (BuildContext context) {
              return ComplaintStatus.values.map((ComplaintStatus status) {
                return PopupMenuItem<ComplaintStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('complaints')
                  .doc(widget.complaint.id)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs
                    .map((doc) => ComplaintMessage.fromMap(
                        doc.data() as Map<String, dynamic>..['id'] = doc.id))
                    .toList();

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = context.read<AuthService>().currentUser;
    if (currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('complaints')
        .doc(widget.complaint.id)
        .collection('messages')
        .add({
      'senderId': currentUser.uid,
      'message': _messageController.text.trim(),
      'timestamp': DateTime.now().toIso8601String(),
    });

    _messageController.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _updateComplaintStatus(ComplaintStatus status) async {
    await FirebaseFirestore.instance
        .collection('complaints')
        .doc(widget.complaint.id)
        .update({
      'status': status.toString().split('.').last,
    });
  }

  Widget _getStatusChip(ComplaintStatus status) {
    Color color;
    switch (status) {
      case ComplaintStatus.pending:
        color = Colors.orange;
        break;
      case ComplaintStatus.inProgress:
        color = Colors.blue;
        break;
      case ComplaintStatus.resolved:
        color = Colors.green;
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Chip(
        label: Text(status.toString().split('.').last),
        backgroundColor: color.withOpacity(0.2),
        labelStyle: TextStyle(color: color),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ComplaintMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthService>().currentUser;
    final isCurrentUser = currentUser?.uid == message.senderId;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Theme.of(context).primaryColor.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message.message),
            Text(
              _formatTimestamp(message.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class AddComplaintDialog extends StatefulWidget {
  const AddComplaintDialog({super.key});

  @override
  State<AddComplaintDialog> createState() => _AddComplaintDialogState();
}

class _AddComplaintDialogState extends State<AddComplaintDialog> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'maintenance';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Complaint'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: [
                'maintenance',
                'cleanliness',
                'security',
                'other',
              ].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitComplaint,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Future<void> _submitComplaint() async {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
      return;
    }

    try {
      final currentUser = context.read<AuthService>().currentUser;
      if (currentUser == null) return;

      // Create the complaint
      final complaintRef = await FirebaseFirestore.instance.collection('complaints').add({
        'userId': currentUser.uid,
        'title': _titleController.text,
        'category': _selectedCategory,
        'status': ComplaintStatus.pending.toString().split('.').last,
        'createdAt': DateTime.now().toIso8601String(),
      });

      print('Created complaint with ID: ${complaintRef.id}');

      // Add the first message
      final messageRef = await complaintRef.collection('messages').add({
        'senderId': currentUser.uid,
        'message': _messageController.text,
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('Added first message with ID: ${messageRef.id}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error submitting complaint: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
} 