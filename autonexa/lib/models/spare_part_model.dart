class SparePartModel {
  final String id;
  final String sellerId;
  final String name;
  final String? description;
  final double price;
  final int stockQuantity;

  SparePartModel({
    required this.id,
    required this.sellerId,
    required this.name,
    this.description,
    required this.price,
    this.stockQuantity = 0,
  });

  SparePartModel copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? description,
    double? price,
    int? stockQuantity,
  }) {
    return SparePartModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seller_id': sellerId,
      'name': name,
      if (description != null) 'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
    };
  }

  factory SparePartModel.fromMap(Map<String, dynamic> map) {
    return SparePartModel(
      id: map['id'] ?? '',
      sellerId: map['seller_id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      price: map['price']?.toDouble() ?? 0.0,
      stockQuantity: map['stock_quantity']?.toInt() ?? 0,
    );
  }
}
