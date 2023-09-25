import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Controllers/config.dart';
import 'package:frontend/Reusables/custommessage.dart';
import 'package:frontend/Reusables/formelements.dart';
import 'package:frontend/Screens/adopt_home/home_page.dart';
import 'package:frontend/utils/spacing_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/global.dart';

import 'Adopt.dart';

class ApplyForAdoptionPage extends StatefulWidget {
  const ApplyForAdoptionPage({super.key});

  @override
  State<ApplyForAdoptionPage> createState() => _ApplyForAdoptionPageState();
}

class _ApplyForAdoptionPageState extends State<ApplyForAdoptionPage> {
  TextEditingController nametxt = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController reason = TextEditingController();
  String petname = ' ';
  String idpet = ' ';
  @override
  void initState() {
    super.initState();
    setname();
  }

  setname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('petname');
    String? petid = prefs.getString('petid');
    String? phone = prefs.getString('Phone');
    String? uname = prefs.getString('Name');
    setState(() {
      petname = name!;
      nametxt.text = uname!;
      number.text = phone!;
      idpet = petid!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.favorite,
                      color: Color(0xff532754),
                    ),
                    addHorizontalSpace(5.0),
                    Text(
                      'Apply for Adoption',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff532754),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Adopting',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff532754),
                      ),
                    ),
                    addHorizontalSpace(5),
                    Text(
                      petname,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffb5abb7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0), // Add spacing
                FormTextField(
                    fieldcontroller: nametxt,
                    keytype: TextInputType.text,
                    hinttext: 'Name',
                    hinttextcol: primaryColor,
                    bordercol: Color(0xffd69fd7),
                    obscure: false),
                const SizedBox(height: 20.0), // Add spacing
                FormTextField(
                    fieldcontroller: number,
                    keytype: TextInputType.number,
                    hinttext: 'Phone',
                    hinttextcol: primaryColor,
                    bordercol: Color(0xffd69fd7),
                    obscure: false),
                const SizedBox(height: 20.0), // Add spacing
                TextField(
                  maxLines: 5,
                  autofocus: true,
                  controller: reason,
                  obscureText: false,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Reason for adoption',
                    labelStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xffd69fd7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0), // Add spacing
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: SizedBox(
                    width: 200,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async{
                        print('object');
                        var headers = {
                          'Content-Type': 'application/json'
                        };
                        var request = http.Request('POST', Uri.parse(global.url+'/addadoptionrecord/'));
                        request.body = json.encode({
                          "userid": number.text.substring(3),
                          "petid": idpet,
                          "reason": reason.text
                        });
                        request.headers.addAll(headers);

                        http.StreamedResponse response = await request.send();
                        print(response.statusCode);
                        if (response.statusCode == 200) {

                          CustomMessage.toast('Submitted Succesfully');
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => App()));
                        }
                        else {
                          if (response.statusCode == 400) {
                            CustomMessage.toast(
                                'Unsucessful: Reason is Compulsory');
                          }
                          else if (response.statusCode == 226) {
                            CustomMessage.toast(
                                'Unsucessful: Already Applied');
                          }
                          else if (response.statusCode == 406){
                            CustomMessage.toast(
                                'Unsucessful: Already Applied');
                          }
                          else { CustomMessage.toast(
                              'Unsucessful: Error');}
                        }


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
