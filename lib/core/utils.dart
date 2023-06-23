import 'package:flutter/material.dart';

void showSnakcBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}
