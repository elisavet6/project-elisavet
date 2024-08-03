import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iq_project/components/landing_page.dart';

class ApiService {
  final places = [];
  Home home = Home();

  Future<List<Map<String, String>>> searchPlacename(String name) async {
    var headers = {'Accept-Language': 'el-GR'};
    var paramName = Uri.encodeFull(name);
    var url = Uri.parse(
        'https://newtickets.hellenictrain.gr/Channels.Website.BFF.WEB/website/place/?name=$paramName');

    http.Response? response;
    try {
      response = await http.get(url, headers: headers);
    } catch (ex) {
      print(ex.toString());
    }
    if (response == null) {
      throw Exception('Failed to search placename');
    }
    if (response.statusCode == 200) {
      final responseText = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseText) as List<dynamic>;

      List<Map<String, String>> places = data
          .map((place) => {
                'locationId': place['locationId'].toString(),
                'label': place['label'] as String
              })
          .toList();

      print('Parsed places: $places');
      return places;
    } else {
      throw Exception('Failed to search placename');
    }
  }

  Future<String?> sendRequest(int startCityId, int destCityId,
      DateTime selectedDate, int adults) async {
    var headers = {
      'Accept-Language': 'en-US',
      'Content-Type': 'application/json; charset=UTF-8'
    };

    var body = json.encode({
      "departureLocationId": startCityId,
      "arrivalLocationId": destCityId,
      "departureTime": selectedDate.toIso8601String(),
      "adults": adults,
      "children": 0,
      "criteria": {
        "frecceOnly": false,
        "regionalOnly": false,
        "noChanges": false,
        "order": "DEPARTURE_DATE",
        "offset": 0,
        "limit": 10
      },
      "advancedSearchRequest": {"bestFare": false, "fastPurchase": false}
    });

    print('Request Body: $body'); // Print the request body for debugging

    try {
      var response = await http.post(
        Uri.parse(
            'https://newtickets.hellenictrain.gr/Channels.Website.BFF.WEB/website/ticket/solutions'),
        headers: headers,
        body: body,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        var decodedResponse = utf8.decode(response.bodyBytes);
        print('Response Body: $decodedResponse');
        return decodedResponse;
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        return null; // Return null to indicate failure
      }
    } catch (e) {
      print('Request failed: $e');
      return null; // Return null to indicate failure
    }
  }
}
