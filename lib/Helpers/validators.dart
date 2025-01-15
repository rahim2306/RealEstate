// lib/utils/form_validators.dart

import 'package:flutter/material.dart';
import 'package:realestate/Components/showsnackbar.dart';

class FormValidators {
  static const emailPatternRules =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const passwordPatternRules =
      r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W)(?!.* ).{8,16}$";

  static String? validateNull(BuildContext context, String? value, field) {
    if (value == null || value.isEmpty) {
      CustomSnackbar.show(
        context: context,
        message: "$field is required",
      );
      return '';
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      CustomSnackbar.show(
        context: context,
        message: "Email is required",
      );
      return '';
    }
    if (!RegExp(emailPatternRules).hasMatch(value)) {
      CustomSnackbar.show(
        context: context,
        message: "Please enter a valid email address",
      );
      return '';
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      CustomSnackbar.show(
        context: context,
        message: "Password is required",
      );
      return '';
    }
    if (!RegExp(passwordPatternRules).hasMatch(value)) {
      CustomSnackbar.show(
        context: context,
        message: "Password must contain at least 8 characters, including uppercase, lowercase, number and special character",
      );
      return '';
    }
    return null;
  }

  static String? validatePhone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      CustomSnackbar.show(
        context: context,
        message: "Phone number is required",
      );
      return '';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      CustomSnackbar.show(
        context: context,
        message: "Please enter a valid 10-digit phone number",
      );
      return '';
    }
    return null;
  }

  static String? priceValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      CustomSnackbar.show(
        context: context,
        message: "Price is required",
      );
      return '';
    }

    String cleanValue = value.replaceAll(' ', '');
    
    int? price = int.tryParse(cleanValue);
    
    if (price == null) {
      CustomSnackbar.show(
        context: context,
        message: "Please enter a valid number",
      );
      return '';
    }

    if (price > 99999) {
      CustomSnackbar.show(
        context: context,
        message: "Price cannot exceed 99,999",
      );
      return '';
    }

    return null;
  }

}