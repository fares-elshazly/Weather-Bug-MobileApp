import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NavbarState extends Equatable {
  const NavbarState();
}

class InitialNavbarState extends NavbarState {
  @override
  List<Object> get props => [];
}

class SwapColors extends NavbarState {
  final locationsColor;
  final settingsColor;

  SwapColors({@required this.locationsColor, @required this.settingsColor});

  @override
  List<Object> get props => [locationsColor, settingsColor];
}
