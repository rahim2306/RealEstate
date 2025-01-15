// lib/Components/custom_snackbar.dart

import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = const Color(0xff005082),
    EdgeInsets margin = const EdgeInsets.all(20),
    String actionLabel = 'Ok',
    Color actionTextColor = Colors.yellow,
    VoidCallback? onActionPressed,
    VoidCallback? onVisible,
    Duration duration = const Duration(seconds: 4),
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: margin,
      duration: duration,
      action: SnackBarAction(
        label: actionLabel,
        disabledTextColor: Colors.white,
        textColor: actionTextColor,
        onPressed: onActionPressed ?? () {},
      ),
      onVisible: onVisible,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      actionTextColor: Colors.white,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      actionTextColor: Colors.white,
    );
  }


  static void showInfo({
    required BuildContext context,
    required String message,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: const Color(0xff005082),
      actionTextColor: Colors.yellow,
    );
  }
}