import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/doctor/prescription.dart';
import 'package:untitled/doctor/selectedpatient.dart';
import '../Services/Auth.dart';
import 'doctordrawer.dart';

class Record extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecordPage();
}

class RecordPage extends State<Record> {
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
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (builder) => SelectedPatient()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("${Provider.of<DoctorProvider>(context, listen: false).selectedRecord!["type_f"]} Record")),
          backgroundColor: Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: DoctorDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showCreatePrescriptionDialog();
          },
          child: Icon(Icons.add),
          backgroundColor:
              Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 60,
          ),
        ),
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
                                        Provider.of<DoctorProvider>(context, listen: false).selectedPrescription = snapshot.data![index];
                                        Navigator.push(context, MaterialPageRoute(builder: (builder) => Prescription()));
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
                                              Spacer(),
                                              TextButton(onPressed: (){ renewPrescription(snapshot.data![index]);}, child: Icon(Icons.cached, color: Colors.grey, size: MediaQuery.of(context).size.height * 0.03,),),
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
      ),
    );
  }

  Future<List<dynamic>>? getPrescriptions() async {
    var data;
    http.Response response = await http.post(
        Uri.parse(
            "http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"),
        body: {
          "method": "getprescriptions",
          "id_fiche": Provider.of<DoctorProvider>(context, listen: false)
              .selectedRecord!["id_fiche"]
        });
    data = jsonDecode(response.body);
    var prescriptions = data;
    return prescriptions;
  }

  Future<void> renewPrescription(Map prescription) async {
    http.Response response = await http.post( Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"),
        body: {"method": "renewprescription", "id_fiche": Provider.of<DoctorProvider>(context, listen: false).selectedRecord!["id_fiche"], "id_ordonnance" : prescription["id_ordonnance"], "date" : DateTime.now().toString()});
    Fluttertoast.showToast(
      msg: "successfully renewed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.push(context, MaterialPageRoute(builder: (builder) => Record()));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void showCreatePrescriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Prescrpition'),
          content: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width / 8,
                    decoration:
                        Provider.of<Auth>(context, listen: false).shadow,
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "$selectedDate",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (selectedDate == null) {
                            return 'please select Date of Creation';
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: visible
                            ? CircularProgressIndicator(
                                color: Provider.of<Auth>(context, listen: false)
                                    .secondarycolor,
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: MediaQuery.of(context).size.width / 9,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      Provider.of<Auth>(context, listen: false)
                                          .secondarycolor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.050),
                                ),
                              ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            http.Response response = await http.post( Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method": "createprescription", "id_fiche": Provider.of<DoctorProvider>(context, listen: false).selectedRecord!["id_fiche"], "date": selectedDate.toString()});
                            Fluttertoast.showToast(
                              msg: "successfully added",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => Record()));
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
        );
      },
    );
  }
}
