import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class MockStore {
  MockStore._() {
    _seedProducts();
    _seedAccounts();
    _seedOrders();
  }

  static final MockStore instance = MockStore._();

  final List<ProductModel> _products = [];
  final Map<String, _MockAccount> _accountsById = {};
  final Map<String, String> _userIdByEmail = {};
  final Map<String, List<OrderModel>> _ordersByUserId = {};
  String? _currentUserId;

  List<ProductModel> get products => List.unmodifiable(_products);

  UserModel? get currentUser {
    final userId = _currentUserId;
    if (userId == null) {
      return null;
    }
    return _accountsById[userId]?.user;
  }

  Future<void> delay([int milliseconds = 350]) async {
    await Future<void>.delayed(Duration(milliseconds: milliseconds));
  }

  UserModel login({required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    final userId = _userIdByEmail[normalizedEmail];

    if (userId == null) {
      throw const MockStoreException('No account found with this email.');
    }

    final account = _accountsById[userId]!;
    if (account.password != password) {
      throw const MockStoreException('Incorrect password. Please try again.');
    }

    _currentUserId = userId;
    return account.user;
  }

  UserModel signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    if (_userIdByEmail.containsKey(normalizedEmail)) {
      throw const MockStoreException(
        'An account already exists with this email.',
      );
    }

    if (password.length < 6) {
      throw const MockStoreException(
        'Password is too weak. Use at least 6 characters.',
      );
    }

    final user = UserModel(
      uid: _generateId('user'),
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
    );

    _saveAccount(user: user, password: password);
    _ordersByUserId.putIfAbsent(user.uid, () => []);
    _currentUserId = user.uid;
    return user;
  }

  UserModel updateProfile({required String name, required String phone}) {
    final current = currentUser;
    if (current == null) {
      throw const MockStoreException(
        'You need to log in before editing your profile.',
      );
    }

    final updatedUser = current.copyWith(
      name: name.trim(),
      phone: phone.trim(),
    );
    final account = _accountsById[current.uid]!;
    _accountsById[current.uid] = account.copyWith(user: updatedUser);
    return updatedUser;
  }

  void sendPasswordResetEmail(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw const MockStoreException('Please enter your email address.');
    }

    if (!_userIdByEmail.containsKey(normalizedEmail)) {
      throw const MockStoreException('No account found with this email.');
    }
  }

  void deleteCurrentAccount({required String password}) {
    final current = currentUser;
    if (current == null) {
      throw const MockStoreException(
        'You need to log in before deleting your account.',
      );
    }

    if (password.trim().isEmpty) {
      throw const MockStoreException(
        'Please enter your password to delete the account.',
      );
    }

    final account = _accountsById[current.uid]!;
    if (account.password != password) {
      throw const MockStoreException('The password you entered is incorrect.');
    }

    _accountsById.remove(current.uid);
    _userIdByEmail.remove(current.email.toLowerCase());
    _ordersByUserId.remove(current.uid);
    _currentUserId = null;
  }

  void logout() {
    _currentUserId = null;
  }

  void addOrder(String userId, OrderModel order) {
    final orders = _ordersByUserId.putIfAbsent(userId, () => []);
    orders.insert(0, order);
  }

  List<OrderModel> getOrders(String userId) {
    final orders = _ordersByUserId[userId] ?? const [];
    return List<OrderModel>.from(orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void _saveAccount({required UserModel user, required String password}) {
    _accountsById[user.uid] = _MockAccount(user: user, password: password);
    _userIdByEmail[user.email.toLowerCase()] = user.uid;
  }

  ProductModel _productById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  void _seedProducts() {
    _products.addAll(const [
      ProductModel(
        id: 'men-linen-shirt',
        name: 'Linen Resort Shirt',
        price: 34.99,
        description:
            'Breathable linen shirt with a relaxed fit for warm-weather days.',
        imageUrl:
            'https://images.unsplash.com/photo-1603252109303-2751441dd157?auto=format&fit=crop&w=900&q=80',
        category: 'men',
        sizes: ['S', 'M', 'L', 'XL'],
        isFeatured: true,
        rating: 4.8,
        reviewCount: 124,
      ),
      ProductModel(
        id: 'women-maxi-dress',
        name: 'Floral Maxi Dress',
        price: 48.50,
        description:
            'Flowing dress with a soft floral print and an easy everyday silhouette.',
        imageUrl:
            'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=900&q=80',
        category: 'women',
        sizes: ['S', 'M', 'L'],
        isFeatured: true,
        rating: 4.9,
        reviewCount: 212,
      ),
      ProductModel(
        id: 'kids-hoodie',
        name: 'Kids Everyday Hoodie',
        price: 22.00,
        description:
            'Soft cotton-blend hoodie built for play, layering, and cooler evenings.',
        imageUrl:
            'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?auto=format&fit=crop&w=900&q=80',
        category: 'kids',
        sizes: ['4Y', '6Y', '8Y', '10Y'],
        rating: 4.6,
        reviewCount: 61,
      ),
      ProductModel(
        id: 'accessories-leather-watch',
        name: 'Classic Leather Watch',
        price: 55.75,
        description:
            'Minimal watch with a slim profile and timeless leather strap.',
        imageUrl:
            'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=900&q=80',
        category: 'accessories',
        sizes: ['One Size'],
        isFeatured: true,
        rating: 4.7,
        reviewCount: 98,
      ),
      ProductModel(
        id: 'men-tailored-trouser',
        name: 'Tailored Trousers',
        price: 39.25,
        description:
            'Clean-cut trousers designed for polished office and evening looks.',
        imageUrl:
            'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=900&q=80',
        category: 'men',
        sizes: ['30', '32', '34', '36'],
        rating: 4.5,
        reviewCount: 73,
      ),
      ProductModel(
        id: 'women-knit-set',
        name: 'Soft Knit Co-ord Set',
        price: 64.00,
        description:
            'Matching knit top and skirt set with a comfortable premium feel.',
        imageUrl:
            'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=900&q=80',
        category: 'women',
        sizes: ['S', 'M', 'L', 'XL'],
        rating: 4.8,
        reviewCount: 147,
      ),
      ProductModel(
        id: 'kids-party-shirt',
        name: 'Kids Party Shirt',
        price: 19.99,
        description:
            'Smart-casual printed shirt made for birthdays, outings, and family events.',
        imageUrl:
            'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?auto=format&fit=crop&w=900&q=80',
        category: 'kids',
        sizes: ['4Y', '6Y', '8Y'],
        isFeatured: true,
        rating: 4.4,
        reviewCount: 37,
      ),
      ProductModel(
        id: 'accessories-tote-bag',
        name: 'Structured Tote Bag',
        price: 42.30,
        description:
            'Roomy structured tote with everyday storage and a refined finish.',
        imageUrl:
            'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=900&q=80',
        category: 'accessories',
        sizes: ['One Size'],
        rating: 4.7,
        reviewCount: 89,
      ),
    ]);
  }

  void _seedAccounts() {
    _saveAccount(
      user: const UserModel(
        uid: 'demo-user',
        name: 'JAFEER ABDULLAH',
        email: 'jafeerabdullah4g@gmail.com',
        phone: '+94770671752',
      ),
      password: '123456',
    );
  }

  void _seedOrders() {
    final now = DateTime.now();
    final firstOrder = OrderModel(
      id: 'order-demo-001',
      orderNumber: 'ABU-240321',
      items: [
        CartItemModel(
          id: 'cart-demo-001',
          product: _productById('women-maxi-dress'),
          selectedSize: 'M',
          quantity: 1,
        ),
        CartItemModel(
          id: 'cart-demo-002',
          product: _productById('accessories-tote-bag'),
          selectedSize: 'One Size',
          quantity: 1,
        ),
      ],
      status: OrderStatus.delivered,
      subtotal: 90.80,
      shipping: 10.00,
      totalAmount: 100.80,
      deliveryName: 'Abdur Rahman',
      deliveryPhone: '+94789501560',
      deliveryAddress: 'No.34/11,M.C.Abdul Cader Road,Kattankudy',
      deliveryCity: 'Batticaloa',
      deliveryZipCode: '30100',
      paymentMethod: 'Cash on Delivery',
      createdAt: now.subtract(const Duration(days: 12)),
      estimatedDelivery: now.subtract(const Duration(days: 7)),
    );

    _ordersByUserId['demo-user'] = [firstOrder];
  }

  String _generateId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }
}

class MockStoreException implements Exception {
  final String message;

  const MockStoreException(this.message);

  @override
  String toString() => message;
}

class _MockAccount {
  final UserModel user;
  final String password;

  const _MockAccount({required this.user, required this.password});

  _MockAccount copyWith({UserModel? user, String? password}) {
    return _MockAccount(
      user: user ?? this.user,
      password: password ?? this.password,
    );
  }
}
