import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../../../core/globals.dart';

class CustomSnackBar {
  static void showSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
  }) {
    try {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Container(
            height: 58,
            alignment: Alignment.center, // Центрируем содержимое
            child: Text(
              message,
              textAlign: TextAlign.center, // Центрируем текст
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 1.2,
                letterSpacing: 0.25,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          dismissDirection: DismissDirection.down,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
          animation: null,
        ),
      );
    } catch (e) {
      developer.log('Ошибка при показе SnackBar: $e');
    }
  }

  static void error(BuildContext context, String message) {
    showSnackBar(
      context,
      message: message,
      backgroundColor: const Color(0xFFAEAAAB),
    );
  }

  static void success(BuildContext context, String message) {
    showSnackBar(
      context,
      message: message,
      backgroundColor: const Color(0xFF5CBCE5),
    );
  }
}
