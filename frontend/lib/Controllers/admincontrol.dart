import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Controllers/drawer.dart';
import 'package:frontend/Controllers/pet_data.dart';
import 'package:frontend/Screens/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/HomePage.dart';
import '../Screens/PetProfile.dart';
import '../Screens/users.dart';
import 'admindrawer.dart';

class AdminMainPage extends StatefulWidget {
  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late TabController tc;
  List<Map<String, String>> pets = [];

  late SharedPreferences prefs ;
  @override
  void initState() {
    super.initState();
    tc = new TabController(vsync: this, length: 2);
    tc.addListener(_handleTabSelection);
  }
  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFf),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFF9E1D2),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Replace with your app logo image
              width: 32,
              height: 32,
            ),
            SizedBox(width: 8),
            Text(
              'Tails Up - Admin', // Replace with your app name
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: AdminDrawer(),
      body: TabBarView(
        controller: tc,
        children: [
          UserStatsPage(),
          UserStatsPage(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: tc,
        tabs: [
          Tab(
            icon: Icon(Icons.supervised_user_circle_sharp),
          ),
          Tab(
            icon: Icon(Icons.query_stats),
          ),
        ],
        indicatorColor: Color(0xFF5E3012),
        unselectedLabelColor: Color(0xFFEC782F),
        labelColor: Color(0xFF5E3012),
        padding: EdgeInsets.only(bottom: 5),
        dividerColor: Color(0xFF5E3012),
      ),
    );
  }
}
