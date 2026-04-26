import 'package:uuid/uuid.dart';
import '../mock/mock_store.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderRepository {
  OrderRepository({MockStore? store}) : _store = store ?? MockStore.instance;

  final MockStore _store;
  final _uuid = const Uuid();

  String _generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ABU-${timestamp.substring(timestamp.length - 6).toUpperCase()}';
  }

  Future<OrderModel> placeOrder({
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
    await _store.delay(500);
    final orderId = _uuid.v4();
    final orderNumber = _generateOrderNumber();
    final now = DateTime.now();
    final estimatedDelivery = now.add(const Duration(days: 5));

    final order = OrderModel(
      id: orderId,
      orderNumber: orderNumber,
      items: items,
      status: OrderStatus.confirmed,
      subtotal: subtotal,
      shipping: shipping,
      totalAmount: subtotal + shipping,
      deliveryName: deliveryName,
      deliveryPhone: deliveryPhone,
      deliveryAddress: deliveryAddress,
      deliveryCity: deliveryCity,
      deliveryZipCode: deliveryZipCode,
      paymentMethod: paymentMethod,
      createdAt: now,
      estimatedDelivery: estimatedDelivery,
    );

    _store.addOrder(userId, order);

    return order;
  }

  Future<List<OrderModel>> getOrderHistory(String userId) async {
    await _store.delay();
    return _store.getOrders(userId);
  }
}
