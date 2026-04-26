import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'cart_state.dart';
import '../../data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';

class CartCubit extends Cubit<CartState> {
  final _uuid = const Uuid();

  CartCubit() : super(const CartState());

  void addToCart(ProductModel product, String selectedSize) {
    final items = List<CartItemModel>.from(state.items);

    final existingIndex = items.indexWhere(
      (item) =>
          item.product.id == product.id && item.selectedSize == selectedSize,
    );

    if (existingIndex != -1) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + 1,
      );
    } else {
      items.add(
        CartItemModel(
          id: _uuid.v4(),
          product: product,
          selectedSize: selectedSize,
          quantity: 1,
        ),
      );
    }

    emit(state.copyWith(items: items));
  }

  void removeFromCart(String cartItemId) {
    final items = state.items.where((item) => item.id != cartItemId).toList();
    emit(state.copyWith(items: items));
  }

  void incrementQuantity(String cartItemId) {
    final items = state.items.map((item) {
      if (item.id == cartItemId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: items));
  }

  void decrementQuantity(String cartItemId) {
    final item = state.items.firstWhere((i) => i.id == cartItemId);
    if (item.quantity <= 1) {
      removeFromCart(cartItemId);
    } else {
      final items = state.items.map((i) {
        if (i.id == cartItemId) {
          return i.copyWith(quantity: i.quantity - 1);
        }
        return i;
      }).toList();
      emit(state.copyWith(items: items));
    }
  }

  void clearCart() {
    emit(const CartState());
  }
}
