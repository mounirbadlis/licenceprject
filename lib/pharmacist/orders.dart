import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/pharmacist/pharmacist.dart';
import 'package:untitled/pharmacist/pharmacistdrawer.dart';
import '../Services/Auth.dart';

class Orders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OPages();
}

class OPages extends State<Orders> {
  bool visible = false;
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  var doctors_orders;
  //var status_color = [Colors.orange, Colors.green, Colors.blue, Colors.red, Colors.amber];
  Map ?priscription;
  List price = [];
  int ?totals;
  List<Map> status = [{"id" : 2, "status" : "arrived"}, {"id" : 3, "status" : "cancel"}];
  var selectedStatus;

  Future<void> onRefresh() async {
    setState(() { getUsers();});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Pharmacist()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Orders")),
          backgroundColor:
          Provider.of<Auth>(context, listen: false).secondarycolor,
        ),
        drawer: PharmacistDrawer(),
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
                              onPressed: (){ priscription = snapshot.data![index];selectedOrder(snapshot.data![index]); showPriscriptionDialog();},
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.095,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Expanded(flex: 1,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(text: TextSpan(children: [TextSpan(text: "${snapshot.data![index]["date"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold))])),
                                            RichText(text: TextSpan(children: [TextSpan(text: "From ", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "${doctors_orders[index]["nom"]} ${doctors_orders[index]["prenom"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020))])),
                                            RichText(text: TextSpan(children: [TextSpan(text: "To ", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "${snapshot.data![index]["nom"]} ${snapshot.data![index]["prenom"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020))])),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on, color: Provider.of<Auth>(context, listen: false).secondarycolor, size: MediaQuery.of(context).size.height * 0.020,),
                                                Text("${snapshot.data![index]["adresse"]}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).secondarycolor),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: int.parse(snapshot.data![index]["etat"]) == 0,
                                        child: Expanded(flex: 1,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(onPressed: () async {
                                                  http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: {"method": "acceptorder", "id_livraison" : snapshot.data![index]["id_livraison"], "etat" : "1"});
                                                  Navigator.push(context, MaterialPageRoute(builder: (builder) => Orders()));
                                                },
                                                      child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30),),
                                                      child: Text("Accept", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                                                TextButton(
                                                  onPressed: (){
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Confirmation'),
                                                            content: Container(
                                                              alignment: Alignment.center,
                                                              width: MediaQuery.of(context).size.width / 1.8,
                                                              height: MediaQuery.of(context).size.width / 3.8,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text("Do You Want To Delete This Order?", style: TextStyle( fontSize: MediaQuery.of(context).size.height * 0.020,fontWeight: FontWeight.bold),),
                                                                  Row(
                                                                    children: [
                                                                      TextButton(onPressed: () async {
                                                                        http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: {"method": "refuseorder", "id_livraison" : snapshot.data![index]["id_livraison"]});
                                                                        Navigator.push(context, MaterialPageRoute(builder: (builder) => Orders()));
                                                                      },
                                                                        child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30),),
                                                                          child: Text("Delete", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                                                                      TextButton(onPressed: (){ Navigator.pop(context);},
                                                                        child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30),),
                                                                          child: Text("Cancel", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                                                                    ],
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                        );
                                                      }
                                                  );
                                                },
                                                  child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(30),),
                                                    child: Text("Refuse", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                                              ],
                                            ),
                                        ),
                                      ),
                                      Visibility( visible: int.parse(snapshot.data![index]["etat"]) != 0 && int.parse(snapshot.data![index]["etat"]) != 2,
                                          child:
                                          Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width * 2 / 5.5,
                                            height: MediaQuery.of(context).size.width * 0.11,
                                            child: Form(
                                              child: DropdownButtonFormField(
                                                value: selectedStatus,
                                                hint: int.parse(snapshot.data![index]["etat"]) == 0 ? Text("") :
                                                Text("update order status", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.015, fontWeight: FontWeight.bold),),
                                                items: status.map((status) {
                                                  return DropdownMenuItem(
                                                    value: status['id'],
                                                    child: Text("${status['status']}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018),),
                                                  );
                                                }).toList(),
                                                onChanged: (value) async {
                                                  if(value == 2){
                                                    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"),
                                                        body: {"method": "updateorder", "id_livraison" : snapshot.data![index]["id_livraison"], "etat" : value.toString(),
                                                          "id_ordonnance" : snapshot.data![index]["id_ordonnance"], "id_pharmacie" : Provider.of<Auth>(context, listen: false).user!["id_pharmacie"]});
                                                    Navigator.push(context, MaterialPageRoute(builder: (builder) => Orders()));
                                                  }else{
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                              title: Text('Confirmation'),
                                                              content: Container(
                                                                alignment: Alignment.center,
                                                                width: MediaQuery.of(context).size.width / 1.8,
                                                                height: MediaQuery.of(context).size.width / 3.8,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text("Do You Want To Delete This Order?", style: TextStyle( fontSize: MediaQuery.of(context).size.height * 0.020,fontWeight: FontWeight.bold),),
                                                                    Row(
                                                                      children: [
                                                                        TextButton(onPressed: () async {
                                                                          http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"),
                                                                              body: {"method": "refuseorder", "id_livraison" : snapshot.data![index]["id_livraison"]});
                                                                          Navigator.push(context, MaterialPageRoute(builder: (builder) => Orders()));
                                                                        },
                                                                          child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05,
                                                                            width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30),),
                                                                            child: Text("Delete", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                                                                        TextButton(onPressed: (){ Navigator.pop(context);},
                                                                          child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05,
                                                                            width: MediaQuery.of(context).size.width / 5.5, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30),),
                                                                            child: Text("Cancel", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                                                                      ],
                                                                      mainAxisAlignment: MainAxisAlignment.center,),],),));});}},
                                              ),
                                            ),
                                          ),
                                      ),
                                      Visibility( visible: int.parse(snapshot.data![index]["etat"]) == 2,
                                        child: Container(alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width / 6, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30),),
                                            child: Text("Arrived", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.020, color: Provider.of<Auth>(context, listen: false).whitecolor),),),),
                                    ],
                                  )
                              ),
                          );
                        }
                    );

                  } else if (snapshot.hasError) {
                    return Text('No Orders found!');
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

  Future<List<dynamic>>? getUsers() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: {"method" : "orders", "id_pharmacie" : Provider.of<Auth>(context, listen: false).user!["id_pharmacie"]});
    data = jsonDecode(response.body);
    var patients_orders = data["orders_patients"];
    doctors_orders = data["orders_doctors"];
    return patients_orders;
  }

  Future<List<dynamic>>? selectedOrder(Map priscription) async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: {"method" : "selectedorder", "id_ordonnance" : priscription["id_ordonnance"]});
    data = jsonDecode(response.body);
    price = data;
    return data;
  }

  void showPriscriptionDialog() {
    var total = 0;
    price.forEach((element) {
      total += int.parse(element["prix"]) * int.parse(element["nbr_b"]);
    });
    setState(() {
      totals = total;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Priscrption'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.width * 0.8, /*alignment: Alignment.topCenter,*/
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity, height: MediaQuery.of(context).size.height * 0.05,
                      child: Row(
                        children: [
                          Expanded( flex: 4,child: Text("Name", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                          Expanded( flex: 2,child: RichText(text: TextSpan(children: [TextSpan(text: "Dosage", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold)), TextSpan(text: "(pills/day)", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.015))]))),
                          Expanded( flex: 1,child: Text("Packs", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List> (
                        future: selectedOrder(priscription!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.06,
                                    child: Row(
                                      children: [
                                        Expanded( flex: 4,child: Text("${snapshot.data![index]["nom_m"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
                                        Expanded( flex: 2,child: Text("${snapshot.data![index]["dosage"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
                                        Expanded( flex: 1,child: Text("${snapshot.data![index]["nbr_b"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
                                      ],
                                    ),
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Center(child: Text('No Medicines found!'));
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
                    ),),
                    Text("Total Price: ${totals} DA", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)
                  ],
                ),
              )
          );
        }
        );
  }

}
