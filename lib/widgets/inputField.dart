import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final String labelText;
  final ValueChanged<String> onValueChange;
  final TextInputType? keyboardType;
  final bool? obscureText;

  const InputField({
    Key? key,
    required this.labelText,
    required this.onValueChange,
    this.keyboardType,
    this.obscureText = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      onChanged: onValueChange,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 20,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }
}