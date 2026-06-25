import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WishlistProvider with ChangeNotifier {
  final Set<String> _wishlistProductIds = {};

  Set<String> get wishlistProductIds => _wishlistProductIds;

  bool isWishlisted(String productId) {
    return _wishlistProductIds.contains(productId);
  }

  void toggleWishlist(String productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    notifyListeners();
  }

  List<Product> getWishlistItems(List<Product> allProducts) {
    return allProducts.where((product) => _wishlistProductIds.contains(product.id)).toList();
  }
}
