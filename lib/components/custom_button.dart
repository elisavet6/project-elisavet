import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  CustomButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;

  void _handlePress() {
    setState(() {
      isPressed = !isPressed;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _handlePress,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.orange.shade600, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        backgroundColor:
            isPressed ? Colors.orange.shade600 : Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon,
              color: isPressed ? Colors.white : Colors.orange.shade600),
          SizedBox(width: 8), // Space between icon and text
          Text(
            widget.text,
            style: TextStyle(
              color: isPressed ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
