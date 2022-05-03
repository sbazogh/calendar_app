import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persian_date/persian_date.dart' as pDate;

import '../widgets/happy_message.dart';
import 'daily_note_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    pDate.PersianDate currentDate = pDate.PersianDate(format: "\t\t\t\t\t  d \n MM  ");
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async{
        setState(() { });
        return;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            title: (auth.currentUser != null) ? HappyMessage() : const Center(child: Text('Calendar')),
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  onExit(context);
                },
                icon: const Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: size.height * 0.11,
                      decoration: const BoxDecoration(
                        color: kGreenColor,
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.26),
                      child: SizedBox(
                        // height: size.height * 0.6,
                        width: size.width,
                        child: const Center(child: CustomCalender(),),
                      ),
                    ),
                    Positioned(
                      left: size.width * 0.28,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                currentDate.now,
                                style: const TextStyle(
                                  color: kBlueColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'یادآوری های روز',
                  ),
                  leading: const Icon(Icons.event_note_outlined),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DailyNote()),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
