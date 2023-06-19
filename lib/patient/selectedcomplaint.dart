import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/Services/patientprovider.dart';
import 'package:untitled/doctor/respose.dart';
import 'package:untitled/patient/patientdrawer.dart';
import '../Services/Auth.dart';

class SelectedComplaint extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SCPages();
}

class SCPages extends State<SelectedComplaint> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Complaint Info")),
        backgroundColor:
        Provider.of<Auth>(context, listen: false).secondarycolor,
      ),
      drawer: PatientDrawer(),
      body: SingleChildScrollView(
        child: Container(
          color: Provider.of<Auth>(context, listen: false).primarycolor, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, alignment: Alignment.center, padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.050),
            child: Column(
            children: [
              Container(width: MediaQuery.of(context).size.width, alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.020),
                      decoration: BoxDecoration(
                        color: Provider.of<Auth>(context, listen: false).secondarycolor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: Text("${Provider.of<PatientProvider>(context, listen: false).selectedComplaint!["info"]}", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.015),),
                    ),
                    Text("Me", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020),),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 28,),
              Visibility( visible: Provider.of<PatientProvider>(context, listen: false).selectedComplaint!["reponse"] == null,
                child: Text("${Provider.of<PatientProvider>(context, listen: false).selectedComplaint!["nom"]} ${Provider.of<PatientProvider>(context, listen: false).selectedComplaint!["prenom"]} doesn't replied yet", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020),),),
              Visibility( visible: Provider.of<PatientProvider>(context, listen: false).selectedComplaint!["reponse"] != null,
                child: Container(width: MediaQuery.of(context).size.width, alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.020),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                        child: Text("${Provider.of<PatientProvider>(context, listen: false).selectedComplaint!["reponse"]}", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.015),),
                      ),
                      Text("${Provider.of<PatientProvider>(context, listen: false).selectedComplaint!["nom"]} ${Provider.of<PatientProvider>(context, listen: false).selectedComplaint!["prenom"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020),),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
