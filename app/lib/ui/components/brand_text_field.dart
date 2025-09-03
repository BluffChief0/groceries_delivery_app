import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_delivery/ui/components/brand_text_field_clear_suffix.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class BrandTextField extends StatelessWidget {
  const BrandTextField({
    required this.formFieldCubit,
    this.decoration,
    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.focusNode,
    this.textController,
    this.autofillHints,
    this.inputFormatters,
    this.showClearButton = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.obscuringCharacter,
    this.useSuffixIconConstraints = false,
    this.expands = false,
    this.textAlignVertical,
    this.altErrorBottom = false,
    this.ensureVisibleInScrollableOnTap = false,
    this.selectAllOnFocus = false,
    this.onSubmitted,
    this.onChanged,
    this.onTapOutside,
    this.textInputAction,
  });

  final FieldCubit<String?>? formFieldCubit;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextEditingController? textController;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool showClearButton;
  final TextCapitalization textCapitalization;
  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final String? obscuringCharacter;
  final bool useSuffixIconConstraints;
  final bool altErrorBottom;
  final bool ensureVisibleInScrollableOnTap;
  final bool selectAllOnFocus;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function(PointerDownEvent)? onTapOutside;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final InputDecoration? _d = decoration;

    const _cursorColor = BrandColors.brandSecondary;
    final _defaultStyle = BrandTypography.callout.copyWith(
      height: 1.2,
    );

    const _errorBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: BrandColors.systemDestructive),
    );

    final InputDecoration _dd = InputDecoration(
      labelStyle: BrandTypography.callout.copyWith(
        color: BrandColors.textSecondary,
      ),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        final List<WidgetState> activeStates = [
          WidgetState.hovered,
          WidgetState.focused,
          WidgetState.pressed,
          WidgetState.selected,
        ];

        if (states.contains(WidgetState.error) &&
            (states.contains(WidgetState.focused) || states.contains(WidgetState.pressed))) {
          return BrandTypography.callout.copyWith(
            color: BrandColors.systemDestructive,
            height: 1,
          );
        }

        for (final WidgetState state in states) {
          if (activeStates.contains(state)) {
            return BrandTypography.callout.copyWith(
              color: BrandColors.textSecondary,
              height: 1,
            );
          }
        }

        return BrandTypography.callout.copyWith(
          color: BrandColors.textSecondary,
          height: 1,
        );
      }),
      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
      errorStyle: BrandTypography.subheadline.copyWith(
        color: BrandColors.systemDestructive,
      ),
      focusedErrorBorder: _errorBorder,
      errorBorder: _errorBorder,
      disabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: BrandColors.divider),
      ),
      helperStyle: BrandTypography.subheadline.copyWith(
        color: BrandColors.textSecondary,
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: BrandColors.divider),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: BrandColors.divider),
      ),
      isDense: true,
      isCollapsed: false,
    );

    final InputDecoration inputDecoration = InputDecoration(
      alignLabelWithHint: _d?.alignLabelWithHint ?? _dd.alignLabelWithHint,
      border: _d?.border ?? _dd.border,
      constraints: _d?.constraints ?? _dd.constraints,
      contentPadding: _d?.contentPadding ?? _dd.contentPadding,
      counter: _d?.counter ?? _dd.counter,
      counterStyle: _d?.counterStyle ?? _dd.counterStyle,
      counterText: _d?.counterText ?? _dd.counterText,
      disabledBorder: _d?.disabledBorder ?? _dd.disabledBorder,
      enabled: _d?.enabled ?? _dd.enabled,
      enabledBorder: _d?.enabledBorder ?? _dd.enabledBorder,
      error: _d?.error ?? _dd.error,
      errorBorder: _d?.errorBorder ?? _dd.errorBorder,
      errorMaxLines: _d?.errorMaxLines ?? _dd.errorMaxLines,
      errorStyle: _d?.errorStyle ?? _dd.errorStyle,
      errorText: _d?.errorText ?? _dd.errorText,
      fillColor: _d?.fillColor ?? _dd.fillColor,
      filled: _d?.filled ?? _dd.filled,
      floatingLabelAlignment: _d?.floatingLabelAlignment ?? _dd.floatingLabelAlignment,
      floatingLabelBehavior: _d?.floatingLabelBehavior ?? _dd.floatingLabelBehavior,
      floatingLabelStyle: _d?.floatingLabelStyle ?? _dd.floatingLabelStyle,
      focusColor: _d?.focusColor ?? _dd.focusColor,
      focusedBorder: _d?.focusedBorder ?? _dd.focusedBorder,
      focusedErrorBorder: _d?.focusedErrorBorder ?? _dd.focusedErrorBorder,
      helper: _d?.helper ?? _dd.helper,
      helperMaxLines: _d?.helperMaxLines ?? _dd.helperMaxLines,
      helperStyle: _d?.helperStyle ?? _dd.helperStyle,
      helperText: _d?.helperText ?? _dd.helperText,
      hintFadeDuration: _d?.hintFadeDuration ?? _dd.hintFadeDuration,
      hintMaxLines: _d?.hintMaxLines ?? _dd.hintMaxLines,
      hintStyle: _d?.hintStyle ?? _dd.hintStyle,
      hintText: _d?.hintText ?? _dd.hintText,
      hintTextDirection: _d?.hintTextDirection ?? _dd.hintTextDirection,
      hoverColor: _d?.hoverColor ?? _dd.hoverColor,
      icon: _d?.icon ?? _dd.icon,
      iconColor: _d?.iconColor ?? _dd.iconColor,
      isCollapsed: _d?.isCollapsed ?? _dd.isCollapsed,
      isDense: _d?.isDense ?? _dd.isDense,
      label: _d?.label ?? _dd.label,
      labelStyle: _d?.labelStyle ?? _dd.labelStyle,
      labelText: _d?.labelText ?? _dd.labelText,
      prefix: _d?.prefix ?? _dd.prefix,
      prefixIcon: _d?.prefixIcon ?? _dd.prefixIcon,
      prefixIconColor: _d?.prefixIconColor ?? _dd.prefixIconColor,
      prefixIconConstraints: _d?.prefixIconConstraints ?? _dd.prefixIconConstraints,
      prefixStyle: _d?.prefixStyle ?? _dd.prefixStyle,
      prefixText: _d?.prefixText ?? _dd.prefixText,
      semanticCounterText: _d?.semanticCounterText ?? _dd.semanticCounterText,
      suffix: _d?.suffix ?? _dd.suffix,
      suffixIcon: _d?.suffixIcon ?? _dd.suffixIcon,
      suffixIconColor: _d?.suffixIconColor ?? _dd.suffixIconColor,
      suffixIconConstraints: _d?.suffixIconConstraints ?? _dd.suffixIconConstraints,
      suffixStyle: _d?.suffixStyle ?? _dd.suffixStyle,
      suffixText: _d?.suffixText ?? _dd.suffixText,
    );
    return _CubitFormTextField(
      textAlignVertical: textAlignVertical,
      textAlign: textAlign,
      autofocus: autofocus,
      focusNode: focusNode,
      textController: textController,
      formFieldCubit: formFieldCubit as FieldCubit<String>,
      obscureText: obscureText,
      cursorColor: _cursorColor,
      style: style ?? _defaultStyle,
      keyboardType: keyboardType,
      maxLines: maxLines == 0 ? null : maxLines,
      minLines: minLines,
      decoration: inputDecoration,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      enabled: enabled,
      textCapitalization: textCapitalization,
      scrollPadding: scrollPadding,
      obscuringCharacter: obscuringCharacter,
      expands: expands,
      showClearButton: showClearButton,
      useSuffixIconConstraints: useSuffixIconConstraints,
      altErrorBottom: altErrorBottom,
      ensureVisibleInScrollableOnTap: ensureVisibleInScrollableOnTap,
      selectAllOnFocus: selectAllOnFocus,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      onTapOutside: onTapOutside,
      textInputAction: textInputAction,
    );
  }
}

