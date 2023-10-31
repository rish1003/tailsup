import 'package:flutter/material.dart';
import 'package:frontend/Reusables/formelements.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Controllers/homescreencontrol.dart';
import '../Controllers/signin.dart';
import '../Reusables/custommessage.dart';
import 'package:frontend/global.dart';
import 'Sign Up.dart';
import 'SignIn.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  var signupconrol = Get.put(SignInControl());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  bool isPasswordError = false;
  bool isConfirmPasswordError = false;
  bool isEmailError = false;
  bool isPincodeError = false;

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
                          FormTextField(fieldcontroller: _nameController,obscure:false, keytype: TextInputType.text, hinttext: 'Name', hinttextcol: Color(0xFF755DC1), bordercol: Color(0xFF837E93)),
                          SizedBox(
                            height: 20,
                          ),
                          FormTextField(
                            fieldcontroller: _passController,
                            obscure: true,
                            keytype: TextInputType.text,
                            hinttext: 'Password',
                            hinttextcol: Color(0xFF755DC1),
                            bordercol: isPasswordError ? Colors.red : Color(0xFF837E93), // Red border on error
                          ),
                          SizedBox(height: 20),
                          FormTextField(
                            fieldcontroller: _confirmPassController,
                            obscure: true,
                            keytype: TextInputType.text,
                            hinttext: 'Confirm Password',
                            hinttextcol: Color(0xFF755DC1),
                            bordercol: isConfirmPasswordError ? Colors.red : Color(0xFF837E93), // Red border on error
                          ),
                          SizedBox(height: 20),
                          FormTextField(
                            fieldcontroller: _emailController,
                            obscure: false,
                            keytype: TextInputType.emailAddress,
                            hinttext: 'Email',
                            hinttextcol: Color(0xFF755DC1),
                            bordercol: isEmailError ? Colors.red : Color(0xFF837E93), // Red border on error
                          ),
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
                                  print("hey");
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String? ph = prefs.getString('Phone');
                                  print("hey");
                                  if (_passController.text != _confirmPassController.text) {
                                    isPasswordError = true;
                                    isConfirmPasswordError = true;
                                  } else {
                                    isPasswordError = false;
                                    isConfirmPasswordError = false;
                                  }

                                  final emailPattern = RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,4})$');

                                  if (!emailPattern.hasMatch(_emailController.text)) {
                                    isEmailError = true;
                                  } else {
                                    isEmailError = false;
                                  }

                                  setState(() {}); // Redraw the UI to reflect error changes
                                  prefs.setString('Name', _nameController.text);
                                  if (!isPasswordError && !isConfirmPasswordError && !isEmailError) {
                                    final response = await http.post(
                                      Uri.parse((global.url)+'/register/'), // Replace with your API endpoint
                                      body: {
                                        'phone': ph?.substring(3),
                                        'name': _nameController.text,
                                        'email': _emailController.text,
                                        'password': _passController.text,
                                        'address': '_addressController.text',
                                        'pincode': '123456',
                                        'is_vet': 'false',
                                        'is_vendor':'false',
                                        'is_shelter':'false'
                                      },
                                    );

                                    if (response.statusCode == 201) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MainPage()),
                                      );
                                    } else {
                                      print(response.body);
                                      CustomMessage.toast('Not Created');
                                    }
                                  }
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
