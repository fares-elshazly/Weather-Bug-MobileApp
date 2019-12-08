import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeather extends WeatherEvent{
  final city;
  GetWeather({@required this.city});
  List<Object> get props => [city];
}
