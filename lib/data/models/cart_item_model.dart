import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final String selectedSize;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    String? selectedSize,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'product': product.toMap(),
    'selectedSize': selectedSize,
    'quantity': quantity,
  };

  factory CartItemModel.fromMap(Map<String, dynamic> map) => CartItemModel(
    id: map['id'] as String,
    product: ProductModel.fromMap(
      Map<String, dynamic>.from(map['product'] as Map),
    ),
    selectedSize: map['selectedSize'] as String,
    quantity: (map['quantity'] as num).toInt(),
  );
}
