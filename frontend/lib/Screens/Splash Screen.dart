import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Controllers/pet_data.dart';
import 'package:frontend/Screens/SignIn.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../Controllers/admincontrol.dart';
import '../Controllers/getdetails.dart';
import '../Controllers/homescreencontrol.dart';
import '../Controllers/signin.dart';
import '../firebase_options.dart';
import 'package:frontend/global.dart';
import 'Onboarding Carousel.dart';
import 'SignIn.dart';
import 'package:firebase_core/firebase_core.dart';




class SplashScreen extends StatefulWidget {
  var getdeatilsconrol = Get.put(GetDetailsControl());
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () => navigate());
  }

  void navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    bool isFirstTime = prefs.getBool('isFirstTime') ?? false;
    if (isFirstTime){
      prefs.setString('pet_name', "");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => onboardingCarousel(prefs: prefs)));
    }
    else{
      String? ph = prefs.getString('Phone');

      if (ph!.length == 0){
        print(ph);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => SignInPage(),
            ));
      }
      else{
        //user
        String? name = prefs.getString('Name');
        if (name!.isNotEmpty){
          print(name);
        }
        else{
          GetDetailsControl.instance.getUser(ph,prefs);
        }

        if (ph == '2222'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminMainPage()),
          );
        }
        else{
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => MainPage(),
              ));
          }


      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: 380, // Set the width of the container
      height: 800, // Set the height of the container
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
          child: Image.asset(
        'assets/splash.gif', // Replace with your image path
        fit: BoxFit.cover, // Use BoxFit.cover to stretch the image
      ),
    ));
  }
}
