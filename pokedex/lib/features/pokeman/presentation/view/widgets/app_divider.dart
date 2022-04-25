import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/colors.dart';

class AppDivider extends StatelessWidget {
  final double? height;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final bool dark;
  final Color? color;

  const AppDivider(
      {Key? key,
      this.height,
      this.thickness = 1,
      this.indent,
      this.endIndent,
      this.dark = false,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color:
          color ?? (dark ? AppColors.darkGunmetal : AppColors.antiFlashWhite2),
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
