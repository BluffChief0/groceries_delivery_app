import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromJson(json) {
    return _$CategoryFromJson(json);
  }
  final String id;
  final String name;
  final String imageUrl;

  static List<Category> parseListFromJson(dynamic json) {
    if (json is! List) {
      return [];
    }

    return json.map(Category.fromJson).toList().cast<Category>();
  }

  @override
  List<Object?> get props => [id];
}
