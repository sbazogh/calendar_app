import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kGreenColor = Color(0xFF63d2ca);
const kLightGreen = Color(0xFF8bd5ab);
const kGreyColor = Color(0xFF444444);
const kDarkBlue = Color(0xFF39405d);
const kBlueColor = Color(0xFF44ace3);


const kInputDecoration = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
    ),
  ),
);

void onExit(BuildContext context) {
  if(Platform.isAndroid){
    SystemNavigator.pop();
  }
  else if(Platform.isIOS){
    exit(0);
  }
  else{
    Navigator.pop(context);
  }
}