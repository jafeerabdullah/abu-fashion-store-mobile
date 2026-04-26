class ProductModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String category; // men, women, kids, accessories
  final List<String> sizes;
  final bool isFeatured;
  final double rating;
  final int reviewCount;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.sizes,
    this.isFeatured = false,
    this.rating = 4.5,
    this.reviewCount = 0,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'description': description,
    'imageUrl': imageUrl,
    'category': category,
    'sizes': sizes,
    'isFeatured': isFeatured,
    'rating': rating,
    'reviewCount': reviewCount,
  };

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map['id'] as String,
    name: map['name'] as String,
    price: (map['price'] as num).toDouble(),
    description: map['description'] as String,
    imageUrl: map['imageUrl'] as String,
    category: map['category'] as String,
    sizes: List<String>.from(map['sizes'] as List),
    isFeatured: map['isFeatured'] as bool? ?? false,
    rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
    reviewCount: map['reviewCount'] as int? ?? 0,
  );
}
