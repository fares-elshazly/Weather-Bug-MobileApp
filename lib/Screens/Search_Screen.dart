import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:weather_bug/Blocs/Weather_Bloc/Bloc.dart';
import 'package:weather_bug/Screens/Loading_Screen.dart';

class SearchScreenData extends InheritedWidget {
  final child;
  final height;
  final width;
  final pageController;
  final searchController;
  final earthIcon;
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
      this.locationsColor,
      this.settingsColor})
      : super(key: key, child: child);

  static SearchScreenData of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SearchScreenData)
        as SearchScreenData);
  }

  @override
  bool updateShouldNotify(SearchScreenData oldWidget) {
    return true;
  }
}

class SearchScreen extends StatelessWidget {
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
        locationsColor: ValueNotifier(Colors.orange),
        settingsColor: ValueNotifier(Colors.black87),
        child: SearchScreenWidget(),
      ),
    );
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
            Navigator.pushNamed(context, '/ShowWeather', arguments: state.weather);
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
      floatingActionButton: buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget buildBody(BuildContext context) {
  return PageView(
    controller: SearchScreenData.of(context).pageController,
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
            child: buildListView('Recently Searched', [
              'Alexandria',
              'Miami',
              'Las Vegas',
              'Alexandria',
              'Miami',
              'Las Vegas',
              'Alexandria',
              'Miami',
              'Las Vegas'
            ]),
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
  final weatherBloc = BlocProvider.of<WeatherBloc>(context);
  return Container(
    height: 55,
    child: TextField(
      controller: SearchScreenData.of(context).searchController,
      decoration: InputDecoration(
          border: InputBorder.none, prefixIcon: Icon(preIcon), labelText: hint),
      onSubmitted: (v) {
        if (v.isNotEmpty) {
          weatherBloc.add(GetWeather(city: v));
          print('Searching For $v ...');
        }
      },
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        color: Colors.white),
  );
}

Widget buildListView(String title, List<String> places) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(title,
          style: TextStyle(
              fontSize: 13, fontFamily: 'AvenirRegular', color: Colors.grey)),
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: places.length,
          itemBuilder: (context, index) {
            return Container(
                height: 100,
                margin: EdgeInsets.only(top: 8, bottom: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://cdn.vox-cdn.com/thumbor/Z7C9NrmCrdHZ0p6JaxsjCBCFTtg=/0x0:3840x5760/1200x675/filters:focal(1613x2573:2227x3187)/cdn.vox-cdn.com/uploads/chorus_image/image/56185263/muzammil_soorma_797975_unsplash.6.jpg'),
                        fit: BoxFit.fill)),
                child: Center(
                    child: Text(
                  places[index],
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'AvenirMed',
                      fontSize: 18),
                )));
          },
        ),
      ),
    ],
  );
}

Widget buildBottomAppBar(BuildContext context) {
  return Container(
    height: SearchScreenData.of(context).height * 0.1,
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
          onPressed: () {
            SearchScreenData.of(context).locationsColor.value = Colors.orange;
            SearchScreenData.of(context).settingsColor.value = Colors.black87;
            SearchScreenData.of(context).pageController.jumpToPage(0);
          },
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
          onPressed: () {
            SearchScreenData.of(context).locationsColor.value = Colors.black87;
            SearchScreenData.of(context).settingsColor.value = Colors.orange;
            SearchScreenData.of(context).pageController.jumpToPage(1);
          },
        ),
      ],
    ),
  );
}

Widget buildFAB() {
  return FloatingActionButton(
    child: Icon(Icons.my_location, color: Colors.white, size: 35),
    tooltip: 'Get My Location',
    onPressed: () {},
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
