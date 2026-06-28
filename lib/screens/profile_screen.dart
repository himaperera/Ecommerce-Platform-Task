import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../providers/theme_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import '../models/order_model.dart';
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
    final cartProvider = context.watch<CartProvider>();

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

        // Live Order Tracking panel
        if (cartProvider.activeTrackingOrder != null)
          _buildTrackingPanel(context, cartProvider.activeTrackingOrder!, cartProvider, isDark),

        // Recent Orders
        Text(
          'Recent Orders',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1C2B22),
          ),
        ),
        const SizedBox(height: 10),
        if (cartProvider.orders.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            alignment: Alignment.center,
            child: const Text('No orders placed yet.', style: TextStyle(color: Colors.grey, fontSize: 12)),
          )
        else
          ...cartProvider.orders.map((order) {
            final isTrackingActive = cartProvider.activeTrackingOrder?.orderId == order.orderId;
            return GestureDetector(
              onTap: () {
                cartProvider.setActiveTrackingOrder(order);
              },
              child: _OrderTile(
                orderId: order.orderId,
                status: order.status,
                amount: 'LKR ${order.amount.toStringAsFixed(0)}',
                date: order.date,
                isTracking: isTrackingActive,
              ),
            );
          }),

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

  Widget _buildTrackingPanel(
    BuildContext context,
    MockOrder activeOrder,
    CartProvider cartProvider,
    bool isDark,
  ) {
    final steps = ['Ordered', 'Packed', 'Shipped', 'On the Way', 'Delivered'];
    final stepIcons = [
      Icons.shopping_cart_outlined,
      Icons.inventory_2_outlined,
      Icons.local_shipping_outlined,
      Icons.moped_outlined,
      Icons.library_add_check_outlined,
    ];

    final currentStep = activeOrder.trackingStep;

    // Detail text description corresponding to active stage
    final stepDescriptions = [
      'Order has been received and is awaiting validation.',
      'Skincare products are packed and prepared at our clean lab.',
      'Package handed over to the express courier partner.',
      'Out for delivery. Driver is near Colombo shipping location.',
      'Delivered successfully! Thank you for being with Earth Rhythm.'
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16201B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Order Tracking',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activeOrder.orderId,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Color(0xFF174A33),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: activeOrder.status == 'Delivered'
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  activeOrder.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: activeOrder.status == 'Delivered'
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Horizontal Stepper
          Row(
            children: List.generate(5, (index) {
              final isCompleted = index <= currentStep;
              final isActive = index == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    // Step Point Dot & Label
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: isCompleted
                                ? const Color(0xFF174A33)
                                : (isDark ? const Color(0xFF24332B) : Colors.grey.shade200),
                            child: Icon(
                              stepIcons[index],
                              size: 13,
                              color: isCompleted ? Colors.white : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            steps[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive
                                  ? const Color(0xFFD67A60)
                                  : (isCompleted ? (isDark ? Colors.white70 : Colors.black87) : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Connection Line
                    if (index < 4)
                      Container(
                        width: 8,
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: index < currentStep
                            ? const Color(0xFF174A33)
                            : (isDark ? const Color(0xFF24332B) : Colors.grey.shade300),
                      ),
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Detail Note
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF174A33)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  stepDescriptions[currentStep],
                  style: const TextStyle(fontSize: 11, height: 1.3, color: Colors.grey),
                ),
              ),
            ],
          ),

          // Interactivity Simulator Button (Active when not fully delivered)
          if (currentStep < 4) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.airport_shuttle_outlined, size: 14),
              label: const Text('Simulate Shipping Progress'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(36),
                backgroundColor: const Color(0xFFD67A60),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                cartProvider.simulateNextTrackingStep(activeOrder.orderId);
              },
            ),
          ],
        ],
      ),
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
  final bool isTracking;

  const _OrderTile({
    required this.orderId,
    required this.status,
    required this.amount,
    required this.date,
    this.isTracking = false,
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
          color: isTracking
              ? const Color(0xFFD67A60)
              : (isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6)),
          width: isTracking ? 1.8 : 1.2,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.receipt_long_outlined,
          color: isTracking ? const Color(0xFFD67A60) : const Color(0xFF174A33),
        ),
        title: Row(
          children: [
            Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
            if (isTracking) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFD67A60).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Tracking',
                  style: TextStyle(fontSize: 8.5, color: Color(0xFFD67A60), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text('$date • $status', style: const TextStyle(fontSize: 11)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amount,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF1C2B22),
                fontSize: 13.5,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
