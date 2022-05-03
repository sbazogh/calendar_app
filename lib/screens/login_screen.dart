import 'package:calendar/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';
import 'home_screen.dart';

class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String errText = '';

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      Future.delayed(
        const Duration(milliseconds: 500),
            () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: kBlueColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 55),
            child: Column(
              children: [
                const Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image(
                      image: AssetImage('assets/images/logo.jpg'),
                    ),
                  ),
                ),
                TextField(
                  controller: emailController,
                  textDirection: TextDirection.rtl,
                  decoration: kInputDecoration.copyWith(
                    suffixIcon: const Icon(
                        Icons.email_outlined, color: Colors.grey),
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
                    suffixIcon: const Icon(
                        Icons.lock_outline, color: Colors.grey),
                    hintText: 'رمز عبور',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onButtonPressed();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12,),
                      child: Text(
                        'ورود به حساب کاربری',
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: const Text(
                        'ثبت نام',
                        style: TextStyle(
                          color: kBlueColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Text(
                      'رمز عبورتان را فراموش کرده اید؟',
                      style: TextStyle(
                        fontSize: 14,
                        color: kGreyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
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

  void onButtonPressed() {
    String email = emailController.text;
    String password = passwordController.text;
    bool status = validationForm(email, password);
    if (status == true) {
      try {
        auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim()
        )
            .then((value) {
          if (auth.currentUser != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  bool validationForm(String email, String password) {
    bool validation = true;
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (email == '' || password == '') {
      errText = 'Can not be empty!';
      validation = false;
    }
    else if (emailValid) {
      if (password.length < 6) {
        errText = 'Password must be at least 6 characters long!';
        validation = false;
      }
    }
    else {
      errText = 'Invalid email!';
      validation = false;
    }

    return validation;
  }


}


