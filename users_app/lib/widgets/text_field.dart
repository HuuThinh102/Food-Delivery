import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final IconData? data;
  final String? hint;
  final TextEditingController? controller;

  const MyTextField({
    super.key,
    this.data,
    this.hint,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Colors.black,
          ),
          hintText: hint,
        ),
        validator: (value) => value!.isEmpty ? 'Field can not be empty' : null,
      ),
    );
  }
}
