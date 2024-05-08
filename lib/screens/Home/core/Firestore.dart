

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
  Future getStarted_addData(String categoryName, String amount, String date, String selectedColor) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Get the current user
    User? userauth = auth.currentUser;
    // [START get_started_add_data_1]
    // Create a new user with a first and last name
    final user = <String, dynamic>{
     
      "date":date,
      "category name": categoryName,
      "Amount": amount,
      "Color": selectedColor,

    };
    print("working");
    // Add a new document with a generated ID
    db.collection('${userauth!.email}').add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
    // [END get_started_add_data_1]
  }

