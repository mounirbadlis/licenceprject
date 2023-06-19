import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/admin/admin.dart';
import 'package:untitled/admin/admindrawer.dart';
import 'package:untitled/doctor/respose.dart';
import '../Services/Auth.dart';

class Modifications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MsPages();
}

class MsPages extends State<Modifications> {
  bool visible = false;
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  var doctors_orders;
  //var status_color = [Colors.orange, Colors.green, Colors.blue, Colors.red, Colors.amber];
  Map ?priscription;
  List price = [];
  List<String> types = ["Doctor", "Pharmacist", "Patient"];
  var selectedStatus;

  Future<void> onRefresh() async {
    setState(() { getUsers();});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Admin()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Edit Requests")),
          backgroundColor:
          Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: AdminDrawer(),
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
                            onPressed: (){ showInfoDialog(snapshot.data![index]);},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.065,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
                              decoration: BoxDecoration(border: Border(left: BorderSide(color: Provider.of<Auth>(context, listen: false).secondarycolor, width: MediaQuery.of(context).size.width * 0.005))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(text: TextSpan(children: [TextSpan(text: "From ", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "${snapshot.data![index]["nom"]} ${snapshot.data![index]["prenom"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020))])),
                                  RichText(text: TextSpan(children: [TextSpan(text: "${types[int.parse(snapshot.data![index]["type"]) - 2]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold))])),
                                ],
                              ),
                            ),
                          );
                        }
                    );

                  } else if (snapshot.hasError) {
                    return Text('No Requests found!');
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
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/admin.php"), body: {"method" : "getmodifications"});
    data = jsonDecode(response.body);
    return data;
  }

  void showInfoDialog(Map request) {
    var info = jsonDecode(request["changes"]);
      //DateFormat inputFormat = DateFormat('yyyy-MM-dd');
      //DateFormat outputFormat = DateFormat('yyyy-MM-dd');
      //String inputDateString = info["date_n"];
      //DateTime inputDate = inputFormat.parse(inputDateString);
      //String formattedDate = outputFormat.format(inputDate);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('New Info'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.width * 0.6, /*alignment: Alignment.topCenter,*/
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container( width: double.infinity, height: MediaQuery.of(context).size.height / 16,
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.04,),
                          SizedBox(width: MediaQuery.of(context).size.width / 40,),
                          Text("${info["nom"]} ${info["prenom"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.03),),
                        ],
                      ),
                    ),
                    Container( width: double.infinity, height: MediaQuery.of(context).size.height / 16,
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.04,),
                          SizedBox(width: MediaQuery.of(context).size.width / 40,),
                          Text("+213${info["phone"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.03),),
                        ],
                      ),
                    ),
                    Container( width: double.infinity, height: MediaQuery.of(context).size.height / 16,
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.04,),
                          SizedBox(width: MediaQuery.of(context).size.width / 40,),
                          Text("${info["adresse"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.03),),
                        ],
                      ),
                    ),
                    Visibility( visible: request["type"] == "2",
                      child: Container( width: double.infinity, height: MediaQuery.of(context).size.height / 16,
                        child: Row(
                          children: [
                            Icon(Icons.medical_services, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.04,),
                            SizedBox(width: MediaQuery.of(context).size.width / 40,),
                            Text("${info["specialite"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.03),),
                          ],
                        ),
                      ),
                    ),
                    Visibility( visible: request["type"] == "3",
                      child: Container( width: double.infinity, height: MediaQuery.of(context).size.height / 16,
                        child: Row(
                          children: [
                            Icon(Icons.work, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.04,),
                            SizedBox(width: MediaQuery.of(context).size.width / 40,),
                            Text("${info["nom_ph"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.03),),
                          ],
                        ),
                      ),
                    ),
                    Visibility( visible: request["type"] == "4",
                      child: Container( width: double.infinity, height: MediaQuery.of(context).size.height / 16,
                        child: Row(
                          children: [
                            Icon(Icons.cake, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.04,),
                            SizedBox(width: MediaQuery.of(context).size.width / 40,),
                            Text("${info["date_n"] != null ? DateFormat('MMM d, yyyy').format(DateFormat('yyyy-MM-dd').parse(info["date_n"])) : 'N/A'}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.03),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        }
    );
  }

}
