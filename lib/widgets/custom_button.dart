import 'package:flutter/material.dart';
import 'package:yellow_nav/common/colors.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final void Function()? onPressed;
  final bool isPrimary;
  final double? width;
  final Widget? child;
  final double? height;

  const CustomButton({
    super.key,
    this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            backgroundColor: AppColors.green2B8, side: BorderSide.none),
        child: child ??
            Text(
              label!,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: AppColors.white),
            ),
      ),
    );
  }
}
