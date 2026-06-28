import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../data/mock_data.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/add_to_cart_animation.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'all_products_screen.dart';
import 'product_details_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EARTH RHYTHM BRAND COLORS (extracted from real product images)
// ─────────────────────────────────────────────────────────────────────────────
const _kGreen = Color(0xFF1A6B3C); // deep forest green (brand primary)
const _kGreenLight = Color(0xFF4A7C5E); // lighter green
const _kSage = Color(0xFFB5C9B1); // sage green (from packaging)
const _kCoral = Color(0xFFE8724A); // warm coral/orange (CTA buttons)
const _kCoralLight = Color(0xFFF0957A); // lighter coral
const _kCream = Color(0xFFFAF6F0); // warm cream background
const _kWarmBrown = Color(0xFF4A2C1A); // deep warm brown (carousel bg)
const _kMint = Color(0xFFD4EDD8); // mint green (product bg)
const _kPeach = Color(0xFFFDE8DC); // soft peach (product bg)
const _kYellow = Color(0xFFF5F0D4); // warm yellow (product bg)
const _kBorder = Color(0xFFEDE8E0); // warm border
const _kText = Color(0xFF1A1A1A); // primary text
const _kTextLight = Color(0xFF6B6B6B); // secondary text

// ─────────────────────────────────────────────────────────────────────────────
// HOME SCREEN SHELL
// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _ExploreTab(),
      const CartScreen(isEmbedded: true),
      const ProfileScreen(isEmbedded: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = context.watch<CartProvider>();
    final currentIndex = cartProvider.currentTabIndex;

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D1610) : Colors.white,
          border: Border(
            top: BorderSide(color: isDark ? Colors.white10 : _kBorder),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 62,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  current: currentIndex,
                  onTap: (i) => cartProvider.setTabIndex(i),
                ),
                _NavItem(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag_rounded,
                  label: 'Bag',
                  index: 1,
                  current: currentIndex,
                  onTap: (i) => cartProvider.setTabIndex(i),
                  badgeBuilder: (ctx) => Consumer<CartProvider>(
                    builder: (_, cart, __) => cart.itemCount > 0
                        ? Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: _kCoral,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  index: 2,
                  current: currentIndex,
                  onTap: (i) => cartProvider.setTabIndex(i),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final int index, current;
  final ValueChanged<int> onTap;
  final Widget Function(BuildContext)? badgeBuilder;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
    this.badgeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? (isDark
                              ? const Color(0xFF1A2E1F)
                              : const Color(0xFFE8F3EB))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    isActive ? activeIcon : icon,
                    color: isActive
                        ? _kGreen
                        : (isDark ? Colors.white38 : Colors.black38),
                    size: 22,
                  ),
                ),
                if (badgeBuilder != null) badgeBuilder!(context),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? _kGreen
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXPLORE TAB
// ─────────────────────────────────────────────────────────────────────────────
class _ExploreTab extends StatefulWidget {
  const _ExploreTab();
  @override
  State<_ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<_ExploreTab>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  late PageController _pageController;
  int _carouselIndex = 0;
  Timer? _carouselTimer;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  // ── Real Earth Rhythm product images for carousel ──────────────────────
  final List<Map<String, dynamic>> _promoBanners = [
    {
      'title': 'Turn your daily routine\ninto a luxury ritual',
      'sub': 'Up to 50% Off',
      'badge': 'EARTH RHYTHM',
      'bg': [const Color(0xFF3B1F0A), const Color(0xFF6B3A1A)],
      'img': 'assets/images/1.png',
    },
    {
      'title': 'SPF 60 Hydrating\nCooling Sunspray',
      'sub': 'PA++++ Protection',
      'badge': 'NEW LAUNCH',
      'bg': [const Color(0xFF1A4A3A), const Color(0xFF2D6B52)],
      'img': 'assets/images/suscreen.png',
    },
    {
      'title': 'Lip & Cheek Tint\nMermaid Shade',
      'sub': 'Shop Now →',
      'badge': 'BESTSELLER',
      'bg': [const Color(0xFF1A4A3A), const Color(0xFF2D6B52)],
      'img': 'assets/images/lip.png',
    },
  ];

