import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2E5C41)),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF2E5C41),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // User Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF2E5C41),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Supun Perera', // ඔයාගේ නම
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'supun.perera@email.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // Profile Options
            buildProfileOption(Icons.shopping_bag_outlined, 'My Orders'),
            buildProfileOption(Icons.favorite_border, 'Wishlist'),
            buildProfileOption(Icons.location_on_outlined, 'Shipping Address'),
            buildProfileOption(Icons.settings_outlined, 'Settings'),
            buildProfileOption(Icons.logout, 'Log Out', isLogout: true),
          ],
        ),
      ),
    );
  }

  // Profile Options ටික ලේසියෙන් හදන්න හදපු Widget එකක්
  Widget buildProfileOption(
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFF2E5C41),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isLogout ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // මෙතන Log out වෙන්න හෝ වෙනත් screen එකකට යන්න දාන්න පුළුවන්
        },
      ),
    );
  }
}
