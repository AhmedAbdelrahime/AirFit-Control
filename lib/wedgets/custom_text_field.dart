import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.suffixIcon,
    required this.keyboardType,
    required this.obscureText,
    required this.controller,
    this.validator,
    required this.lable,
  }) : super(key: key);

  final Widget suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final String hintText;
  final String? validator;
  final String lable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: TextFormField(
            keyboardType: keyboardType,
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  const TextStyle(color: Colors.white54), // Hint text color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.blue.withOpacity(0.2),
              filled: true,
              prefixIcon: suffixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white), // Input text color
            validator: (value) {
              if (value!.isEmpty) {
                return validator;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class Coustemtextfeild extends StatelessWidget {
  const Coustemtextfeild(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.inputType,
      required this.controller});
  final String hintText;
  final IconData icon;
  final TextInputType inputType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.blue,
      controller: controller,
      style: const TextStyle(color: Colors.white), // Input text color

      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54), // Hint text color
        alignLabelWithHint: true,
        border: InputBorder.none,
        fillColor: Colors.blue.withOpacity(0.2),
        filled: true,
      ),
    );
  }
}
