import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget{
  final TextEditingController fieldcontroller;
  final TextInputType keytype;
  final String hinttext;
  final Color hinttextcol;
  final Color bordercol;
  final bool obscure;

  FormTextField({required this.fieldcontroller, required this.keytype, required this.hinttext, required this.hinttextcol, required this.bordercol, required this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: fieldcontroller,
      obscureText: obscure,
      textAlign: TextAlign.center,
      keyboardType: keytype,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      style: const TextStyle(
        color: Color(0xFF393939),
        fontSize: 13,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: hinttext,
        labelStyle: TextStyle(
          color: hinttextcol,
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: bordercol,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: hinttextcol,
          ),
        ),
      ),
    );
  }

}

class FormButton extends StatelessWidget{
  Function? pressFunc;
  Color bgcolor;
  String hinttext;
  FormButton({required this.pressFunc,required this.bgcolor,required this.hinttext});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: SizedBox(
        width: 329,
        height: 56,
        child: ElevatedButton(
          onPressed: () => pressFunc,
          style: ElevatedButton.styleFrom(
            backgroundColor:  bgcolor,
          ),
          child: Text(
            hinttext,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

}