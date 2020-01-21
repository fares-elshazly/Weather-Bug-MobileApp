import 'dart:async';

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bug/Blocs/Theme_Bloc/Bloc.dart';
import 'package:weather_bug/Screens/Loading_Screen.dart';
import 'package:weather_bug/Screens/Pages_Viewer.dart';
import 'package:weather_bug/Screens/Splash_Screen.dart';
import 'package:weather_bug/Utilities/Conversion_Utilities.dart';
import 'package:weather_bug/Utilities/Shared_Preference_Utilities.dart';
import 'Screens/Weather_Screen.dart';

// void main() => runApp(
//   DevicePreview(
//     builder: (context) => MyApp(),
//   ),
// );

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final sharedPreference = SharedPreferenceUtilities();
  ThemeData theme = ThemeData(primaryColor: Colors.white);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is InitialTheme) {
            loadTheme(context);
          } else if (state is NewTheme) {
            theme = state.theme;
            sharedPreference.addThemeColor(theme.primaryColor);
          }
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: theme.primaryColor,
          ));
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather Bug',
            theme: theme,
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/PagesViewer': (context) => PagesViewer(),
              '/ShowWeather': (context) => WeatherScreen(),
            },
          );
        },
      ),
    );
  }

  loadTheme(BuildContext context) async {
    final intColor = await sharedPreference.getThemeColor();
    BlocProvider.of<ThemeBloc>(context).add(ChangeTheme(color: intColor));
  }
}
