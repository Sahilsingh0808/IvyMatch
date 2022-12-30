import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ivymatch/page2.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  List labels = [];
  FToast fToast = new FToast();

  List labelData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    fetchAllContact();
    fToast = FToast();
    fToast.init(context);
  }

  List gender = [];
  List<String> occupation = [];
  Future<void> fetchAllContact() async {
    await Firebase.initializeApp();
    print("SAHIL");
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('form fields').get();
    snap.docs.forEach((document) {
      setState(() {
        labels.add(document.id);
        final Map<String, dynamic> convertedData =
            jsonDecode(jsonEncode(document.data()));
        labelData.add(convertedData);
        print(document.data().runtimeType);
        if (document.id == "gender") {
          setState(() {
            String a = labelData[2]['value'];
            gender = a.split("%");
          });
        }
        if (document.id == "occupation") {
          setState(() {
            String a = labelData[4]['value'];
            occupation = a.split("%");
            dropdownvalue = occupation[0];
          });
        }
      });
    });
    print(labelData);
  }

  String selectGender = "";
  String dropdownvalue = "";
  String name = "";
  int age = 0;
  String email = "";

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: selectGender,
          onChanged: (value) {
            setState(() {
              print(value);
              selectGender = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  setFilters() {
    setState(() {
      dropdownvalue = occupation[0];
    });
  }

  save() async {
    print(age.toString() + email + selectGender + name + dropdownvalue);
    if (age == 0) {
      showSnack("Age is empty");
    } else if (email == "") {
      showSnack("Email is empty");
    } else if (email.contains('@') == false || email.contains('.') == false) {
      showSnack("Email is invalid");
    } else if (selectGender == "") {
      showSnack("Gender is empty");
    } else if (name == "") {
      showSnack("Name is empty");
    } else if (dropdownvalue == "Occupation") {
      showSnack("Occupation is empty");
    } else {
      CollectionReference students =
          FirebaseFirestore.instance.collection('users');
      await students.doc(email).set({
        //Data added in the form of a dictionary into the document.
        'name': name,
        'age': age,
        'gender': selectGender,
        'email': email,
        'occupation': dropdownvalue
      }).then((value) {
        showSnack("User Added Successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Page2()),
        );
      });
    }
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  void showSnack(String text) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty),
          SizedBox(
            width: 12.0,
          ),
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Page2()),
                  );
                });
              },
            ),
            body: (labels.length == 0)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    // ignore: sort_child_properties_last
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: 300,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 45, 247, 19),
                                    Color.fromARGB(255, 0, 47, 17)
                                  ]),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 4,
                                        spreadRadius: 3,
                                        color: Colors.black12)
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(200),
                                      bottomRight: Radius.circular(200))),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 25, left: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      ' Register',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black45,
                                                offset: Offset(1, 1),
                                                blurRadius: 5)
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            for (int i = 0; i < labels.length; i++)
                              (i == 0 || i == 1 || i == 3)
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30)
                                              .copyWith(bottom: 10),
                                      child: TextField(
                                        onChanged: (String? value) {
                                          setState(() {
                                            if (i == 0) {
                                              age = int.parse(value!);
                                            } else if (i == 1) {
                                              email = value!;
                                            } else if (i == 3) {
                                              name = value!;
                                            }
                                          });
                                        },
                                        keyboardType: (i == 0)
                                            ? TextInputType.number
                                            : TextInputType.name,
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 14.5),
                                        decoration: InputDecoration(
                                            prefixIconConstraints:
                                                BoxConstraints(minWidth: 45),
                                            prefixIcon: Icon(
                                              (i == 3)
                                                  ? Icons.person
                                                  : (i == 1
                                                      ? Icons.email
                                                      : i == 0
                                                          ? Icons.numbers
                                                          : Icons
                                                              .check_box_outline_blank),
                                              color:
                                                  Color.fromARGB(179, 0, 0, 0),
                                              size: 22,
                                            ),
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter ' + labels[i].toString(),
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    153, 0, 0, 0),
                                                fontSize: 14.5),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(100)
                                                    .copyWith(
                                                        bottomRight:
                                                            Radius.circular(0)),
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        97, 48, 47, 47))),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(100)
                                                    .copyWith(
                                                        bottomRight:
                                                            Radius.circular(0)),
                                                borderSide: BorderSide(color: Colors.white70))),
                                      ),
                                    )
                                  : (i == 2)
                                      ? Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              addRadioButton(0, 'Male'),
                                              addRadioButton(1, 'Female'),
                                              addRadioButton(2, 'Others'),
                                            ],
                                          ),
                                        )
                                      : (i == 4)
                                          ? Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                        horizontal: 30)
                                                    .copyWith(bottom: 10),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      DropdownButtonFormField(
                                                        // Initial Value

                                                        // Down Arrow Icon
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),

                                                        // Array list of items
                                                        items: occupation.map(
                                                            (String items) {
                                                          return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items),
                                                          );
                                                        }).toList(),

                                                        decoration: InputDecoration(
                                                            filled: true,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey[800]),
                                                            hintText:
                                                                "Occupation",
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(100).copyWith(
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            0)),
                                                                borderSide: BorderSide(
                                                                    color:
                                                                        Color.fromARGB(
                                                                            97,
                                                                            48,
                                                                            47,
                                                                            47))),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(100)
                                                                        .copyWith(bottomRight: Radius.circular(0)),
                                                                borderSide: BorderSide(color: Colors.white70))),
                                                        value: dropdownvalue,
                                                        // After selecting the desired option,it will
                                                        // change button value to selected value
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            dropdownvalue =
                                                                newValue!;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                            SizedBox(
                              height: 60,
                            ),
                            Center(
                              child: new Container(
                                child: new Material(
                                  child: new InkWell(
                                    onTap: () {
                                      save();
                                    },
                                    child: new Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      width: 100.0,
                                      height: 40.0,
                                      child: Text(
                                        'Save',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black45,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 5)
                                            ]),
                                      ),
                                    ),
                                  ),
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 229, 255, 227),
                      Color.fromARGB(255, 40, 245, 13)
                    ])))));
  }
}
