import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'adopt_drawer/drawer.dart';
import 'adopt_home/home_page.dart';

class App extends StatefulWidget {

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState(){
    super.initState();
    setpage();
  }
  setpage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('adopthome', true);
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: Stack(
        children: const <Widget>[
          DrawerScreen(),
          HomePage(),
        ],
      ),
    );
  }
}
