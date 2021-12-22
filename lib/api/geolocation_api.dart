// geonames.org

import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> getLatLngFromDistrict(String district) async {
    const url = 'api.geonames.org';
    const path = '/searchJSON';
    String name =
        !district.startsWith('Kecamatan') ? 'Kecamatan ' + district : district;

    final Map<String, String> params = {
      'name': name,
      'country': 'id',
      'username': 'csd168_mapapi'
    };
    final uri = Uri.http(url, path, params);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final totalResult = json['totalResultsCount'] as int;

      if (totalResult > 0) {
        final geonames = json['geonames'] as List<dynamic>;
        final geonames1 = geonames[0] as Map; // pick the first result

        return {
          'lng': double.parse(geonames1['lng']),
          'lat': double.parse(geonames1['lat'])
        };
      } else {
        return 'Sorry, but this location is not available yet on our map';
      }
    } else {
      throw response.statusCode;
    }
  }
}
