import 'package:flutter/material.dart';
import '../auth_service.dart';
import '../user_model.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

/// Home screen showing all available message boards
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load current user's data from Firestore
  Future<void> _loadUserData() async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      final user = await _authService.getUserData(uid);
      setState(() => _currentUser = user);
    }
  }

  /// Message boards data
  /// In a real app, this could come from Firestore
  final List<Map<String, dynamic>> _boards = [
    {
      'id': 'games',
      'name': 'Games',
      'icon': Icons.sports_esports,
      'color': Colors.red,
    },
    {
      'id': 'business',
      'name': 'Business',
      'icon': Icons.business_center,
      'color': Colors.teal,
    },
    {
      'id': 'public_health',
      'name': 'Public Health',
      'icon': Icons.local_hospital,
      'color': Colors.pink,
    },
    {
      'id': 'study',
      'name': 'Study',
      'icon': Icons.school,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select A Room'),
        centerTitle: false,
      ),
      
      // Navigation drawer (hamburger menu)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header with user info
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  _currentUser?.firstName[0].toUpperCase() ?? 'U',
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              accountName: Text(
                _currentUser?.fullName ?? 'User',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(_currentUser?.email ?? ''),
            ),
            
            // Message Boards option (home)
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Message Boards'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            
            // Profile option
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            
            // Settings option
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      
      // Main content - list of message boards
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _boards.length,
        itemBuilder: (context, index) {
          final board = _boards[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              // Board icon
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: board['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  board['icon'],
                  color: board['color'],
                  size: 32,
                ),
              ),
              
              // Board name
              title: Text(
                board['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Arrow icon
              trailing: const Icon(Icons.arrow_forward_ios),
              
              // Navigate to chat screen when tapped
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      boardId: board['id'],
                      boardName: board['name'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}