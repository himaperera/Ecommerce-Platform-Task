import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../providers/theme_provider.dart';
import '../providers/wishlist_provider.dart';
import 'login_screen.dart';
import 'product_details_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool isEmbedded;

  const ProfileScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();

    // Load actual saved items
    final wishlistItems = wishlistProvider.getWishlistItems(earthRhythmProducts);

    Widget profileBody = ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      children: [
        // User profile Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: isDark ? const Color(0xFF1E2F26) : const Color(0xFFFAF8F3),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF174A33),
                  size: 34,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supun Perera',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: isDark ? Colors.white : const Color(0xFF1C2B22),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'supun.perera@email.com',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Live Wishlist Carousel
        Text(
          'My Wishlist (${wishlistItems.length})',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1C2B22),
          ),
        ),
        const SizedBox(height: 10),
        wishlistItems.isEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF16201B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
                    width: 0.8,
                  ),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(Icons.favorite_border_rounded, color: Colors.grey, size: 24),
                      SizedBox(height: 6),
                      Text(
                        'No saved items yet',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                height: 105,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: wishlistItems.length,
                  itemBuilder: (context, index) {
                    final item = wishlistItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: item)),
                        );
                      },
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF16201B) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
                            width: 1.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(item.imageUrl, fit: BoxFit.cover),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  color: Colors.black.withValues(alpha: 0.5),
                                  child: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        const SizedBox(height: 24),

        // Settings / Controls
        Text(
          'Settings',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1C2B22),
          ),
        ),
        const SizedBox(height: 10),
        
        // Active Dark Mode Switch
        _buildProfileTile(
          icon: isDark ? Icons.dark_mode : Icons.light_mode,
          title: 'Dark Mode Theme',
          subtitle: isDark ? 'Using dark settings' : 'Using light settings',
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ),
        
        _buildProfileTile(
          icon: Icons.location_on_outlined,
          title: 'Shipping Address',
          subtitle: 'No. 24, Colombo, Sri Lanka',
          trailing: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
        ),

        const SizedBox(height: 24),

        // Recent Orders
        Text(
          'Recent Orders',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1C2B22),
          ),
        ),
        const SizedBox(height: 10),
        const _OrderTile(
          orderId: 'ER-1024',
          status: 'Delivered',
          amount: 'LKR 1,617',
          date: '24 Jun 2026',
        ),
        const _OrderTile(
          orderId: 'ER-1019',
          status: 'Processing',
          amount: 'LKR 978',
          date: '20 Jun 2026',
        ),

        const SizedBox(height: 24),

        // Log out button
        _buildProfileTile(
          icon: Icons.logout,
          title: 'Log Out',
          subtitle: 'Resets login onboarding state',
          isDestructive: true,
          onTap: () {
            // Push replacement and clear history
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );

    if (isEmbedded) {
      return Scaffold(
        body: SafeArea(child: profileBody),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: profileBody,
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        final color = isDestructive
            ? const Color(0xFFD67A60)
            : const Color(0xFF174A33);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
              width: 1.2,
            ),
          ),
          child: ListTile(
            onTap: onTap,
            leading: Icon(icon, color: color),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: isDestructive ? color : null, fontSize: 13.5),
            ),
            subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
            trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ),
        );
      }
    );
  }
}

class _OrderTile extends StatelessWidget {
  final String orderId;
  final String status;
  final String amount;
  final String date;

  const _OrderTile({
    required this.orderId,
    required this.status,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
          width: 1.2,
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.receipt_long_outlined, color: const Color(0xFF174A33)),
        title: Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
        subtitle: Text('$date • $status', style: const TextStyle(fontSize: 11)),
        trailing: Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1C2B22),
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
