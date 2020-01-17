import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:recase/recase.dart';
import 'package:weather_bug/Blocs/Navbar_Bloc/Bloc.dart';
import 'package:weather_bug/Blocs/Weather_Bloc/Bloc.dart';
import 'package:weather_bug/Models/City_Model.dart';
import 'package:weather_bug/Models/WeatherScreenArgs_Model.dart';
import 'package:weather_bug/Screens/Search_Screen.dart';
import 'package:weather_bug/Services/Location_Service.dart';
import 'package:weather_bug/Utilities/Shared_Preference_Utilities.dart';
import 'Loading_Screen.dart';

class PagesControllerData extends InheritedWidget {
  final height;
  final width;
  final pageController;
  final sharedPreferenceUtilities;
  final earthIcon;
  final gearIcon;
  Color locationsColor;
  Color settingsColor;

  PagesControllerData(
      {Key key,
      Widget child,
      this.height,
      this.width,
      this.pageController,
      this.sharedPreferenceUtilities,
      this.earthIcon,
      this.gearIcon,
      this.locationsColor,
      this.settingsColor})
      : super(key: key, child: child);

  static PagesControllerData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PagesControllerData>();
  }

  @override
  bool updateShouldNotify(PagesControllerData oldWidget) {
    return true;
  }
}

class PagesController extends StatelessWidget {
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
      child: PagesControllerData(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        pageController: PageController(initialPage: 0),
        sharedPreferenceUtilities: SharedPreferenceUtilities(),
        earthIcon: IconData(0xf38c,
            fontFamily: CupertinoIcons.iconFont,
            fontPackage: CupertinoIcons.iconFontPackage),
        gearIcon: CupertinoIcons.gear,
        locationsColor: Theme.of(context).primaryColor,
        settingsColor: Colors.black87,
        child: PagesControllerWidget(),
      ),
    );
  }
}

class PagesControllerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocListener<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is LoadedWeatherState) {
            PagesControllerData.of(context).sharedPreferenceUtilities.addCity(
                City(
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
                controller: PagesControllerData.of(context).pageController,
                onPageChanged: (page) => BlocProvider.of<NavbarBloc>(context)
                    .add(Swipe(
                        locationsColor:
                            PagesControllerData.of(context).locationsColor,
                        settingsColor:
                            PagesControllerData.of(context).settingsColor)),
                children: <Widget>[
                  SearchScreen(),
                  Center(child: Text('Settings Page!'))
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
              PagesControllerData.of(context).locationsColor =
                  state.locationsColor;
              PagesControllerData.of(context).settingsColor =
                  state.settingsColor;
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
    height: PagesControllerData.of(context).height * 0.09,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(PagesControllerData.of(context).earthIcon,
                  size: 25,
                  color: PagesControllerData.of(context).locationsColor),
              Text('Locations',
                  style: TextStyle(
                      color: PagesControllerData.of(context).locationsColor)),
            ],
          ),
          onPressed: () =>
              PagesControllerData.of(context).pageController.jumpToPage(0),
        ),
        FlatButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(PagesControllerData.of(context).gearIcon,
                  size: 25,
                  color: PagesControllerData.of(context).settingsColor),
              Text('Settings',
                  style: TextStyle(
                      color: PagesControllerData.of(context).settingsColor)),
            ],
          ),
          onPressed: () =>
              PagesControllerData.of(context).pageController.jumpToPage(1),
        ),
      ],
    ),
  );
}

Widget buildFAB(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.my_location, color: Colors.white, size: 35),
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
