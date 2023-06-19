import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/patient/patientdrawer.dart';
import '../Services/Auth.dart';
import '../Services/doctorprovider.dart';
import '../Services/patientprovider.dart';
import 'complaint.dart';

class SelectedPrescription extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SPrescriptionPage();

}

class SPrescriptionPage extends State<SelectedPrescription>{
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
    setState(() {selectedpriscription();});
  }
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(child: Text("Prescription")),
              Spacer(),
              TextButton(onPressed: (){
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
                                Text("Do You Want To Renew This Prescription?", style: TextStyle( fontSize: MediaQuery.of(context).size.height * 0.020,fontWeight: FontWeight.bold),),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                      http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/patient.php"), body: {"method": "renewalrequest", "date" : Provider.of<PatientProvider>(context, listen: false).selectedPrescription!["date"],"id_fiche" : Provider.of<PatientProvider>(context, listen: false).selectedRecord!["id_fiche"], "date_r" : DateTime.now().toString()});
                                      Navigator.push(context, MaterialPageRoute(builder: (builder) => SelectedPrescription()));
                                      Fluttertoast.showToast(msg: "successfully sent",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0,);
                                      },
                                      child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30),),
                                        child: Text("Yes", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                                    TextButton(onPressed: (){ Navigator.pop(context);},
                                      child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30),),
                                        child: Text("No", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ],
                            ),
                          )
                      );
                    }
                );
              }, child: Icon(Icons.cached, color: Provider.of<Auth>(context, listen: false).whitecolor, size: MediaQuery.of(context).size.height * 0.04,),),
              TextButton(
                onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (builder) => Complaint()));},
                child: Container(
                  alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.04, width: MediaQuery.of(context).size.width / 5, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30),),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flag, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.02,),
                      Text("Complaint", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.015, color: Provider.of<Auth>(context, listen: false).secondarycolor),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //Center(child: Text("Prescription")),
        backgroundColor: Provider.of<Auth>(context, listen: false).secondarycolor,
      ),
      drawer: PatientDrawer(),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefresh,
        child: Container(
          color: Provider.of<Auth>(context, listen: false).primarycolor, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,/* padding: EdgeInsets.all(20),*/ alignment: Alignment.center,
          child: Column(
            children: [
                Container(
                  width: double.infinity, height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(color: Provider.of<Auth>(context, listen: false).whitecolor, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded( flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded( flex: 4,child: Text("Name", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                              Expanded( flex: 1,child: RichText(text: TextSpan(children: [TextSpan(text: "Dosage", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "(pills/day)", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.015))]))),
                              Expanded( flex: 1,child: Text("Packs", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                                    Expanded( flex: 1,child: Text("${snapshot.data![index]["dosage"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
                                    Expanded( flex: 1,child: Text("${snapshot.data![index]["nbr_b"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
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
    );
  }

  Future<List<dynamic>>? selectedpriscription() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/patient.php"), body: {"method": "selectedprescription", "id_ordonnance" : Provider.of<PatientProvider>(context, listen: false).selectedPrescription!["id_ordonnance"]});
    data = jsonDecode(response.body);
    return data;
  }

}