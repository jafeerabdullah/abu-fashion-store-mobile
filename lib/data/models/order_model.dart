import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final String orderNumber;
  final List<CartItemModel> items;
  final OrderStatus status;
  final double subtotal;
  final double shipping;
  final double totalAmount;
  final String deliveryName;
  final String deliveryPhone;
  final String deliveryAddress;
  final String deliveryCity;
  final String deliveryZipCode;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime estimatedDelivery;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.shipping,
    required this.totalAmount,
    required this.deliveryName,
    required this.deliveryPhone,
    required this.deliveryAddress,
    required this.deliveryCity,
    required this.deliveryZipCode,
    required this.paymentMethod,
    required this.createdAt,
    required this.estimatedDelivery,
  });

  String get formattedDeliveryAddress {
    final parts = [
      deliveryAddress.trim(),
      deliveryCity.trim(),
      deliveryZipCode.trim(),
    ].where((part) => part.isNotEmpty).toList();

    return parts.join(', ');
  }

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);

  Map<String, dynamic> toMap() => {
    'id': id,
    'orderNumber': orderNumber,
    'items': items.map((item) => item.toMap()).toList(),
    'status': status.name,
    'subtotal': subtotal,
    'shipping': shipping,
    'totalAmount': totalAmount,
    'deliveryName': deliveryName,
    'deliveryPhone': deliveryPhone,
    'deliveryAddress': deliveryAddress,
    'deliveryCity': deliveryCity,
    'deliveryZipCode': deliveryZipCode,
    'paymentMethod': paymentMethod,
    'createdAt': createdAt.toIso8601String(),
    'estimatedDelivery': estimatedDelivery.toIso8601String(),
  };

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
    id: map['id'] as String,
    orderNumber: map['orderNumber'] as String? ?? 'Unknown',
    items: ((map['items'] as List?) ?? const [])
        .map(
          (item) =>
              CartItemModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList(),
    status: _parseStatus(map['status'] as String?),
    subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
    shipping: (map['shipping'] as num?)?.toDouble() ?? 0,
    totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0,
    deliveryName: map['deliveryName'] as String? ?? '',
    deliveryPhone: map['deliveryPhone'] as String? ?? '',
    deliveryAddress: map['deliveryAddress'] as String? ?? '',
    deliveryCity: map['deliveryCity'] as String? ?? '',
    deliveryZipCode: map['deliveryZipCode'] as String? ?? '',
    paymentMethod: map['paymentMethod'] as String? ?? '',
    createdAt: _parseDate(map['createdAt']),
    estimatedDelivery: _parseDate(map['estimatedDelivery']),
  );

  static OrderStatus _parseStatus(String? status) {
    return OrderStatus.values.firstWhere(
      (value) => value.name == status,
      orElse: () => OrderStatus.confirmed,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
