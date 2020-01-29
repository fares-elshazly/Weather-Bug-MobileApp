import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Screens/Pages_Viewer.dart';
import 'Screens/Splash_Screen.dart';
import 'Screens/Weather_Screen.dart';
import 'Blocs/Theme_Bloc/Bloc.dart';
import 'Utilities/Shared_Preference_Utilities.dart';

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
