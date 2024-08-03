import 'dart:convert';

import 'package:http/http.dart' as http;

class Ferryhopper {
  final ports = [];
  Future<List<Map<String, String>>> searchPorts(String name) async {
    var headers = {'x-api-key': 'stage-mock'};

    var request = http.Request('GET',
        Uri.parse('https://ferryhapi.uat.ferryhopper.com/ports?language=en'));

    request.headers.addAll(headers);
    http.Response? response;

    try {
      response = await http.get(request as Uri, headers: headers);
    } catch (ex) {
      print(ex.toString());
    }
    if (response == null) {
      throw Exception('Failed to search port');
    }

    if (response.statusCode == 200) {
      final responseText = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseText) as List<dynamic>;

      List<Map<String, String>> ports = data
          .map((port) =>
              {'code': port['code'].toString(), 'name': port['name'] as String})
          .toList();

      print('Parsed places: $ports');
      return ports;
    } else {
      throw Exception('Failed to search ports');
    }
  }
}
