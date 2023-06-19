import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/admin/admin.dart';
import 'package:untitled/doctor/doctor.dart';
import 'package:untitled/login.dart';
import 'package:untitled/patient/patient.dart';
import 'package:untitled/patient/patientprofile.dart';
import 'package:untitled/pharmacist/pharmacist.dart';

import '../Services/Auth.dart';

class PatientDrawer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DrawerPage();

}

class DrawerPage extends State<PatientDrawer>{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04, bottom: MediaQuery.of(context).size.height * 0.04),
            decoration: BoxDecoration( color: Provider.of<Auth>(context, listen: false).secondarycolor, ),
            child: Column(
              children: [
                CircleAvatar(
                  child: Text("${Provider.of<Auth>(context, listen: false).user!["nom"][0]}${Provider.of<Auth>(context, listen: false).user!["prenom"][0]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width *0.06, fontWeight: FontWeight.bold),),
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Text("${Provider.of<Auth>(context, listen: false).user!["prenom"]} ${Provider.of<Auth>(context, listen: false).user!["nom"]}", style: TextStyle(color: Colors.white),),
                SizedBox(height: MediaQuery.of(context).size.height*0.01),
                Text("${Provider.of<Auth>(context, listen: false).user!["email"]}", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => Patient()));},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => PatientProfile()));
            },
          ),
          Spacer(), // Adds empty space to push Logout tile to bottom
          ListTile(
              leading: Icon(Icons.exit_to_app, color: Provider.of<Auth>(context, listen: false).whitecolor,),
              title: Text('Logout', style: TextStyle(color: Provider.of<Auth>(context, listen: false).whitecolor),),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.push(context, MaterialPageRoute(builder: (builder) => Login()));
              },
              tileColor: Colors.red
          ),
        ],
      ),
    );
  }
}