import 'dart:convert';
import 'package:weather_bug/Models/City_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtilities {
  SharedPreferences _sharedPreferences;
  List<City> cities;
  List jsonData;

  void addCity(City city) async {
    cities = List<City>();
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.containsKey('Cities')) {
      jsonData = json.decode(_sharedPreferences.getString('Cities'));
      cities = jsonData.map((city) => City.fromJson(city)).toList();
    }
    if(cities.length == 0)
      cities.add(city);
    else if(cities.elementAt(0) != city)
      cities.insert(0, city);
    if(cities.length == 6)
      cities.removeLast();
    jsonData = cities.map((city) => city.toJson()).toList();
    _sharedPreferences.setString('Cities', json.encode(jsonData));
  }

  Future<List<City>> getCities() async {
    cities = List<City>();
    _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.containsKey('Cities')) {
      jsonData = json.decode(_sharedPreferences.getString('Cities'));
      cities = jsonData.map((city) => City.fromJson(city)).toList();
    }
    return cities;
  }

  void clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }
}
