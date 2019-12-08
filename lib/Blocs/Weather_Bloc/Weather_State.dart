import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_bug/Models/Weather_Models/Weather_Model.dart';

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
  LoadedWeatherState({@required this.weather});
  List<Object> get props => [weather];
}

class ErrorWeatherState extends WeatherState {
  final String error;
  ErrorWeatherState({@required this.error});
  List<Object> get props => [error];
}
