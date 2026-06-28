import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/add_to_cart_animation.dart';
import 'product_details_screen.dart';

const _kGreen = Color(0xFF2D5A3D);
const _kCoral = Color(0xFFE8724A);
const _kCream = Color(0xFFFAF6F0);
const _kMint = Color(0xFFD4EDD8);
const _kPeach = Color(0xFFFDE8DC);
const _kYellow = Color(0xFFF5F0D4);
const _kBorder = Color(0xFFEDE8E0);
const _kText = Color(0xFF1A1A1A);
const _kTextLight = Color(0xFF6B6B6B);

class AllProductsScreen extends StatefulWidget {
  final String? category;
  const AllProductsScreen({super.key, this.category});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late String _selectedCategory;
  String _searchQuery = '';
  String _sortBy = 'Default';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category ?? 'All';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    final list = earthRhythmProducts.where((p) {
      final matchCat =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();

    if (_sortBy == 'Price: Low to High') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Top Rated') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0E1512) : _kCream,
      appBar: AppBar(
        title: const Text('Earth Skincare'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0E1512) : _kCream,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF16201B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white10 : _kBorder,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search all products...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: _kGreen,
                          size: 20,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showSortSheet(context, isDark),
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF16201B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white10 : _kBorder,
                      ),
                    ),
                    child: const Icon(Icons.swap_vert_rounded, color: _kGreen),
                  ),
                ),
              ],
            ),
          ),

          // Categories horizontal bar
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: productCategories.length,
              itemBuilder: (context, index) {
                final cat = productCategories[index];
                final isSelected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _kGreen
                          : (isDark ? const Color(0xFF16201B) : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? _kGreen
                            : (isDark ? Colors.white10 : _kBorder),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white70 : _kTextLight),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Main list grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? _buildEmptyState(isDark)
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: _filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      return _ProductCard(
                        product: _filteredProducts[index],
                        index: index,
                        isDark: isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            'No products match your criteria',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white70 : _kText,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try selecting another category or query',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF16201B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort Products By',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...[
              'Default',
              'Price: Low to High',
              'Price: High to Low',
              'Top Rated',
            ].map((sort) {
              final isSel = _sortBy == sort;
              return ListTile(
                onTap: () {
                  setState(() => _sortBy = sort);
                  Navigator.pop(context);
                },
                title: Text(sort, style: const TextStyle(fontSize: 14)),
                trailing: isSel
                    ? const Icon(Icons.check, color: _kGreen)
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final bool isDark;

  const _ProductCard({
    super.key,
    required this.product,
    required this.index,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bgs = [
      _kMint,
      _kPeach,
      _kYellow,
      const Color(0xFFEDE8F5),
      const Color(0xFFE8F0FD),
      const Color(0xFFFDF0E8),
    ];
    final cardBg = isDark ? const Color(0xFF14201A) : bgs[index % bgs.length];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white10 : _kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(
                            Icons.spa_outlined,
                            color: _kGreen.withOpacity(0.3),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _kCoral,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.badge.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        color: isDark ? Colors.white : _kText,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'LKR ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: _kGreen,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'LKR ${(product.price * 1.2).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 8.5,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Consumer<CartProvider>(
                      builder: (ctx, cart, _) => GestureDetector(
                        onTap: () {
                          cart.addItem(product);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                AddToCartAnimation(productName: product.name),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _kCoral,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'ADD TO CART',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