class _CubitFormTextField extends StatefulWidget {
  const _CubitFormTextField({
    required this.formFieldCubit,
    this.enabled = true,
    this.keyboardType,
    this.decoration = const InputDecoration(),
    this.obscureText = false,
    this.inputFormatters,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.focusNode,
    this.textController,
    this.cursorColor,
    this.maxLines,
    this.minLines,
    this.autofocus = false,
    // this.prefixText,
    // this.hintText,
    this.autofillHints,
    this.showClearButton = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.expands = false,
    this.textAlignVertical,
    this.obscuringCharacter,
    this.useSuffixIconConstraints = false,
    this.altErrorBottom = false,
    this.ensureVisibleInScrollableOnTap = false,
    this.selectAllOnFocus = false,
    this.onSubmitted,
    this.onChanged,
    this.onTapOutside,
    this.textInputAction,
  });

  final FieldCubit<String> formFieldCubit;
  final bool enabled;
  // final String? prefixText;
  // final String? hintText;
  final InputDecoration decoration;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final TextEditingController? textController;
  final Color? cursorColor;
  final int? maxLines;
  final int? minLines;
  final Iterable<String>? autofillHints;
  final bool showClearButton;
  final TextCapitalization textCapitalization;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final String? obscuringCharacter;
  final bool useSuffixIconConstraints;
  final bool altErrorBottom;
  final bool ensureVisibleInScrollableOnTap;
  final bool selectAllOnFocus;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function(PointerDownEvent)? onTapOutside;
  final TextInputAction? textInputAction;

