import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

var height, width;

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: buildBody(),
      floatingActionButton: buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget buildBody() {
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
          SizedBox(height: height * 0.05),
          buildLocation('San Francisco, California, US'),
          SizedBox(height: height * 0.2),
          buildTemperature(10),
          buildCondition('Partly Cloudy'),
          SizedBox(height: height * 0.02),
          buildDate('10:00 AM - Monday, November 11, 2019'),
          SizedBox(height: height * 0.04),
          buildConditionIcon(WeatherIcons.day_cloudy),
          SizedBox(height: height * 0.04),
          buildConditionData(88, 0, 2),
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
          Text('Precipitation',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontFamily: 'AvenirRegular')),
          Text('$precipitation%',
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
  IconData back = IconData(0xf3d5,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);
  return FloatingActionButton(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Icon(back, color: Colors.white, size: 40),
    ),
    onPressed: () => Navigator.pop(context),
  );
}
