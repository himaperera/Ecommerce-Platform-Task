import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  // Keep cart item map
  final Map<String, CartItem> _items = {};
  
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
}
