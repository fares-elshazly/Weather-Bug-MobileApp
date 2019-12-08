import 'package:flutter/material.dart';
import 'package:weather_bug/Widgets/Color_Spinner.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ColorSpinner(
          dotRadius: 10,
          radius: 20,
        ),
      ),
    );
  }
}