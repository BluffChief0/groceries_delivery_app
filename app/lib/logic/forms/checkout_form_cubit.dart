import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/models/order_request.dart';
import 'package:grocery_delivery/utils/helper_functions.dart';

class CheckoutFormCubit extends FormCubit {
  CheckoutFormCubit(this.cartCubit) {
    fio = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
        MinLengthValidation(
          5,
          'ФИО не может быть короче 5 символов',
        ),
      ],
    );
    phone = FieldCubit<String>(
      initalValue: '',
      validations: [
        PhoneStringValidation(11, 'Некорректно введен номер телефона'),
      ],
    );
    street = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
      ],
    );
    building = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
      ],
    );
    entrance = FieldCubit<String>(initalValue: '');
    floor = FieldCubit<String>(initalValue: '');
    apartment = FieldCubit<String>(initalValue: '');
    dateCubit = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
      ],
    );
    date = FieldCubit<DateTime?>(initalValue: null);
    timeCubit = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
      ],
    );
    time = FieldCubit<TimeOfDay?>(initalValue: null);
    comment = FieldCubit<String>(initalValue: '');
    deliveryType = FieldCubit<DeliveryType?>(
      initalValue: null,
      validations: [
        RequiredNotNullValidation('Это поле обязательное'),
      ],
    );
    paymentType = FieldCubit<PaymentType?>(
      initalValue: null,
      validations: [
        RequiredNotNullValidation('Это поле обязательное'),
      ],
    );

    addFields([
      fio,
      phone,
      street,
      building,
      entrance,
      floor,
      apartment,
      dateCubit,
      timeCubit,
      comment,
      deliveryType,
      paymentType,
    ]);
  }

  final CartCubit cartCubit;

  late FieldCubit<String> fio;
  late FieldCubit<String> phone;
  late FieldCubit<String> street;
  late FieldCubit<String> building;
  late FieldCubit<String> entrance;
  late FieldCubit<String> floor;
  late FieldCubit<String> apartment;
  late FieldCubit<String> dateCubit;
  late FieldCubit<DateTime?> date;
  late FieldCubit<String> timeCubit;
  late FieldCubit<TimeOfDay?> time;
  late FieldCubit<String> comment;
  late FieldCubit<DeliveryType?> deliveryType;
  late FieldCubit<PaymentType?> paymentType;

  @override
  FutureOr<bool> asyncValidation() async {
    final deliveryTime = uniteTime(date: date.state.value!, time: time.state.value!);
    final address = uniteAddress(
      street: street.state.value,
      building: building.state.value,
      entrance: entrance.state.value,
      floor: floor.state.value,
      apartment: apartment.state.value,
    );
    final orderRequest = OrderRequest(
      userPhone: phone.state.value,
      deliveryAddress: address,
      deliveryTime: deliveryTime,
      items: cartCubit.state.entries
          .map(
            (entry) => OrderProduct(
              productId: entry.key.id,
              amount: entry.value,
              price: entry.key.price,
            ),
          )
          .toList(),
      paymentType: paymentType.state.value!,
      deliveryType: deliveryType.state.value!,
      fio: fio.state.value,
      comment: comment.state.value,
    );
    final res = await ApiService.createOrder(orderRequest);
    return res;
  }

  @override
  FutureOr<void> onSubmit() {}
}
