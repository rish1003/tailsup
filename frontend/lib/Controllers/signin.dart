import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:frontend/Controllers/homescreencontrol.dart';
import 'package:frontend/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Reusables/custommessage.dart';


class SignInControl extends GetxController {
  static SignInControl get instance => Get.find();

  signInUser(ph, pw,context) async {
    var headers = {
      'Content-Type': 'text/plain'
    };
    var request = http.Request(
        'POST', Uri.parse((global.url)+'//signin/'));

    request.body = jsonEncode({
      "phone": ph,
      "password": pw,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Phone', '+91'+ph);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );

    }
    else {
      CustomMessage.toast('Invalid Credentials');
      print(response.reasonPhrase);
    }
  }
}