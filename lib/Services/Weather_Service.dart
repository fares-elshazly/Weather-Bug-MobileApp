import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_bug/Models/Weather_Models/Weather_Model.dart';

class WeatherRepository {
  final String _apiURL = 'http://api.openweathermap.org/data/2.5/weather?q=';
  final String _contApiURL = '&units=metric&APPID=';
  final String _apiKey = '2f4d1957eef1406fb09c09e51dcdf8c0';

  Future<Weather> getWeather(String city) async {
    final response = await http
        .get('$_apiURL$city$_contApiURL$_apiKey')
        .timeout(Duration(seconds: 5));
    try {
      return Weather.fromJson(json.decode(response.body));
    } catch (_) {
      throw Exception();
    }
  }
}
