import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0; // 0: Use & Info, 1: Ingredients, 2: Our Promise
  int _quantity = 1;

  late AnimationController _tabAnimController;
  late Animation<double> _tabFadeAnim;

  @override
  void initState() {
    super.initState();
    _tabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _tabFadeAnim = CurvedAnimation(parent: _tabAnimController, curve: Curves.easeIn);
    _tabAnimController.forward();
  }

  @override
  void dispose() {
    _tabAnimController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (_selectedTab != index) {
      _tabAnimController.reset();
      setState(() {
        _selectedTab = index;
      });
      _tabAnimController.forward();
    }
  }

  Widget _buildTabContent(Product product) {
    switch (_selectedTab) {
      case 0:
        return FadeTransition(
          opacity: _tabFadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Key Benefits & Highlights',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: product.highlights
                    .map(
                      (highlight) => Chip(
                        avatar: const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF174A33)),
                        label: Text(highlight, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Color(0xFFEBE6DD)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      case 1:
        return FadeTransition(
          opacity: _tabFadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Key Ingredients',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Naturally sourced bio-active ingredients tailored to support optimal dermal nutrition without harsh chemicals.',
                style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 14),
              _IngredientRow(name: 'Natural Plant Extract', percentage: '45%', desc: 'Soothes dermal inflammation'),
              _IngredientRow(name: 'Hyaluronic Acid Complex', percentage: '2.5%', desc: 'Deep cellular skin hydration'),
              _IngredientRow(name: 'Bio-Vitamins & Minerals', percentage: '12%', desc: 'Replenishes lipid barrier protection'),
            ],
          ),
        );
      case 2:
        return FadeTransition(
          opacity: _tabFadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'The Earth Rhythm Promise',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _PromiseItem(
                icon: Icons.science_outlined,
                title: 'Dermatologically Tested',
                desc: 'Tested by independent dermatologists to ensure zero irritations or side effects.',
              ),
              _PromiseItem(
                icon: Icons.pets_outlined,
                title: 'Cruelty Free & Vegan',
                desc: 'We never test on animals and utilize 100% plant-based organic derivatives.',
              ),
              _PromiseItem(
                icon: Icons.eco_outlined,
                title: 'Ecological Safety',
                desc: 'Biodegradable packaging materials helping lower carbon footprints.',
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
                width: 1.2,
              ),
            ),
          ),
          child: Row(
            children: [
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // Add to Cart Button
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Add to Bag'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF174A33),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Add quantity multiple times
                    final cartProvider = context.read<CartProvider>();
                    for (int i = 0; i < _quantity; i++) {
                      cartProvider.addItem(widget.product);
                    }
                    
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $_quantity item(s) of ${widget.product.name} to bag'),
                        duration: const Duration(milliseconds: 1500),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        action: SnackBarAction(
                          label: 'View Bag',
                          textColor: const Color(0xFFE49E87),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CartScreen()),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Parallax Image Header
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : const Color(0xFF174A33),
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            title: const Text('Product Details'),
            actions: [
              // Wishlist Heart in App Bar
              Consumer<WishlistProvider>(
                builder: (context, wishlist, _) {
                  final isFavorite = wishlist.isWishlisted(widget.product.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? const Color(0xFFD67A60) : null,
                    ),
                    onPressed: () {
                      wishlist.toggleWishlist(widget.product.id);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite 
                                ? 'Removed from wishlist' 
                                : 'Added to wishlist!'
                          ),
                          duration: const Duration(milliseconds: 1000),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              
              // Direct Cart navigation badge
              Consumer<CartProvider>(
                builder: (context, cart, _) {
                  return IconButton(
                    tooltip: 'Cart',
                    icon: Badge(
                      isLabelVisible: cart.itemCount > 0,
                      label: Text('${cart.itemCount}'),
                      child: const Icon(Icons.shopping_bag_outlined),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.product.id,
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark ? const Color(0xFF1D2622) : const Color(0xFFFAF8F3),
                          child: const Icon(Icons.image_not_supported_outlined, size: 48),
                        );
                      },
                    ),
                  ),
                  // Dark shadow gradient on bottom of image for readability
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.02),
                          Colors.black.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD67A60),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.product.badge.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Core Product Info details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ratings and category row
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF3AA2D), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.product.rating}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${widget.product.reviews} reviews)',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF16201B) : const Color(0xFFF0F7F3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF174A33), width: 0.8),
                        ),
                        child: Text(
                          widget.product.category,
                          style: const TextStyle(
                            color: Color(0xFF174A33),
                            fontWeight: FontWeight.w800,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  
                  // Price breakdown
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'LKR ${widget.product.price.toStringAsFixed(0)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF1C2B22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'LKR ${widget.product.originalPrice.toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${widget.product.discountPercentage}% OFF',
                        style: const TextStyle(
                          color: Color(0xFFD67A60),
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(),
                  ),
                  
                  // Interactive Content Tabs Selector (Clean UI custom tab buttons)
                  Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF16201B) : const Color(0xFFF5F2EC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TabButton(
                            title: 'Details',
                            isSelected: _selectedTab == 0,
                            onTap: () => _switchTab(0),
                          ),
                        ),
                        Expanded(
                          child: _TabButton(
                            title: 'Ingredients',
                            isSelected: _selectedTab == 1,
                            onTap: () => _switchTab(1),
                          ),
                        ),
                        Expanded(
                          child: _TabButton(
                            title: 'Promise',
                            isSelected: _selectedTab == 2,
                            onTap: () => _switchTab(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Displaying the active tab body
                  _buildTabContent(widget.product),
                  
                  const SizedBox(height: 24),
                  // General info cards
                  _InfoCardTile(
                    icon: Icons.local_shipping_outlined,
                    title: 'Free Island-wide Delivery',
                    desc: 'On orders over LKR 3,500. Expected delivery within 2-4 business days.',
                  ),
                  _InfoCardTile(
                    icon: Icons.workspace_premium_outlined,
                    title: '100% Quality Assurance',
                    desc: 'Made with organic ingredients certified safe under global skincare guidelines.',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Tab Button widget
class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF174A33) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

// Ingredient row item helper
class _IngredientRow extends StatelessWidget {
  final String name;
  final String percentage;
  final String desc;

  const _IngredientRow({required this.name, required this.percentage, required this.desc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2621) : const Color(0xFFFAF8F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Text(
            percentage,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD67A60), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// Promise list item helper
class _PromiseItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _PromiseItem({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF174A33), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Info Card helper
class _InfoCardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _InfoCardTile({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16201B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF174A33), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
