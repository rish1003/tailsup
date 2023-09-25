import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Controllers/drawer.dart';
import 'package:frontend/Controllers/pet_data.dart';
import 'package:frontend/Screens/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/HomePage.dart';
import '../Screens/PetProfile.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
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
    fetchAndSetPets();
  }
  Future<void> fetchAndSetPets() async {
    try {
      final List<Pet> fetchedPets = await PetService.fetchPets();
      final List<Map<String, String>> petDataList = fetchedPets
          .map((pet) => {
        'pet_name': pet.name,
        'breed': pet.breed,
        'age': pet.age,
        'weight': pet.weight,
        'gender': pet.gender,
        'special_need': pet.specialNeeds,
        'desc': pet.description,
        'pic': pet.picture
      })
          .toList();

      setState(() {
        pets = petDataList; // Set the fetched pets in the state
      });
    } catch (error) {
      print('Failed to fetch pets: $error');
    }
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
              'Tails Up', // Replace with your app name
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
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
      endDrawer: MyDrawer(),
      body: TabBarView(
        controller: tc,
        children: [
          MyHomePage(),
          PetDetails(petsData: pets),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: tc,
        tabs: [
          Tab(
            icon: Icon(Icons.home),
          ),
          Tab(
            icon: Icon(Icons.pets),
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
