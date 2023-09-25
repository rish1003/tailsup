
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Registration%20Page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Reusables/custommessage.dart';

class signupcontrol extends GetxController {
  static signupcontrol get instance => Get.find();
  var verificationid = ''.obs;
  RxString selectedRole = ''.obs;

  Future<void> verifyPhone (ph) async
  {
    print(ph);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: ph,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e){
          print(e.message);
        },
        codeSent:( verificationId,resendtk){
          this.verificationid.value = verificationId;

        },
        codeAutoRetrievalTimeout: (verificationId){
          this.verificationid.value = verificationId;

        });
  }
  void signin(ph,l1) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Phone', ph);

    Get.offAll(RegistrationPage());
  }

  void  verifyOTP (otp,ph) async{
    var credential = await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: this.verificationid.value, smsCode: otp));
    List<String> l1 = [];
    if (credential.user != null){
      signin(ph,l1);
    }
    else{
      CustomMessage.toast('Incorrect OTP Entered');
    }
  }
}