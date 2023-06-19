import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/doctor/respose.dart';
import '../Services/Auth.dart';
import 'doctor.dart';
import 'doctordrawer.dart';

class Complaints extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CsPages();
}

class CsPages extends State<Complaints> {
  bool visible = false;
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  var doctors_orders;
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
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Doctor()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Complaints")),
          backgroundColor:
          Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: DoctorDrawer(),
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
                            onPressed: (){ showComplaintDialog(snapshot.data![index]);},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.085,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
                              decoration: BoxDecoration(border: Border(left: BorderSide(color: Provider.of<Auth>(context, listen: false).secondarycolor, width: MediaQuery.of(context).size.width * 0.005))),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(text: TextSpan(children: [TextSpan(text: "From ", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "${snapshot.data![index]["nom"]} ${snapshot.data![index]["prenom"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020))])),
                                    RichText(text: TextSpan(children: [TextSpan(text: "Record ", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "${snapshot.data![index]["type_f"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020))])),
                                    RichText(text: TextSpan(children: [TextSpan(text: "Send on ", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "${snapshot.data![index]["date_r"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020))])),
                                  ],
                                ),
                            ),
                          );
                        }
                    );

                  } else if (snapshot.hasError) {
                    return Text('No Compalints found!');
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
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: {"method" : "getcomplaints", "id_medecin" : Provider.of<Auth>(context, listen: false).user!["id_medecin"]});
    data = jsonDecode(response.body);
    return data;
  }

  void showComplaintDialog(Map complaint) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Complaint'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.width * 0.8, /*alignment: Alignment.topCenter,*/
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(child: Text("${complaint["info"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020)))),
                    TextButton(
                      onPressed: (){Provider.of<DoctorProvider>(context, listen: false).selectedComplaint = complaint; Navigator.push(context, MaterialPageRoute(builder: (builder) => Response()));},
                      child: Container(
                        alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.04, width: MediaQuery.of(context).size.width / 5, decoration: BoxDecoration(color: Provider.of<Auth>(context, listen: false).secondarycolor, borderRadius: BorderRadius.circular(30),),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: Provider.of<Auth>(context, listen: false).whitecolor, size: MediaQuery.of(context).size.height * 0.02,),
                            Text("Reply", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.015, color: Provider.of<Auth>(context, listen: false).whitecolor),),
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
