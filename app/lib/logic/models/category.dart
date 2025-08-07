import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable(createToJson: false)
class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromJson(json) {
    return _$CategoryFromJson(json);
  }
  final int id;
  final String name;
  final String imageUrl;

  static Category get mockFruits => const Category(
        id: 1,
        name: 'Фрукты',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3593/3593464.png',
      );
  static Category get mockVegetables => const Category(
        id: 2,
        name: 'Овощи',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3593/3593464.png',
      );
  static Category get mockMilks => const Category(
        id: 3,
        name: 'Молочные продукты',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3593/3593464.png',
      );
  static Category get mockDrinks => const Category(
        id: 4,
        name: 'Напитки',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3593/3593464.png',
      );

  static List<Category> get mockCategories => [
        mockFruits,
        mockVegetables,
        mockMilks,
        mockDrinks,
      ];

  @override
  List<Object?> get props => [id];
}
