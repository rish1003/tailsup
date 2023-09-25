import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/adopt_home/components/favourites.dart';
import 'package:frontend/Screens/adoptionapplication.dart';
import 'package:frontend/Screens/vet_home/components/appointments.dart';

import 'package:frontend/utils/spacing_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/app_bar.dart';
import 'components/vets_available.dart';

class VetHomePage extends StatefulWidget {
  const VetHomePage({super.key});

  @override
  State<VetHomePage> createState() => _VetHomePageState();
}

class _VetHomePageState extends State<VetHomePage> {
  bool? isvethome = true;
  void initState() {
    super.initState();
    checkpage();
  }

  checkpage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isVetHome =
        prefs.getBool('vethome') ?? true; // Set a default value here
    setState(() {
      isvethome = isVetHome;
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
      isvethome = prefs.getBool('vethome');
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
            isDrawerOpen: _isDrawerOpen,
            openDrawer: _openDrawer,
            closeDrawer: _closeDrawer,
            text: isvethome == true ? 'Vets' : 'Appointments',
          ),
          Expanded(
            child: isvethome == true ? VetsAvailable() : AppointmentsPage(),
          ),
        ],
      ),
    );
  }
}
