import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled/admin/admin.dart';
import 'package:untitled/admin/admindrawer.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/admin/pharmacistslist.dart';
import 'package:untitled/doctor/doctor.dart';
import 'package:untitled/doctor/doctordrawer.dart';
import 'package:untitled/patient/patient.dart';
import 'package:untitled/patient/patientdrawer.dart';
import '../Services/Auth.dart';

class PatientProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PPPages();
}

class PPPages extends State<PatientProfile> {
  bool visible = false;
  bool visible_e = false;
  final formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController currentpassword = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController specialete = TextEditingController();
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Patient()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(child: Text("Profile")),
              TextButton(onPressed: (){
                final snackBar = SnackBar(content: Text('You Can Change The Email And Password, But The Other Info Should Send Order To Admin'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);},
                child: Icon(Icons.info, color: Provider.of<Auth>(context, listen: false).whitecolor, size: MediaQuery.of(context).size.height * 0.03,),)
            ],
          ),
          backgroundColor:
          Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: PatientDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {showEditProfileDialog();},
          child: Icon(Icons.edit),
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
        body: Container(
          color: Provider.of<Auth>(context, listen: false).primarycolor, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.02),
                decoration: BoxDecoration( color: Provider.of<Auth>(context, listen: false).secondarycolor, ),
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Text("${Provider.of<Auth>(context, listen: false).user!["nom"][0]}${Provider.of<Auth>(context, listen: false).user!["prenom"][0]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.06, fontWeight: FontWeight.bold),),
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Text("${Provider.of<Auth>(context, listen: false).user!["prenom"]} ${Provider.of<Auth>(context, listen: false).user!["nom"]}", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width *0.04),),
                  ],
                ),
              ),
              Container( width: double.infinity, height: MediaQuery.of(context).size.height / 14, padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.004),
                child: Row(
                  children: [
                    Icon(Icons.email, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.05,),
                    SizedBox(width: MediaQuery.of(context).size.width / 30,),
                    Expanded(child: Text("${Provider.of<Auth>(context, listen: false).user!["email"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.04),)),
                    TextButton(onPressed: (){showChangeEmailDialog();},
                      child: Icon(Icons.edit, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.03,),)
                  ],
                ),
              ),
              Container( width: double.infinity, height: MediaQuery.of(context).size.height / 14, padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.004),
                child: Row(
                  children: [
                    Icon(Icons.phone, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.05,),
                    SizedBox(width: MediaQuery.of(context).size.width / 30,),
                    Text("+213${Provider.of<Auth>(context, listen: false).user!["phone"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.04),),
                  ],
                ),
              ),
              Container( width: double.infinity, height: MediaQuery.of(context).size.height / 14, padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.004),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.05,),
                    SizedBox(width: MediaQuery.of(context).size.width / 30,),
                    Text("${Provider.of<Auth>(context, listen: false).user!["adresse"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.04),),
                  ],
                ),
              ),
              Container( width: double.infinity, height: MediaQuery.of(context).size.height / 14, padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.004),
                child: Row(
                  children: [
                    Icon(Icons.cake, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.05,),
                    SizedBox(width: MediaQuery.of(context).size.width / 30,),
                    Text("${Provider.of<Auth>(context, listen: false).user!["date_n"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.04),),
                  ],
                ),
              ),
              Container(height: 0, width: MediaQuery.of(context).size.width/2, decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Provider.of<Auth>(context, listen: false).secondarycolor, width: MediaQuery.of(context).size.width *0.003))),),
              Container( width: double.infinity, height: MediaQuery.of(context).size.height / 14, padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.004,), alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: (){ showChangePasswordDialog();},
                  child: Text("Change The Password", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.03),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  void showEditProfileDialog() {
    prenom.text = Provider.of<Auth>(context, listen: false).user!["prenom"]; nom.text = Provider.of<Auth>(context, listen: false).user!["nom"];
    phone.text = "0" + Provider.of<Auth>(context, listen: false).user!["phone"]; adresse.text = Provider.of<Auth>(context, listen: false).user!["adresse"];
    selectedDate = DateTime.tryParse(Provider.of<Auth>(context, listen: false).user!["date_n"]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.width * 1.2,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "First Name",
                          style: TextStyle(
                              color: Provider.of<Auth>(context, listen: false).secondarycolor,
                              fontSize: MediaQuery.of(context).size.height * 0.015, fontWeight: FontWeight.bold),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.width / 6.5,
                            decoration:
                            Provider.of<Auth>(context, listen: false)
                                .shadow,
                            child: TextFormField(
                              controller: prenom,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [LengthLimitingTextInputFormatter(100),],
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
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Family Name",
                          style: TextStyle(
                              color: Provider.of<Auth>(context, listen: false).secondarycolor,
                              fontSize: MediaQuery.of(context).size.height * 0.015, fontWeight: FontWeight.bold),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.width / 6.5,
                            decoration:
                            Provider.of<Auth>(context, listen: false)
                                .shadow,
                            child: TextFormField(
                              controller: nom,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [LengthLimitingTextInputFormatter(100),],
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                              color: Provider.of<Auth>(context, listen: false)
                                  .secondarycolor,
                              fontSize:
                              MediaQuery.of(context).size.height * 0.015,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width *
                                0.6,
                            height:
                            MediaQuery.of(context).size.width / 6.5,
                            decoration: Provider.of<Auth>(context,
                                listen: false)
                                .shadow,
                            child: TextFormField(
                              controller: phone,
                              keyboardType: TextInputType.number,
                              inputFormatters: [LengthLimitingTextInputFormatter(50),],
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
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.height * 0.015, fontWeight: FontWeight.bold),),
                        Container(
                            width: MediaQuery.of(context).size.width *
                                0.6,
                            height:
                            MediaQuery.of(context).size.width / 6.5,
                            decoration: Provider.of<Auth>(context,
                                listen: false)
                                .shadow,
                            child: TextFormField(
                              controller: adresse,
                              keyboardType: TextInputType.text,
                              inputFormatters: [LengthLimitingTextInputFormatter(50),],
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
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date Of Birth", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.height * 0.015, fontWeight: FontWeight.bold),),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width / 8,
                          decoration: Provider.of<Auth>(context, listen: false).shadow,
                          child: InkWell(
                            onTap: () {
                              _selectDate(context, DateTime.parse(Provider.of<Auth>(context, listen: false).user!["date_n"]));
                            },
                            child: TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "${Provider.of<Auth>(context, listen: false).user!["date_n"]}",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: visible
                              ? CircularProgressIndicator(
                            color: Provider.of<Auth>(context,
                                listen: false)
                                .secondarycolor,
                          )
                              : Container(
                            width:
                            MediaQuery.of(context).size.width * 0.6,
                            height:
                            MediaQuery.of(context).size.width / 9,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Provider.of<Auth>(context,
                                  listen: false)
                                  .secondarycolor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Sent',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.050),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/login.php"), body: { "method" : "editprofile", "id_utilisateur" : Provider.of<Auth>(context, listen: false).user!["id_utilisateur"], "changes" : jsonEncode({"nom" : nom.text, "prenom" : prenom.text, "phone" : phone.text, "adresse" : adresse.text, "date_n" : selectedDate.toString()}),});
                              Navigator.push(context, MaterialPageRoute(builder: (builder) => PatientProfile()));
                              Fluttertoast.showToast(
                                msg: "successfully Sent",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  void showChangeEmailDialog() {
    email.text = Provider.of<Auth>(context, listen: false).user!["email"];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Email'),
          content: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.width / 2.5,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              color: Provider.of<Auth>(context, listen: false).secondarycolor,
                              fontSize: MediaQuery.of(context).size.height * 0.015, fontWeight: FontWeight.bold),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.width / 6.5,
                            decoration:
                            Provider.of<Auth>(context, listen: false)
                                .shadow,
                            child: TextFormField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [LengthLimitingTextInputFormatter(100),],
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: visible
                              ? CircularProgressIndicator(
                            color: Provider.of<Auth>(context,
                                listen: false)
                                .secondarycolor,
                          )
                              : Container(
                            width:
                            MediaQuery.of(context).size.width * 0.6,
                            height:
                            MediaQuery.of(context).size.width / 9,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Provider.of<Auth>(context,
                                  listen: false)
                                  .secondarycolor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.050),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if(email.text == Provider.of<Auth>(context, listen: false).user!["email"]){
                                Fluttertoast.showToast(
                                  msg: "You Don't Change The Email",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }else{
                                setState(() {visible = !visible;});
                                http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/patient.php"), body: { "method" : "changeemail", "id_utilisateur" : Provider.of<Auth>(context, listen: false).user!["id_utilisateur"], "email" : email.text,});
                                if (response.statusCode == 200) {
                                  var data = jsonDecode(response.body);
                                  Provider.of<Auth>(context, listen: false).user = data[0] ;
                                  Navigator.push(context, MaterialPageRoute(builder: (builder) => PatientProfile()));
                                  Fluttertoast.showToast(
                                    msg: "Successfully Change",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  setState(() {
                                    visible = !visible;
                                  });
                                  Fluttertoast.showToast(
                                    msg: "this email is aleardy used",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
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
          ),
        );
      },
    );
  }
  void showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.width / 1.7,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width / 6.5,
                      decoration:
                      Provider.of<Auth>(context, listen: false)
                          .shadow,
                      child: TextFormField(
                        obscureText: true,
                        controller: currentpassword,
                        keyboardType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(100),],
                        decoration: InputDecoration(
                            hintText: 'Current password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'please enter password';
                          }
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width / 6.5,
                      decoration:
                      Provider.of<Auth>(context, listen: false)
                          .shadow,
                      child: TextFormField(
                        obscureText: true,
                        controller: password,
                        keyboardType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(100),],
                        decoration: InputDecoration(
                            hintText: 'New password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'please enter password';
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: visible
                              ? CircularProgressIndicator(
                            color: Provider.of<Auth>(context,
                                listen: false)
                                .secondarycolor,
                          )
                              : Container(
                            width:
                            MediaQuery.of(context).size.width * 0.6,
                            height:
                            MediaQuery.of(context).size.width / 9,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Provider.of<Auth>(context,
                                  listen: false)
                                  .secondarycolor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Save Changes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.050),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if(currentpassword.text == Provider.of<Auth>(context, listen: false).user!["password"]){
                                http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/patient.php"), body: { "method" : "changepassword", "id_utilisateur" : Provider.of<Auth>(context, listen: false).user!["id_utilisateur"], "password" : password.text,});
                                var data = jsonDecode(response.body);
                                Provider.of<Auth>(context, listen: false).user = data[0];
                                Navigator.push(context, MaterialPageRoute(builder: (builder) => PatientProfile()));
                                Fluttertoast.showToast(
                                  msg: "Successfully Change",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }else{
                                Fluttertoast.showToast(
                                  msg: "the current password is incorrect",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
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
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
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
