import 'package:meta/meta.dart';
import 'Weather_Models/Weather_Model.dart';
import 'Pexels_Models/Pexels_Model.dart';

class WeatherScreenArgs {
  Weather weather;
  Pexels photos;

  WeatherScreenArgs({@required this.weather, @required this.photos});
}
