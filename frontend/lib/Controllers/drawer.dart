import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/SignIn.dart';

class MyDrawer extends StatefulWidget {


  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  phone,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: Text('Edit Details'),
            onTap: () {
// Navigate to edit details screen
              Navigator.of(context).pop(); // Close the drawer
// Add your navigation logic here
            },
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
