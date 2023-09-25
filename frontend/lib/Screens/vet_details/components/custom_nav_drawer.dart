import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Adoptpage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import '../../../Controllers/config.dart';


class CustomBottomBar extends StatefulWidget {
  bool isfav;
  CustomBottomBar({super.key,required this.isfav});


  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {

  @override
  void initState(){
    super.initState();

  }
  addfavpet() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('Phone')!.substring(3);
    String? petid = prefs.getString('petid');
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://192.168.221.189:8000/addfavpet/'));
    request.body = json.encode({
      "user": ph,
      "pet": petid
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
  removefavpet() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('Phone')!.substring(3);
    String? petid = prefs.getString('petid');
    String? petname = prefs.getString('petname');
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://192.168.221.189:8000/removefavpet/'));
    request.body = json.encode({
      "user": ph,
      "pet": petid
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
  setFav() async{
      setState(() {
        if (widget.isfav == false){

          addfavpet();
      }
        else{
          removefavpet();
        }
        widget.isfav = !widget.isfav;

    });
  }
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(
        28.0,
      ),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(30.0),
          right: Radius.circular(30.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setFav();
            },
            child: Container(
              width: 60.0,
              height: 50.0,
              padding: EdgeInsets.all(5.0),
              color: Color(0xff532754),
              child: Icon(
                widget.isfav  ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => ApplyForAdoptionPage()));},
            child: Container(
              width: size.width * .65,
              height: 50.0,
              decoration: BoxDecoration(
                boxShadow: shadowList,
                color: primaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  'Adoption',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
