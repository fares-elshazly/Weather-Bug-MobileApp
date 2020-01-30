import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Screens/Pages_Viewer.dart';
import 'Screens/Splash_Screen.dart';
import 'Screens/Weather_Screen.dart';
import 'Blocs/Theme_Bloc/Bloc.dart';
import 'Utilities/Shared_Preference_Utilities.dart';

void main() => runApp(MyApp());

class MyAppData extends InheritedWidget {
  final sharedPreferenceUtilities;
  ThemeData theme;
  bool popUps;
  bool sound;

  MyAppData(
      {Key key,
      Widget child,
      this.sharedPreferenceUtilities,
      this.theme,
      this.popUps,
      this.sound})
      : super(key: key, child: child);

  static MyAppData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyAppData>();
  }

  @override
  bool updateShouldNotify(MyAppData oldWidget) {
    return true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyAppData(
      sharedPreferenceUtilities: SharedPreferenceUtilities(),
      theme: ThemeData(primaryColor: Colors.white),
      popUps: true,
      sound: true,
      child: MyAppWidget(),
    );
  }
}

class MyAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is InitialTheme) {
            loadTheme(context);
          } else if (state is NewTheme) {
            MyAppData.of(context).theme = state.theme;
            MyAppData.of(context)
                .sharedPreferenceUtilities
                .addThemeColor(MyAppData.of(context).theme.primaryColor);
          }
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: MyAppData.of(context).theme.primaryColor,
          ));
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather Bug',
            theme: MyAppData.of(context).theme,
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
    final intColor =
        await MyAppData.of(context).sharedPreferenceUtilities.getThemeColor();
    MyAppData.of(context).popUps = await MyAppData.of(context).sharedPreferenceUtilities.getSettings('popUps');
    MyAppData.of(context).sound = await MyAppData.of(context).sharedPreferenceUtilities.getSettings('sound');
    BlocProvider.of<ThemeBloc>(context).add(ChangeTheme(color: intColor));
  }
}
