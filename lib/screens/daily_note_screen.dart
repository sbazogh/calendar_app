import 'package:calendar/screens/structure_daily_note.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persian_date/persian_date.dart' as pDate;

import '../constants.dart';

class DailyNote extends StatelessWidget {
   DailyNote({Key? key}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  pDate.PersianDate currentDate = pDate.PersianDate(format: "yyyy-mm-dd");

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'یادآوری های روز',
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: firestore.collection('calenderEvents')
                    .doc(currentDate.now)
                    .collection(currentDate.now)
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map(
                            (doc) {
                          String id = doc.id;
                          Map data = doc.data() as Map;
                          return GestureDetector(
                            onTap: () {
                              if(auth.currentUser != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => StructureDailyNote(dataEvent: data,id: id,type: 'ویرایش')),
                                );
                              }
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(data['title']),
                                  subtitle: Text(data['reason']),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: kLightGreen,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        onDelete(data, id);
                                      },
                                    ),
                                  ),
                                  trailing: Text(
                                    data['time'],
                                    style: const TextStyle(
                                      color: kBlueColor,
                                    ),
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),

                          );
                        },
                      ).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StructureDailyNote(dataEvent: {}, id: '-1', type: 'افزودن',)),
            );
          },
          backgroundColor: kBlueColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

   onDelete(Map data, String id) async {
     firestore.collection('calenderEvents')
         .doc(currentDate.now)
         .collection(currentDate.now).doc(id).delete();
   }

}
