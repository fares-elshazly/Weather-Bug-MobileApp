import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:weather_bug/Screens/Search_Screen.dart';

// void main() => runApp(
//   DevicePreview(
//     builder: (context) => MyApp(),
//   ),
// );

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: DevicePreview.of(context).locale,
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Weather Bug',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SearchScreen(),
    );
  }
}
