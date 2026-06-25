import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  final bool isEmbedded;

  const CartScreen({super.key, this.isEmbedded = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  String _couponError = '';
  bool _isSuccessCheckout = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon(CartProvider cart) {
    setState(() {
      _couponError = '';
    });
    final enteredCode = _couponController.text.trim();
    if (enteredCode.isEmpty) return;

    final success = cart.applyCoupon(enteredCode);
    if (!success) {
      setState(() {
        _couponError = "Invalid code. Try 'EARTH20'";
      });
    } else {
      _couponController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _handleCheckout(CartProvider cart) {
    // Show order success overlay animation
    setState(() {
      _isSuccessCheckout = true;
    });

    // Clear cart after short delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        cart.clearCart();
        setState(() {
          _isSuccessCheckout = false;
        });
        
        // Show confirmation snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Order placed successfully! 🎉'),
            backgroundColor: const Color(0xFF174A33),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // If not embedded, navigate back
        if (!widget.isEmbedded) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Body content definition
    Widget mainContent;

    if (_isSuccessCheckout) {
      mainContent = _buildSuccessAnim(isDark);
    } else if (cart.items.isEmpty) {
      mainContent = _buildEmptyState(context, isDark);
    } else {
      mainContent = Column(
        children: [
          // List of items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items.values.toList()[index];
                final productId = cart.items.keys.toList()[index];

                return Dismissible(
                  key: Key(productId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 26,
                    ),
                  ),
                  onDismissed: (_) => cart.removeItem(productId),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              cartItem.product.imageUrl,
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 75,
                                height: 75,
                                color: isDark ? const Color(0xFF1D2622) : const Color(0xFFFAF8F3),
                                child: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: isDark ? Colors.white : const Color(0xFF1C2B22),
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cartItem.product.category,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF174A33),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'LKR ${(cartItem.product.price * cartItem.quantity).toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                        color: isDark ? Colors.white : const Color(0xFF1C2B22),
                                      ),
                                    ),
                                    
                                    // Quantity controls
                                    Row(
                                      children: [
                                        _QtyButton(
                                          icon: Icons.remove,
                                          onTap: () => cart.decreaseQuantity(productId),
                                          isRemove: cartItem.quantity == 1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            '${cartItem.quantity}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: isDark ? Colors.white : const Color(0xFF1C2B22),
                                            ),
                                          ),
                                        ),
                                        _QtyButton(
                                          icon: Icons.add,
                                          onTap: () => cart.addItem(cartItem.product),
                                          isRemove: false,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
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

          // Coupon Code field & totals checkout summary block
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF16201B) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF24332B) : const Color(0xFFEFECE6),
                  width: 1.2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Coupon Input Box
                if (cart.appliedCoupon.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0E1512) : const Color(0xFFF7F4F0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _couponController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Promo Code (e.g. EARTH20)',
                                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _applyCoupon(cart),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF174A33),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Apply', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      if (_couponError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 6, top: 4),
                          child: Text(
                            _couponError,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 11),
                          ),
                        ),
                    ],
                  )
                else
                  // Applied Coupon Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2F26) : const Color(0xFFE4F3EC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF174A33), width: 0.8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF174A33), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Coupon ${cart.appliedCoupon} Applied! (-20%)',
                              style: const TextStyle(
                                color: Color(0xFF174A33),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => cart.removeCoupon(),
                          child: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                
                // Totals
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    Text('LKR ${cart.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13)),
                  ],
                ),
                if (cart.discountAmount > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Discount', style: TextStyle(fontSize: 13, color: Color(0xFFD67A60))),
                      Text('- LKR ${cart.discountAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 13, color: Color(0xFFD67A60), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Shipping', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    Text('FREE', style: TextStyle(fontSize: 13, color: Color(0xFF174A33), fontWeight: FontWeight.bold)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    Text(
                      'LKR ${cart.grandTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF174A33),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleCheckout(cart),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF174A33),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Place Order'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Embed check
    if (widget.isEmbedded) {
      return Scaffold(
        body: SafeArea(child: mainContent),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Bag'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => _showClearDialog(context, cart),
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
        ],
      ),
      body: mainContent,
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16201B) : const Color(0xFFF0F7F3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 44,
                color: Color(0xFF174A33),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your bag is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add clean skincare products to get started',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessAnim(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Checked mark icon circular shell with pop details
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: Color(0xFF174A33),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 54,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Placed Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF174A33),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your organic skincare goodies are on their way. Thank you for choosing Earth Rhythm!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.45),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD67A60)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Bag?'),
        content: const Text('Do you want to remove all items from your bag?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isRemove;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.isRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isRemove 
              ? (isDark ? const Color(0xFF331E1B) : const Color(0xFFFFF0EE)) 
              : (isDark ? const Color(0xFF1E2F26) : const Color(0xFFF0F7F3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isRemove ? Colors.redAccent : const Color(0xFF174A33),
        ),
      ),
    );
  }
}
