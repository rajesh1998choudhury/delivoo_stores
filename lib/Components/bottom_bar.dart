import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Themes/style.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final Function? onTap;
  final String? text;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final double? iconsize;

  BottomBar({
    @required this.onTap,
    @required this.text,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.iconsize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function(),
      child: Container(
        height: height ?? 50.0,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          // BorderRadius.circular(10),
          color: color ?? kMainColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconsize ?? 15,
              color: textColor,
            ),
            SizedBox(
              width: 2,
            ),
            Center(
              child: Text(
                text!,
                style: bottomBarTextStyle.copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
