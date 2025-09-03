import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/forms/checkout_form_cubit.dart';
import 'package:grocery_delivery/logic/models/order_request.dart';
import 'package:grocery_delivery/ui/components/brand_button.dart';
import 'package:grocery_delivery/ui/components/brand_text_field.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';
import 'package:grocery_delivery/utils/extensions/list.dart';
import 'package:intl/intl.dart';
import 'package:ru_phone_formatter/ru_phone_formatter.dart';

InputBorder textFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide.none,
);

InputDecoration textFieldDecoration = InputDecoration(
  filled: true,
  fillColor: BrandColors.fillTertiary,
  labelStyle: BrandTypography.subheadline.copyWith(color: BrandColors.textSecondary),
  hintStyle: BrandTypography.subheadline.copyWith(color: BrandColors.textSecondary),
  border: textFieldBorder,
  enabledBorder: textFieldBorder,
  focusedBorder: textFieldBorder,
  focusedErrorBorder:
      textFieldBorder.copyWith(borderSide: const BorderSide(color: BrandColors.systemDestructive)),
  errorBorder:
      textFieldBorder.copyWith(borderSide: const BorderSide(color: BrandColors.systemDestructive)),
  disabledBorder: textFieldBorder,
  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
);

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оформление заказа')),
      body: BlocProvider(
        create: (context) => CheckoutFormCubit(BlocProvider.of<CartCubit>(context)),
        child: Builder(
          builder: (context) {
            final formCubit = context.watch<CheckoutFormCubit>();
            return BlocListener<CheckoutFormCubit, FormCubitState>(
              listener: (context, state) {
                if (state.isSubmitted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ваш заказ оформлен! Скоро с Вами свяжется менежер для уточнения деталей.',
                      ),
                    ),
                  );
                  BlocProvider.of<CartCubit>(context).clearCart();
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Заполните контактную информацию:',
                        style: BrandTypography.titleSmallBold,
                      ),
                      const SizedBox(height: 4),
                      BrandTextField(
                        formFieldCubit: formCubit.fio,
                        decoration: textFieldDecoration.copyWith(hintText: 'ФИО'),
                        style: BrandTypography.subheadline,
                      ),
                      BrandTextField(
                        formFieldCubit: formCubit.phone,
                        style: BrandTypography.subheadline,
                        decoration: textFieldDecoration.copyWith(hintText: 'Телефон'),
                        inputFormatters: [RuPhoneInputFormatter()],
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            flex: 2,
                            child: BrandTextField(
                              formFieldCubit: formCubit.street,
                              style: BrandTypography.subheadline,
                              decoration: textFieldDecoration.copyWith(hintText: 'Улица'),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: BrandTextField(
                              formFieldCubit: formCubit.building,
                              style: BrandTypography.subheadline,
                              decoration: textFieldDecoration.copyWith(hintText: 'Дом'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          Expanded(
                            child: BrandTextField(
                              formFieldCubit: formCubit.entrance,
                              style: BrandTypography.subheadline,
                              decoration: textFieldDecoration.copyWith(hintText: 'Подъезд'),
                            ),
                          ),
                          Expanded(
                            child: BrandTextField(
                              formFieldCubit: formCubit.floor,
                              style: BrandTypography.subheadline,
                              decoration: textFieldDecoration.copyWith(hintText: 'Этаж'),
                            ),
                          ),
                          Expanded(
                            child: BrandTextField(
                              formFieldCubit: formCubit.apartment,
                              style: BrandTypography.subheadline,
                              decoration: textFieldDecoration.copyWith(hintText: 'Квартира'),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          final res = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                            helpText: 'Выберите дату доставки',
                          );
                          if (res != null) {
                            final format = DateFormat('dd.MM.yyyy');
                            formCubit.date.setValue(res);
                            formCubit.dateCubit.setValue(format.format(res));
                          }
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: BrandTextField(
                            formFieldCubit: formCubit.dateCubit,
                            style: BrandTypography.subheadline,
                            decoration: textFieldDecoration.copyWith(hintText: 'Дата доставки'),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final res = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            helpText: 'Выберите время доставки',
                          );
                          if (res != null) {
                            formCubit.timeCubit.setValue(res.format(context));
                            formCubit.time.setValue(res);
                          }
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: BrandTextField(
                            formFieldCubit: formCubit.timeCubit,
                            style: BrandTypography.subheadline,
                            decoration: textFieldDecoration.copyWith(hintText: 'Время доставки'),
                          ),
                        ),
                      ),
                      BrandTextField(
                        formFieldCubit: formCubit.comment,
                        style: BrandTypography.subheadline,
                        decoration: textFieldDecoration.copyWith(hintText: 'Комментарий'),
                        minLines: 2,
                        maxLines: 2,
                      ),
                      RadiobuttonsChooser(
                        fieldCubit: formCubit.deliveryType,
                        title: 'Выберите вариант доставки:',
                        variants: [
                          RadiobuttonVariant(text: DeliveryType.selfPickup),
                          RadiobuttonVariant(
                            text: DeliveryType.courier,
                            additionalInfo: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 4,
                              children: [
                                DeliveryPrice(name: 'Таганка', price: '200₽'),
                                DeliveryPrice(name: 'Другой район', price: '500₽'),
                                DeliveryPrice(name: 'Заказ от 5 000₽', price: 'Бесплатно'),
                              ],
                            ),
                          ),
                        ],
                        itemLabel: (DeliveryType dt) => dt.name,
                      ),
                      RadiobuttonsChooser(
                        fieldCubit: formCubit.paymentType,
                        title: 'Выберите вариант оплаты:',
                        variants: [
                          RadiobuttonVariant(text: PaymentType.cash),
                          RadiobuttonVariant(text: PaymentType.card),
                        ],
                        itemLabel: (PaymentType pt) => pt.name,
                      ),
                      const SizedBox(height: 16),
                      BrandButton(
                        onTap: formCubit.trySubmit,
                        label: 'Подтвердить заказ',
                        labelColor: BrandColors.white,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RadiobuttonsChooser<T> extends StatelessWidget {
  const RadiobuttonsChooser({
    required this.fieldCubit,
    required this.title,
    required this.variants,
    required this.itemLabel,
  });

  final FieldCubit<T?> fieldCubit;
  final String title;
  final List<RadiobuttonVariant> variants;
  final String Function(T) itemLabel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldCubit, FieldCubitState>(
      bloc: fieldCubit,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              title,
              style: BrandTypography.bodyBold,
            ),
            ...variants.map((variant) => _variant(variant.text)).toList(),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: variants
                      .firstWhereOrNull((variant) => variant.text == fieldCubit.state.value)
                      ?.additionalInfo ??
                  const SizedBox.shrink(),
              crossFadeState: fieldCubit.state.value != null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
            if (state.isErrorShown && state.error != null)
              Text(
                state.error!,
                style: BrandTypography.subheadline.copyWith(color: BrandColors.systemDestructive),
              ),
          ],
        );
      },
    );
  }

  Widget _variant(T variant) {
    return GestureDetector(
      onTap: () {
        if (fieldCubit.state.value != variant) {
          fieldCubit.setValue(variant);
        }
      },
      child: Row(
        spacing: 8,
        children: [
          if (fieldCubit.state.value == variant)
            const Icon(
              Icons.radio_button_on,
              color: BrandColors.systemLink,
            )
          else
            const Icon(
              Icons.radio_button_off,
              color: BrandColors.textTertiary,
            ),
          Text(
            itemLabel(variant),
            style: BrandTypography.subheadline,
          ),
        ],
      ),
    );
  }
}

class DeliveryPrice extends StatelessWidget {
  const DeliveryPrice({required this.name, required this.price});

  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: '$name ', style: BrandTypography.subheadline),
          TextSpan(text: price, style: BrandTypography.subheadlineBold),
        ],
      ),
    );
  }
}

class RadiobuttonVariant<T> {
  RadiobuttonVariant({required this.text, this.additionalInfo});

  final T text;
  final Widget? additionalInfo;
}
