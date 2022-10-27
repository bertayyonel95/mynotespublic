import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<String?> textInsertDialog<String>({
  required BuildContext context,
  required String title,
  required String previousText,
  required DialogOptionBuilder optionBuilder,
  required TextEditingController textEditingController,
}) {
  final options = optionBuilder();
  return showDialog<String>(
    context: context,
    builder: (context) {
      textEditingController.text = previousText.toString();
      return AlertDialog(
        title: const Text('Tags'),
        content: TextField(
          controller: textEditingController,
        ),
        actions: options.keys.map((optionTitle) {
          return TextButton(
            onPressed: <String>() {
              Navigator.of(context).pop(textEditingController.text);
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
