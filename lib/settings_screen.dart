import 'package:flutter/material.dart';
import '../auth_service.dart';
import 'change_password_screen.dart';

/// Settings screen for app preferences and account management
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Account section
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          
          // Change password option
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          
          const Divider(),
          
          // Preferences section
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          
          // Notifications toggle (placeholder)
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Enable push notifications'),
            value: true,
            onChanged: (bool value) {
              // In a real app, save this preference
            },
          ),
          
          const Divider(),
          
          // About section
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About ChatBoards'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'ChatBoards',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 ChatBoards',
                children: [
                  const SizedBox(height: 16),
                  const Text('Message boards for the new age.'),
                ],
              );
            },
          ),
          
          const Divider(),
          
          // Logout button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () async {
                // Show confirmation dialog
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await authService.signOut();
                  // Navigation will be handled by StreamBuilder in main.dart
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}