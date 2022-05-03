import 'package:flutter/material.dart';
import 'package:jalali_table_calendar/jalali_table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class StructureDailyNote extends StatefulWidget {
  StructureDailyNote({Key? key, required this.type, required this.id, required this.dataEvent}) : super(key: key);

  String type , id;
  Map dataEvent;

  @override
  State<StructureDailyNote> createState() => _StructureDailyNoteState();
}

class _StructureDailyNoteState extends State<StructureDailyNote> {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference eventsRef =
     FirebaseFirestore.instance.collection('calenderEvents');

  TextEditingController titleController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String errText = '';

  String _value = '';
  String dateNote = '';
  String timeNote = '';

  bool isEditing = false;

  String get type => widget.type;

  get dataEvent => widget.dataEvent;

  String? get id => id;

  Future selectDate() async {
    String picked = await jalaliCalendarPicker(
        context: context,
        convertToGregorian: false,
        showTimePicker: true,
        hore24Format: true);
    if (picked != null) setState(() => _value = picked);
    dateNote = _value.substring(0,10);
    timeNote = _value.substring(11,);
  }

  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(type == 'ویرایش'){
      titleController.text = dataEvent['title'];
      reasonController.text = dataEvent['reason'];
      descriptionController.text = dataEvent['description'];

      dateNote = dataEvent['date'];
      timeNote = dataEvent['time'];
      isEditing = true;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            type,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 45),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: kInputDecoration.copyWith(
                    hintText: 'عنوان',
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
                  controller: reasonController,
                  decoration: kInputDecoration.copyWith(
                    hintText: 'مناسبت',
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
                  controller: descriptionController,
                  decoration: kInputDecoration.copyWith(
                    hintText: 'توضیحات',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                    ),
                  ),
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: selectDate,
                      label: const Text(' تاریخ و ساعت', style: TextStyle(color: Colors.grey),),
                      icon: const Icon(Icons.today, color: Colors.grey),
                    ),
                    Text(dateNote),
                    Text(timeNote),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                (auth.currentUser != null) ? Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20,),
                      child: Text('یادآوری', style: TextStyle(color: Colors.grey,),),
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                        print(isSwitched);
                      },
                      activeTrackColor: kLightGreen,
                      activeColor: kGreenColor,

                    ),
                  ],
                ) : const SizedBox(height:5),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  // width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          onButtonPressed();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: Text(
                            'ذخیره',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kBlueColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: Text(
                            'انصراف',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kGreyColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
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

  void onButtonPressed() async{
    String title = titleController.text;
    String reason = reasonController.text;
    String description = descriptionController.text;

    Map<String, dynamic> newMap = Map();
    newMap['title'] = title;
    newMap['reason'] = reason;
    newMap['description'] = description;
    newMap['date'] = dateNote;
    newMap['time'] = timeNote;

    bool status = validationForm(title, reason, description, dateNote, timeNote);

    if(status == true){
      if(isEditing == true){
        try{
          eventsRef.doc(dateNote).collection(dateNote).doc(id)
              .update({
            'title' : title,
            'reason' : reason,
            'description' : description,
            'date' : dateNote,
            'time' : timeNote
          }).then((value) => print("Note Updated"));
        } catch (e) {
          print(e);
        }
      }
      else{
        try {
          eventsRef.doc(dateNote).collection(dateNote)
              .add(newMap).then((value) {
            print(value);
            resetValues();
          });
        } catch (e) {
          print(e);
        }
      }
      resetValues();
    }

  }

  bool validationForm(String title, String reason, String description, String date, String time){
    bool validation = true;
    setState(() {
      if(title == '' || reason == '' || description == '' || date == '' || time == ''){
        errText = 'Can not be empty!';
        validation = false;
      }
      else
      {
        //pass
      }
    });
    setState(() {
      errText = '';
    });
    return validation;
  }

  resetValues(){
    setState((){
      titleController.clear();
      reasonController.clear();
      descriptionController.clear();
      dateNote = '';
      timeNote = '';
    });
  }

}
