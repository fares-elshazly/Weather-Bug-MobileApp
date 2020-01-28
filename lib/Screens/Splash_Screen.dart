import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Blocs/Theme_Bloc/Bloc.dart';
import '../Widgets/Color_Spinner.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ThemeBloc, ThemeState>(
        listener: (context, state) {
          if (state is NewTheme) {
            Navigator.pushReplacementNamed(context, '/PagesViewer');
          }
        },
        child: Scaffold(
          body: Center(
            child: ColorSpinner(
              dotRadius: 10,
              radius: 20,
            ),
          ),
        ),
      ),
    );
  }
}
