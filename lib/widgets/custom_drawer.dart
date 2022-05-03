import 'package:calendar/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/structure_daily_note.dart';
import '../constants.dart';

class CustomDrawer extends StatefulWidget {

  CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Image(
                    image: AssetImage('assets/images/logo.jpg'),
                  ),
                ),
              ),
            ],
          ),
          (auth.currentUser != null) ?
            ListTile(
              title: const Text(
              'خروج از حساب کاربری',
              ),
              trailing: const Icon(Icons.person_outline_outlined),
              onTap: () {
                auth.signOut();
                Navigator.pop(context);
              },
            )
          : ListTile(
            title: const Text(
              'ورود به حساب کاربری',
            ),
            trailing: const Icon(Icons.person_outline_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'یادآوری / یادداشت',
            ),
            trailing: const Icon(Icons.event_note_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StructureDailyNote(dataEvent: {}, id: '-1', type: 'افزودن',)),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'خروج',
            ),
            trailing: const Icon(Icons.exit_to_app),
            onTap: () {
              onExit(context);
            },
          ),
        ],
      ),
    );
  }
}
