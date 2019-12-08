import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:weather_bug/Services/Weather_Service.dart';
import './bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepository weatherService = WeatherRepository();

  @override
  WeatherState get initialState => InitialWeatherState();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeather) {
      yield LoadingWeatherState();
      try {
        final weather = await weatherService.getWeather(event.city);
        yield LoadedWeatherState(weather: weather);
      } on TimeoutException catch (_) {
        yield ErrorWeatherState(error: 'Please Check Your Internet Connection!');
      } catch (_) {
        yield ErrorWeatherState(error: 'City Not Found!');
      }
    }
  }
}
