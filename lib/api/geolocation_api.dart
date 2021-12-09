// geonames.org

import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, double>> getLatLngFromDistrict(http.Client client, String district) async {
  const url = 'http://api.geonames.org/';
  const path = 'searchJSON';
  String name = !district.startsWith('Kecamatan')
      ? 'Kecamatan ' + district
      : district;

  final Map<String, String> params = {
    'name' : name,
    'country': 'id',
    'username': 'csd168_mapapi'
  };
  final uri = Uri.http(url, path, params);

  final response = await client.get(uri);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return {
      'lng' : double.parse(json['lng']),
      'lat' : double.parse(json['lat'])
    };
  } else {
    throw response.statusCode;
  }
}