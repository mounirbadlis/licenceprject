import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Services/Auth.dart';
import 'package:untitled/admin/admindrawer.dart';
import 'package:untitled/admin/doctorslist.dart';
import 'package:untitled/admin/patientslist.dart';
import 'package:untitled/admin/pharmacistslist.dart';
import 'package:untitled/doctor/complaints.dart';
import 'package:untitled/doctor/doctordrawer.dart';
import 'package:untitled/doctor/medicinesdoctor.dart';
import 'package:untitled/doctor/mypatients.dart';
import 'package:untitled/doctor/patients.dart';
import 'package:untitled/doctor/stockdoctor.dart';
class Doctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DoctorPage();
}

class DoctorPage extends State<Doctor> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).getUsers();
    super.initState();
  }

  Future<void> onRefresh() async {
    Provider.of<Auth>(context, listen: false).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Doctor Dashboard"),),
          backgroundColor:
          Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: DoctorDrawer(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => Patients()));},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.18,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                      image: DecorationImage( image: AssetImage('assets/doctor/patients.jpg',), fit: BoxFit.cover)
                  ),
                  child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.18 / 4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                        child: Text('Patients', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              TextButton(
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => MyPatients()));},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.18,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                      image: DecorationImage( image: AssetImage('assets/doctor/mypatients.png',), fit: BoxFit.cover)
                  ),
                  child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.18 / 4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                        child: const Text('My Patients', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              TextButton(
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => Complaints()));},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.18,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                      image: DecorationImage( image: AssetImage('assets/doctor/complaints.webp',), fit: BoxFit.cover)
                  ),
                  child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.18 / 4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                        child: const Text('Complaints', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              TextButton(
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => MedicinesDoctor()));},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.18,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                      image: DecorationImage( image: AssetImage('assets/pharmacist/medicines.jpg',), fit: BoxFit.cover)
                  ),
                  child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.18 / 4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                        child: const Text('Medicines', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
