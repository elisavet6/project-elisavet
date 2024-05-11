import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AutocompleteTextField(),
    );
  }
}

class AutocompleteTextField extends StatefulWidget {
  @override
  _AutocompleteTextFieldState createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
  TextEditingController _textEditingController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> _key = GlobalKey();
  List<String> _countries = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries('');
  }

  void _fetchCountries(String query) async {
    final response = await http.get(
        Uri.parse('https://restcountries.com/v3.1/name/$query?fullText=true'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> countries = data
          .map<String>((country) => country['name']['common'] as String)
          .toList();
      setState(() {
        _countries = countries;
      });
    } else {
      throw Exception('Failed to fetch countries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autocomplete TextField'),
      ),
      body: Column(
        children: [
          SimpleAutoCompleteTextField(
            key: _key,
            controller: _textEditingController,
            suggestions: _countries,
            textChanged: (value) {
              _fetchCountries(value);
            },
            textSubmitted: (value) {
              print('Submitted: $value');
            },
            decoration: InputDecoration(
              labelText: 'Country',
              hintText: 'Type to search',
            ),
          ),
        ],
      ),
    );
  }
}
