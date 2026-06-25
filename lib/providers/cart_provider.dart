import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  // Keep cart item map
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  // total cart iteams
  int get itemCount => _items.length;

  // Total price of cart
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  // adding iteams to cart
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // in cart iteam incress the quantity
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // add new iteam tto cart
      _items.putIfAbsent(product.id, () => CartItem(product: product));
    }
    notifyListeners(); // must for update UI
  }

  // decrease the Quantity of iteams
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
    notifyListeners();
  }
}
