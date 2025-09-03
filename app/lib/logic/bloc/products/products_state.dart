part of 'products_cubit.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsError extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  const ProductsLoaded({required this.products});

  final List<Product> products;

  @override
  List<Object> get props => [products];
}
