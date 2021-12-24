// API Wilayah Indonesia oleh emsifa
// site: https://github.com/emsifa/api-wilayah-indonesia
// There should be attribution on the link but i cannot find them.

import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationApi
{
  static const baseUrl = 'http://www.emsifa.com/api-wilayah-indonesia/api/';

  LocationApi._();

  /// Lists all provinces in Indonesia by [client].
  static Future<List<ProvinceResponse>> getProvinces(http.Client client) async {
    const String uri = 'provinces.json';

    final response = await client.get(Uri.parse(baseUrl + uri));

    if (response.statusCode == 200) {
      final list = json.decode(response.body) as List;
      return list.map<ProvinceResponse>(
              (p) => ProvinceResponse.fromMap(p)
      ).toList();
    } else {
      throw response.statusCode;
    }
  }

  /// lists all regencies in Indonesia by [client] filtered by [provinceId]
  static Future<List<RegencyResponse>> getRegencies(http.Client client, int provinceId) async {
    const String uri = 'regencies/';

    final response = await client.get(Uri.parse(baseUrl + uri + provinceId.toString() + '.json'));

    if (response.statusCode == 200) {
      final list = json.decode(response.body) as List;
      return list.map<RegencyResponse>(
              (r) => RegencyResponse.fromMap(r)
      ).toList();
    } else {
      throw response.statusCode;
    }
  }

  /// List all districts in indonesia by [client] filtered by [regencyId]
  static Future<List<DistrictResponse>> getDistricts(http.Client client, int regencyId) async {
    const String uri = 'districts/';

    final response = await client.get(Uri.parse(baseUrl + uri + regencyId.toString() + '.json'));

    if (response.statusCode == 200) {
      final list = json.decode(response.body) as List;
      return list.map<DistrictResponse>(
          (d) => DistrictResponse.fromMap(d)
      ).toList();
    } else {
      throw response.statusCode;
    }
  }
}

class ProvinceResponse {
  final int id;
  final String name;

  ProvinceResponse({required this.id, required this.name});

  factory ProvinceResponse.fromMap(Map<String, dynamic> map) {
    return ProvinceResponse(
        id: int.parse(map['id']),
        name: map['name']
    );
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProvinceResponse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class RegencyResponse {
  final int id;
  final int provinceId;
  final String name;

  RegencyResponse({required this.id, required this.provinceId, required this.name});

  factory RegencyResponse.fromMap(Map<String, dynamic> map) {
    return RegencyResponse(
        id: int.parse(map['id']),
        provinceId: int.parse(map['province_id']),
        name: map['name'] as String
    );
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegencyResponse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          provinceId == other.provinceId &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ provinceId.hashCode ^ name.hashCode;
}

class DistrictResponse {
  final int id;
  final int regencyId;
  final String name;

  DistrictResponse({required this.id, required this.regencyId, required this.name});

  factory DistrictResponse.fromMap(Map<String, dynamic> map) {
    return DistrictResponse(
        id: int.parse(map['id']),
        regencyId: int.parse(map['regency_id']),
        name: map['name']
    );
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistrictResponse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          regencyId == other.regencyId &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ regencyId.hashCode ^ name.hashCode;
}