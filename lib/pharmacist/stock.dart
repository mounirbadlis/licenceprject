import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/pharmacist/pharmacist.dart';
import 'package:untitled/pharmacist/pharmacistdrawer.dart';
import '../Services/Auth.dart';

class Stock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SPage();
}

class SPage extends State<Stock> {
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController qte = TextEditingController();
  bool visible = false;
  List medicines = [];
  var selectedMedicine;

  @override
  void initState(){
    getStock();
    super.initState();
  }

  Future<void> onRefresh() async {
    setState(() {
      getStock();
    });
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
          title: Center(child: Text("Stock")), backgroundColor: Provider.of<Auth>(context, listen: false).secondarycolor,),
        drawer: PharmacistDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () { showAddStockDialog();},
          child: Icon(Icons.add),
          backgroundColor: Provider.of<Auth>(context, listen: false).secondarycolor,
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
          onRefresh: onRefresh,
          child: Container(
            color: Provider.of<Auth>(context, listen: false).primarycolor, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,/* padding: EdgeInsets.all(20),*/ alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                  width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration( color: Provider.of<Auth>(context, listen: false).whitecolor,boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)]),
                  child: Row(
                    children: [
                      Expanded( flex: 4,child: Text("Name", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                      Expanded( flex: 1,child: Text("QTE", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),)),
                      Expanded( flex: 1,child: TextButton(onPressed: (){}, child: Icon(Icons.edit, color: Colors.transparent, size: MediaQuery.of(context).size.height * 0.03,),),),
                      Expanded( flex: 1,child: TextButton(onPressed: (){}, child: Icon(Icons.edit, color: Colors.transparent, size: MediaQuery.of(context).size.height * 0.03,),),),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List> (
                      future: getStock(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  child: Row(
                                    children: [
                                      Expanded( flex: 4,child: Text("${snapshot.data![index]["nom_m"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
                                      Expanded( flex: 1,child: Text("${snapshot.data![index]["quantite"]}", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor,fontSize: MediaQuery.of(context).size.height * 0.020),)),
                                      Expanded( flex: 1,child: TextButton(onPressed: (){ showModifyStockDialog(snapshot.data![index]);}, child: Icon(Icons.edit, color: Colors.grey, size: MediaQuery.of(context).size.height * 0.03,),),),
                                      Expanded( flex: 1,child: TextButton(onPressed: (){ deleteStock(snapshot.data![index]["id_stock"]);}, child: Icon(Icons.delete, color: Colors.grey, size: MediaQuery.of(context).size.height * 0.03,),),),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showModifyStockDialog(Map medicine) {
    qte.text = medicine["quantite"];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Modify Quantity'),
              content: Container(
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
                            controller: qte,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Quantity',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                )),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'please enter Quantity';
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
                                http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: { "method" : "editstock", "id_stock" : medicine["id_stock"], "quantite" : qte.text});
                                Navigator.push(context, MaterialPageRoute(builder: (builder) => Stock()));
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  void showAddStockDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Add Stock'),
              content: Container(
                height: MediaQuery.of(context).size.width * 0.5,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.width / 9,
                        child: Form(
                          child: DropdownButtonFormField(
                            value: selectedMedicine,
                            hint: Text('Select a Medicine'),
                            items: medicines.map((medicine) {
                              return DropdownMenuItem(
                                value: medicine['id_medicament'],
                                child: Text("${medicine['nom_m']}", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018),),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMedicine = value;
                                print(selectedMedicine);
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width / 8,
                          decoration:
                          Provider.of<Auth>(context, listen: false).shadow,
                          child: TextFormField(
                            controller: qte,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Quantity',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                )),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'please enter Quantity';
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
                              child: Text('Add', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.050),),
                            ),
                            onPressed: () async {
                              if(formKey.currentState!.validate()){
                                setState(() { visible = !visible;});
                                http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: { "method" : "addstock", "id_medicament" : selectedMedicine, "id_pharmacie" : Provider.of<Auth>(context, listen: false).user!["id_pharmacie"], "quantite" : qte.text});
                                if(response.statusCode == 200){
                                  Fluttertoast.showToast(msg: "successfully added",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0,);
                                  Navigator.push(context, MaterialPageRoute(builder: (builder) => Stock()));
                                }else{
                                  setState(() { visible = !visible;});
                                  Fluttertoast.showToast(msg: "this medicine is aleardy added",
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
              )
          );
        }
    );
  }

  Future<List<dynamic>>? getStock() async {
    var data;
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: {"method": "getstock", "id_pharmacie": Provider.of<Auth>(context, listen: false).user!["id_pharmacie"]});
    data = jsonDecode(response.body);
    var data2;
    http.Response response2 = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: {"method": "getmedicines", "id_pharmacie" : Provider.of<Auth>(context, listen: false).user!["id_pharmacie"]});
    data2 = jsonDecode(response2.body);
    setState(() {
      medicines = data2;
    });
    return data;
  }

  Future<void> deleteStock(dynamic id_stock) async {
    http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/pharmacist.php"), body: {"method" : "deletestock", "id_stock" : id_stock});
    Fluttertoast.showToast(msg: "successfully removed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,);
    Navigator.push(context, MaterialPageRoute(builder: (builder) => Stock()));
  }
}

