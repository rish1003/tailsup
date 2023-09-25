import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controllers/config.dart';
import 'package:frontend/global.dart';

import '../Controllers/pet_data.dart';
import '../Reusables/vetcard.dart';
import 'PetAdd.dart';

class PetDetails extends StatefulWidget {
  List<Map<String, String>> petsData; // List of pet data
  int selectedPetIndex = 0;
  PetDetails({required this.petsData});
  @override
  _PetDetailsState createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  var hasappts;
  @override
  void initState(){
    super.initState();
    getAppts();
    fetchAndSetPets();
  }

  Future<void> fetchAndSetPets() async {
    try {
      final List<Pet> fetchedPets = await PetService.fetchPets();
      final List<Map<String, String>> petDataList = fetchedPets
          .map((pet) => {
        'pet_name': pet.name,
        'breed': pet.breed,
        'age': pet.age,
        'weight': pet.weight,
        'gender': pet.gender,
        'special_need': pet.specialNeeds,
        'desc': pet.description,
        'pic': pet.picture
      })
          .toList();

      setState(() {
        widget.petsData = petDataList; // Set the fetched pets in the state
      });
    } catch (error) {
      print('Failed to fetch pets: $error');
    }
  }

  getAppts() async{
    setState(() {
      hasappts = false;
    });

  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (widget.petsData.isEmpty ||
        widget.selectedPetIndex < 0 ||
        widget.selectedPetIndex >= widget.petsData.length) {
      // Handle the case where petsData is empty or currentIndex is out of range.
      return Center(
        child: Text('No pet data available'),
      );
    }
    final currentPet = widget.petsData[widget.selectedPetIndex];

    final petName = currentPet['pet_name'];
    final breed = currentPet['breed'];
    final age = currentPet['age'];
    final weight = currentPet['weight'];
    final gender = currentPet['gender'];
    final specialNeed = currentPet['special_need'];
    final description = currentPet['desc'];
    final picture = currentPet['pic'];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement the refresh logic here
          // You can call the fetchAndSetPets method or any other logic to update the data
          await fetchAndSetPets();
        },
        child: Column(
          children: [
            // Image
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: DropdownButton<int>(
                      icon: Icon(
                        Icons.pets,
                        color: Colors.grey,
                      ),
                      dropdownColor: Colors.grey,
                      value: widget.selectedPetIndex,
                      items: List.generate(
                        widget.petsData.length,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text(
                            'Pet ${index + 1}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ), // Customize the text as needed
                        ),
                      ),
                      onChanged: (newIndex) {
                        setState(() {
                          widget.selectedPetIndex = newIndex!;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child:  ElevatedButton(
                      onPressed: () async{
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreatePetPage()),
                        );
                      //
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // Background color
                      ),
                      child: Icon(Icons.add,color: Colors.white,)
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              color: Colors.white,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 0.75 * width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFF9E1D2),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    border: Border.all(
                      color: Color(0xFFF9E1D2),// Border color
                      width: 8, // Border width
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(
                              20)), // Apply border radius to the image
                      child:
                          Image.network(global.url + picture!, fit: BoxFit.fill)),
                ),
              ),
            ),
            // Details Box

            // Description (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left:20.0,right:20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 2, // Border width
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  petName!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Icon(
                                  gender == 'Male'
                                      ? Icons.male_rounded
                                      : Icons.female_rounded,
                                  color: Colors.grey[500],
                                  size: 30,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  breed!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                    letterSpacing: 0.7,
                                  ),
                                ),
                                Text(
                                  age! + ' years old',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.plus_one,
                                      color: primaryColor,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    specialNeed?.isNotEmpty == true
                                        ? Text(
                                      specialNeed!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[400],
                                        letterSpacing: 0.8,
                                      ),
                                    )
                                        : Text(
                                      'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[400],
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  weight! + ' kgs',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,

                      ),
                    ),
                    Text(
                      description!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                        letterSpacing: 0.7,
                      ),
                    ),
                    SizedBox(height:20),
                    //med his
                    Text(
                      "Medical History",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,

                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 2, // Border width
                        ),

                        color: Colors.white,
                      ),
                      height: 0.2 * height,
                      padding: EdgeInsets.only(top:20,bottom: 20),
                      child: PageView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          buildMedical("assets/vet.jpeg", "22-09-2023", "Tick Fever",height,width),
                          buildMedical("assets/vet.jpeg", "23-09-2023", "Fever",height,width),


                        ],
                      ),
                    ),
                    // appts
                    SizedBox(height:20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          "Appointments",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,

                          ),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),

                          child: SizedBox(
                            width: 80,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () async{


                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent, // Background color
                              ),
                              child: const Text(
                                'Book',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 2, // Border width
                        ),

                        color: Colors.white,
                      ),
                      height: 0.2 * height,
                      padding: EdgeInsets.only(top:20,bottom: 20),
                      child: PageView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          hasappts == true ?
                          buildAppointments("assets/vet.jpeg", "22-09-2023", "vetid",height,width) :
                          Center(child: Text('No Upcoming Appts')),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
