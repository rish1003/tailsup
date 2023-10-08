import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/adopt_home/components/favourites.dart';
import 'package:frontend/Screens/adoptionapplication.dart';
import 'package:frontend/Screens/shop_home/components/userprofile.dart';
import 'package:frontend/Screens/vet_home/components/appointments.dart';

import 'package:frontend/utils/spacing_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/app_bar.dart';
import 'components/shooping.dart';

class MyShopHomePage extends StatefulWidget {
  const MyShopHomePage({super.key});

  @override
  State<MyShopHomePage> createState() => _MyShopHomePageState();
}

class _MyShopHomePageState extends State<MyShopHomePage> {
  bool? isshophome = true;
  void initState() {
    super.initState();
    checkpage();
  }

  checkpage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isShopHome =
        prefs.getBool('shophome') ?? true; // Set a default value here
    setState(() {
      isshophome = isShopHome;
    });
  }

  double _xOffset = 0;
  double _yOffset = 0;
  double _scaleFactor = 1;

  bool _isDrawerOpen = false;

  void _openDrawer() {
    setState(() {
      _xOffset = 230;
      _yOffset = 150;
      _scaleFactor = 0.6;
      _isDrawerOpen = true;
    });
  }

  void _closeDrawer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _xOffset = 0;
      _yOffset = 0;
      _scaleFactor = 1;
      _isDrawerOpen = false;
      isshophome = prefs.getBool('shophome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(_xOffset, _yOffset, 0)
        ..scale(_scaleFactor),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          )),
      child: Column(
        children: <Widget>[
          addVerticalSpace(60.0),
          buildAppBar(
            context : context,
            isDrawerOpen: _isDrawerOpen,
            openDrawer: _openDrawer,
            closeDrawer: _closeDrawer,
            text: isshophome == true ? 'Shop' : 'Orders',
          ),
          Expanded(
            child: isshophome == true ? MyShoppingPage() : UserProfile(),
          ),
        ],
      ),
    );
  }
}
