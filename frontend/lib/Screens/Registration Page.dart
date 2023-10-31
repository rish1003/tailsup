import 'package:flutter/material.dart';
import 'package:frontend/Reusables/formelements.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controllers/signin.dart';
import 'Sign Up.dart';
import 'SignIn.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  var signupconrol = Get.put(SignInControl());
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 13),
                      child: Image.asset(
                        "assets/loginp3.png",
                        width: 428,
                        height: 400,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top:50,left:30,right: 30),
                      child: Column(
                        textDirection: TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Register',
                            style: TextStyle(
                              color: Color(0xFF755DC1),
                              fontSize: 27,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height:20,
                          ),
                          FormTextField(fieldcontroller: _phoneController,obscure:false, keytype: TextInputType.text, hinttext: 'Name', hinttextcol: Color(0xFF755DC1), bordercol: Color(0xFF837E93)),
                          SizedBox(
                            height: 20,
                          ),
                          FormTextField(fieldcontroller: _passController,obscure:false, keytype: TextInputType.text, hinttext: 'Email', hinttextcol: Color(0xFF755DC1), bordercol: Color(0xFF837E93)),
                          SizedBox(
                            height: 20,
                          ),
                          FormTextField(fieldcontroller: _passController,obscure:false, keytype: TextInputType.text, hinttext: 'Address', hinttextcol: Color(0xFF755DC1), bordercol: Color(0xFF837E93)),
                          SizedBox(
                            height: 20,
                          ),
                          FormTextField(fieldcontroller: _passController,obscure:false, keytype: TextInputType.number, hinttext: 'Pincode', hinttextcol: Color(0xFF755DC1), bordercol: Color(0xFF837E93)),

                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: SizedBox(
                              width: 329,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () async{

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9F7BFF),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Have an account?',
                                style: TextStyle(
                                  color: Color(0xFF837E93),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 2.5,
                              ),
                              InkWell(
                                onTap: ()  {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignInPage()),
                                  );
                                },
                                child:  Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: Color(0xFF755DC1),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),

                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
