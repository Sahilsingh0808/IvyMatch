import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
          backgroundColor: Colors.green,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 45, 247, 19),
                      Color.fromARGB(255, 0, 47, 17)
                    ]),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4, spreadRadius: 3, color: Colors.black12)
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200))),
                padding: EdgeInsets.all(8),
                child: (snapshot.data!.docs.length == 0)
                    ? Center(
                        child: Text('No users found'),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, int index) {
                          return Center(
                            child: Container(
                              height: 128,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        child: Icon(
                                          (snapshot.data!.docs[index]
                                                      ['gender'] ==
                                                  "Male")
                                              ? Icons.boy
                                              : (snapshot.data!.docs[index]
                                                          ['gender'] ==
                                                      "Female")
                                                  ? Icons.girl
                                                  : Icons.transgender,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 128,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text('Name: ' +
                                                snapshot.data!.docs[index]
                                                    ['name']),
                                            Text('Age: ' +
                                                snapshot
                                                    .data!.docs[index]['age']
                                                    .toString()),
                                            Text('Email: ' +
                                                snapshot.data!.docs[index]
                                                    ['email']),
                                            Text('Gender: ' +
                                                snapshot.data!.docs[index]
                                                    ['gender']),
                                            Text('Occupation: ' +
                                                snapshot.data!.docs[index]
                                                    ['occupation']),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
              );
            }));
  }
}
