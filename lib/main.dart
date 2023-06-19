import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Services/doctorprovider.dart';
import 'package:untitled/patient/patient.dart';
import 'package:untitled/pharmacist/pharmacist.dart';
import 'Services/Auth.dart';
import 'Services/patientprovider.dart';
import 'admin/admin.dart';
import 'doctor/doctor.dart';
import 'login.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter  Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState(){
    super.initState();
    initialization();
    tryToken();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    //print('ready in 1...');
    //await Future.delayed(const Duration(seconds: 1));
    //print('go!');
    FlutterNativeSplash.remove();
  }
  Future<void> tryToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    print("token----------------------- ${storage.getString('token')}");
    if(storage.getString("token") == null){
      Navigator.push(context, MaterialPageRoute(builder: (builder) => Login()));
    }else{
      http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/login.php"), body: {"method" : "trytoken", "valeur" : storage.getString('token')});
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print("data------------- $data");
        Provider.of<Auth>(context, listen: false).user = data["user"][0];
        print("${Provider.of<Auth>(context, listen: false).user}");
        switch(data["user"][0]['type']){
          case '1':
            Navigator.push(context, MaterialPageRoute(builder: (builder) => Admin()));
            break;
          case '2':
            Navigator.push(context, MaterialPageRoute(builder: (builder) => Doctor()));
            break;
          case '3':
            Navigator.push(context, MaterialPageRoute(builder: (builder) => Pharmacist()));
            break;
          case '4':
            Navigator.push(context, MaterialPageRoute(builder: (builder) => Patient()));
        }
      }else{
        print(2);
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Login()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitWaveSpinner(
          color: Color.fromARGB(233, 20, 108, 148),
          trackColor: Color.fromARGB(233, 25, 167, 206),
          waveColor: Color.fromARGB(233, 175, 211, 226),
          size: MediaQuery.of(context).size.width / 6,
          duration: Duration(milliseconds: 1500),
        )
        //CircularProgressIndicator(color: Provider.of<Auth>(context, listen: false).secondarycolor,),
      ),
    );
  }
}
