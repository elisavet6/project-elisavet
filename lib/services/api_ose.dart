import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iq_project/components/landing_page.dart';

class ApiService {
  final places = [];
  Home home = const Home();

  // Future<List<Map<String, String>>> searchPlacename(String name) async {
  //   var headers = {
  //     'Cookie':
  //         'ak_bmsc=A908E84FA75923B4F9B573977E3F9C59~000000000000000000000000000000~YAAQXbV7XPd0ZbuPAQAATkWozhdSKaLpqnfe+quTpFUcuxeUG1FU0/OtyKftc0gxY/ByqPjLLxk72Z87pJy7hGaJsNRZjBqKSIsRzzayeAOLt0/F2oe2j8DsaC6ylF6Svz6riz05y0qGeokiE5IHqQw137K+s9cOjE9vMGdV3NMXZaCg/qzTdCyjPh2unJK3IcZnqNbtpFs7dL6wzIeH3YKAid+lPKWZucHKdBlBN4lsa/K8EG73jH4qH9Ygq0pDrpJq73lrE2XmyBY3DZvOznKnTfmgBYA6yYR0L2fMjziX46v+VImGWafHRuoYvvBACS9TebBhtZvifjepC6gEK5zQLGf8nuFGiabYJKFt+q09edED6zLQuDx6NRnFq9u7gg==; bm_sv=E90379285871B8D72DC6843C619FB332~YAAQXbV7XK16ZbuPAQAAq7qozhfcLkXiQjf5hALHYy0OSkNgOnNQS2XtTXFVTBx2on4iG5e+TJcmA6i76jvlttFj/KaHO9GwTGAPxKhYrMpX+nZIl815jCsxBYtlrrEWjWRTI6dArX+A9EiL+Lko3arHqAag/0ebW0njnepvUAnqAUc71z5xkZyjJ93iBhQCf4/gCec4epvoih7I0e//qY5lhso64q8y+2qEjY978tn/UFIsRJduPV0bweY6iM0O632umYDB~1; OSESSIONID=0000U-hcsFZ-USiJTw9s6Qi6jms:PRODOSE416A'
  //   };
  //   var request = http.Request(
  //       'GET',
  //       Uri.parse(
  //           'http://localhost:3000/proxy?url=https://newtickets.hellenictrain.gr/Channels.Website.BFF.WEB/website/place/?name=$name'));
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     final responseData = await response.stream.bytesToString();
  //     final data = jsonDecode(responseData) as List<dynamic>;
  //
  //     List<Map<String, String>> places = data
  //         .map((place) => {
  //               'locationId': place['locationId'].toString(),
  //               'label': place['label'] as String
  //             })
  //         .toList();
  //
  //     print('Parsed places: $places');
  //     return places;
  //   } else {
  //     throw Exception('Failed to search placename');
  //   }
  // }

  Future<List<Map<String, String>>> searchPlacename(String name) async {
    var headers = {
      'Accept-Language': 'el-GR',
      "Access-Control-Allow-Origin": "*"
    };
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

//   Future<void> sendRequest(
//       int startCityId, int destCityId, DateTime selectedDate) async {
//     var headers = {
//       'Accept-Language': 'en-US',
//       'Content-Type': 'application/json',
//       'Cookie':
//           'ak_bmsc=E1BD585F914CF77C1CD7C1B54035D363~000000000000000000000000000000~YAAQbRdlXxd4vVKQAQAADRZQfRgTNJ+A3gZ1YZ9eYzMDjrbs4kF3EfR3UNgeZQpSLoQMXKzm55UGomgYhQyy/hM37v7BZR7804krNxiGUrNJuvviKq84enGD2XcM5euNIG8IrqY8lHhrJouiCZ+iJLeQ8Qvsmr6MEOCix5eksKg+tf/eRFGXv/FsAidvnDQ7piujWERDsd2mPUGlwrKIqLGoazr6TcQNvfPPtLfrgZ+chiN+msbiC+vyv2Xfgc35/Crm/A5pARbRFuThDsSrBwpzB7dVf+j5u9XYgD9yXNaAJLJ/+fW10eBJA4ij61wJPun0eSbkevdcP0qfooKdiS9fba9CE+79wUf16cud5q9sBVtMlHio7WtI74l425bBPA==; OSESSIONID=0000c33Zk_udC4t-gVS4Pt6ZqXy:PRODOSE414A'
//     };
//     // final url = Uri.parse(
//     //     'https://newtickets.hellenictrain.gr/Channels.Website.BFF.WEB/website/ticket/solutions');
// var request = http.Request('POST', Uri.parse('https://newtickets.hellenictrain.gr/Channels.Website.BFF.WEB/website/ticket/solutions'));
//     final body = jsonEncode({
//       "departureLocationId": startCityId,
//       "arrivalLocationId": destCityId,
//       "departureTime": selectedDate.toIso8601String(),
//       "adults": 1,
//       "children": 0,
//       "criteria": {
//         "freccieOnly": false,
//         "regionalOnly": false,
//         "noChanges": false,
//         "order": "DEPARTURE_DATE",
//         "offset": 0,
//         "limit": 10,
//       },
//       "advancedSearchRequest": {
//         "bestFare": false,
//         "fastPurchase": false,
//       }
//     });

//     final response = await http.post(url, headers: headers, body: body);
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//     print('${startCityId}');
//   }

  Future<void> sendRequest(
      int startCityId, int destCityId, DateTime selectedDate) async {
    var headers = {
      'Accept-Language': 'el-GR',
      'Content-Type': 'application/json'
    };

    var body = json.encode({
      "departureLocationId": startCityId,
      "arrivalLocationId": destCityId,
      "departureTime": selectedDate.toIso8601String(),
      "adults": 1,
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

    try {
      var response = await http.post(
        Uri.parse(
            'https://newtickets.hellenictrain.gr/Channels.Website.BFF.WEB/website/ticket/solutions'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }
}
