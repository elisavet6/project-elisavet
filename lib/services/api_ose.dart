import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'https://newtickets.hellenictrain.gr/Channels.Website.BFF.WEB/website';

  Future<List<String>> searchPlacename(String name) async {
    final url = Uri.parse('$baseUrl/place/?name=$name');
    final response = await http.get(
      url,
      headers: {'Accept-Language': 'en-EN'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      List<String> places = [];
      for (var place in data) {
        places.add(place['name']);
      }
      return places;
    } else {
      throw Exception('Failed to search placename');
    }
  }
}
