import 'package:flutter/material.dart';

class TextFieldCalculator extends StatelessWidget {
  final TextEditingController textController;
  final String textLabel;
  final Function(String)? onChanged;

  const TextFieldCalculator(
      {super.key,
      required this.textLabel,
      required this.textController,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return (TextField(
      controller: textController,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 119, 0),
          ),
        ),
        label: Text(
          textLabel,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ));
  }
}