  @override
  _CubitFormTextFieldState createState() => _CubitFormTextFieldState();
}

class _CubitFormTextFieldState extends State<_CubitFormTextField> {
  late TextEditingController _controller;
  late StreamSubscription _subscription;

  late FocusNode _focusNode;
  bool isFocused = false;

  void _cubitListener(FieldCubitState<String> state) {
    if (state is InitialFieldCubitState) {
      _controller.clear();
      _unfocus();
    } else if (state is ExternalChangeFieldCubitState) {
      _unfocus();
      _controller.text = state.value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    } else if (_controller.text != state.value) {
      _controller.text = state.value;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  void textControllerListener() {
    if (widget.formFieldCubit.state.value != _controller.text) {
      widget.formFieldCubit.setValue(_controller.text);
    }
  }

  void onFocusChange() {
    if (_focusNode.hasFocus) {
      if (widget.selectAllOnFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    }

    if (_focusNode.hasFocus != isFocused) {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _unfocus() {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  @override
  void didUpdateWidget(covariant _CubitFormTextField oldWidget) {
    if (oldWidget.formFieldCubit != widget.formFieldCubit) {
      _controller.removeListener(textControllerListener);
      _subscription.cancel();
      _focusNode.removeListener(onFocusChange);
      initControllerAndSubs();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    initControllerAndSubs();
  }

  void initControllerAndSubs() {
    _controller =
        widget.textController ?? TextEditingController(text: widget.formFieldCubit.state.value);
    _controller.addListener(textControllerListener);
    _subscription = widget.formFieldCubit.stream.listen(_cubitListener);

    _focusNode = widget.focusNode ?? FocusNode();
    isFocused = _focusNode.hasFocus;
    _focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.removeListener(textControllerListener);
    _controller.dispose();
    _focusNode.removeListener(onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldCubit, FieldCubitState>(
      bloc: widget.formFieldCubit,
      builder: (context, state) {
        final textField = TextField(
          onTap: widget.ensureVisibleInScrollableOnTap
              ? () => Scrollable.ensureVisible(context)
              : null,
          onTapOutside: widget.onTapOutside,
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          textAlignVertical: widget.textAlignVertical,
          expands: widget.expands,
          controller: _controller,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          textCapitalization: widget.textCapitalization,
          autofillHints: widget.autofillHints,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          cursorColor: widget.cursorColor,
          focusNode: _focusNode,
          textAlign: widget.textAlign ?? TextAlign.left,
          style: widget.style ?? Theme.of(context).textTheme.titleMedium,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          obscuringCharacter: widget.obscuringCharacter ?? '•',
          decoration: widget.decoration.copyWith(
            enabledBorder: state.isErrorShown && state.error != null
                ? widget.decoration.errorBorder
                : widget.decoration.enabledBorder,
            prefixStyle: widget.style ?? Theme.of(context).textTheme.titleMedium,
            suffixIcon: widget.decoration.suffixIcon ??
                (widget.showClearButton
                    ? BrandTextFieldClearSuffix(
                        visible: isFocused && widget.formFieldCubit.state.value != '',
                        onTap: () {
                          widget.formFieldCubit.setValue('');
                        },
                      )
                    : null),
            suffixIconConstraints: widget.decoration.suffixIconConstraints ??
                (widget.useSuffixIconConstraints
                    ? const BoxConstraints(maxWidth: 22, maxHeight: 10)
                    : null),
          ),
          inputFormatters: widget.inputFormatters,
          scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20),
        );

        return Column(
          mainAxisAlignment: widget.expands ? MainAxisAlignment.start : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.expands) Expanded(child: textField) else textField,
            //
            if (state.isErrorShown && state.error != null) ...[
              const SizedBox(height: 6),
              if (widget.altErrorBottom)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      state.error!,
                      style: BrandTypography.caption.copyWith(
                        color: BrandColors.systemDestructive,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  state.error!,
                  style: BrandTypography.subheadline.copyWith(color: BrandColors.systemDestructive),
                ),
            ],
          ],
        );
      },
    );
  }
}
