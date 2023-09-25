import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:frontend/Screens/shop/utils.dart';

import 'itemscreen.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({Key? key}) : super(key: key);

  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: App,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    // height: 200,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OFFER",
                          style: TextStyle(
                              letterSpacing: 4, color: MainColor, fontSize: 12),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Flat 35% OFFER",
                          style: TextStyle(
                              letterSpacing: 4,
                              color: Colors.white,
                              fontSize: 25,
                              // fontFamily: 'Comfortaa-',
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "in honor of World Helath Day\nwe had likely to give this \namazing offer",
                          style: TextStyle(
                              letterSpacing: 1,
                              color: Color.fromARGB(255, 177, 176, 176),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: Container(
                            width: 160,
                            child: Center(child: Text('View Offers')),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                                color: MainColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(13))),
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: SecondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  // Positioned(
                  //     child: Image(
                  //   image: AssetImage('assets/images/basket.png'),
                  // ))
                ],
              ),
              SizedBox(
                height: 50,
              ),

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Fruits",
                    style: TextStyle(
                        color: Colors.black, // Set text color to black
                        fontSize: 25,
                        fontFamily: 'Comfortaa'),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(color: Colors.black), // Set text color to black
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: itemList.map((e) => ItemC(context, e)).toList(),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: tColor,
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () {},
                          icon: Icon(
                            Icons.shop_2_sharp,
                            color: Colors.black, // Set icon color to black
                          )),
                      IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () {},
                        icon: Icon(
                          Icons.mail,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          size: 20,
                          color: Colors.grey,
                        ),
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector ItemC(BuildContext context, Item e) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ItemScreen(e: e),
        ));
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            height: 120,
            child: Image(
              image: AssetImage(e.image),
            ),
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: BoxDecoration(
              color: e.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(300),
                topRight: Radius.circular(300),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'FRUIT',
                    style: TextStyle(
                        color: Colors.black, // Set text color to black
                        letterSpacing: 5,
                        fontSize: 10),
                  ),
                  Text(
                    e.name,
                    style: TextStyle(color: Colors.black), // Set text color to black
                  ),
                  Text(
                    "⭐ (${e.reviewCount} reviews)",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${e.price} ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black), // Set text color to black
                      ),
                      Text(
                        'per Kg',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    ],
                  )
                ]),
            height: 120,
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: BoxDecoration(
              color: tColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
