import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/models/product_model.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;
  List<ProductModel> _allProducts = [];
  List<ProductModel> _featured = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';

  ProductCubit(this._repository) : super(const ProductInitial());

  Future<void> loadProducts() async {
    emit(const ProductLoading());
    try {
      _allProducts = await _repository.getAllProducts();
      _featured = _allProducts.where((product) => product.isFeatured).toList();
      _selectedCategory = 'all';
      _searchQuery = '';
      _emitFilteredProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> filterByCategory(String category) async {
    if (state is! ProductsLoaded) return;
    emit(const ProductLoading());
    try {
      _selectedCategory = category;
      _emitFilteredProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void searchProducts(String query) {
    if (state is! ProductsLoaded) return;
    _searchQuery = query;
    _emitFilteredProducts();
  }

  void _emitFilteredProducts() {
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    final filtered = _allProducts.where((product) {
      final matchesCategory =
          _selectedCategory == 'all' || product.category == _selectedCategory;
      final matchesSearch =
          normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.category.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery);

      return matchesCategory && matchesSearch;
    }).toList();

    emit(
      ProductsLoaded(
        products: filtered,
        featured: _featured,
        selectedCategory: _selectedCategory,
        searchQuery: _searchQuery,
      ),
    );
  }
}
