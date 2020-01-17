import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:weather_bug/Services/City_Service.dart';
import 'package:weather_bug/Services/Weather_Service.dart';
import './Bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepository weatherService = WeatherRepository();
  CityRepository photoService = CityRepository();

  @override
  WeatherState get initialState => InitialWeatherState();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeather) {
      yield LoadingWeatherState();
      try {
        final weather = await weatherService.getWeather(event.cityName);
        final photos = await photoService.getPhotos(event.cityName);
        yield LoadedWeatherState(weather: weather, photos: photos);
      } on TimeoutException catch (_) {
        yield ErrorWeatherState(error: 'Please Check Your Internet Connection!');
      } catch (_) {
        yield ErrorWeatherState(error: 'City Not Found!');
      }
    }
  }
}
