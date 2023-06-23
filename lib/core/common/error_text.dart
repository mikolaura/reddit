import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String err;
  const ErrorText({super.key, required this.err});
  
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(err),
    );
  }
}