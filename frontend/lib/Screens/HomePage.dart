import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/shop/main_Shop.dart';

import '../Controllers/vet_model.dart';
import '../Reusables/category tile.dart';
import '../Reusables/vetcard.dart';
import 'Adopt.dart';
import 'Vet.dart';


class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> vets=[];
  @override
  void initState() {
    super.initState();
    fetchAndSetVets();
    print(vets);
  }

  Future<void> fetchAndSetVets() async {
    try {
      final List<Vet> fetchedVets = await VetService.fetchVets();
      final List<Map<String, String>> vetDataList = fetchedVets
          .map((vet) => {
        'name': vet.name,
        'phone': vet.phone,
        'picture' : vet.picture
        // Add other vet properties as needed
      })
          .toList();

      setState(() {
        vets = vetDataList; // Set the fetched vets in the state
      });
    } catch (error) {
      print('Failed to fetch vets: $error');
    }
  }

  var colorizeColors = [
    Color(0xFFF63B63),
    Color(0xFFBA78DE),
    Color(0xFF11E1D3),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [

          Padding(
            padding: EdgeInsets.all(16),
            child: AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'One-Stop Pet Needs App!',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,

                  ),
                  colors: colorizeColors,

                ),
              ],
              isRepeatingAnimation: true,
              totalRepeatCount: 20,
              repeatForever: true,

            ),

          ),
          Column(
            children: [
              ClickableContainer(
                backgroundImage: 'assets/vetcategory.png', // Replace with your image asset
                text: 'Vet',
                a_height: 0.17*height ,
                a_width: .9* width ,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => VetApp()));
                  // Handle container click
                  print('Container Clicked!');
                },
                shadowColor: Color(0xFFF9E1D2), // Set shadow color here
              ),
              SizedBox(
                height: 20,
              ),
              ClickableContainer2(
                backgroundImage: 'assets/shopcategory.png', // Replace with your image asset
                text: 'Shop',
                a_height: 0.17*height ,
                a_width: .9* width ,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => ShopHomePage()));// Handle container click ShopHomePage
                  print('Container Clicked!');
                },
                shadowColor: Color(0xFFEABD99), // Set shadow color here
              ),
              SizedBox(
                height: 20,
              ),
              ClickableContainer(
                backgroundImage: 'assets/adoptcategory.png', // Replace with your image asset
                text: 'Adopt',
                a_height: 0.17*height ,
                a_width: .9* width ,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => App()));
                  print('Container Clicked!');
                },
                shadowColor: Color(0xFFFCB386), // Set shadow color here
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  "Popular Vets",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,

                  ),
                ),

                Icon(
                  Icons.more_horiz,
                  color: Colors.grey[800],
                ),

              ],
            ),
          ),
          //vets
          Container(
            height: 0.2 * height,
            margin: EdgeInsets.only(bottom: 10),
            child: PageView(
              physics: BouncingScrollPhysics(),
              children: vets.map((vetData) {
                return buildVet(
                  vetData['picture'] ?? '',
                  vetData['name'] ?? '',
                  vetData['phone'] ?? '',
                  height,
                  width,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}