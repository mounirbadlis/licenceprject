import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/Services/patientprovider.dart';
import 'package:untitled/doctor/prescription.dart';
import 'package:untitled/patient/patientdrawer.dart';
import 'package:untitled/patient/selectedprescription.dart';
import '../Services/Auth.dart';

class SelectedRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SRecordPage();
}

class SRecordPage extends State<SelectedRecord> {
  final formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  bool visible = false;

  Future<void> onRefresh() async {
    setState(() {
      getPrescriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${Provider.of<PatientProvider>(context, listen: false).selectedRecord!["type_f"]} Record")),
        backgroundColor: Provider.of<Auth>(context, listen: false).secondarycolor,
      ),
      drawer: PatientDrawer(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Container(
          color: Provider.of<Auth>(context, listen: false).primarycolor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Container(
            child: FutureBuilder<List>(
                future: getPrescriptions(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TextButton(
                              onPressed: () {
                                Provider.of<PatientProvider>(context, listen: false).selectedPrescription = snapshot.data![index];
                                Navigator.push(context, MaterialPageRoute(builder: (builder) => SelectedPrescription()));
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(border: Border(left: BorderSide(color: Provider.of<Auth>(context, listen: false).secondarycolor, width: MediaQuery.of(context).size.width * 0.005))),
                                child: Row(
                                    children: [
                                      Text("${snapshot.data![index]["date"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.030, color: Provider.of<Auth>(context, listen: false).secondarycolor),),
                                    ]),
                              ));
                        });
                  } else if (snapshot.hasError) {
                    return Center(child: Text('No Prescriptions found!'));
                  }
                  return Center(
                      child: SpinKitWaveSpinner(
                        color: Color.fromARGB(233, 20, 108, 148),
                        trackColor: Color.fromARGB(233, 25, 167, 206),
                        waveColor: Color.fromARGB(233, 175, 211, 226),
                        size: MediaQuery.of(context).size.width / 6,
                        duration: Duration(milliseconds: 1500),
                      )
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>>? getPrescriptions() async {
    var data;
    http.Response response = await http.post(
        Uri.parse(
            "http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/patient.php"),
        body: {
          "method": "selectedrecord",
          "id_fiche": Provider.of<PatientProvider>(context, listen: false).selectedRecord!["id_fiche"]
        });
    data = jsonDecode(response.body);
    var prescriptions = data;
    return prescriptions;
  }
}
