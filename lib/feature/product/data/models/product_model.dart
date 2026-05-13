class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final String? imagePath;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    this.imagePath,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
      title: json['title'] ?? 'Untitled Product',
      description: json['description'] ?? 'No description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      thumbnail:
          json['thumbnail'] ?? 'https://placehold.co/600x400/png?text=No+Image',
      imagePath: json['imagePath'],
    );
  }
}