  // ── Categories with real product photos ───────────────────────────────
  final List<Map<String, String>> _categories = [
    {
      'name': 'Cleanse',
      'img': 'assets/images/c.png',
      'fallback': 'assets/images/c.png',
    },
    {
      'name': 'Treat',
      'img': 'assets/images/t.png',
      'fallback': 'assets/images/t.png',
    },
    {
      'name': 'Moisturize',
      'img': 'assets/images/M.png',
      'fallback': 'assets/images/M.png',
    },
    {
      'name': 'Protect',
      'img': 'assets/images/S.png',
      'fallback': 'assets/images/S.png',
    },
    {
      'name': 'Eye Care',
      'img': 'assets/images/e.png',
      'fallback': 'assets/images/e.png',
    },
  ];

  // ── New Launches ───────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _newLaunches = [
    {
      'name': 'Matcha Mochi\nCleanser 100g',
      'tag': 'NEW LAUNCH',
      'tagColor': _kCoral,
      'price': '₹467',
      'mrp': '₹549',
      'discount': '15% OFF',
      'img': 'assets/images/mochi.png',
      'fallback': 'assets/images/mochi.png',
      'bg': const Color(0xFFEFF5EC),
      'highlights': ['Deep Cleansing', 'Brightening Care', 'Even Glow'],
    },
    {
      'name': 'Ceramide\nBarrier Serum',
      'tag': 'JUST IN',
      'tagColor': _kGreen,
      'price': '₹749',
      'mrp': '₹899',
      'discount': '17% OFF',
      'img': 'assets/images/ceramide.png',
      'fallback': 'assets/images/ceramide.png',
      'bg': const Color(0xFFE8F4F8),
      'highlights': ['Barrier Repair', 'Deep Hydration', 'Soothing'],
    },
    {
      'name': 'Rose PDRN\nCapsule Cream',
      'tag': 'NEW LAUNCH',
      'tagColor': _kCoral,
      'price': '₹899',
      'mrp': '₹1099',
      'discount': '18% OFF',
      'img': 'assets/images/pdrn.png',
      'fallback': 'assets/images/pdrn.png',
      'bg': const Color(0xFFFDE8E8),
      'highlights': ['Anti-Aging', 'Plumping', 'Radiance'],
    },
  ];

  // ── Reviews ────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Priya S.',
      'rating': 5,
      'text':
          'My skin has never looked better! The Vitamin C serum transformed my complexion in just 2 weeks. Absolutely love it!',
      'product': 'Vitamin C Glow Serum',
      'avatar': 'P',
      'avatarColor': Color(0xFFE8724A),
    },
    {
      'name': 'Rahul M.',
      'rating': 5,
      'text':
          'Completely obsessed with the SPF 60 sunspray. Lightweight, no white cast, and smells incredible. A game changer!',
      'product': 'SPF 60 Cooling Sunspray',
      'avatar': 'R',
      'avatarColor': Color(0xFF2D5A3D),
    },
    {
      'name': 'Ananya K.',
      'rating': 5,
      'text':
          'Love the Matcha Mochi Cleanser — no dryness, no irritation. My skin glows! Finally found my holy grail cleanser.',
      'product': 'Matcha Mochi Cleanser',
      'avatar': 'A',
      'avatarColor': Color(0xFF6B4A8A),
    },
    {
      'name': 'Meera T.',
      'rating': 5,
      'text':
          'The Tender Tint is the most beautiful shade. Gives such a natural flush to my cheeks and lips. Repurchasing forever!',
      'product': 'Tender Tint - Bourbon',
      'avatar': 'M',
      'avatarColor': Color(0xFFB5524A),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          (_carouselIndex + 1) % _promoBanners.length,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _carouselTimer?.cancel();
    _fadeCtrl.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    return earthRhythmProducts.where((p) {
      bool matchCat = _selectedCategory == 'All';
      if (!matchCat) {
        if (_selectedCategory == 'Cleanse') {
          matchCat = p.category == 'Face' || p.name.toLowerCase().contains('cleanser');
        } else if (_selectedCategory == 'Treat') {
          matchCat = p.category == 'Serum' || p.name.toLowerCase().contains('serum');
        } else if (_selectedCategory == 'Moisturize') {
          matchCat = p.category == 'Body' || p.name.toLowerCase().contains('cream') || p.name.toLowerCase().contains('balm') || p.name.toLowerCase().contains('lotion');
        } else if (_selectedCategory == 'Protect') {
          matchCat = p.category == 'Sun' || p.name.toLowerCase().contains('sun');
        } else if (_selectedCategory == 'Eye Care') {
          matchCat = p.category == 'Face' || p.name.toLowerCase().contains('eye');
        } else {
          matchCat = p.category == _selectedCategory;
        }
      }

      final matchSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D1610) : _kCream;

    return Scaffold(
      backgroundColor: bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(isDark),
            SliverToBoxAdapter(child: _buildSearchBar(isDark)),
            SliverToBoxAdapter(child: _buildCarousel(isDark)),
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                'Categories',
                'See All',
                isDark,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllProductsScreen(category: null),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildCategoryPics(isDark)),
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                'New Launches ✨',
                'See All',
                isDark,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllProductsScreen(category: 'New'),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildNewLaunches(isDark)),
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                'Best Sellers',
                'See All',
                isDark,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllProductsScreen(category: null),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildCategoryChips(isDark)),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            _filteredProducts.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) =>
                            _buildProductCard(_filteredProducts[i], isDark),
                        childCount: _filteredProducts.length > 6
                            ? 6
                            : _filteredProducts.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.62,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                    ),
                  ),
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                'What Our Customers Say 💬',
                '',
                isDark,
              ),
            ),
            SliverToBoxAdapter(child: _buildReviews(isDark)),
            SliverToBoxAdapter(child: _buildTrustSection(isDark)),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  // ── APP BAR ──────────────────────────────────────────────────────────────
  Widget _buildAppBar(bool isDark) {
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── LEFT: Location (fixed, no Expanded) ─────────────────
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _kCoral.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: _kCoral,
                      size: 13,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : _kText,
                            ),
                          ),
                          const SizedBox(width: 1),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: isDark ? Colors.white54 : _kTextLight,
                            size: 14,
                          ),
                        ],
                      ),
                      Text(
                        'Akshya Nagar Cross',
                        style: TextStyle(
                          fontSize: 9,
                          color: isDark ? Colors.white38 : _kTextLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ── CENTER: logo centered via Spacers ────────────────────
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'earth',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : _kGreen,
                        letterSpacing: -1.5,
                      ),
                    ),
                    TextSpan(
                      text: 'rhythm',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w200,
                        color: isDark ? Colors.white : _kGreen,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // ── RIGHT: icons (fixed, no Expanded) ────────────────────
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _IconButton(
                    icon: Icons.favorite_border_rounded,
                    isDark: isDark,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: _kCoral,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── SEARCH BAR ───────────────────────────────────────────────────────────
  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF14201A) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? Colors.white10 : _kBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white : _kText,
                ),
                decoration: InputDecoration(
                  hintText: 'Search serums, cleansers, SPF...',
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _kGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ── HERO CAROUSEL ────────────────────────────────────────────────────────
  Widget _buildCarousel(bool isDark) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _promoBanners.length,
            onPageChanged: (i) => setState(() => _carouselIndex = i),
            itemBuilder: (ctx, index) {
              final b = _promoBanners[index];
              final colors = b['bg'] as List<Color>;
              final imgPath = b['img'] as String;
              final isAsset = imgPath.startsWith('assets/');

              return Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // ── FULL BLEED IMAGE (asset or network) ──────────
                      isAsset
                          ? Image.asset(
                              imgPath,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              errorBuilder: (_, __, ___) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: colors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            )
                          : Image.network(
                              imgPath,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              errorBuilder: (_, __, ___) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: colors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            ),

                      // ── GRADIENT OVERLAY — left dark, right transparent ──
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withOpacity(0.75),
                              Colors.black.withOpacity(0.40),
                              Colors.black.withOpacity(0.05),
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),

                      // ── TEXT OVERLAY on left ──────────────────────────
                      Positioned(
                        left: 20,
                        top: 0,
                        bottom: 0,
                        right: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Badge pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.20),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.35),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                b['badge'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Title
                            Text(
                              b['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // CTA pill button
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                b['sub'] as String,
                                style: TextStyle(
                                  color: colors.isNotEmpty
                                      ? colors.first
                                      : _kGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promoBanners.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _carouselIndex ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _carouselIndex ? _kGreen : _kBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── CATEGORIES WITH PHOTOS ───────────────────────────────────────────────
  Widget _buildCategoryPics(bool isDark) {
    return SizedBox(
      height: 112,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _categories.length,
        itemBuilder: (ctx, i) {
          final cat = _categories[i];
          final isSelected = _selectedCategory == cat['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['name']!),
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? _kCoral : Colors.transparent,
                        width: 2.5,
                      ),
                      color: isDark ? const Color(0xFF14201A) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? _kCoral.withOpacity(0.2)
                              : Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        cat['fallback']!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: isDark ? const Color(0xFF1A2C20) : _kMint,
                          child: Icon(
                            Icons.spa_outlined,
                            color: _kGreen,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['name']!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected
                          ? _kCoral
                          : (isDark ? Colors.white70 : _kText),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── NEW LAUNCHES ─────────────────────────────────────────────────────────
  Widget _buildNewLaunches(bool isDark) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _newLaunches.length,
        itemBuilder: (ctx, i) {
          final item = _newLaunches[i];
          return GestureDetector(
            onTap: () {
              final name = item['name'] as String;
              Product? matchedProduct;
              if (name.contains('Matcha') || name.contains('Mochi')) {
                matchedProduct = earthRhythmProducts.firstWhere((p) => p.id == 'p2');
              } else if (name.contains('Ceramide') || name.contains('Barrier')) {
                matchedProduct = earthRhythmProducts.firstWhere((p) => p.id == 'p1');
              } else if (name.contains('Rose') || name.contains('PDRN')) {
                matchedProduct = earthRhythmProducts.firstWhere((p) => p.id == 'p1');
              }
              if (matchedProduct != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(product: matchedProduct!),
                  ),
                );
              }
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF14201A) : (item['bg'] as Color),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? Colors.white10 : _kBorder),
              ),
            child: Stack(
              children: [
                // Tag banner (corner ribbon style)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: item['tagColor'] as Color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      item['tag'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Product image
                Positioned(
                  top: 28,
                  left: 8,
                  right: 8,
                  height: 105,
                  child: Image.network(
                    item['fallback'] as String,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
                // Bottom info
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : _kText,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            item['price'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: _kGreen,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['mrp'] as String,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _kCoral,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['discount'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      ),
    );
  }

  // ── CATEGORY CHIPS ───────────────────────────────────────────────────────
  Widget _buildCategoryChips(bool isDark) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: productCategories.length,
        itemBuilder: (ctx, i) {
          final cat = productCategories[i];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? _kGreen
                    : (isDark ? const Color(0xFF14201A) : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? _kGreen
                      : (isDark ? Colors.white10 : _kBorder),
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white60 : _kTextLight),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── PRODUCT CARD (like image 3 reference) ────────────────────────────────
  Widget _buildProductCard(Product product, bool isDark) {
    // Background colors cycling through brand palettes
    final bgs = [
      _kMint,
      _kPeach,
      _kYellow,
      const Color(0xFFEDE8F5),
      const Color(0xFFE8F0FD),
      const Color(0xFFFDF0E8),
    ];
    final bgIndex = earthRhythmProducts.indexOf(product) % bgs.length;
    final cardBg = isDark ? const Color(0xFF14201A) : bgs[bgIndex];

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
            // Image area
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // Product image
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
                  // NEW LAUNCH tag (top left corner)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        color: _kCoral,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'NEW LAUNCH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  // Wishlist button (top right)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 14,
                        color: _kCoral,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info area
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : _kText,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Rating
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < product.rating.floor()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 11,
                            color: const Color(0xFFFF9500),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF9500),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Price row
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: _kGreen,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '₹${(product.price * 1.18).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // ADD TO CART button
                    Consumer<CartProvider>(
                      builder: (ctx, cart, _) => GestureDetector(
                        onTap: () {
                          cart.addItem(product);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AddToCartAnimation(
                              productName: product.name,
                            ),
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

  // ── REVIEWS ──────────────────────────────────────────────────────────────
  Widget _buildReviews(bool isDark) {
    return SizedBox(
      height: 175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _reviews.length,
        itemBuilder: (ctx, i) {
          final r = _reviews[i];
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF14201A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white10 : _kBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (r['avatarColor'] as Color).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          r['avatar'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: r['avatarColor'] as Color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['name'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : _kText,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (_) => const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFF9500),
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Quote icon
                    Text(
                      '"',
                      style: TextStyle(
                        fontSize: 36,
                        color: _kGreen.withOpacity(0.15),
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    r['text'] as String,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark ? Colors.white60 : _kTextLight,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: _kCoral,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      r['product'] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _kGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── CLEAN · KIND · EFFECTIVE ─────────────────────────────────────────────
  Widget _buildTrustSection(bool isDark) {
    final badges = [
      {'icon': Icons.verified_outlined, 'label': 'Dermatologically\nTested'},
      {'icon': Icons.pets_outlined, 'label': 'Cruelty\nFree'},
      {'icon': Icons.science_outlined, 'label': 'Paraben\nFree'},
      {'icon': Icons.water_drop_outlined, 'label': 'Sulphate\nFree'},
      {'icon': Icons.eco_outlined, 'label': 'Vegan'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF14201A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white10 : _kBorder),
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                color: isDark ? Colors.white : _kText,
              ),
              children: [
                const TextSpan(text: 'CLEAN '),
                TextSpan(
                  text: '. ',
                  style: TextStyle(color: _kCoral),
                ),
                const TextSpan(text: 'KIND '),
                TextSpan(
                  text: '. ',
                  style: TextStyle(color: _kCoral),
                ),
                const TextSpan(text: 'EFFECTIVE'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: badges
                .map(
                  (b) => Column(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1A2C20)
                              : const Color(0xFFF0F7F2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? Colors.white10
                                : const Color(0xFFD0E8D8),
                          ),
                        ),
                        child: Icon(
                          b['icon'] as IconData,
                          color: _kGreen,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        b['label'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white54 : _kTextLight,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── SECTION HEADER ───────────────────────────────────────────────────────
  Widget _buildSectionHeader(
    String title,
    String action,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : _kText,
              letterSpacing: -0.3,
            ),
          ),
          if (action.isNotEmpty)
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _kGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _kGreen.withOpacity(0.2)),
                ),
                child: Text(
                  action,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _kGreen,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: _kSage),
            const SizedBox(height: 12),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _kText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different filter or search term',
              style: TextStyle(fontSize: 12, color: _kTextLight),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED ICON BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class _IconButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2620) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? Colors.white10 : _kBorder),
        ),
        child: Icon(icon, size: 17, color: isDark ? Colors.white70 : _kText),
      ),
    );
  }
}
