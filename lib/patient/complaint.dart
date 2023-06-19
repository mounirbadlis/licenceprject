import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Services/patientprovider.dart';
import 'package:untitled/patient/patientdrawer.dart';
import 'package:untitled/patient/selectedprescription.dart';
import 'package:untitled/patient/selectedrecord.dart';
import 'package:untitled/pharmacist/pharmacistdrawer.dart';
import '../Services/Auth.dart';

class Complaint extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CPages();
}

class CPages extends State<Complaint> {
  final formKey = GlobalKey<FormState>();
  TextEditingController complaint = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Create Complaint")),
        backgroundColor:
        Provider.of<Auth>(context, listen: false).secondarycolor,
      ),
      drawer: PatientDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if(formKey.currentState!.validate()){
              http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/patient.php"), body: {"method": "sendcomplaint", "date" : Provider.of<PatientProvider>(context, listen: false).selectedPrescription!["date"],"id_fiche" : Provider.of<PatientProvider>(context, listen: false).selectedRecord!["id_fiche"], "info" : complaint.text, "date_r" : DateTime.now().toString()});
              Navigator.push(context, MaterialPageRoute(builder: (builder) => SelectedPrescription()));
              Fluttertoast.showToast(msg: "successfully sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0,);
            }
          },
          child: Icon(Icons.send),
          backgroundColor: Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 60,
          ),
        ),
      body: Container(
        color: Provider.of<Auth>(context, listen: false).primarycolor, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, alignment: Alignment.center, padding: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: complaint,
            minLines: MediaQuery.of(context).size.height.toInt() ,
            maxLines: null,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Write Your Complaint Here",
              filled: false,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                )
            ),
            validator: (v) {
              if (v!.isEmpty) {
                Fluttertoast.showToast(msg: "please enter your complaint",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0,);
                return ",,,,,,,,,";
              }
            },
          ),
        ),
      )
    );
  }

}
