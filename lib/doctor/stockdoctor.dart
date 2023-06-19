import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Services/Auth.dart';
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/admin/admindrawer.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/doctor/doctordrawer.dart';
import 'package:untitled/doctor/pharmacy.dart';

class StockDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SDPages();
}

class SDPages extends State<StockDoctor> {
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> onRefresh() async {
    setState(() { getPharmacies();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Stock of Pharmacies")),
        backgroundColor:
        Provider.of<Auth>(context, listen: false).secondarycolor,
      ),
      drawer: DoctorDrawer(),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefresh,
        child: Container(
          color: Provider.of<Auth>(context, listen: false).primarycolor, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,/* padding: EdgeInsets.all(20),*/ alignment: Alignment.center,
          child: FutureBuilder<List> (
              future: getPharmacies(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                            onPressed: (){
                              Provider.of<DoctorProvider>(context, listen: false).selectedPharmacy = snapshot.data![index];
                              Navigator.push(context, MaterialPageRoute(builder: (builder) => Pharmacy()));
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.082,
                              decoration: BoxDecoration(border: Border(left: BorderSide(color: Provider.of<Auth>(context, listen: false).secondarycolor, width: MediaQuery.of(context).size.width * 0.005))),
                              child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${snapshot.data![index]["nom_ph"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),),
                                  Text("${snapshot.data![index]["adresse_ph"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor),),
                                  Text("${snapshot.data![index]["COUNT(s.id_pharmacie)"]} medicines", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor),),
                                ],
                              ),
                            )
                        );
                      }
                  );
                } else if (snapshot.hasError) {
                  return Text('No Pharmacies found!');
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
      ),
    );
  }

  Future<List<dynamic>>? getPharmacies() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: { "method" : "getpharmacies"});
    data = jsonDecode(response.body);
    return data;
  }
}
