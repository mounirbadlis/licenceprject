import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled/admin/admindrawer.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/admin/pharmacistslist.dart';
import '../Services/Auth.dart';
import 'doctor.dart';
import 'doctordrawer.dart';

class Patients extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PLPages();
}

class PLPages extends State<Patients> {
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
  DateTime? selectedDate;
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
          title: Row(
            children: [
              Expanded(child: Text("Patients")),
              TextButton(onPressed: (){
                final snackBar = SnackBar(content: Text('You Can See Only The Patients You Don\'t Have Any Records With'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);},
                child: Icon(Icons.info, color: Provider.of<Auth>(context, listen: false).whitecolor, size: MediaQuery.of(context).size.height * 0.03,),)
            ],
          ),
          backgroundColor:
          Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: DoctorDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () { showAddPatientDialog();},
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
                              onPressed: (){},
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
                                        Text("${snapshot.data![index]["nom"]} ${snapshot.data![index]["prenom"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.025,),),
                                        Text("${DateTime.now().year - DateTime.parse(snapshot.data![index]["date_n"]).year} years", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor),),
                                        Text("+213${snapshot.data![index]["phone"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor),),
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(onPressed: (){showAddRecordDialog(snapshot.data![index]);}, child: Icon(Icons.add_chart_outlined, color: Colors.grey, size: MediaQuery.of(context).size.height * 0.03,),),
                                      ],
                                    )
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


  void showAddPatientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Patient'),
          content: Container(
            height: MediaQuery.of(context).size.width,
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
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'please enter email';
                          }
                        },
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width / 8,
                      decoration:
                      Provider.of<Auth>(context, listen: false).shadow,
                      child: TextFormField(
                        controller: password,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Passowrd',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'please enter Password';
                          }
                        },
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width / 8,
                            decoration:
                            Provider.of<Auth>(context, listen: false).shadow,
                            child: TextFormField(
                              controller: prenom,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'First Name',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  )),
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'please enter First Name';
                                }
                              },
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width / 8,
                            decoration:
                            Provider.of<Auth>(context, listen: false).shadow,
                            child: TextFormField(
                              controller: nom,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Family Name',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  )),
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'please enter Family Name';
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width / 8,
                      decoration:
                      Provider.of<Auth>(context, listen: false).shadow,
                      child: TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'Phone Number',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'please enter Phone Number';
                          }
                        },
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width / 8,
                      decoration:
                      Provider.of<Auth>(context, listen: false).shadow,
                      child: TextFormField(
                        controller: adresse,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Address',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'please enter Address';
                          }
                        },
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width / 8,
                    decoration: Provider.of<Auth>(context, listen: false).shadow,
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Date of Birth",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (selectedDate == null) {
                            return 'please select Date of Birth';
                          }
                        },
                      ),
                    ),
                  ),
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
                          child: Text('Add', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.050),),
                        ),
                        onPressed: () async {
                          if(formKey.currentState!.validate()){
                            setState(() { visible = !visible;});
                            http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: { "method" : "addpatient", "email" : email.text, "password" : password.text, "nom" : nom.text, "prenom" : prenom.text, "phone" : phone.text, "adresse" : adresse.text, "date_n" : selectedDate.toString()});
                            if(response.statusCode == 200){
                              Fluttertoast.showToast(msg: "successfully added",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0,);
                              Navigator.push(context, MaterialPageRoute(builder: (builder) => Patients()));
                            }else{
                              setState(() { visible = !visible;});
                              Fluttertoast.showToast(msg: "this email is aleardy used",
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
          ),
        );
      },
    );
  }

  void showAddRecordDialog(Map data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Medical record'),
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
                          child: Text('Create', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.050),),
                        ),
                        onPressed: () async {
                          if(formKey.currentState!.validate()){
                            setState(() { visible = !visible;});
                            http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: { "method" : "createrecord", "id_medecin" : Provider.of<Auth>(context, listen: false).user!["id_medecin"], "id_patient" : data["id_patient"], "type_f" : title.text});
                            if(response.statusCode == 200){
                              Navigator.push(context, MaterialPageRoute(builder: (builder) => Patients()));
                              Fluttertoast.showToast(msg: "successfully created",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0,);
                            }else{
                              setState(() { visible = !visible;});
                              Fluttertoast.showToast(msg: "this Record is already created for this patient",
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
          ),
        );
      },
    );
  }



  Future<List<dynamic>>? getUsers() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/doctor.php"), body: { "method" : "getpatients", "id_utilisateur" : Provider.of<Auth>(context, listen: false).user!["id_utilisateur"]});
    data = jsonDecode(response.body);
    return data;
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
}
