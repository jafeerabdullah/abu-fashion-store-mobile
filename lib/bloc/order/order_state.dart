import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderPlacing extends OrderState {
  const OrderPlacing();
}

class OrderSuccess extends OrderState {
  final OrderModel order;
  const OrderSuccess(this.order);
  @override
  List<Object?> get props => [order.id];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);
  @override
  List<Object?> get props => [message];
}
