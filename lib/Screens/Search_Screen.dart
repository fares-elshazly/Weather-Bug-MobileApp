import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var height, width;
final myPage = PageController(initialPage: 0);
ValueNotifier<Color> locationsColor = ValueNotifier(Colors.orange);
ValueNotifier<Color> settingsColor = ValueNotifier(Colors.black87);

class SearchScreen extends StatelessWidget {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: myPage,
        children: <Widget>[
          Center(
            child: Container(
              width: width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height * 0.04),
                  buildTitle('Locations'),
                  SizedBox(height: height * 0.04),
                  buildRoundedTextField(
                      'Search', Icons.search, searchController),
                  SizedBox(height: height * 0.04),
                  Expanded(
                    child: buildListView('Recently Searched', [
                      'Alexandria',
                      'Miami',
                      'Las Vegas',
                      'Alexandria',
                      'Miami',
                      'Las Vegas',
                      'Alexandria',
                      'Miami',
                      'Las Vegas'
                    ]),
                  ),
                ],
              ),
            ),
          ),
          Center(child: Text('Hello World!'))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: buildBottomAppBar(),
      ),
      floatingActionButton: buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget buildTitle(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(title, style: TextStyle(fontSize: 25, fontFamily: 'AvenirDemi')),
      Divider(
        color: Color.fromARGB(255, 255, 160, 14),
        thickness: 5,
        indent: 2,
        endIndent: width * 0.8,
      )
    ],
  );
}

Widget buildRoundedTextField(
    String hint, IconData preIcon, TextEditingController controller) {
  return Container(
    height: 55,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none, prefixIcon: Icon(preIcon), labelText: hint),
      onSubmitted: (v) {
        print('Searching For $v ...');
      },
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        color: Colors.white),
  );
}

Widget buildListView(String title, List<String> places) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(title,
          style: TextStyle(
              fontSize: 13, fontFamily: 'AvenirRegular', color: Colors.grey)),
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: places.length,
          itemBuilder: (context, index) {
            return Container(
                height: 100,
                margin: EdgeInsets.only(top: 8, bottom: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://cdn.vox-cdn.com/thumbor/Z7C9NrmCrdHZ0p6JaxsjCBCFTtg=/0x0:3840x5760/1200x675/filters:focal(1613x2573:2227x3187)/cdn.vox-cdn.com/uploads/chorus_image/image/56185263/muzammil_soorma_797975_unsplash.6.jpg'),
                        fit: BoxFit.fill)),
                child: Center(
                    child: Text(
                  places[index],
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'AvenirMed',
                      fontSize: 18),
                )));
          },
        ),
      ),
    ],
  );
}

Widget buildBottomAppBar() {
  IconData earth = IconData(0xf38c,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);
  return Container(
    height: height * 0.1,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          child: ValueListenableBuilder(
            valueListenable: locationsColor,
            builder: (BuildContext context, dynamic value, Widget child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(earth, size: 25, color: value),
                  Text('Locations', style: TextStyle(color: value)),
                ],
              );
            },
          ),
          onPressed: () {
            locationsColor.value = Colors.orange;
            settingsColor.value = Colors.black87;
            myPage.jumpToPage(0);
          },
        ),
        FlatButton(
          child: ValueListenableBuilder(
            valueListenable: settingsColor,
            builder: (BuildContext context, dynamic value, Widget child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(CupertinoIcons.gear, size: 25, color: value),
                  Text('Settings', style: TextStyle(color: value)),
                ],
              );
            },
          ),
          onPressed: () {
            locationsColor.value = Colors.black87;
            settingsColor.value = Colors.orange;
            myPage.jumpToPage(1);
          },
        ),
      ],
    ),
  );
}

Widget buildFAB() {
  return FloatingActionButton(
    child: Icon(Icons.my_location, color: Colors.white, size: 35),
    tooltip: 'Get My Location',
    onPressed: () {},
  );
}
