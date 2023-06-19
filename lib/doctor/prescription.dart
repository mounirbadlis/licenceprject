import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/doctor/record.dart';
import '../Services/Auth.dart';
import '../Services/doctorprovider.dart';
import 'doctordrawer.dart';

class Prescription extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PrescriptionPage();

}

class PrescriptionPage extends State<Prescription>{
  bool formvisible = false;
  var selectedPharmacy;
  var selectedMedicine;
  final formKey = GlobalKey<FormState>();
  TextEditingController dosage = TextEditingController();
  TextEditingController qte = TextEditingController();
  Map ?pharmacy;
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  List medicines = []; List pharmacies = [];
  bool visible = true;

  Future<void> onRefresh() async {
    setState(() {selectedpriscription(); verifyDelivery();});
  }
  @override
  void initState(){
    verifyDelivery();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Record()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Prescription")),
          backgroundColor: Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: DoctorDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () { if(!visible){
            Fluttertoast.showToast(msg: "This Prescription is already sent",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0,);
          } else { showAddMedicinesDialog();}},
          child: Icon(Icons.add),
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
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: onRefresh,
          child: Container(
            color: Provider.of<Auth>(context, listen: false).primarycolor, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,/* padding: EdgeInsets.all(20),*/ alignment: Alignment.center,
            child: Column(
              children: [
                Visibility( visible: visible,
                    child: Container(
                      width: double.infinity, height: MediaQuery.of(context).size.height * 0.10,
                      decoration: BoxDecoration(color: Provider.of<Auth>(context, listen: false).whitecolor, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)]),
                      child: Column(
                        children: [
                          Expanded( flex: 1,
                            child: Container(
                              child: TextButton(
                                onPressed: (){verifyPharmacy(); showFindPharmaciesDialog();},
                                child: Text("Find Pharmacies", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor, fontWeight: FontWeight.bold),),
                              ),
                            )
                          ),
                          Expanded( flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded( flex: 4,child: Text("Name", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                                  Expanded( flex: 2,child: RichText(text: TextSpan(children: [TextSpan(text: "Dosage", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "(pills/day)", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.015))]))),
                                  Expanded( flex: 1,child: Text("Packs", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                                  Expanded( flex: 1,child: TextButton(onPressed: (){}, child: Icon(Icons.edit, color: Colors.transparent, size: MediaQuery.of(context).size.height * 0.03,),),),
                                  Expanded( flex: 1,child: TextButton(onPressed: (){}, child: Icon(Icons.edit, color: Colors.transparent, size: MediaQuery.of(context).size.height * 0.03,),),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
                Visibility( visible: !visible,
                    child: Container(
                      width: double.infinity, height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(color: Provider.of<Auth>(context, listen: false).whitecolor, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded( flex: 1,child: Container( alignment: Alignment.center,child: Text("Sent To ${pharmacy?["nom_ph"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor, fontWeight: FontWeight.bold),))),
                          Expanded( flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded( flex: 4,child: Text("Name", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                                  Expanded( flex: 2,child: RichText(text: TextSpan(children: [TextSpan(text: "Dosage", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "(pills/day)", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.015))]))),
                                  Expanded( flex: 1,child: Text("Packs", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                                  Expanded( flex: 1,child: TextButton(onPressed: (){}, child: Icon(Icons.edit, color: Colors.transparent, size: MediaQuery.of(context).size.height * 0.03,),),),
                                  Expanded( flex: 1,child: TextButton(onPressed: (){}, child: Icon(Icons.edit, color: Colors.transparent, size: MediaQuery.of(context).size.height * 0.03,),),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
                Expanded(
                  child: FutureBuilder<List> (
                      future: selectedpriscription(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  child: Row(
                                    children: [
                                      Expanded( flex: 4,child: Text("${snapshot.data![index]["nom_m"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
                                      Expanded( flex: 2,child: Text("${snapshot.data![index]["dosage"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
                                      Expanded( flex: 1,child: Text("${snapshot.data![index]["nbr_b"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
                                      Expanded( flex: 1,child: TextButton(onPressed: (){ showModifyDosageDialog(snapshot.data![index]); print(snapshot.data![index]);}, child: Icon(Icons.edit, color: Colors.grey, size: MediaQuery.of(context).size.height * 0.03,),),),
                                      Expanded( flex: 1,child: TextButton(onPressed: (){ removeMedicine(snapshot.data![index]);}, child: Icon(Icons.delete, color: Colors.grey, size: MediaQuery.of(context).size.height * 0.03,),),),
                                    ],
                                  ),
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Center(child: Text('No Medicines found!'));
                        }
                        return Center(
                            child: SpinKitWaveSpinner(
                              color: Color.fromARGB(233, 20, 108, 148),
                              trackColor: Color.fromARGB(233, 25, 167, 206),
                              waveColor: Color.fromARGB(233, 175, 211, 226),
                              size: MediaQuery.of(context).size.width / 6,
                              duration: Duration(milliseconds: 1500),
                            )
                          //CircularProgressIndicator(color: Provider.of<Auth>(context, listen: false).secondarycolor,),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> removeMedicine(Map medicine) async {
    if(visible){
      http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method": "removemedicine", "id_medicament" : medicine!["id_medicament"]});
      Navigator.push(context, MaterialPageRoute(builder: (builder) => Prescription()));
      Fluttertoast.showToast(msg: "Successfully removed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,);
    }else{
      Fluttertoast.showToast(msg: "The Prescription Is Already Sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,);
    }

  }

  Future<List<dynamic>>? selectedpriscription() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method": "selectedprescription", "id_ordonnance" : Provider.of<DoctorProvider>(context, listen: false).selectedPrescription!["id_ordonnance"]});
    data = jsonDecode(response.body);
    return data;
  }

  verifyDelivery() async {
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method": "verifydelivery", "id_ordonnance" : Provider.of<DoctorProvider>(context, listen: false).selectedPrescription!["id_ordonnance"]});
    switch(response.statusCode){
      case 200:
        var data;
        data = jsonDecode(response.body);
        setState(() {pharmacy = data[0];});
        visible = false;
        break;
      case 400:
        visible = true;
        break;
    }
    var data2;
    http.Response response2 = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method": "getmedicinespharmacies"});
    data2 = jsonDecode(response2.body);
    setState(() {
      medicines = data2["medicines"];
      pharmacies = data2["pharmacies"];
    });
  }

  sendPrescription( Map ph) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Confirmation'),
              content: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.8,
                height: MediaQuery.of(context).size.width / 3.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Do You Want To Send Order To This Pharmacy?", style: TextStyle( fontSize: MediaQuery.of(context).size.height * 0.020,fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        TextButton(onPressed: () async {
                          http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method": "sendprescription", "id_ordonnance" : Provider.of<DoctorProvider>(context, listen: false).selectedPrescription!["id_ordonnance"], "id_pharmacie" : ph["id_pharmacie"]});
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => Prescription()));
                          Fluttertoast.showToast(msg: "Successfully Sent",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0,);
                        },
                          child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30),),
                            child: Text("Send", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                        TextButton(onPressed: (){ Navigator.pop(context);},
                          child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(30),),
                            child: Text("Cancel", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              )
          );
        }
        );
  }

  void showAddMedicinesDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Add Medicine'),
              content: Container(
                height: MediaQuery.of(context).size.width *0.7,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.width / 9,
                        child: Form(
                          child: DropdownButtonFormField(
                            value: selectedMedicine,
                            hint: Text('Select a Medicine'),
                            items: medicines.map((medicine) {
                              return DropdownMenuItem(
                                value: medicine['id_medicament'],
                                child: Text("${medicine['nom_m']}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018),),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMedicine = value;
                                print(selectedMedicine);
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width / 8,
                          decoration:
                          Provider.of<Auth>(context, listen: false).shadow,
                          child: TextFormField(
                            controller: dosage,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Dosage',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                )),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'please enter Dosage';
                              }
                            },
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width / 8,
                          decoration:
                          Provider.of<Auth>(context, listen: false).shadow,
                          child: TextFormField(
                            controller: qte,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Quantity',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                )),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'please enter Quantity';
                              }
                            },
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: formvisible ? CircularProgressIndicator(color: Provider.of<Auth>(context, listen: false).secondarycolor,)
                                : Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.width / 9,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Provider.of<Auth>(context, listen: false).secondarycolor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text('Add', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.050),),
                            ),
                            onPressed: () async {
                              if(formKey.currentState!.validate()){
                                setState(() { formvisible = !formvisible;});
                                http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method" : "addmedicine", "id_ordonnance" : Provider.of<DoctorProvider>(context, listen: false).selectedPrescription!["id_ordonnance"], "id_medicament" : selectedMedicine, "dosage" : dosage.text, "nbr_b" : qte.text});
                                if(response.statusCode == 200){
                                  Fluttertoast.showToast(msg: "successfully added",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0,);
                                  Navigator.push(context, MaterialPageRoute(builder: (builder) => Prescription()));
                                }else{
                                  setState(() { formvisible = !formvisible;});
                                  Fluttertoast.showToast(msg: "this medicine is aleardy added",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0,);
                                }
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        }
        );
  }
  void showModifyDosageDialog(Map medicine) {
    dosage.text = medicine["dosage"];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Modify Dosage'),
              content: Container(
                child: Form(
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
                          child: TextFormField(
                            controller: dosage,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Dosage',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                )),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'please enter Dosage';
                              }
                            },
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: formvisible ? CircularProgressIndicator(color: Provider.of<Auth>(context, listen: false).secondarycolor,)
                                : Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.width / 9,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Provider.of<Auth>(context, listen: false).secondarycolor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text('Modify', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.050),),
                            ),
                            onPressed: () async {
                              if(formKey.currentState!.validate()){
                                setState(() { formvisible = !formvisible;});
                                print(dosage.text);
                                http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: { "method" : "modifydosage", "id_ordonnance" : Provider.of<DoctorProvider>(context, listen: false).selectedPrescription!["id_ordonnance"], "id_medicament" : medicine["id_medicament"], "dosage" : dosage.text});
                                Navigator.push(context, MaterialPageRoute(builder: (builder) => Prescription()));
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        }
        );
  }

  Future<List<dynamic>>? verifyPharmacy() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method": "verifypharmacy", "id_ordonnance" : Provider.of<DoctorProvider>(context, listen: false).selectedPrescription!["id_ordonnance"]});
    data = jsonDecode(response.body);
    return data;
  }

  void showFindPharmaciesDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Available Pharmacies'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.width * 0.8, alignment: Alignment.center,
                child:  FutureBuilder<List> (
                    future: verifyPharmacy(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TextButton(
                                onPressed: (){ sendPrescription(snapshot.data![index]);},
                                child: Container(
                                  width: double.infinity, height: MediaQuery.of(context).size.height * 0.06,
                                  child: Text("${snapshot.data![index]["nom_ph"]} - ${snapshot.data![index]["adresse_ph"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.023),),
                                ),
                              );
                            }
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('No Pharmacies found!'));
                      }
                      return Center(
                          child: SpinKitWaveSpinner(
                            color: Color.fromARGB(233, 20, 108, 148),
                            trackColor: Color.fromARGB(233, 25, 167, 206),
                            waveColor: Color.fromARGB(233, 175, 211, 226),
                            size: MediaQuery.of(context).size.width / 6,
                            duration: Duration(milliseconds: 1500),
                          )
                        //CircularProgressIndicator(color: Provider.of<Auth>(context, listen: false).secondarycolor,),
                      );
                    }
                ),
              )
          );
        }
    );
  }

}


//Text("Send to:", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor, fontWeight: FontWeight.bold),),
//TextButton(onPressed: (){verifyPharmacy(); showFindPharmaciesDialog();}, child: Icon(Icons.find_in_page, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.03,),),

/*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Send to:", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor, fontWeight: FontWeight.bold),),
                              TextButton(onPressed: (){verifyPharmacy(); showFindPharmaciesDialog();}, child: Icon(Icons.find_in_page, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.03,),),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: MediaQuery.of(context).size.width / 9,
                                child: Form(
                                  child: DropdownButtonFormField(
                                    value: selectedPharmacy,
                                    hint: Text('Select a pharmacy'),
                                    items: pharmacies.map((pharmacy) {
                                      return DropdownMenuItem(
                                        value: pharmacy['id_pharmacie'],
                                        child: Text("${pharmacy['nom_ph']}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018),),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPharmacy = value;
                                        print(selectedPharmacy);
                                      });
                                      },
                                  ),
                                ),
                              ),
                              TextButton(onPressed: (){/*sendPrescription();*/}, child: Icon(Icons.send, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.03,),),
                            ]
                          ) */