// ignore_for_file: must_be_immutable

import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? image;
  final String? initialValue;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final String? hint;
  final InputBorder? border;
  final Widget? suffixIcon;
  final Function? onTap;
  final TextCapitalization? textCapitalization;
  final Color? imageColor;
  final Widget? icon;
  void Function()? onEditingComplete;
  final TextStyle? style;
  final bool? enabled;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final AutovalidateMode? autovalidate;
  final String? Function(String)? onChanged;

  EntryField({
    this.controller,
    this.label,
    this.image,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.hint,
    this.border,
    this.maxLines,
    this.suffixIcon,
    this.onTap,
    this.textCapitalization,
    this.imageColor,
    this.icon,
    this.onEditingComplete,
    this.style,
    this.enabled,
    this.validator,
    this.inputFormatters,
    this.prefix,
    this.autovalidate,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
      child: TextFormField(
        autovalidateMode: autovalidate,
        enabled: enabled,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        cursorColor: kMainColor,
        onTap: onTap as void Function()?,
        autofocus: false,
        validator: validator,
        inputFormatters: inputFormatters,
        controller: controller,
        initialValue: initialValue,
        style: style != null ? style : Theme.of(context).textTheme.bodySmall,
        readOnly: readOnly ?? false,
        keyboardType: keyboardType,
        minLines: 1,
        maxLength: maxLength,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
        decoration: InputDecoration(
            prefix: prefix,
            suffixIcon: suffixIcon,
            labelText: label, /////////
            hintText: hint, //////////
            hintStyle: theme.textTheme.bodySmall!
                .copyWith(color: theme.hintColor), ////////
            border: border,
            //counter: Offstage(), /////////////
            icon: (icon != null)
                ? icon
                : (image != null)
                    ? ImageIcon(
                        AssetImage(image!),
                        color: imageColor ?? theme.primaryColor,
                        size: 20.0,
                      )
                    : null),
      ),
    );
  }
}
