import 'package:flutter/material.dart';

class AuthPageTitle extends StatelessWidget {
  const AuthPageTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2F4B26),
      ),
      textAlign: TextAlign.center,
    );
  }
}
