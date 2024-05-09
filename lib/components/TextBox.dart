import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String sectionName;
  final String text;
  final void Function()? onPressed;

  const MyTextBox(
      {super.key,
      required this.sectionName,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.orange, // Color of the underline
            width: 1.0, // Thickness of the underline
          ),
        ),
      ),
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              sectionName,
              style: TextStyle(color: Colors.grey.shade500),
            ),
            IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey.shade700,
                ))
          ],
        ),
        Text(text),
      ]),
    );
  }
}
