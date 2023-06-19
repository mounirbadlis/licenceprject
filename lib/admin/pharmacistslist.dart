import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled/admin/admindrawer.dart';
import 'package:http/http.dart' as http;
import '../Services/Auth.dart';
import 'admin.dart';

class PharmacistsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PhLPages();
}

class PhLPages extends State<PharmacistsList> {
  bool visible = false;
  bool hide = true;
  final formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController specialete = TextEditingController();
  List pharmacies = [];
  var selectedPharmacie;
  var colors = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.amber
  ];
  Random c = Random();

  Future<void> onRefresh() async {
    setState(() {
      getUsers();
    });
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
          title: Center(child: Text("Pharmacists")),
          backgroundColor:
              Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: AdminDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddPharmacistDialog();
          },
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
            color: Provider.of<Auth>(context, listen: false).primarycolor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: FutureBuilder<List>(
                future: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TextButton(
                              onPressed: () {},
                              child: Container(
                                padding: EdgeInsets.zero,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.08,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          colors[c.nextInt(colors.length)],
                                      radius: MediaQuery.of(context).size.width *
                                          0.09,
                                      child: Text(
                                        "${snapshot.data![index]["nom"][0]}${snapshot.data![index]["prenom"][0]}",
                                        style: TextStyle(
                                            color: Provider.of<Auth>(context,
                                                    listen: false)
                                                .whitecolor,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.data![index]["nom"]} ${snapshot.data![index]["prenom"]}",
                                          style: TextStyle(
                                              color: Provider.of<Auth>(context,
                                                      listen: false)
                                                  .secondarycolor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.020,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${snapshot.data![index]["nom_ph"]}",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.020,
                                              color: Provider.of<Auth>(context,
                                                      listen: false)
                                                  .secondarycolor),
                                        ),
                                        Text(
                                          "+213${snapshot.data![index]["phone"]}",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.020,
                                              color: Provider.of<Auth>(context,
                                                      listen: false)
                                                  .secondarycolor),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            showModifyPharmacistDialog(
                                                snapshot.data![index]);
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      title: Text('Confirmation'),
                                                      content: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                1.8,
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                3.8,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Do You Want To Delete This Pharmacist?",
                                                              style: TextStyle(
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.020,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Row(
                                                              children: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    deletePharmacist(
                                                                        snapshot.data![
                                                                                index]
                                                                            [
                                                                            "id_utilisateur"],
                                                                        snapshot.data![
                                                                                index]
                                                                            [
                                                                            "id_pharmacien"]);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .height *
                                                                        0.05,
                                                                    width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width /
                                                                        5.5,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    child: Text(
                                                                      "Delete",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.height *
                                                                                  0.020,
                                                                          color: Provider.of<Auth>(context,
                                                                                  listen: false)
                                                                              .whitecolor),
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .height *
                                                                        0.05,
                                                                    width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width /
                                                                        5.5,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .green,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    child: Text(
                                                                      "No",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.height *
                                                                                  0.020,
                                                                          color: Provider.of<Auth>(context,
                                                                                  listen: false)
                                                                              .whitecolor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                        });
                  } else if (snapshot.hasError) {
                    return Text('No Pharmacists found!');
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
                }),
          ),
        ),
      ),
    );
  }

  void showAddPharmacistDialog() {
    email.clear();
    password.clear();
    nom.clear();
    prenom.clear();
    phone.clear();
    adresse.clear();
    specialete.clear();
    selectedPharmacie = null;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Pharmacist'),
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
                            hintText: 'Password',
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
                                Provider.of<Auth>(context, listen: false)
                                    .shadow,
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
                                Provider.of<Auth>(context, listen: false)
                                    .shadow,
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
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.width / 9,
                      //decoration:  BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50),]),
                      child: DropdownButtonFormField(
                        value: selectedPharmacie,
                        hint: Text('Select a pharmacy'),
                        items: pharmacies.map((pharmacy) {
                          return DropdownMenuItem(
                            value: pharmacy['id_pharmacie'],
                            child: Text(
                                "${pharmacy['nom_ph']} - ${pharmacy['adresse_ph']}"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPharmacie = value;
                            print(selectedPharmacie);
                          });
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: visible
                            ? CircularProgressIndicator(
                                color: Provider.of<Auth>(context, listen: false)
                                    .secondarycolor,
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: MediaQuery.of(context).size.width / 9,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      Provider.of<Auth>(context, listen: false)
                                          .secondarycolor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.050),
                                ),
                              ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              visible = !visible;
                            });
                            http.Response response = await http.post(
                                Uri.parse(
                                    "http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/admin.php"),
                                body: {
                                  "method": "addpharmacist",
                                  "email": email.text,
                                  "password": password.text,
                                  "nom": nom.text,
                                  "prenom": prenom.text,
                                  "phone": phone.text,
                                  "adresse": adresse.text,
                                  "id_pharmacie": selectedPharmacie
                                });
                            if (response.statusCode == 200) {
                              Fluttertoast.showToast(
                                msg: "successfully added",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => PharmacistsList()));
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

  void showModifyPharmacistDialog(Map data) {
    String v_email = data["email"];
    email.text = data["email"];
    password.text = data["password"];
    prenom.text = data["prenom"];
    nom.text = data["nom"];
    phone.text = data["phone"];
    adresse.text = data["adresse"];
    selectedPharmacie = data["id_pharmacie"];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool hide = true;
        return AlertDialog(
            title: Text('Modify Pharmacist'),
            content: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.58,
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
                                color: Provider.of<Auth>(context,
                                    listen: false)
                                    .secondarycolor,
                                fontSize:
                                MediaQuery.of(context).size.height *
                                    0.015,
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
                                controller: prenom,
                                keyboardType: TextInputType.text,
                                inputFormatters: [LengthLimitingTextInputFormatter(50),],
                                decoration: InputDecoration(
                                    hintText: 'First Name',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
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
                                color: Provider.of<Auth>(context,
                                    listen: false)
                                    .secondarycolor,
                                fontSize:
                                MediaQuery.of(context).size.height *
                                    0.015,
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
                                controller: nom,
                                keyboardType: TextInputType.text,
                                inputFormatters: [LengthLimitingTextInputFormatter(50),],
                                decoration: InputDecoration(
                                    hintText: 'Family Name',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
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
                          Text("Pharmacy", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.height * 0.015, fontWeight: FontWeight.bold),),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.width / 9,
                              alignment: Alignment.center,
                              //decoration:  BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50),]),
                              child: DropdownButtonFormField(
                                value: selectedPharmacie,
                                hint: Text(
                                    '${data["nom_ph"]} - ${data['adresse_ph']}'),
                                items: pharmacies.map((pharmacy) {
                                  return DropdownMenuItem(
                                    value: pharmacy['id_pharmacie'],
                                    child: Text(
                                        "${pharmacy['nom_ph']} - ${pharmacy['adresse_ph']}"),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPharmacie = value;
                                    print(selectedPharmacie);
                                  });
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
                                      'Modify',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context).size.width * 0.050),
                                    ),
                                  ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/admin.php"), body: {"method": "editpharmacist", "id_utilisateur": data["id_utilisateur"], "id_pharmacien": data["id_pharmacien"], "nom": nom.text, "prenom": prenom.text, "phone": phone.text, "adresse": adresse.text, "id_pharmacie": selectedPharmacie,});
                                Fluttertoast.showToast(
                                  msg: "successfully modify",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.push(context, MaterialPageRoute(builder: (builder) => PharmacistsList()));
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Future<List<dynamic>>? getUsers() async {
    var data;
    http.Response response = await http.post(
        Uri.parse(
            "http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/admin.php"),
        body: {"method": "getusers"});
    data = jsonDecode(response.body);
    var pharmacists = data["pharmacists"];
    pharmacies = data["pharmacies"];
    return pharmacists;
  }

  Future<void> deletePharmacist(
      dynamic id_utilisateur, dynamic id_pharmacist) async {
    print("$id_utilisateur --- $id_pharmacist");
    http.Response response = await http.post(
        Uri.parse(
            "http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/admin.php"),
        body: {
          "method": "deletepharmacist",
          "id_utilisateur": id_utilisateur,
          "id_pharmacien": id_pharmacist
        });
    Fluttertoast.showToast(
      msg: "successfully removed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => PharmacistsList()));
  }
}
