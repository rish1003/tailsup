import 'package:flutter/material.dart';
import 'package:frontend/global.dart';

Widget buildVet(
    String imageUrl, String name, String phone, double height, double width) {
  return Container(
    margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(25),
      ),
      border: Border.all(
        width: 1,
        color: Colors.grey,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 0.30 * width,
          height: 0.20 * height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image.network(global.url + imageUrl, fit: BoxFit.fill)),
        ),
        SizedBox(
          width: 16,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.grey[800],
                    size: 18,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    phone,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildMedical(String imageUrl, String date, String diagnosis,
    double height, double width) {
  return Container(
    margin: EdgeInsets.only(left: 16, right: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(25),
      ),
      border: Border.all(
        width: 1,
        color: Colors.grey,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 0.30 * width,
          height: 0.20 * height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(30), // Apply border radius to the image
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.report,
                    color: Colors.grey[800],
                    size: 12,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    diagnosis,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildAppointments(
    String imageUrl, String date, String vetId, double height, double width) {
  return Container(
    margin: EdgeInsets.only(left: 16, right: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(25),
      ),
      border: Border.all(
        width: 1,
        color: Colors.grey,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 0.30 * width,
          height: 0.20 * height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(30), // Apply border radius to the image
            child: Image.asset(
              imageUrl, // Replace with your image URL
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.report,
                    color: Colors.grey[800],
                    size: 12,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Vet ID: $vetId',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  print('hey');
                },
                child: Text(
                  'View Vet Details',
                  style: TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
