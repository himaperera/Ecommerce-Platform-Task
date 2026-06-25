class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String category;
  final String badge;
  final List<String> highlights;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.category,
    required this.badge,
    required this.highlights,
  });

  int get discountPercentage {
    if (originalPrice <= price) return 0;
    return (((originalPrice - price) / originalPrice) * 100).round();
  }
}
