import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:frontend/Screens/shop/utils.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  addHorizontalSpace(70.0),
                  const Icon(
                    Icons.favorite,
                    color: Color(0xffcf4055),
                  ),
                  addHorizontalSpace(5.0),
                  Text(
                    'Shop',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffcf4055),
                    ),
                  ),
                  addHorizontalSpace(5.0),
                ],
              ),
            ],
          ),
        ],
      ),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(

                    padding: EdgeInsets.all(20),
                    // height: 200,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Image.asset('assets/shop.png',height:120),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Best',textAlign: TextAlign.left,
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffcf4055),
                              ),),
                            Text('Pet',textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffcf4055),
                              ),),
                            Text('Products',textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffcf4055),
                              ),)
                          ],
                        ),
                        ]
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0x90cf4055),width: 8),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                  // Positioned(
                  //     child: Image(
                  //   image: AssetImage('assets/images/basket.png'),
                  // ))
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Categories",
                    style: GoogleFonts.montserrat(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff413c3c),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryTile(
                    context:context,
                    categoryName: "Category 1",
                    imageUrl: "assets/logo.png", // Replace with your image asset
                  ),
                  CategoryTile(
                    context:context,
                    categoryName: "Category 2",
                    imageUrl: "assets/category2_image.png", // Replace with your image asset
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryTile(
                    context: context,
                    categoryName: "Category 3",
                    imageUrl: "assets/category3_image.png", // Replace with your image asset
                  ),
                  CategoryTile(
                    context:context,
                    categoryName: "Category 4",
                    imageUrl: "assets/category4_image.png", // Replace with your image asset
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final BuildContext context;
  final String categoryName;
  final String imageUrl;

  CategoryTile({
    required this.context,
    required this.categoryName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle category selection if needed
      },
      child: Column(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: tColor,
              borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0x90cf4055),width: 8),

              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            categoryName,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color(0xffcf4055),
            ),
          ),
        ],
      ),
    );
  }
}