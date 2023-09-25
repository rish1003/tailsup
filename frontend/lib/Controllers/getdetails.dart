import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:frontend/Controllers/homescreencontrol.dart';
import 'package:frontend/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class GetDetailsControl  extends GetxController {
  static GetDetailsControl get instance => Get.find();
  getUser(ph,prefs) async {
    var headers = {
      'Content-Type': 'text/plain'
    };
    var request = http.Request('GET', Uri.parse((global.url)+'/userdetails/'+ph.substring(3)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    var res = jsonDecode(data);

    if (response.statusCode == 200) {
      prefs.setString('Name', res['name']);
      prefs.setString('Email', res['email']);
      prefs.setString('Address', res['email']);
      prefs.setString('Pincode', res['pincode']);
      prefs.setBool('isVendor',res['is_vendor'] == 'false' ? false : true );
      prefs.setBool('isVet',res['is_vet'] == 'false' ? false : true );
      prefs.setBool('isShelter',res['is_shelter'] == 'false' ? false : true );
    }
    else {
      print(response.reasonPhrase);
    }
  }


}


