import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;
  final List<ProductModel> featured;
  final String selectedCategory;
  final String searchQuery;

  const ProductsLoaded({
    required this.products,
    required this.featured,
    this.selectedCategory = 'all',
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
    products,
    featured,
    selectedCategory,
    searchQuery,
  ];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object?> get props => [message];
}
