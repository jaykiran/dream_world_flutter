import 'package:flutter/material.dart';
import 'app.dart';
import 'flavors.dart';
import 'package:dream_world/services/sharedPref.dart';
import 'screens/home.dart';
import 'data/theme.dart';

void main() {
  F.appFlavor = Flavor.SANDBOX; 
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = appThemeLight;
  //final String apiUrl;
  @override
  void initState() {
    super.initState();
    updateThemeFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream World',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Home', changeTheme: setTheme),
    );
  }

  setTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      setState(() {
        theme = appThemeDark;
      });
    } else {
      setState(() {
        theme = appThemeLight ;
      });
    }
  }

  void updateThemeFromSharedPref() async {
    String themeText = await getThemeFromSharedPref();
    if (themeText == 'light') {
      setTheme(Brightness.light);
    } else {
      setTheme(Brightness.dark);
    }
  }
}