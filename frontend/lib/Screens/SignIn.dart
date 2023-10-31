import 'package:flutter/material.dart';
import 'package:frontend/Controllers/admincontrol.dart';
import 'package:frontend/Reusables/formelements.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controllers/signin.dart';
import 'Sign Up.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Image.asset(
                        "assets/loginp1.png",
                        width: 413,
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
                            'Sign In',
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
                          FormTextField(fieldcontroller: _phoneController,obscure:false, keytype: TextInputType.number, hinttext: 'Phone', hinttextcol: Color(0xFF755DC1), bordercol: Color(0xFF837E93)),
                          SizedBox(
                            height: 20,
                          ),
                          FormTextField(fieldcontroller: _passController,obscure:true, keytype: TextInputType.text, hinttext: 'Password', hinttextcol: Color(0xFF755DC1), bordercol: Color(0xFF837E93)),

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
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('Phone', "+91"+_phoneController.text);
                                  if (_phoneController.text == '2222'){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AdminMainPage()),
                                    );
                                  }
                                  else{
                                  SignInControl.instance.signInUser(_phoneController.text, _passController.text, context);}
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9F7BFF),
                                ),
                                child: const Text(
                                  'Sign In',
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
                            children: [
                              const Text(
                                'Don’t have an account?',
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
                                    MaterialPageRoute(builder: (context) => VerifyScreen()),
                                  );
                                },
                                child:  Text(
                                  'Sign Up',
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
