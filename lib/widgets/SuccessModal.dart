import 'package:flutter/material.dart';

class SuccessModal extends StatelessWidget {
  final String message;

  SuccessModal({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Success'),
      content: Text(message),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  static void showSuccessModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SuccessModal(message: message),
    );
  }
}