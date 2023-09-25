import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:frontend/Controllers/pet_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/global.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/config.dart';
import '../adopt_home/components/pets_available.dart';
import 'components/custom_nav_drawer.dart';

class PetDetailsPage extends StatefulWidget {
  final Pet pet;

  const PetDetailsPage({required this.pet});



  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  bool isLiked = false;
  List a=[];
  @override
  void initState(){
    super.initState();
    setpet();
  }
  setpet() async{
    a = await PetShelter.fetchLikedPets();
    setState(()  {
        isLiked = a.contains(int.tryParse(widget.pet.petId));


    });
    }

  int _activeIndex = 0;
  final _pageViewController = PageController();
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final Pet pet = widget.pet;
    _pageViewController.addListener(() {
      setState(() {
        _activeIndex = _pageViewController.page!.round();
      });
    });
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(isfav: isLiked,),
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: size.height * .6,
            child: PageView.builder(
              itemCount: 1,
              controller: _pageViewController,
              itemBuilder: (context, index) {
                return Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                        color: Color(0xff532754),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: Color(0xff532754), // Border color
                          width: 8, // Border width
                        )),
                    child: ClipRRect(
                      child: Image.network(
                        global.url + pet.picture!,
                        fit: BoxFit.fitHeight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ));
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10.0,
              ),
              margin: EdgeInsets.only(top: size.height * .325),
              width: size.width * .85,
              height: size.height * .14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        pet.name,
                        style: GoogleFonts.montserrat(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Icon(
                        pet.gender == 'Male'
                            ? Icons.male_rounded
                            : Icons.female_rounded,
                        color: primaryColor,
                        size: 30,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        pet.breed,
                        style: GoogleFonts.montserrat(
                          color: primaryColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '${pet.age} years old',
                        style: GoogleFonts.montserrat(
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: SingleChildScrollView(
                child: Text(
                  pet.description,
                  style: GoogleFonts.montserrat(
                    height: 1.5,
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
