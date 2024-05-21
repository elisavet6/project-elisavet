import 'package:flutter/material.dart';

class EditableTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onSaved;

  const EditableTextField({
    required this.label,
    required this.initialValue,
    required this.onSaved,
  });

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (!_isEditing) {
      widget.onSaved(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      subtitle: _isEditing
          ? TextField(
              controller: _controller,
              autofocus: true,
              onSubmitted: (_) => _toggleEditing(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            )
          : Text(widget.initialValue),
      trailing: IconButton(
        icon: Icon(_isEditing ? Icons.check : Icons.edit),
        onPressed: _toggleEditing,
      ),
    );
  }
}
