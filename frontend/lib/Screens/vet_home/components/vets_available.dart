import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Controllers/config.dart';
import '../../../Controllers/pet_model.dart';
import 'package:frontend/global.dart';

import '../../../Controllers/vet_model.dart';
import '../../adopt_details/details.dart';
import '../../vet_details/details.dart';

class VetsAvailable extends StatefulWidget {
  const VetsAvailable({Key? key});

  @override
  State<VetsAvailable> createState() => _VetsAvailableState();
}

class _VetsAvailableState extends State<VetsAvailable> {
  List<Map<String, String>> vets = [];
  @override
  void initState() {
    super.initState();
    fetchAndSetVets();
  }

  Future<void> fetchAndSetVets() async {
    print('object');
    try {
      final List<Vet> fetchedVets = await VetService.fetchVets();
      final List<Map<String, String>> vetDataList = fetchedVets
          .map((vet) => {
                'name': vet.name,
                'phone': vet.phone,
                'picture': vet.picture,
                'email': vet.email,
                'phone': vet.phone,
                'address': vet.address,
                'pincode': vet.pincode
              })
          .toList();

      setState(() {
        vets = vetDataList; // Set the fetched vet in the state
      });
    } catch (error) {
      print('Failed to fetch vets: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: vets.length,
      itemBuilder: (context, index) {
        final petData =
            vets[index]; // Assuming pets is a List<Map<String, String>>

        final vet = Vet(
          name: petData['name'] ?? '',
          picture: petData['picture'] ?? '',
          phone: petData['phone'] ?? '',
          email: petData['email'] ?? '',
          address: petData['address'] ?? '',
          pincode: petData['pincode'] ?? '',
        );

        return GestureDetector(
            onTap: () async {
              var a = await PetShelter.fetchLikedPets();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('vetid', vet.phone);
              prefs.setString('vetname', vet.name);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VetDetailsPage(vet: vet)));
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        padding: const EdgeInsets.fromLTRB(18.0, 0, 8.0, 0),
                        width: size.width * .45,
                        height: size.height * .2,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              vet.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),

                            Text(
                              vet.phone,
                              style: GoogleFonts.montserrat(
                                fontSize: 13.0,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              vet.address,
                              style: GoogleFonts.montserrat(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(top: 30.0),
                            width: size.width * .45,
                            height: size.height * .25,
                            decoration: BoxDecoration(
                                color: primaryColor2,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: primaryColor2, // Border color
                                  width: 8, // Border width
                                )),
                            child: ClipRRect(
                              child: Image.network(
                                global.url + vet.picture!,
                                fit: BoxFit.fitHeight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
