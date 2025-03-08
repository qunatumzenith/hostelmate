import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HostelMate'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to HostelMate',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            FeatureCard(
              title: 'Room Allocation',
              description: 'Book your hostel room and manage accommodation',
              icon: Icons.hotel,
              imagePath: 'assets/images/room.jpg',
              onTap: () => Navigator.pushNamed(context, '/room-allocation'),
            ),
            FeatureCard(
              title: 'Medical Assistance',
              description: 'Request medical help and track your health status',
              icon: Icons.medical_services,
              imagePath: 'assets/images/medical.jpg',
              onTap: () => Navigator.pushNamed(context, '/medical-assistance'),
            ),
            FeatureCard(
              title: 'Food Services',
              description: 'View menu, order meals and track your orders',
              icon: Icons.restaurant_menu,
              imagePath: 'assets/images/food.jpg',
              onTap: () => Navigator.pushNamed(context, '/food-services'),
            ),
            FeatureCard(
              title: 'Complaints',
              description: 'Submit and track your complaints',
              icon: Icons.report_problem,
              imagePath: 'assets/images/complaints.jpg',
              onTap: () => Navigator.pushNamed(context, '/complaints'),
            ),
          ],
        ),
      ),
    );
  }
} 