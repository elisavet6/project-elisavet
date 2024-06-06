import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<String>> searchPlacename(String name) async {
    var headers = {
      'Cookie':
          'ak_bmsc=A908E84FA75923B4F9B573977E3F9C59~000000000000000000000000000000~YAAQXbV7XPd0ZbuPAQAATkWozhdSKaLpqnfe+quTpFUcuxeUG1FU0/OtyKftc0gxY/ByqPjLLxk72Z87pJy7hGaJsNRZjBqKSIsRzzayeAOLt0/F2oe2j8DsaC6ylF6Svz6riz05y0qGeokiE5IHqQw137K+s9cOjE9vMGdV3NMXZaCg/qzTdCyjPh2unJK3IcZnqNbtpFs7dL6wzIeH3YKAid+lPKWZucHKdBlBN4lsa/K8EG73jH4qH9Ygq0pDrpJq73lrE2XmyBY3DZvOznKnTfmgBYA6yYR0L2fMjziX46v+VImGWafHRuoYvvBACS9TebBhtZvifjepC6gEK5zQLGf8nuFGiabYJKFt+q09edED6zLQuDx6NRnFq9u7gg==; bm_sv=E90379285871B8D72DC6843C619FB332~YAAQXbV7XK16ZbuPAQAAq7qozhfcLkXiQjf5hALHYy0OSkNgOnNQS2XtTXFVTBx2on4iG5e+TJcmA6i76jvlttFj/KaHO9GwTGAPxKhYrMpX+nZIl815jCsxBYtlrrEWjWRTI6dArX+A9EiL+Lko3arHqAag/0ebW0njnepvUAnqAUc71z5xkZyjJ93iBhQCf4/gCec4epvoih7I0e//qY5lhso64q8y+2qEjY978tn/UFIsRJduPV0bweY6iM0O632umYDB~1; OSESSIONID=0000U-hcsFZ-USiJTw9s6Qi6jms:PRODOSE416A'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://localhost:3000/proxy?url=https://newtickets.hellenictrain.gr/Channels.Website.BFF.WEB/website/place/?name=$name'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();

      final data = jsonDecode(responseData) as List<dynamic>;
      List<String> places = data
          .map((place) => place['label'] as String?)
          .where((label) => label != null)
          .map((label) => label!)
          .toList();
      print('Parsed places: $places');
      return places;
    } else {
      throw Exception('Failed to search placename');
    }
  }
}
