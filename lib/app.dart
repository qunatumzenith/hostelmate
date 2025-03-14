import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/auth_service.dart';
import 'ui/screens/attendance_screen.dart';
import 'ui/screens/leave_request_screen.dart';
import 'ui/screens/leave_approval_screen.dart';

class HostelMateApp extends StatelessWidget {
  const HostelMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'HostelMate',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AttendanceScreen(),
    const LeaveRequestScreen(),
    LeaveApprovalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.how_to_reg),
            label: 'Attendance',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Leave Request',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Approvals',
          ),
        ],
      ),
    );
  }
} 