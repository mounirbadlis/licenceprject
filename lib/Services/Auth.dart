import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/login.dart';

class Auth extends ChangeNotifier{
  Map ?user;
  List ?medecins;
  List ?pharmacists;
  List ?patients;
  String baseurl = "192.168.142.240";
  Color primarycolor = Color.fromARGB(100, 233, 233, 233);
  Color secondarycolor = Color.fromARGB(249, 8, 27, 63);
  Color whitecolor = Colors.white;
  BoxDecoration shadow = BoxDecoration(boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50),]);

  Future<void> logout() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    http.Response response = await http.post(Uri.parse("http://${baseurl}/mydb/login.php"), body: { "method" : "logout", "token" : storage.getString('token')});
    if(response.statusCode == 200){
      storage.remove('token');
    }
  }

  Future<void> getUsers() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${baseurl}/mydb/admin.php"), body: { "method" : "getusers"});
    data = jsonDecode(response.body);
    medecins = data["medecins"];
    pharmacists = data["pharmacists"];
    patients = data["patients"];
    notifyListeners();
  }
}

/*ListView.builder(
            itemCount: medecins?.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.10,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Provider.of<Auth>(context, listen: false).whitecolor,
              boxShadow: [BoxShadow( color: Colors.grey, offset: Offset(1, 1), blurRadius: 50)]
              ),
              child: Stack(
              children: [
              Positioned( left: MediaQuery.of(context).size.width * 0.030, top: MediaQuery.of(context).size.height * 0.005,child: Text("${medecins![index]["prenom"]} ${medecins![index]["nom"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.030,),)),
              Positioned( left: MediaQuery.of(context).size.width * 0.030, top: MediaQuery.of(context).size.height * 0.035,child: Text("Speciality: ${medecins![index]["specialite"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025, color: Provider.of<Auth>(context, listen: false).secondarycolor),)),
              Positioned( left: MediaQuery.of(context).size.width * 0.030, top: MediaQuery.of(context).size.height * 0.065,child: Text("Phone: +213${medecins![index]["phone"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025, color: Provider.of<Auth>(context, listen: false).secondarycolor),)),
              Positioned( right: MediaQuery.of(context).size.width * 0.010, bottom: MediaQuery.of(context).size.height * 0.015,child: TextButton(onPressed: (){}, child: Icon(Icons.remove_circle, color: Colors.red, size: MediaQuery.of(context).size.height * 0.05,),)),
              Positioned( right: MediaQuery.of(context).size.width * 0.12, bottom: MediaQuery.of(context).size.height * 0.015,child: TextButton(onPressed: (){}, child: Icon(Icons.edit, color: Colors.grey, size: MediaQuery.of(context).size.height * 0.05,),)),
              ],
              ),
              );
            }
            ),
            */
