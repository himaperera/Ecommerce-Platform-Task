import 'cart_item_model.dart';

class MockOrder {
  final String orderId;
  final String date;
  final String
  status; // 'Ordered', 'Processing', 'Shipped', 'Out for Delivery', 'Delivered'
  final double amount;
  final List<CartItem> items;
  final String address;
  final int
  trackingStep; // 0 to 4 (Ordered -> Packed -> Shipped -> Out for Delivery -> Delivered)

  MockOrder({
    required this.orderId,
    required this.date,
    required this.status,
    required this.amount,
    required this.items,
    required this.address,
    this.trackingStep = 0,
  });

  MockOrder copyWith({String? status, int? trackingStep}) {
    return MockOrder(
      orderId: orderId,
      date: date,
      status: status ?? this.status,
      amount: amount,
      items: items,
      address: address,
      trackingStep: trackingStep ?? this.trackingStep,
    );
  }
}
