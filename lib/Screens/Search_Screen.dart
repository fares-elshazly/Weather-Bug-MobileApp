import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Blocs/Weather_Bloc/Bloc.dart';
import '../Models/City_Model.dart';
import '../Utilities/Shared_Preference_Utilities.dart';
import '../main.dart';

class SearchScreenData extends InheritedWidget {
  final height;
  final width;
  final searchController;
  SearchScreenData(
      {Key key,
      Widget child,
      this.height,
      this.width,
      this.searchController})
      : super(key: key, child: child);

  static SearchScreenData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SearchScreenData>();
  }

  @override
  bool updateShouldNotify(SearchScreenData oldWidget) {
    return true;
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchScreenData(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      searchController: TextEditingController(),
      child: SearchScreenWidget(),
    );
  }
}

class SearchScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SearchScreenData.of(context).width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: SearchScreenData.of(context).height * 0.06),
            buildTitle(context, 'Locations'),
            SizedBox(height: SearchScreenData.of(context).height * 0.04),
            buildRoundedTextField(context, 'Search', Icons.search),
            SizedBox(height: SearchScreenData.of(context).height * 0.04),
            Expanded(
              child: buildListView(context, 'Recently Searched'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTitle(BuildContext context, String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(title, style: TextStyle(fontSize: 25, fontFamily: 'AvenirDemi')),
      Divider(
        color: Theme.of(context).primaryColor,
        thickness: 5,
        indent: 2,
        endIndent: SearchScreenData.of(context).width * 0.8,
      )
    ],
  );
}

Widget buildRoundedTextField(
    BuildContext context, String hint, IconData preIcon) {
  return Container(
    height: 55,
    child: TextField(
      controller: SearchScreenData.of(context).searchController,
      decoration: InputDecoration(
          border: InputBorder.none, prefixIcon: Icon(preIcon), labelText: hint),
      onSubmitted: (text) async {
        if (text.isNotEmpty) {
          BlocProvider.of<WeatherBloc>(context).add(GetWeather(cityName: text));
        }
      },
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        color: Colors.white),
  );
}

Widget buildListView(BuildContext context, String title) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(title,
          style: TextStyle(
              fontSize: 13, fontFamily: 'AvenirRegular', color: Colors.grey)),
      FutureBuilder(
        initialData: List<City>(),
        future:
            MyAppData.of(context).sharedPreferenceUtilities.getCities(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return buildListViewUnit(context, index, snapshot);
              },
            ),
          );
        },
      ),
    ],
  );
}

Widget buildListViewUnit(
    BuildContext context, int index, AsyncSnapshot snapshot) {
  return GestureDetector(
    child: Container(
        height: SearchScreenData.of(context).height * 0.15,
        margin: index == snapshot.data.length - 1
            ? EdgeInsets.only(
                top: 8, bottom: SearchScreenData.of(context).height * 0.15)
            : EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image:
                    CachedNetworkImageProvider(snapshot.data[index].imageURL),
                fit: BoxFit.cover)),
        child: Center(
            child: Text(
          snapshot.data[index].name,
          style: TextStyle(
              color: Colors.white, fontFamily: 'AvenirMed', fontSize: 18),
        ))),
    onTap: () => BlocProvider.of<WeatherBloc>(context)
        .add(GetWeather(cityName: snapshot.data[index].name)),
  );
}
