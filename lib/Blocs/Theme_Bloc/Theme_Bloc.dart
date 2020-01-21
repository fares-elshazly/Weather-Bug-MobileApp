import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:weather_bug/Blocs/Theme_Bloc/Theme_Event.dart';
import './Bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState => InitialTheme();

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ChangeTheme) {
      yield NewTheme(color: event.color);
    }
  }
}
