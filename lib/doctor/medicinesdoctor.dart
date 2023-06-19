import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/doctor/doctordrawer.dart';
import 'package:untitled/pharmacist/pharmacistdrawer.dart';
import '../Services/Auth.dart';
import 'doctor.dart';

class MedicinesDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MDPage();
}

class MDPage extends State<MedicinesDoctor> {
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool visible = false;

  Future<void> onRefresh() async {
    setState(() {
      getStock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Doctor()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Medicines")), backgroundColor: Provider.of<Auth>(context, listen: false).secondarycolor,),
        drawer: DoctorDrawer(),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Container(
            color: Provider.of<Auth>(context, listen: false).primarycolor, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,/* padding: EdgeInsets.all(20),*/ alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                  width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration( color: Provider.of<Auth>(context, listen: false).whitecolor,boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)]),
                  child: Row(
                    children: [
                      Expanded( flex: 4,child: Text("Name", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                      Expanded( flex: 1,child: Text("Price", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List> (
                      future: getStock(),
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
                                      Expanded( flex: 1,child: Text("${snapshot.data![index]["prix"]} DA", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
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

  Future<List<dynamic>>? getStock() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: {"method": "getmedicines"});
    data = jsonDecode(response.body);
    return data;
  }

}
