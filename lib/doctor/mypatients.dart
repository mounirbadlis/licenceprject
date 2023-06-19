import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/admin/admindrawer.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/admin/pharmacistslist.dart';
import 'package:untitled/doctor/doctor.dart';
import 'package:untitled/doctor/record.dart';
import 'package:untitled/doctor/selectedpatient.dart';
import '../Services/Auth.dart';
import 'doctordrawer.dart';

class MyPatients extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MPLPages();
}

class MPLPages extends State<MyPatients> {
  bool visible = false;
  final formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController specialete = TextEditingController();
  TextEditingController title = TextEditingController();
  var colors = [Colors.orange, Colors.green, Colors.blue, Colors.red, Colors.amber];
  Random c = Random();

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
          title: Center(child: Text("My Patients")),
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
                              onPressed: (){
                                Provider.of<DoctorProvider>(context, listen: false).selectedPatient = snapshot.data![index];
                                Navigator.push(context, MaterialPageRoute(builder: (builder) => SelectedPatient()));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.08,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: colors[c.nextInt(colors.length)],
                                      radius: MediaQuery.of(context).size.width * 0.1,
                                      child: Text("${snapshot.data![index]["nom"][0]}${snapshot.data![index]["prenom"][0]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).whitecolor, fontSize: MediaQuery.of(context).size.width *0.07, fontWeight: FontWeight.bold),),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${snapshot.data![index]["nom"]} ${snapshot.data![index]["prenom"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),),
                                        Text("${DateTime.now().year - DateTime.parse(snapshot.data![index]["date_n"]).year} years", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor),),
                                        Text("+213${snapshot.data![index]["phone"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor),),
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(Icons.chevron_right, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.03,),
                                  ],
                                ),
                              )
                          );
                        }
                    );


                  } else if (snapshot.hasError) {
                    return Text('No Patients found!');
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
      ),
    );
  }

  void showModifyRecordDialog(Map data) {
    title.text = data["type_f"];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modify Record'),
          content: Container(
            constraints: BoxConstraints(maxHeight: double.infinity),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width / 8,
                      decoration:
                      Provider.of<Auth>(context, listen: false).shadow,
                      child: TextFormField(
                        controller: title,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Title',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'please enter title';
                          }
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: visible ? CircularProgressIndicator(color: Provider.of<Auth>(context, listen: false).secondarycolor,)
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
                            setState(() { visible = !visible;});
                            http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: { "method" : "editrecord", "id_fiche" : data["id_fiche"], "type_f" : title.text});
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => MyPatients()));
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  Future<List<dynamic>>? getUsers() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: { "method" : "mypatients", "id_medecin" : Provider.of<Auth>(context, listen: false).user!["id_medecin"]});
    data = jsonDecode(response.body);
    var mypatients = data;
    return mypatients;
  }

  Future<void> deleteRecord(dynamic id_fiche) async {
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: { "method" : "deleterecord", "id_fiche" : id_fiche});
    Fluttertoast.showToast(msg: "successfully removed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,);
    Navigator.push(context, MaterialPageRoute(builder: (builder) => MyPatients()));
  }
}
