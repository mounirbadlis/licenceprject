import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Services/Auth.dart';
import 'package:untitled/admin/admindrawer.dart';
import 'package:untitled/admin/doctorslist.dart';
import 'package:untitled/admin/patientslist.dart';
import 'package:untitled/admin/pharmacistslist.dart';
import 'package:untitled/patient/mycomplaints.dart';
import 'package:untitled/patient/myrecords.dart';
import 'package:untitled/patient/patientdrawer.dart';
import 'package:untitled/pharmacist/medicines.dart';
import 'package:untitled/pharmacist/orders.dart';
import 'package:untitled/pharmacist/pharmacistdrawer.dart';
import 'package:untitled/pharmacist/stock.dart';

import 'myorders.dart';

class Patient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PatientPage();
}

class PatientPage extends State<Patient> {
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
          title: Center(child: Text("Patient Dashboard"),),
          backgroundColor:
          Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: PatientDrawer(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          color: Provider.of<Auth>(context, listen: false).primarycolor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (builder) => MyRecords()));},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.18,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                      image: DecorationImage( image: AssetImage('assets/patient/myrecords.jpg',), fit: BoxFit.cover)
                  ),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.18 / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                    child: Text('My Records', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              TextButton(
                onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (builder) => MyOrders()));},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.18,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                      image: DecorationImage( image: AssetImage('assets/patient/myorders.jpg'), fit: BoxFit.cover)
                  ),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.18 / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                    child: Text('My Orders', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              TextButton(
                onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (builder) => MyComplaints()));},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.18,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                      image: DecorationImage( image: AssetImage('assets/patient/mycomplaints.png'), fit: BoxFit.cover)
                  ),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.18 / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                    child: Text('My Complaints', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
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
