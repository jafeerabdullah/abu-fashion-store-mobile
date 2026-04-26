import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_state.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/models/cart_item_model.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _repository;

  OrderCubit(this._repository) : super(const OrderInitial());

  Future<void> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required String deliveryName,
    required String deliveryPhone,
    required String deliveryAddress,
    required String deliveryCity,
    required String deliveryZipCode,
    required String paymentMethod,
    required double subtotal,
    required double shipping,
  }) async {
    emit(const OrderPlacing());
    try {
      final order = await _repository.placeOrder(
        userId: userId,
        items: items,
        deliveryName: deliveryName,
        deliveryPhone: deliveryPhone,
        deliveryAddress: deliveryAddress,
        deliveryCity: deliveryCity,
        deliveryZipCode: deliveryZipCode,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        shipping: shipping,
      );
      emit(OrderSuccess(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  void reset() => emit(const OrderInitial());
}
