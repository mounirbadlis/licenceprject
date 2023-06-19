import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Services/patientprovider.dart';
import 'package:untitled/patient/patient.dart';
import 'package:untitled/patient/patientdrawer.dart';
import 'package:untitled/patient/selectedrecord.dart';
import 'package:untitled/pharmacist/pharmacistdrawer.dart';
import '../Services/Auth.dart';

class MyRecords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MRPages();
}

class MRPages extends State<MyRecords> {
  bool visible = false;
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  var doctors_records;
  //var status_color = [Colors.orange, Colors.green, Colors.blue, Colors.red, Colors.amber];
  Map ?priscription;
  List price = [];
  List<Map> status = [{"id" : 1, "status" : "arriving"}, {"id" : 2, "status" : "arrived"}, {"id" : 3, "status" : "cancel"}];
  var selectedStatus;

  Future<void> onRefresh() async {
    setState(() { getUsers();});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Patient()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("My Records")),
          backgroundColor:
          Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: PatientDrawer(),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: onRefresh,
          child: Container(
            color: Provider.of<Auth>(context, listen: false).primarycolor, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, alignment: Alignment.center,
            child: FutureBuilder<List> (
                future: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TextButton(
                            onPressed: (){
                              Provider.of<PatientProvider>(context, listen: false).selectedRecord = snapshot.data![index];
                              Navigator.push(context, MaterialPageRoute(builder: (builder) => SelectedRecord()));
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.060,
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
                                decoration: BoxDecoration(border: Border(left: BorderSide(color: Provider.of<Auth>(context, listen: false).secondarycolor, width: MediaQuery.of(context).size.width * 0.005))),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Expanded(flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(text: TextSpan(children: [TextSpan(text: "Record ", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "${snapshot.data![index]["type_f"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020))])),
                                          RichText(text: TextSpan(children: [TextSpan(text: "Dr. ", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "${doctors_records[index]["nom"]} ${doctors_records[index]["prenom"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020))])),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.chevron_right, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.04,),
                                  ],
                                )
                            ),
                          );
                        }
                    );

                  } else if (snapshot.hasError) {
                    return Text('No Records found!');
                  }

                  return Center(
                      child: SpinKitWaveSpinner(
                        color: Color.fromARGB(233, 20, 108, 148),
                        trackColor: Color.fromARGB(233, 25, 167, 206),
                        waveColor: Color.fromARGB(233, 175, 211, 226),
                        size: MediaQuery.of(context).size.width / 6,
                        duration: Duration(milliseconds: 1500),
                      ));
                }
            ),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>>? getUsers() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/patient.php"), body: {"method" : "myrecords", "id_patient" : Provider.of<Auth>(context, listen: false).user!["id_patient"]});
    data = jsonDecode(response.body);
    var patients_orders = data["records_patient"];
    doctors_records = data["records_doctor"];
    return patients_orders;
  }

}
