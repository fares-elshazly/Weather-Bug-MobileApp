import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeather extends WeatherEvent{
  final String cityName;
  GetWeather({@required this.cityName});
  @override
  List<Object> get props => [cityName];
}
