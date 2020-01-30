import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather_bug/main.dart';
import '../Blocs/Theme_Bloc/Bloc.dart';
import '../Utilities/Shared_Preference_Utilities.dart';
import '../Widgets/Color_Picker/color/color_picker.dart';

class SettingsScreenData extends InheritedWidget {
  final height;
  final width;
  final flutterLocalNotificationsPlugin;

  SettingsScreenData(
      {Key key,
      Widget child,
      this.height,
      this.width,
      this.flutterLocalNotificationsPlugin})
      : super(key: key, child: child);

  static SettingsScreenData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsScreenData>();
  }

  @override
  bool updateShouldNotify(SettingsScreenData oldWidget) {
    return true;
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsScreenData(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
      child: SettingsScreenWidget(),
    );
  }
}

class SettingsScreenWidget extends StatefulWidget {
  @override
  _SettingsScreenWidgetState createState() => _SettingsScreenWidgetState();
}

class _SettingsScreenWidgetState extends State<SettingsScreenWidget> {
  @override
  Widget build(BuildContext context) {
    initializeNotifications(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: SettingsScreenData.of(context).height * 0.06),
          Container(
              width: SettingsScreenData.of(context).width * 0.95,
              child: buildTitle(context, 'Notifications')),
          SizedBox(height: SettingsScreenData.of(context).height * 0.02),
          buildNotificationsSettings(context),
          SizedBox(height: SettingsScreenData.of(context).height * 0.04),
          Container(
              width: SettingsScreenData.of(context).width * 0.95,
              child: buildTitle(context, 'Search History')),
          SizedBox(height: SettingsScreenData.of(context).height * 0.02),
          buildClearHistory(context),
          SizedBox(height: SettingsScreenData.of(context).height * 0.04),
          Container(
              width: SettingsScreenData.of(context).width * 0.95,
              child: buildTitle(context, 'Theme Color')),
          SizedBox(height: SettingsScreenData.of(context).height * 0.01),
          buildColorPicker(context),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: 15, fontFamily: 'AvenirMed')),
        Divider(
          color: Theme.of(context).primaryColor,
          thickness: 3,
          indent: 2,
          endIndent: SettingsScreenData.of(context).width * 0.88,
        )
      ],
    );
  }

  Widget buildNotificationsSettings(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child:
                        Icon(Icons.stay_primary_portrait, color: Colors.white),
                  )),
              SizedBox(width: SettingsScreenData.of(context).width * 0.02),
              Text('Pop-Ups'),
            ],
          ),
          trailing: Switch(
            value: MyAppData.of(context).popUps,
            onChanged: (value) {
              value
                  ? showNotification("Thank You!",
                      "You've Now Subscribed To Our Our Weather Changes Notifications System")
                  : showNotification("We're Sorry To Hear That!",
                      "You've Unsubscribed From Our Weather Changes Notifications System");
              setState(() {
                MyAppData.of(context).popUps = value;
                MyAppData.of(context)
                    .sharedPreferenceUtilities
                    .setSettings('popUps', value);
              });
            },
          ),
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(Icons.notifications, color: Colors.white),
                  )),
              SizedBox(width: SettingsScreenData.of(context).width * 0.02),
              Text('Sound'),
            ],
          ),
          trailing: Switch(
            value: MyAppData.of(context).sound,
            onChanged: (value) {
              setState(() {
                MyAppData.of(context).sound = value;
                MyAppData.of(context)
                    .sharedPreferenceUtilities
                    .setSettings('sound', value);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildClearHistory(BuildContext context) {
    return Container(
      width: SettingsScreenData.of(context).width * 0.9,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        child: Text('Clear Search History',
            style: TextStyle(color: Colors.white, fontFamily: 'AvenirRegular')),
        onPressed: () =>
            MyAppData.of(context).sharedPreferenceUtilities.clearHistory(),
      ),
    );
  }

  Widget buildColorPicker(BuildContext context) {
    return Container(
      height: 270,
      width: SettingsScreenData.of(context).width,
      child: ColorPicker(
        type: MaterialType.transparency,
        onColor: (color) {
          BlocProvider.of<ThemeBloc>(context)
              .add(ChangeTheme(color: color.value));
        },
        currentColor: Color(Theme.of(context).primaryColor.value),
      ),
    );
  }

  initializeNotifications(BuildContext context) {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    SettingsScreenData.of(context).flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future showNotification(String title, String body) async {
    final androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '1',
        'Push Notification Subsrciption',
        'Push Notification Subsrciption Status',
        importance: Importance.Max,
        priority: Priority.High);
    final iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    final platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await SettingsScreenData.of(context)
        .flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics);
  }

  Future onSelectNotification(String payload) async =>
      print('Notification Selected!');
}
