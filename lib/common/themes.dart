import 'package:flutter/material.dart';

import 'colors.dart';

class AppThemes{
  static InputDecoration textFieldInputDecoration({IconData? iconData, String? labelText, String? hintText, String? errorText}){
    InputDecoration decoration = InputDecoration(
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.blue),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.blueLight),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      hintText: hintText,
      // helperText: errorText,
      errorText: errorText,
      labelText: labelText,
      prefixText: '',
      suffixText: '',
      suffixStyle: const TextStyle(color: AppColors.red),
    );
    return decoration;
  }

  static InputDecoration textFieldInputDecorationChat({IconData? iconData, String? labelText, String? hintText, String? errorText}){
    InputDecoration decoration = InputDecoration(
      fillColor: AppColors.grayLight,
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      // helperText: errorText,
      errorText: errorText,
      labelText: labelText,
      prefixText: '',
      suffixText: '',
      suffixStyle: const TextStyle(color: AppColors.red),
    );
    return decoration;
  }
}