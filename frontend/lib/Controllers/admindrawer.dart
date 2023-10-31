import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/SignIn.dart';

class AdminDrawer extends StatefulWidget {


  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String phone = '';
  String name = '';
  void initState() {
    super.initState();
    getValue();
  }

  void getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('Phone')!;
      name = prefs.getString('Name')!;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30),
            color: Colors.pinkAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
          ListTile(
              title: Text('Logout'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('Phone', '');
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SignInPage(),
                ));
              } // Close the drawer
// Add your logout logic here

              ),
        ],
      ),
    );
  }
}
