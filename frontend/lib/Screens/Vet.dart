import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Screens/vet_drawer/components/app_bar.dart';
import 'package:frontend/Screens/vet_drawer/drawer.dart';
import 'package:frontend/Screens/vet_home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adopt_drawer/drawer.dart';
import 'adopt_home/home_page.dart';

class VetApp extends StatefulWidget {

  const VetApp({super.key});

  @override
  State<VetApp> createState() => _VetAppState();
}

class _VetAppState extends State<VetApp> {
  @override
  void initState(){
    super.initState();
    setpage();
  }
  setpage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('vethome', true);
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: Stack(
        children: const <Widget>[
          VetDrawerScreen(),
          VetHomePage(),
        ],
      ),
    );
  }
}
