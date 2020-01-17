import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NavbarEvent extends Equatable {
  const NavbarEvent();
}

class Swipe extends NavbarEvent {
  final locationsColor;
  final settingsColor;

  Swipe({@required this.locationsColor, @required this.settingsColor});

  @override
  List<Object> get props => [locationsColor, settingsColor];
}
