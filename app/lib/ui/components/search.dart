import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class Search extends StatefulWidget {
  const Search({
    required this.hintText,
    this.onChanged,
  });
  final String hintText;
  final void Function(String)? onChanged;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(textController.text);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: BrandTypography.body.copyWith(color: BrandColors.textSecondary),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: textController.text.isNotEmpty
            ? GestureDetector(
                onTap: () => textController.text = '',
                child: const Icon(
                  CupertinoIcons.xmark,
                  size: 15,
                ),
              )
            : const SizedBox.shrink(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
