import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/model.dart';
import 'package:recase/recase.dart';
import 'package:weather_bug/Blocs/Weather_Bloc/Bloc.dart';
import 'package:weather_bug/Models/City_Model.dart';
import 'package:weather_bug/Models/WeatherScreenArgs_Model.dart';
import 'package:weather_bug/Screens/Loading_Screen.dart';
import 'package:weather_bug/Services/Location_Service.dart';
import 'package:weather_bug/Utilities/Shared_Preference_Utilities.dart';

class SearchScreenData extends InheritedWidget {
  final child;
  final height;
  final width;
  final pageController;
  final searchController;
  final earthIcon;
  final sharedPreferenceUtilities;
  final ValueNotifier<Color> locationsColor;
  final ValueNotifier<Color> settingsColor;
  SearchScreenData(
      {Key key,
      this.child,
      this.height,
      this.width,
      this.pageController,
      this.searchController,
      this.earthIcon,
      this.sharedPreferenceUtilities,
      this.locationsColor,
      this.settingsColor})
      : super(key: key, child: child);

  static SearchScreenData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SearchScreenData>();
  }

  @override
  bool updateShouldNotify(SearchScreenData oldWidget) {
    return true;
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => WeatherBloc(),
      child: SearchScreenData(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        pageController: PageController(initialPage: 0),
        searchController: TextEditingController(),
        earthIcon: IconData(0xf38c,
            fontFamily: CupertinoIcons.iconFont,
            fontPackage: CupertinoIcons.iconFontPackage),
        sharedPreferenceUtilities: SharedPreferenceUtilities(),
        locationsColor: ValueNotifier(Theme.of(context).primaryColor),
        settingsColor: ValueNotifier(Colors.black87),
        child: SearchScreenWidget(),
      ),
    );
  }

  @override
  void dispose() {
    BlocProvider.of<WeatherBloc>(context).close();
    super.dispose();
  }
}

class SearchScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocListener<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is LoadedWeatherState) {
            SearchScreenData.of(context).sharedPreferenceUtilities.addCity(City(
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
              return buildBody(context);
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: buildBottomAppBar(context),
      ),
      floatingActionButton: buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget buildBody(BuildContext context) {
  return PageView(
    controller: SearchScreenData.of(context).pageController,
    onPageChanged: (page) {
      final tmp = SearchScreenData.of(context).locationsColor.value;
      SearchScreenData.of(context).locationsColor.value =
          SearchScreenData.of(context).settingsColor.value;
      SearchScreenData.of(context).settingsColor.value = tmp;
    },
    children: <Widget>[
      buildLocationsPage(context),
      Center(child: Text('Settings Page!'))
    ],
  );
}

Widget buildLocationsPage(BuildContext context) {
  return Center(
    child: Container(
      width: SearchScreenData.of(context).width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: SearchScreenData.of(context).height * 0.04),
          buildTitle(context, 'Locations'),
          SizedBox(height: SearchScreenData.of(context).height * 0.04),
          buildRoundedTextField(context, 'Search', Icons.search),
          SizedBox(height: SearchScreenData.of(context).height * 0.04),
          Expanded(
            child: buildListView(context, 'Recently Searched'),
          ),
        ],
      ),
    ),
  );
}

Widget buildTitle(BuildContext context, String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(title, style: TextStyle(fontSize: 25, fontFamily: 'AvenirDemi')),
      Divider(
        color: Color.fromARGB(255, 255, 160, 14),
        thickness: 5,
        indent: 2,
        endIndent: SearchScreenData.of(context).width * 0.8,
      )
    ],
  );
}

Widget buildRoundedTextField(
    BuildContext context, String hint, IconData preIcon) {
  return Container(
    height: 55,
    child: TextField(
      controller: SearchScreenData.of(context).searchController,
      decoration: InputDecoration(
          border: InputBorder.none, prefixIcon: Icon(preIcon), labelText: hint),
      onSubmitted: (text) async {
        if (text.isNotEmpty) {
          BlocProvider.of<WeatherBloc>(context).add(GetWeather(cityName: text));
        }
      },
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        color: Colors.white),
  );
}

Widget buildListView(BuildContext context, String title) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(title,
          style: TextStyle(
              fontSize: 13, fontFamily: 'AvenirRegular', color: Colors.grey)),
      FutureBuilder(
        initialData: List<City>(),
        future:
            SearchScreenData.of(context).sharedPreferenceUtilities.getCities(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                      height: SearchScreenData.of(context).height * 0.15,
                      margin: index == snapshot.data.length - 1
                          ? EdgeInsets.only(
                              top: 8,
                              bottom:
                                  SearchScreenData.of(context).height * 0.15)
                          : EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  snapshot.data[index].imageURL),
                              fit: BoxFit.cover)),
                      child: Center(
                          child: Text(
                        snapshot.data[index].name,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'AvenirMed',
                            fontSize: 18),
                      ))),
                  onTap: () => BlocProvider.of<WeatherBloc>(context)
                      .add(GetWeather(cityName: snapshot.data[index].name)),
                );
              },
            ),
          );
        },
      ),
    ],
  );
}

Widget buildBottomAppBar(BuildContext context) {
  return Container(
    height: SearchScreenData.of(context).height * 0.09,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          child: ValueListenableBuilder(
            valueListenable: SearchScreenData.of(context).locationsColor,
            builder: (BuildContext context, dynamic value, Widget child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(SearchScreenData.of(context).earthIcon,
                      size: 25, color: value),
                  Text('Locations', style: TextStyle(color: value)),
                ],
              );
            },
          ),
          onPressed: () =>
              SearchScreenData.of(context).pageController.jumpToPage(0),
        ),
        FlatButton(
          child: ValueListenableBuilder(
            valueListenable: SearchScreenData.of(context).settingsColor,
            builder: (BuildContext context, dynamic value, Widget child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(CupertinoIcons.gear, size: 25, color: value),
                  Text('Settings', style: TextStyle(color: value)),
                ],
              );
            },
          ),
          onPressed: () =>
              SearchScreenData.of(context).pageController.jumpToPage(1),
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
