

import 'dart:convert';
import 'package:frontend/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:frontend/Controllers/config.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controllers/vet_model.dart';
import '../../../utils/spacing_widgets.dart';
import '../../vet_details/details.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http; // Import http for downloading the PDF


class AppointmentRePage extends StatefulWidget {
  final Vet vet;
  final String apptid;
  const AppointmentRePage({super.key, required this.vet, required this.apptid});

  @override
  State<AppointmentRePage> createState() => _AppointmentRePageState();
}
class Medical {
  final String userId;
  final String vetId;
  final String date;
  final String diagnosis;
  final String treatment;
  final String report;

  Medical({
    required this.userId,
    required this.vetId,
    required this.date,
    required this.diagnosis,
    required this.treatment,
    required this.report,
  });

}


class _AppointmentRePageState extends State<AppointmentRePage> {
  @override
  void initState() {
    super.initState();
    fetchDiagnoses();
  }


  late Medical medical;
  var res2=null;
  Future<void> fetchDiagnoses() async {

    try {
          var request = http.Request('GET', Uri.parse((global.url) + '/appointments/diagnoses/' + widget.apptid));


      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      var res = jsonDecode(data);
      setState(() {
        res2 = res;
        print(res);
      });
    } catch (e) {
      // Handle network errors
      print('Error fetching diagnoses: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:  AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.medical_services,
                      color: Color(0xff0d6b6a),
                    ),
                    addHorizontalSpace(5.0),
                    Text(
                      'Appointment Details',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0d6b6a),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(

                elevation: 4.0,
                color: primaryColor2,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: 360 ,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date:'+ (res2 != null ? res2[0]['date'] : 'N/A'),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                color: Color(0x9B79D5C9), // Set a different color here
                margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VetDetailsPage(vet: widget.vet),
                            ),
                          );
                        },
                        child: Text(
                          'Vet:'+widget.vet.name, // Assuming 'vet' has a 'name' property
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontSize: 16.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Diagnosis:'+(res2 != null ? res2[0]['diagnosis'] : 'N/A'),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Course of Treatment:' +(res2 != null ? res2[0]['treatment'] : 'N/A'),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImageDialog(path: (res2 != null ? res2[0]['report'] : 'N/A'));
                    },
                  );
                },
                child: Center(
                  child: Text(
                    'View Report PDF',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Montserrat',
                      color: primaryColor2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ImageDialog extends StatelessWidget {
  final String path;
  const ImageDialog({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: primaryColor2,
      title: Text('Medical Report',style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Montserrat', color: Colors.white,fontWeight: FontWeight.bold

      ),),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white)
          ),
          child: Image.network(
            global.url + path, fit: BoxFit.contain,
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            // Close the dialog when the "Close" button is clicked
            Navigator.of(context).pop();
          },
          child: Text('Close',style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Montserrat', color: Colors.white,fontWeight: FontWeight.bold

          ),),
        ),
      ],
    );
  }
}
