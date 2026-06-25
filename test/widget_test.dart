import 'package:flutter_application_1/data/mock_data.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cart provider adds, updates, removes, and totals products', () {
    final cart = CartProvider();
    final product = earthRhythmProducts.first;

    cart.addItem(product);
    cart.addItem(product);

    expect(cart.itemCount, 1);
    expect(cart.items[product.id]?.quantity, 2);
    expect(cart.totalAmount, product.price * 2);

    cart.decreaseQuantity(product.id);
    expect(cart.items[product.id]?.quantity, 1);

    cart.removeItem(product.id);
    expect(cart.items, isEmpty);
  });
}
