import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_bug/Models/Pexels_Models/Pexels_Model.dart';

class CityRepository {
  final String _apiURL = 'https://api.pexels.com/v1/search?query=';
  final String _apiKey =
      '563492ad6f917000010000011ad997d281e7483bb05ff9ea8ab41005';

  Future<Pexels> getPhotos(String city) async {
    final response = await http.get(
      '$_apiURL$city',
      headers: {HttpHeaders.authorizationHeader: '$_apiKey'},
    ).timeout(Duration(seconds: 5));
    try {
      return Pexels.fromJson(json.decode(response.body));
    } catch (_) {
      throw Exception();
    }
  }
}
