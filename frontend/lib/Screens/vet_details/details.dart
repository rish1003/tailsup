import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Controllers/vet_model.dart';
import 'package:frontend/global.dart';
import 'package:http/http.dart' as http;
import '../../Controllers/config.dart';
import '../../Reusables/custommessage.dart';

class VetDetailsPage extends StatefulWidget {
  final Vet vet;

  const VetDetailsPage({required this.vet});

  @override
  State<VetDetailsPage> createState() => _VetDetailsPageState();
}

class _VetDetailsPageState extends State<VetDetailsPage> {
  int slotid = 0;
  DateTime selectedDate = DateTime.now();
  int selectedSlotIndex = -1;
  List<dynamic> slots =[];
  List<String> services = []; // List to store vet services
  List<String> appointmentSlots = []; // Initialize as an empty list

// Function to fetch and populate appointment slots from the API
  Future<void> fetchAppointmentSlots() async {
    try {
      final response = await http.get(
        Uri.parse(global.url+'/slots/'+widget.vet.phone),
      );

      if (response.statusCode == 200) {
        final List<dynamic> slotData = json.decode(response.body);

        setState(() {
          // Map the slot data to the desired format
          appointmentSlots = slotData.map<String>((slot) {
            final String startTime = slot['start_time'];
            final String endTime = slot['end_time'];
            return '$startTime - $endTime';
          }).toList();
          slots = slotData;
        });


      } else {
        throw Exception('Failed to load slots');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching slots: $e');
    }
  }

// Call the function to fetch appointment slots


  @override
  void initState() {
    super.initState();
    fetchVetServices();
    fetchAppointmentSlots();
  }

  Future<void> fetchVetServices() async {
    try {
      final response = await http.get(Uri.parse(global.url+'/services/'+widget.vet.phone));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<String> vetServices = responseData.map<String>((service) => service.toString()).toList();

        setState(() {
          services = vetServices;
        });
      } else {
        // Handle errors here, such as displaying an error message
        print('Failed to load vet services: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching vet services: $e');
    }
  }


  Widget buildAppointmentBookingUI(Size size) {
    // Replace this with your actual appointment slot data.

    // Initialize with current date

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Date Picker
        Text(
          'Select Appointment Date:',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != selectedDate) {
              setState(() {
                selectedDate = picked;
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: primaryColor2,
                size: 20,
              ),
              Text(
                '   ' +
                    '${selectedDate.toLocal()}'
                        .split(' ')[0], // Display selected date
                style: GoogleFonts.montserrat(
                  color: primaryColor2,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.0), // Available Slots
        Text(
          'Available Slots:',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: 8.0),
        // List of available appointment slots as small tiles
        Center(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: appointmentSlots.asMap().entries.map((entry) {
              final int index = entry.key;
              final String slot = entry.value;


              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSlotIndex = index;
                    slotid = slots[selectedSlotIndex]['id'];
                    print(slotid);
                  });
                  // Add your booking action logic here
                  // Example: bookAppointment(slot);
                },
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: index == selectedSlotIndex
                        ? primaryColor2 // Change border color if selected
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: primaryColor2,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    slot,
                    style: GoogleFonts.montserrat(
                      color: index == selectedSlotIndex
                          ? Colors.white // Change text color if selected
                          : primaryColor2,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 16.0),
        // Send Booking Request Button
        Center(
          child: ElevatedButton(
            onPressed: () async{
              var request = http.Request('GET', Uri.parse('http://192.168.60.189:8000/book/'));


              http.StreamedResponse response = await request.send();

              if (response.statusCode == 200) {
                CustomMessage.toast('Request Sent!');
                print(await response.stream.bytesToString());
              }
              else {
              print(response.reasonPhrase);
              }


            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor2,
            ),
            child: Text(
              'Send Booking Request',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _activeIndex = 0;
  final _pageViewController = PageController();

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final Vet vet = widget.vet;

    _pageViewController.addListener(() {
      setState(() {
        _activeIndex = _pageViewController.page!.round();
      });
    });

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: size.height * 0.6,
                  backgroundColor: Color(0x3b7dede),
                  automaticallyImplyLeading: true,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SizedBox(
                      height: size.height * 0.6,
                      child: PageView.builder(
                        itemCount: 1,
                        controller: _pageViewController,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: primaryColor2,
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: primaryColor2, // Border color
                                width: 8, // Border width
                              ),
                            ),
                            child: ClipRRect(
                              child: Image.network(
                                global.url + vet.picture!,
                                fit: BoxFit.fitHeight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(24.0),
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Original Back Button
                  Text(
                    vet.name,
                    style: GoogleFonts.montserrat(
                      color: primaryColor2,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    vet.address,
                    style: GoogleFonts.montserrat(
                      color: primaryColor2,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Phone: ${vet.phone}',
                    style: GoogleFonts.montserrat(
                      color: primaryColor2,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Email: ${vet.email}',
                    style: GoogleFonts.montserrat(
                      color: primaryColor2,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Services Provided',
                    style: GoogleFonts.montserrat(
                      color: primaryColor2,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  // Add your service details here as needed.
                  SizedBox(height: 12.0),

                  Card(
                    elevation: 4.0,
                    color: Color(0xed99d3d1),
                    // Add a margin at the bottom
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // List of services with bullet points and reduced spacing
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: services.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 2.0),
                            itemBuilder: (context, index) {
                              final service = services[index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, right: 8.0),
                                    child: Icon(
                                      Icons.brightness_1,
                                      size: 8.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      service,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30.0),
                  Text(
                    'Book an Appointment',
                    style: GoogleFonts.montserrat(
                      color: primaryColor2,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  // Add your service details here as needed.
                  SizedBox(height: 5.0), // Card for appointment booking
                  Card(
                    color: Color(0xed99d3d1),
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 8.0),
                          // Add your appointment booking UI here
                          buildAppointmentBookingUI(size),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))));
  }
}
