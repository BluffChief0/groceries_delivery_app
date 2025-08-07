import 'package:equatable/equatable.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(createToJson: false)
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.amountDescription,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(json) {
    return _$ProductFromJson(json);
  }
  final int id;
  final String name;
  final String amountDescription;
  final Category category;
  final double price;
  final String imageUrl;

  static List<Product> getMockProducts() {
    return [
      Product(
        id: 1,
        name: 'Бананы',
        amountDescription: 'за 1 кг',
        category: Category.mockFruits,
        price: 99.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 2,
        name: 'Апельсины',
        amountDescription: 'за 1 кг',
        category: Category.mockFruits,
        price: 199.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 3,
        name: 'Яблоки',
        amountDescription: 'за 0.5 кг',
        category: Category.mockFruits,
        price: 159.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 4,
        name: 'Гранат',
        amountDescription: 'за 0.5 кг',
        category: Category.mockFruits,
        price: 399.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 5,
        name: 'Огурцы',
        amountDescription: 'за 0.5 кг',
        category: Category.mockVegetables,
        price: 99.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 6,
        name: 'Помидоры',
        amountDescription: 'за 0.5 кг',
        category: Category.mockVegetables,
        price: 299.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 7,
        name: 'Творог',
        amountDescription: 'за 200 г',
        category: Category.mockMilks,
        price: 99.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 8,
        name: 'Молоко',
        amountDescription: 'за 1 л',
        category: Category.mockMilks,
        price: 99.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 9,
        name: 'Кока-кола',
        amountDescription: 'за 1 шт',
        category: Category.mockDrinks,
        price: 199.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 10,
        name: 'Спрайт',
        amountDescription: 'за 1 шт',
        category: Category.mockDrinks,
        price: 199.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 11,
        name: 'Фанта',
        amountDescription: 'за 1 шт',
        category: Category.mockDrinks,
        price: 199.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
      Product(
        id: 12,
        name: 'Тархун',
        amountDescription: 'за 1 шт',
        category: Category.mockDrinks,
        price: 99.99,
        imageUrl:
            'https://static.wikia.nocookie.net/fnaf-fanon-animatronics/images/4/40/%D0%91%D0%B0%D0%BD%D0%B0%D0%BD.png/revision/latest?cb=20190614113143&path-prefix=ru',
      ),
    ];
  }

  @override
  List<Object?> get props => [id];
}
