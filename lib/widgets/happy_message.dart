import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persian_date/persian_date.dart' as pDate;

class HappyMessage extends StatelessWidget {
  HappyMessage({Key? key}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    pDate.PersianDate currentDate = pDate.PersianDate(format: "m-d");
    String currentdate = currentDate.now;
    String userId = auth.currentUser!.uid;
    bool isBirth = false;

    return StreamBuilder(
        stream: firestore.collection('Users').where('userId', isEqualTo: userId).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot<Object?>? query = snapshot.data;
            if (query!.docs.isEmpty) {
              return const Center(
                  child: Text(''));
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: snapshot.data!.docs.map(
                    (QueryDocumentSnapshot doc) {
                  Map data = doc.data() as Map;
                  String birthday = data['birthday'];
                  String birthMonth = birthday.substring(5);
                  isBirth = (birthMonth == currentdate);
                  if(isBirth) {
                    return Text(
                      '* ${data['displayName']} جان تولدت مبارک * ',
                      style: const TextStyle(
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const Text('Calendar');
                },
              ).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }

}
