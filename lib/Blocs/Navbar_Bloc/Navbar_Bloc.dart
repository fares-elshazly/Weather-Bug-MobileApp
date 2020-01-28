import 'dart:async';
import 'package:bloc/bloc.dart';
import './Bloc.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  @override
  NavbarState get initialState => InitialNavbarState();

  @override
  Stream<NavbarState> mapEventToState(
    NavbarEvent event,
  ) async* {
    if (event is Swipe) {
      yield SwapColors(
          locationsColor: event.settingsColor,
          settingsColor: event.locationsColor);
    }
    else {
      yield InitialNavbarState();
    }
  }
}
