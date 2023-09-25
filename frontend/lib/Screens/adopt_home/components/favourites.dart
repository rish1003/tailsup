import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Controllers/config.dart';
import '../../../Controllers/pet_model.dart';
import '../../adopt_details/details.dart';
import 'package:frontend/global.dart';

class FavPetsPage extends StatefulWidget {
  const FavPetsPage({Key? key});

  @override
  State<FavPetsPage> createState() => _FavPetsPageState();
}

class _FavPetsPageState extends State<FavPetsPage> {
  List<Map<String, String>> pets = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetPets(); // Fetch pets when the page is initialized
  }

  Future<void> fetchAndSetPets() async {
    try {
      final List<Pet> fetchedPets = await PetShelter.fetchFavPets();
      final List<Map<String, String>> petDataList = fetchedPets
          .map((pet) => {
        'pet_name': pet.name,
        'breed': pet.breed,
        'shelter': pet.shelter.toString(),
        'age': pet.age.toString(),
        'weight': pet.weight.toString(),
        'gender': pet.gender,
        'special_need': pet.specialNeeds,
        'desc': pet.description,
        'pic': pet.picture,
        'pet_id': pet.petId.toString(),
      })
          .toList();

      setState(() {
        pets = petDataList; // Set the fetched pets in the state
      });
    } catch (error) {
      print('Failed to fetch pets: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        await fetchAndSetPets(); // Refresh pets when the user pulls down to refresh
      },
      child: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final petData = pets[index]; // Assuming pets is a List<Map<String, String>>

          final pet = Pet(
            petId: petData['pet_id'] ?? '', // Add the parameter names here
            name: petData['pet_name'] ?? '',
            shelter: petData['shelter'] ?? '',
            breed: petData['breed'] ?? '',
            age: petData['age'] ?? '',
            weight: petData['weight'] ?? '',
            gender: petData['gender'] ?? '',
            specialNeeds: petData['special_need'] ?? '',
            description: petData['desc'] ?? '',
            picture: petData['pic'] ?? '',
          );

          return GestureDetector(
            onTap: () async {
              var a = await PetShelter.fetchLikedPets();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('petid', pet.petId);
              prefs.setString('petname', pet.name);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PetDetailsPage(pet: pet)),
              );
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  pet.name,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                Icon(
                                  pet.gender == 'Male'
                                      ? Icons.male_rounded
                                      : Icons.female_rounded,
                                  color: primaryColor,
                                  size: 30,
                                ),
                              ],
                            ),
                            Text(
                              pet.breed,
                              style: GoogleFonts.montserrat(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              '${pet.age} years old',
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
                            color: const Color(0xff532754),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: const Color(0xff532754), // Border color
                              width: 8, // Border width
                            ),
                          ),
                          child: ClipRRect(
                            child: Image.network(
                              global.url + pet.picture!,
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
