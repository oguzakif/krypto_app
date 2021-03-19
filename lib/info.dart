import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krypto App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white10,
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
      ),
      home: Info(),
    );
  }
}

class Info extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: (MediaQuery.of(context).size.height),
      padding: EdgeInsets.all(18.0),
      decoration:
          BoxDecoration(border: Border.all(width: 15.0), color: Colors.black45),
      child: ListView(
        children: [
          Card(
              color: Colors.deepPurple.shade900,
              elevation: 3,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Wrap(children: [
                    Row(
                      children: [
                        Text(
                          "About Us",
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                            "Krypto-Project is a project that displays the most used crypto currency values.This project is developed by three students and you can contact them with their contact informations."),
                      ],
                    ),
                  ]))),
          Card(
            color: Colors.deepPurple.shade900,
            elevation: 3,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Wrap(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Contact Us",
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("Ozan Uslan"),
                            IconButton(
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.github),
                                onPressed: () {
                                  launch('https://github.com/ozanuslan');
                                }),
                            IconButton(
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.linkedin),
                                onPressed: () {
                                  launch(
                                      'https://www.linkedin.com/in/ozan-uslan-5611461a0/');
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Hüseyin Saatçi"),
                            IconButton(
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.github),
                                onPressed: () {
                                  launch('https://github.com/huseyinsaatci');
                                }),
                            IconButton(
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.linkedin),
                                onPressed: () {
                                  launch(
                                      'https://www.linkedin.com/in/huseyin-saatci/');
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Oğuz Akif Tüfekcioğlu"),
                            IconButton(
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.github),
                                onPressed: () {
                                  launch('https://github.com/oguzakif');
                                }),
                            IconButton(
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.linkedin),
                                onPressed: () {
                                  launch(
                                      'https://www.linkedin.com/in/oguzakiftufekcioglu/');
                                }),
                          ],
                        )
                      ],
                    ),
                  ],
                )),
          ),
          Card(
              color: Colors.deepPurple.shade900,
              elevation: 3,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Wrap(children: [
                    Row(
                      children: [
                        Text(
                          "Our Website",
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              launch("https://krypto-project.herokuapp.com/");
                            },
                            child: Text("krypto-project.herokuapp.com"))
                      ],
                    )
                  ]))),
          Card(
              color: Colors.deepPurple.shade900,
              elevation: 3,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Wrap(children: [
                    Row(
                      children: [
                        Text(
                          "Source Code",
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              launch("https://github.com/oguzakif/krypto_app");
                            },
                            child: Text("github.com/oguzakif/krypto_app"))
                      ],
                    )
                  ]))),
        ],
      ),
    ));

    // TODO: implement build
    throw UnimplementedError();
  }
}
