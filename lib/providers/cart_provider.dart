import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class CartProvider with ChangeNotifier {
  // Keep cart item map
  final Map<String, CartItem> _items = {};

  // Order tracking and history
  final List<MockOrder> _orders = [
    MockOrder(
      orderId: 'ER-1024',
      date: '24 Jun 2026',
      status: 'Delivered',
      amount: 1617.0,
      items: [],
      address: 'No. 24, Colombo, Sri Lanka',
      trackingStep: 4,
    ),
    MockOrder(
      orderId: 'ER-1019',
      date: '20 Jun 2026',
      status: 'Processing',
      amount: 978.0,
      items: [],
      address: 'No. 24, Colombo, Sri Lanka',
      trackingStep: 1,
    ),
  ];

  MockOrder? _activeTrackingOrder;
  int _currentTabIndex = 0;
  String _appliedCoupon = '';
  double _couponDiscountPercentage = 0.0;

  Map<String, CartItem> get items => {..._items};

  // total cart items
  int get itemCount => _items.length;

  // Coupon properties
  String get appliedCoupon => _appliedCoupon;
  double get couponDiscountPercentage => _couponDiscountPercentage;

  // Total price of cart (Subtotal)
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  // Calculate discount amount
  double get discountAmount {
    return totalAmount * (_couponDiscountPercentage / 100);
  }

  // Calculate grand total after discount
  double get grandTotal {
    final netTotal = totalAmount - discountAmount;
    return netTotal < 0 ? 0.0 : netTotal;
  }

  // Apply a coupon code
  bool applyCoupon(String code) {
    final sanitizedCode = code.trim().toUpperCase();
    if (sanitizedCode == 'EARTH20') {
      _appliedCoupon = sanitizedCode;
      _couponDiscountPercentage = 20.0;
      notifyListeners();
      return true;
    } else if (sanitizedCode == 'FREESHIP') {
      // Shipping is already free, but maybe another code
      _appliedCoupon = sanitizedCode;
      _couponDiscountPercentage = 10.0; // 10% off
      notifyListeners();
      return true;
    }
    return false;
  }

  // Remove coupon
  void removeCoupon() {
    _appliedCoupon = '';
    _couponDiscountPercentage = 0.0;
    notifyListeners();
  }

  // adding items to cart
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // in cart item increase the quantity
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // add new item to cart
      _items.putIfAbsent(product.id, () => CartItem(product: product));
    }
    notifyListeners(); // must for update UI
  }

  // decrease the Quantity of items
  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // remove item from the cart
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // clear cart
  void clearCart() {
    _items.clear();
    _appliedCoupon = '';
    _couponDiscountPercentage = 0.0;
    notifyListeners();
  }

  // Getters for orders and tab
  List<MockOrder> get orders => [..._orders];
  int get currentTabIndex => _currentTabIndex;

  MockOrder? get activeTrackingOrder =>
      _activeTrackingOrder ?? (_orders.isNotEmpty ? _orders.first : null);

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void setActiveTrackingOrder(MockOrder order) {
    _activeTrackingOrder = order;
    notifyListeners();
  }

  void simulateNextTrackingStep(String orderId) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1) {
      final order = _orders[index];
      int nextStep = order.trackingStep + 1;
      if (nextStep > 4) nextStep = 4; // Max is Delivered

      String nextStatus;
      switch (nextStep) {
        case 0:
          nextStatus = 'Ordered';
          break;
        case 1:
          nextStatus = 'Processing';
          break;
        case 2:
          nextStatus = 'Shipped';
          break;
        case 3:
          nextStatus = 'Out for Delivery';
          break;
        case 4:
        default:
          nextStatus = 'Delivered';
          break;
      }

      final updatedOrder = order.copyWith(
        status: nextStatus,
        trackingStep: nextStep,
      );

      _orders[index] = updatedOrder;

      if (_activeTrackingOrder?.orderId == orderId) {
        _activeTrackingOrder = updatedOrder;
      }
      notifyListeners();
    }
  }

  void placeOrder(String address) {
    final nextIdNum = _orders.isEmpty
        ? 1000
        : int.parse(_orders.first.orderId.replaceAll('ER-', '')) + 1;
    final newOrderId = 'ER-$nextIdNum';

    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateStr = '${now.day} ${months[now.month - 1]} ${now.year}';

    final newOrder = MockOrder(
      orderId: newOrderId,
      date: dateStr,
      status: 'Processing',
      amount: grandTotal,
      items: _items.values.toList(),
      address: address,
      trackingStep: 1, // Start at Processing
    );

    _orders.insert(0, newOrder);
    _activeTrackingOrder = newOrder;

    // Clear cart and coupon properties
    _items.clear();
    _appliedCoupon = '';
    _couponDiscountPercentage = 0.0;

    notifyListeners();
  }
}
