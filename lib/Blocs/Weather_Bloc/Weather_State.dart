import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_bug/Models/Weather_Models/Weather_Model.dart';
import 'package:weather_bug/Models/Pexels_Models/Pexels_Model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class InitialWeatherState extends WeatherState {
  List<Object> get props => [];
}

class LoadingWeatherState extends WeatherState {
  List<Object> get props => null;
}

class LoadedWeatherState extends WeatherState {
  final Weather weather;
  final Pexels photos;
  LoadedWeatherState({@required this.weather, @required this.photos});
  List<Object> get props => [weather];
}

class ErrorWeatherState extends WeatherState {
  final String error;
  ErrorWeatherState({@required this.error});
  List<Object> get props => [error];
}
