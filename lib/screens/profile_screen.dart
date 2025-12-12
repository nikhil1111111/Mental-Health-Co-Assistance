import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart' as my_auth;
import '../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<my_auth.MyAuthProvider>(context);

    if (!isFirebaseSupported) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile - Firebase not supported on this platform'),
            SizedBox(height: 20),
            Text('Use Android, iOS, or Web for full features'),
          ],
        ),
      );
    }

    final userData = userProvider.userData;

    return userData == null
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData['profilePhoto'] ?? ''),
                ),
                const SizedBox(height: 16),
                Text(
                  userData['name'] ?? 'User',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${userData['occupation'] ?? ''} - ${userData['location'] ?? ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile_setup');
                  },
                  child: const Text('Edit Profile'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await authProvider.signOut();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
  }
}
