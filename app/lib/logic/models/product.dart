import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.stock,
    required this.rating,
    required this.calories,
    required this.weight,
    required this.country,
  });

  factory Product.fromJson(json) {
    return _$ProductFromJson(json);
  }
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final double price;
  final double? discountPrice;
  final String imageUrl;
  final double stock;
  final double rating;
  final double calories;
  final double weight;
  final String country;



  static List<Product> parseListFromJson(dynamic json) {
    if (json is! List) {
      return [];
    }

    return json.map(Product.fromJson).toList().cast<Product>();
  }

  @override
  List<Object?> get props => [id];
}
