part of 'categories_cubit.dart';

sealed class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesLoading extends CategoriesState {}

final class CategoriesError extends CategoriesState {}

final class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({required this.categories});

  final List<Category> categories;

  @override
  List<Object> get props => [categories];
}
