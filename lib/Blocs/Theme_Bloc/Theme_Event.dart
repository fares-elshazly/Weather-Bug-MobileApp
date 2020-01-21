import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ChangeTheme extends ThemeEvent {
  final color;

  ChangeTheme({@required this.color});

  @override
  List<Object> get props => [this.color];
}
