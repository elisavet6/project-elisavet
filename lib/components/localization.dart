import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocalizationCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      dropdownColor: Colors.grey.shade400,
      focusColor: Colors.orange,
      value: context.locale,
      icon: Icon(
        Icons.language,
        color: Colors.white,
      ),
      onChanged: (Locale? locale) {
        if (locale != null) {
          context.setLocale(locale);
        }
      },
      items: [
        DropdownMenuItem(
          value: Locale('en', 'US'),
          child: Text(
            'EN',
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: Locale('el', 'GR'),
          child: Text(
            'GR',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
