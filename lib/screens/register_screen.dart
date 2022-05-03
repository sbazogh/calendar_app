import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jalali_table_calendar/jalali_table_calendar.dart';

import '../constants.dart';
import 'login_screen.dart';

class Register extends StatefulWidget {

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference userRef =
      FirebaseFirestore.instance.collection('Users');

  String errText = '';

  String datetime = '';
  String _format = 'yyyy-mm-dd';
  String valuePiker = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              children: [
                const Center(
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: Image(
                      image: AssetImage('assets/images/logo.jpg'),
                    ),
                  ),
                ),
                TextField(
                  controller: nameController,
                  textDirection: TextDirection.rtl,
                  decoration: kInputDecoration.copyWith(
                    suffixIcon: const Icon(Icons.person_outline_outlined, color: Colors.grey),
                    hintText: 'نام کاربری',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: emailController,
                  textDirection: TextDirection.rtl,
                  decoration: kInputDecoration.copyWith(
                    suffixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    hintText: 'ایمیل',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: passwordController,
                  textDirection: TextDirection.rtl,
                  decoration: kInputDecoration.copyWith(
                    suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    hintText: 'رمز عبور',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[100],
                  ),
                  child: GestureDetector(
                    onTap: birthdayDialog,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'تاریخ تولد ', style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                        ),
                        Icon(Icons.today, color: Colors.grey, textDirection: TextDirection.rtl,),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      onButtonPressed();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, ),
                      child: Text(
                        'ثبت نام',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kGreenColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: const Text(
                        'ورود ',
                        style: TextStyle(
                          color: kBlueColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Text(
                      'در حال حاضر یک حساب کاربری دارید؟',
                      style: TextStyle(
                        fontSize: 14,
                        color: kGreyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  errText,
                  style: const TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void birthdayDialog() {
    const bool showTitleActions = false;
    DatePicker.showDatePicker(context,
        minYear: 1300,
        maxYear: 1450,
        confirm: const Text(
          'تایید',
          style: TextStyle(color: Colors.red),
        ),
        cancel: const Text(
          'لغو',
          style: TextStyle(color: Colors.cyan),
        ),
        dateFormat: _format, onChanged: (year, month, day) {
          if (!showTitleActions) {
            changeDatetime(year, month, day);
          }
        }, onConfirm: (year, month, day) {
          changeDatetime(year, month, day);
          valuePiker = datetime;
        });

  }
  void changeDatetime(int year, int month, int day) {
    setState(() {
      datetime = '$year-$month-$day';
    });
  }

  void onButtonPressed(){
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    Map<String, dynamic> newMap = Map();
    newMap['displayName'] = name;
    newMap['email'] = email;
    newMap['password'] = password;
    newMap['birthday'] = valuePiker;

    bool status = validationForm(name, email, password, valuePiker);

    if(status == true){
      try {
        auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        )
            .then((value) {
          newMap['userId'] = value.user!.uid;
          userRef.add(newMap).then((value) => print(value));
          resetValues();
        });
      } catch (e) {
        print(e);
      }
    }
    else{
      //pass
    }
  }

  bool validationForm(String name, String email, String password, String valuePiker){
    bool validation = true;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    setState(() {
      if(name == '' || email == '' || password == '' || valuePiker == ''){
        errText = 'Can not be empty!';
        validation = false;
      }
      else if(emailValid)
      {
        if(password.length < 6)
        {
          errText = 'Password must be at least 6 characters long!';
          print('Password must be at least 6 characters long!');
          validation = false;
        }
      }
      else
      {
        errText = 'Invalid email!';
        print('Invalid email!');
        validation = false;
      }
    });
    setState(() {
      errText = '';
    });
    return validation;
  }

  resetValues(){
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }



}

