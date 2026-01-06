class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock; // <-- Add this line

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock, // <-- Add this line
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      stock: (map['stock'] ?? 0), // <-- Add this line
    );
  }
}
