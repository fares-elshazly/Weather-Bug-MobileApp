import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoder/geocoder.dart';
import 'package:recase/recase.dart';
import '../main.dart';
import 'Search_Screen.dart';
import 'Settings_Screen.dart';
import 'Loading_Screen.dart';
import '../Blocs/Navbar_Bloc/Bloc.dart';
import '../Blocs/Weather_Bloc/Bloc.dart';
import '../Services/Location_Service.dart';
import '../Models/City_Model.dart';
import '../Models/WeatherScreenArgs_Model.dart';

class PagesViewerData extends InheritedWidget {
  final height;
  final width;
  final pageController;
  final earthIcon;
  final gearIcon;
  Color locationsColor;
  Color settingsColor;

  PagesViewerData(
      {Key key,
      Widget child,
      this.height,
      this.width,
      this.pageController,
      this.earthIcon,
      this.gearIcon,
      this.locationsColor,
      this.settingsColor})
      : super(key: key, child: child);

  static PagesViewerData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PagesViewerData>();
  }

  @override
  bool updateShouldNotify(PagesViewerData oldWidget) {
    return true;
  }
}

class PagesViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherBloc>(
          create: (BuildContext context) => WeatherBloc(),
        ),
        BlocProvider<NavbarBloc>(
          create: (BuildContext context) => NavbarBloc(),
        ),
      ],
      child: PagesViewerData(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        pageController: PageController(initialPage: 0),
        earthIcon: IconData(0xf38c,
            fontFamily: CupertinoIcons.iconFont,
            fontPackage: CupertinoIcons.iconFontPackage),
        gearIcon: CupertinoIcons.gear,
        locationsColor: Theme.of(context).primaryColor,
        settingsColor: Colors.black87,
        child: PagesViewerWidget(),
      ),
    );
  }
}

class PagesViewerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocListener<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is LoadedWeatherState) {
            MyAppData.of(context).sharedPreferenceUtilities.addCity(City(
                name: state.weather.name,
                imageURL: state.photos.photos[0].src.original));
            Navigator.pushNamed(context, '/ShowWeather',
                arguments: WeatherScreenArgs(
                    weather: state.weather, photos: state.photos));
          } else if (state is ErrorWeatherState) {
            buildFlushBar(context, state.error);
          }
        },
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is LoadingWeatherState) {
              return LoadingScreen();
            } else {
              return PageView(
                controller: PagesViewerData.of(context).pageController,
                onPageChanged: (page) => BlocProvider.of<NavbarBloc>(context)
                    .add(Swipe(
                        locationsColor:
                            PagesViewerData.of(context).locationsColor,
                        settingsColor:
                            PagesViewerData.of(context).settingsColor)),
                children: <Widget>[
                  SearchScreen(),
                  SettingsScreen(),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: BlocBuilder<NavbarBloc, NavbarState>(
          builder: (context, state) {
            if (state is SwapColors) {
              PagesViewerData.of(context).locationsColor = state.locationsColor;
              PagesViewerData.of(context).settingsColor = state.settingsColor;
              if (state.locationsColor != Theme.of(context).primaryColor &&
                  state.settingsColor != Theme.of(context).primaryColor) {
                PagesViewerData.of(context).locationsColor = Colors.black87;
                PagesViewerData.of(context).settingsColor =
                    Theme.of(context).primaryColor;
              }
            }
            return buildBottomAppBar(context);
          },
        ),
      ),
      floatingActionButton: buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget buildBottomAppBar(BuildContext context) {
  return Container(
    height: PagesViewerData.of(context).height * 0.09,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(PagesViewerData.of(context).earthIcon,
                  size: 25, color: PagesViewerData.of(context).locationsColor),
              Text('Locations',
                  style: TextStyle(
                      color: PagesViewerData.of(context).locationsColor)),
            ],
          ),
          onPressed: () =>
              PagesViewerData.of(context).pageController.jumpToPage(0),
        ),
        FlatButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(PagesViewerData.of(context).gearIcon,
                  size: 25, color: PagesViewerData.of(context).settingsColor),
              Text('Settings',
                  style: TextStyle(
                      color: PagesViewerData.of(context).settingsColor)),
            ],
          ),
          onPressed: () =>
              PagesViewerData.of(context).pageController.jumpToPage(1),
        ),
      ],
    ),
  );
}

Widget buildFAB(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.my_location, color: Colors.white, size: 35),
    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
    tooltip: 'Get My Location',
    onPressed: () async {
      Address address = await LocationRepository.getLocation();
      String city = LocationRepository.getCityName(address);
      BlocProvider.of<WeatherBloc>(context).add(GetWeather(cityName: city));
    },
  );
}

Widget buildFlushBar(BuildContext context, String message) {
  Flushbar flush;
  flush = Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    title: 'Sorry!',
    message: ReCase(message).titleCase,
    backgroundColor: Colors.red[700],
    duration: Duration(seconds: 3),
    isDismissible: true,
    mainButton: FlatButton(
      child: Icon(CupertinoIcons.clear_thick, color: Colors.white),
      onPressed: () => flush.dismiss(),
    ),
  )..show(context);
  return flush;
}
