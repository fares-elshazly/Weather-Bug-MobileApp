import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import 'package:weather_bug/Models/Weather_Models/Weather_Model.dart';
import 'package:weather_bug/Utilities/Weather_Utilities.dart';

class WeatherScreenData extends InheritedWidget {
  final Weather weather;
  final date;
  final time;
  final child;
  final height;
  final width;
  final backArrowIcon;
  WeatherScreenData(
      {Key key,
      this.weather,
      this.date,
      this.time,
      this.child,
      this.height,
      this.width,
      this.backArrowIcon})
      : super(key: key, child: child);

  static WeatherScreenData of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(WeatherScreenData)
        as WeatherScreenData);
  }

  @override
  bool updateShouldNotify(WeatherScreenData oldWidget) {
    return true;
  }
}

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WeatherScreenData(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      backArrowIcon: IconData(0xf3d5,
          fontFamily: CupertinoIcons.iconFont,
          fontPackage: CupertinoIcons.iconFontPackage),
      weather: ModalRoute.of(context).settings.arguments,
      date:
          DateFormat.yMMMMEEEEd("en_US").format(new DateTime.now()).toString(),
      time: DateFormat.jm().format(new DateTime.now()).toString(),
      child: WeatherScreenWidget(),
    );
  }
}

class WeatherScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      floatingActionButton: buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget buildBody(BuildContext context) {
  final weather = WeatherScreenData.of(context).weather;
  return DecoratedBox(
    decoration: BoxDecoration(
      image: DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1534050359320-02900022671e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1400&q=80'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), BlendMode.darken)),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: WeatherScreenData.of(context).height * 0.05),
          buildLocation('${weather.name}, ${weather.sys.country}'),
          SizedBox(height: WeatherScreenData.of(context).height * 0.2),
          buildTemperature(weather.main.temp.round()),
          buildCondition(ReCase('${weather.weather[0].description}').titleCase),
          SizedBox(height: WeatherScreenData.of(context).height * 0.02),
          buildDate(
              '${WeatherScreenData.of(context).time} - ${WeatherScreenData.of(context).date}'),
          SizedBox(height: WeatherScreenData.of(context).height * 0.04),
          buildConditionIcon(WeatherUtilities.getWeatherIcon(
              weather.weather[0].main,
              weather.weather[0].icon[weather.weather[0].icon.length - 1])),
          SizedBox(height: WeatherScreenData.of(context).height * 0.04),
          buildConditionData(weather.main.humidity, weather.main.pressure,
              weather.wind.speed.round()),
        ],
      ),
    ),
  );
}

Widget buildLocation(String location) {
  return Text(location,
      style: TextStyle(
          color: Colors.white, fontSize: 18, fontFamily: 'AvenirRegular'));
}

Widget buildTemperature(int temperature) {
  return Text('$temperature˚',
      style: TextStyle(
          color: Colors.white, fontSize: 80, fontFamily: 'AvenirMed'));
}

Widget buildCondition(String condition) {
  return Text(condition,
      style: TextStyle(
          color: Colors.white, fontSize: 25, fontFamily: 'AvenirMed'));
}

Widget buildDate(String date) {
  return Text(date,
      style: TextStyle(
          color: Colors.white70, fontSize: 15, fontFamily: 'AvenirRegular'));
}

Widget buildConditionIcon(IconData icon) {
  return Icon(icon, size: 50, color: Colors.white);
}

Widget buildConditionData(int humidity, int precipitation, int wind) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      Column(
        children: <Widget>[
          Text('Humidity',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontFamily: 'AvenirRegular')),
          Text('$humidity%',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'AvenirRegular')),
        ],
      ),
      Column(
        children: <Widget>[
          Text('Pressure',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontFamily: 'AvenirRegular')),
          Text('$precipitation Mb',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'AvenirRegular')),
        ],
      ),
      Column(
        children: <Widget>[
          Text('Wind',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontFamily: 'AvenirRegular')),
          Text('$wind Km/h',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'AvenirRegular'))
        ],
      )
    ],
  );
}

Widget buildFAB(BuildContext context) {
  return FloatingActionButton(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Icon(WeatherScreenData.of(context).backArrowIcon,
          color: Colors.white, size: 40),
    ),
    backgroundColor: Colors.black.withOpacity(0.3),
    onPressed: () => Navigator.pop(context),
  );
}
