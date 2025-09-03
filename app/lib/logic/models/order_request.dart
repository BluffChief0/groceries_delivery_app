import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_request.g.dart';

@JsonSerializable(createToJson: true, fieldRename: FieldRename.snake)
class OrderRequest extends Equatable {
  const OrderRequest({
    required this.userPhone,
    required this.deliveryAddress,
    required this.deliveryTime,
    required this.items,
    required this.paymentType,
    required this.deliveryType,
    required this.fio,
    required this.comment,
  });

  factory OrderRequest.fromJson(json) {
    return _$OrderRequestFromJson(json);
  }
  final String userPhone;
  final String deliveryAddress;
  final String deliveryTime;
  @JsonKey(toJson: OrderProduct.listToJsonList)
  final List<OrderProduct> items;
  @JsonKey(toJson: PaymentType.slug)
  final PaymentType paymentType;
  @JsonKey(toJson: DeliveryType.slug)
  final DeliveryType deliveryType;
  final String fio;
  final String comment;

  Map<String, dynamic> toJson() => _$OrderRequestToJson(this);

  @override
  List<Object?> get props => [];
}

@JsonSerializable(createToJson: true, fieldRename: FieldRename.snake)
class OrderProduct extends Equatable {
  const OrderProduct({
    required this.productId,
    required this.amount,
    required this.price,
  });

  factory OrderProduct.fromJson(json) {
    return _$OrderProductFromJson(json);
  }

  final String productId;
  final int amount;
  final double price;

  static List<Map<String, dynamic>> listToJsonList(List<OrderProduct> products) {
    return products.map((product) => product.toJson()).toList();
  }

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);

  @override
  List<Object?> get props => [];
}

enum PaymentType {
  card,
  cash;

  static String slug(PaymentType pt) {
    switch (pt) {
      case card:
        return 'карта';
      case cash:
        return 'наличные';
    }
  }

  String get name {
    switch (this) {
      case PaymentType.card:
        return 'Картой курьеру';
      case PaymentType.cash:
        return 'Наличными';
    }
  }
}

enum DeliveryType {
  courier,
  selfPickup;

  static String slug(DeliveryType dt) {
    switch (dt) {
      case courier:
        return 'курьер';
      case selfPickup:
        return 'самовывоз';
    }
  }

  String get name {
    switch (this) {
      case DeliveryType.courier:
        return 'Доставка курьером';
      case DeliveryType.selfPickup:
        return 'Самовывоз';
    }
  }
}
