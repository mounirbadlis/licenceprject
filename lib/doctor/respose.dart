import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/Services/patientprovider.dart';
import 'package:untitled/patient/patientdrawer.dart';
import 'package:untitled/patient/selectedprescription.dart';
import 'package:untitled/patient/selectedrecord.dart';
import 'package:untitled/pharmacist/pharmacistdrawer.dart';
import '../Services/Auth.dart';
import 'complaints.dart';
import 'doctordrawer.dart';

class Response extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RPages();
}

class RPages extends State<Response> {
  final formKey = GlobalKey<FormState>();
  TextEditingController reply = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Response")),
          backgroundColor:
          Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: DoctorDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if(formKey.currentState!.validate()){
              http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method": "sendresponse", "reponse" : reply.text, "id_reclamation_fiche" : Provider.of<DoctorProvider>(context, listen: false).selectedComplaint!["id_reclamation_fiche"]});
              Navigator.push(context, MaterialPageRoute(builder: (builder) => Complaints()));
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
              controller: reply,
              minLines: MediaQuery.of(context).size.height.toInt() ,
              maxLines: null,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Write Your Response Here",
                  filled: false,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )
              ),
              validator: (v) {
                if (v!.isEmpty) {
                  Fluttertoast.showToast(msg: "please enter your response",
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
