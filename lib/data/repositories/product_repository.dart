import '../mock/mock_store.dart';
import '../models/product_model.dart';

class ProductRepository {
  ProductRepository({MockStore? store}) : _store = store ?? MockStore.instance;

  final MockStore _store;

  Future<List<ProductModel>> getAllProducts() async {
    await _store.delay();
    final products = List<ProductModel>.from(_store.products);
    products.sort((a, b) => a.name.compareTo(b.name));
    return products;
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final products = await getAllProducts();
    return products.where((product) => product.isFeatured).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    if (category == 'all') {
      return getAllProducts();
    }

    await _store.delay();
    final products = _store.products
        .where((product) => product.category == category)
        .toList();
    products.sort((a, b) => a.name.compareTo(b.name));
    return products;
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final products = await getAllProducts();
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return products;
    }

    return products
        .where(
          (product) =>
              product.name.toLowerCase().contains(normalizedQuery) ||
              product.category.toLowerCase().contains(normalizedQuery) ||
              product.description.toLowerCase().contains(normalizedQuery),
        )
        .toList();
  }

  Future<ProductModel?> getProductById(String id) async {
    await _store.delay();
    for (final product in _store.products) {
      if (product.id == id) {
        return product;
      }
    }
    return null;
  }
}
