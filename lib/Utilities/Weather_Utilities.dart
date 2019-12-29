import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherUtilities {
  static IconData getWeatherIcon(String weatherCondition, String dayOrNight) {
    switch (weatherCondition) {
      case 'Thunderstorm':
        return dayOrNight == 'd'
            ? WeatherIcons.day_thunderstorm
            : WeatherIcons.night_alt_thunderstorm;
        break;
      case 'Drizzle':
        return dayOrNight == 'd'
            ? WeatherIcons.day_sprinkle
            : WeatherIcons.night_alt_sprinkle;
        break;
      case 'Rain':
        return dayOrNight == 'd'
            ? WeatherIcons.day_rain
            : WeatherIcons.night_alt_rain;
        break;
      case 'Snow':
        return dayOrNight == 'd'
            ? WeatherIcons.day_snow
            : WeatherIcons.night_alt_snow;
        break;
      case 'Clear':
        return dayOrNight == 'd'
            ? WeatherIcons.day_sunny
            : WeatherIcons.night_clear;
        break;
      case 'Clouds':
        return dayOrNight == 'd'
            ? WeatherIcons.day_cloudy
            : WeatherIcons.night_alt_cloudy;
        break;
      case 'Squall':
        return dayOrNight == 'd'
            ? WeatherIcons.day_storm_showers
            : WeatherIcons.night_alt_storm_showers;
        break;
      case 'Mist':
      case 'Fog':
        return dayOrNight == 'd'
            ? WeatherIcons.day_fog
            : WeatherIcons.night_fog;
        break;
      case 'Smoke':
        return WeatherIcons.smoke;
        break;
      case 'Haze':
        return WeatherIcons.day_haze;
        break;
      case 'Dust':
        return WeatherIcons.dust;
        break;
      case 'Sand':
        return WeatherIcons.sandstorm;
        break;
      case 'Ash':
        return WeatherIcons.volcano;
        break;
      case 'Tornado':
        return WeatherIcons.tornado;
        break;
      default:
        return WeatherIcons.cloud_refresh;
    }
  }
}
