import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_bug/Utilities/Conversion_Utilities.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();
}

class InitialTheme extends ThemeState {
  @override
  List<Object> get props => null;
}

class NewTheme extends ThemeState {
  final color;
  final theme;

  NewTheme({@required this.color})
      : theme = ThemeData(
            primarySwatch:
                MaterialColor(color, Conversions.colorToSwatch(Color(color))));

  @override
  List<Object> get props => [this.color, this.theme];
}
