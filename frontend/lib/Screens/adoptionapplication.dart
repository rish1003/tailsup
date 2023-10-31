import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Controllers/config.dart';
import '../../../Controllers/pet_model.dart';
import 'package:frontend/global.dart';

import '../utils/spacing_widgets.dart';
import 'adopt_details/details.dart';

class AdoptionApplicationTracking extends StatefulWidget {
  const AdoptionApplicationTracking({Key? key});

  @override
  State<AdoptionApplicationTracking> createState() =>
      _AdoptionApplicationTrackingState();
}

class _AdoptionApplicationTrackingState
    extends State<AdoptionApplicationTracking> {
  List<Map<String, dynamic>> adoptionApplications = [];
  String username = "";

  @override
  void initState() {
    super.initState();
    fetchAndSetAdoptionApplications();
  }

  Future<void> fetchAndSetAdoptionApplications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('Phone');
    try {
      // Make an HTTP GET request to fetch adoption applications
      final response = await http.get(
          Uri.parse(global.url + '/fetch_adoption/'+ph!.substring(3)+"/"));

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          username = data['username'];
          adoptionApplications = List<Map<String, dynamic>>.from(data['adoption_applications']);
        });
      }  else {
        throw Exception(
            'Failed to fetch adoption applications: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch adoption applications: $error');
    }
  }

  Future<void> refreshAdoptionApplications() async {
    await fetchAndSetAdoptionApplications();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.favorite,
                      color: Color(0xff532754),
                    ),
                    addHorizontalSpace(5.0),
                    Text(
                      'Adoption Applications',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff532754),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshAdoptionApplications,
        child: Container(
          margin: EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: adoptionApplications.length,
            itemBuilder: (context, index) {
              final applicationData = adoptionApplications[index];

              return GestureDetector(
                onTap: () {},
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Date Applied On: ${applicationData['date']}',
                          style: GoogleFonts.montserrat(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'User Name: $username',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Pet Name: ${applicationData['pet_name']}',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Reason: ${applicationData['reason']}',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Status: ${applicationData['status'] ? 'Approved' : 'Pending'}',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.0,
                            color: applicationData['status'] ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
