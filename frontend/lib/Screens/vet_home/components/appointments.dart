import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/vet_details/details.dart';
import 'package:frontend/global.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Controllers/pet_model.dart';
import 'package:frontend/Controllers/vet_model.dart';
import 'package:frontend/Controllers/config.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apptdeets.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class Appointment {
  final String id;
  final String date;
  final String time;
  final String vetName;
  final String isConfirmed;
  final String vetId;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.vetName,
    required this.isConfirmed,
    required this.vetId,
  });
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late Vet vet;
  List<Appointment> pastAppointments =
      []; // Replace with your past appointments data
  List<Appointment> upcomingAppointments =
      []; // Replace with your upcoming appointments data
  String message = '';



  fetchandgovet(ph) async {
    print(ph);
    final response =
        await http.get(Uri.parse((global.url) + '/userdetails/9980653944'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final Vet vet2 = Vet.fromJson(jsonData);

      setState(() {
        vet = vet2;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => VetDetailsPage(vet: vet)));
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetAppointments();
    fetchAndSetUpAppointments();// Fetch appointments when the page is initialized
  }

  Future<void> fetchAndSetAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph2 = prefs.getString('Phone');
    final url = (global.url) + '/appointments/past/' + ph2!.substring(3);

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Appointment> pastappointments = data.map((item) {
        return Appointment(
          id : item['id'].toString() ?? '',
          date: item['date'] ?? '',
          time: item['time'] ?? '',
          vetName: item['vetname'] ?? '',
          isConfirmed: item['status'].toString() ?? '',
          vetId: item['vetid'] ?? '',
        );
      }).toList();
      print(pastappointments);
      setState(() {
        pastAppointments = pastappointments;
      });
    } else {
      throw Exception('Failed to load past appointments');
    }
  }

  Future<void> fetchAndSetUpAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph2 = prefs.getString('Phone');
    final url2 = (global.url) + '/appointments/upcoming/' + ph2!.substring(3);

    final response2 = await http.get(Uri.parse(url2));

    if (response2.statusCode == 200) {
      final List<dynamic> data2 = json.decode(response2.body);
      final List<Appointment> upappointments = data2.map((item) {
        return Appointment(
          id : item['id'].toString() ?? '',
          date: item['date'] ?? '',
          time: item['time'] ?? '',
          vetName: item['vetname'] ?? '',
          isConfirmed: item['status'].toString() ?? '',
          vetId: item['vetid'] ?? '',
        );
      }).toList();

      setState(() {
        upcomingAppointments = upappointments;
      });
    } else {
      throw Exception('Failed to load past appointments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Past and Upcoming
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.add,color: Colors.grey[200]),
          backgroundColor:
              Colors.grey[200], // Set the background color of the AppBar
          bottom: TabBar(
            indicatorColor: primaryColor2,
            labelColor: primaryColor2,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildAppointmentsList(
                upcomingAppointments, Color(0x800BECEC), true),
            buildAppointmentsList(pastAppointments, Color(0x80569898), false),
          ],
        ),
      ),
    );
  }

  Widget buildAppointmentsList(
      List<Appointment> appointments, Color col, bool status) {
    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            color: col,
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${appointment.date}',
                      style: GoogleFonts.montserrat(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${appointment.time}',
                      style: GoogleFonts.montserrat(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                subtitle: InkWell(
                  onTap: () {
                    fetchandgovet(appointment.vetId);
                  },
                  child: Text(
                    'Vet: ${appointment.vetName}',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.0,
                      decoration: TextDecoration
                          .underline, // Add underline to indicate it's clickable
                      color: Colors
                          .white, // Change color to indicate it's clickable
                    ),
                  ),
                ),
                onTap: () async {
                  final response = await http.get(Uri.parse(
                      (global.url) + '/userdetails/9980653944'));
                  print(appointment.vetId+"hey");

                  if (response.statusCode == 200) {
                    final Map<String, dynamic> jsonData =
                        json.decode(response.body);
                    final Vet vet2 = Vet.fromJson(jsonData);

                    setState(() {
                      vet = vet2;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AppointmentRePage(vet: vet,apptid: appointment.id)));
                  } else {
                    print(response.reasonPhrase);
                  }
                },
                trailing: status == true
                    ? appointment.isConfirmed == 'true'
                        ? Text(
                            'Confirmed',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            'Not Confirmed',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                    : Text('')),
          );
        },
      ),
    );
  }
}
