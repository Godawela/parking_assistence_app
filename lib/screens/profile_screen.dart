import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                       CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue[100],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _changeProfilePicture,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'johndoe@example.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_parking,
                              size: 14,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Premium Parker',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stats Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Bookings', '127'),
                  _buildDivider(),
                  _buildStatItem('Hours Saved', '24h'),
                  _buildDivider(),
                  _buildStatItem('Carbon Saved', '12kg'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Menu Options
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.directions_car,
                    title: 'My Vehicles',
                    subtitle: '2 vehicles registered',
                    onTap: _openMyVehicles,
                  ),
                  _buildMenuTile(
                    icon: Icons.history,
                    title: 'Parking History',
                    onTap: _openParkingHistory,
                  ),
                  _buildMenuTile(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    subtitle: 'Visa ending in 1234',
                    onTap: _openPaymentMethods,
                  ),
                  _buildMenuTile(
                    icon: Icons.favorite_outline,
                    title: 'Favorite Locations',
                    onTap: _openFavoriteLocations,
                  ),
                  _buildMenuTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    onTap: null,
                  ),
                  _buildMenuTile(
                    icon: Icons.security,
                    title: 'Privacy & Security',
                    onTap: _openPrivacySecurity,
                  ),
                  _buildMenuTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: _openHelpSupport,
                  ),
                  _buildMenuTile(
                    icon: Icons.info_outline,
                    title: 'About ParkSpot',
                    onTap: _openAbout,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red[700],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.blue[700],
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                )
              : null),
      onTap: onTap,
    );
  }

  void _editProfile() {
    // Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Profile clicked')),
    );
  }

  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(Icons.camera_alt, 'Camera'),
                _buildImageOption(Icons.photo_library, 'Gallery'),
                _buildImageOption(Icons.delete, 'Remove'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  void _openMyVehicles() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('My Vehicles clicked')),
    );
  }

  void _openParkingHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Parking History clicked')),
    );
  }

  void _openPaymentMethods() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Methods clicked')),
    );
  }

  void _openFavoriteLocations() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Favorite Locations clicked')),
    );
  }

  void _openPersonalInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Personal Information clicked')),
    );
  }

  void _openPrivacySecurity() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy & Security clicked')),
    );
  }

  void _changeLanguage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language selection clicked')),
    );
  }

  void _openHelpSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help & Support clicked')),
    );
  }

  void _openAbout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('About ParkSpot clicked')),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              // Handle logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}