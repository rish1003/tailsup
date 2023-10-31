import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Reusables/formelements.dart';
import '../Reusables/custommessage.dart';
import 'SignIn.dart';
import 'MainPage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  // Define error booleans for each field
  bool isPasswordError = false;
  bool isConfirmPasswordError = false;
  bool isEmailError = false;
  bool isPincodeError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... The rest of your code ...

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
      // ... The rest of your code ...

      // When the "Register" button is pressed, validate the fields and set error flags
      ElevatedButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? ph = prefs.getString('Phone');

          if (_passController.text != _confirmPassController.text) {
            isPasswordError = true;
            isConfirmPasswordError = true;
          } else {
            isPasswordError = false;
            isConfirmPasswordError = false;
          }

          if (_pincodeController.text.length != 6) {
            isPincodeError = true;
          } else {
            isPincodeError = false;
          }

          final emailPattern = RegExp(
              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,4})$');

          if (!emailPattern.hasMatch(_emailController.text)) {
            isEmailError = true;
          } else {
            isEmailError = false;
          }

          setState(() {}); // Redraw the UI to reflect error changes

          if (!isPasswordError && !isConfirmPasswordError && !isPincodeError && !isEmailError) {
            final response = await http.post(
              Uri.parse('YOUR_API_ENDPOINT'), // Replace with your API endpoint
              body: {
                'phone': ph,
                'name': _nameController.text,
                'email': _emailController.text,
                'password': _passController.text,
                'address': _addressController.text,
                'pincode': _pincodeController.text,
              },
            );

            if (response.statusCode == 201) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            } else {
              CustomMessage.toast('Not Created');
            }
          }
        },
        // ... The rest of your code ...
      ),
    );
  }
}
