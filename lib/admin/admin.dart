import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Services/Auth.dart';
import 'package:untitled/admin/admindrawer.dart';
import 'package:untitled/admin/doctorslist.dart';
import 'package:untitled/admin/patientslist.dart';
import 'package:untitled/admin/pharmacistslist.dart';

import 'modifications.dart';

class Admin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AdminPage();
}

class AdminPage extends State<Admin> {
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
          title: Center(child: Text("Admin Dashboard"),),
          backgroundColor:
              Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: AdminDrawer(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            color: Provider.of<Auth>(context, listen: false).primarycolor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => DoctorsList()));},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.18,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                        image: DecorationImage( image: AssetImage('assets/admin/doctors.jpg',), fit: BoxFit.cover)
                    ),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.18 / 4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                      child: Text('Doctors', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => PharmacistsList()));},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.18,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                        image: DecorationImage( image: AssetImage('assets/admin/pharmacists.jpeg',), fit: BoxFit.cover)
                    ),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.18 / 4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                      child: Text('Pharmacists', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => PatientsList()));},
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
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => Modifications()));},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.18,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)],
                        image: DecorationImage( image: AssetImage('assets/admin/complaints.jpg',), fit: BoxFit.cover)
                    ),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.18 / 4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
                      child: const Text('Edit Requests', style: TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
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
