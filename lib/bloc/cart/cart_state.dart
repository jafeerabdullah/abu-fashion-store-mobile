import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  final bool isLoading;

  const CartState({this.items = const [], this.isLoading = false});

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get shipping => items.isEmpty ? 0.0 : 10.0;
  double get total => subtotal + shipping;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({List<CartItemModel>? items, bool? isLoading}) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, isLoading];
}
