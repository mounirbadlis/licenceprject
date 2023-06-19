import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Services/Auth.dart';
import 'package:untitled/admin/admin.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:untitled/doctor/doctor.dart';
import 'package:untitled/patient/patient.dart';
import 'package:untitled/pharmacist/pharmacist.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPage();
}

class LoginPage extends State<Login> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool hide = true;
  bool visible = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          color: Provider.of<Auth>(context, listen: false).primarycolor,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo.png", width: MediaQuery.of(context).size.width * 0.4, height: MediaQuery.of(context).size.width * 0.4,),
                SizedBox(height: MediaQuery.of(context).size.width / 8,),
                Container( alignment: Alignment.centerLeft,child: Text("Welcome", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width * 0.08, fontWeight: FontWeight.bold),)),
                Container( alignment: Alignment.centerLeft,child: Text("Back!", style: TextStyle(color: Provider.of<Auth>(context, listen: false).secondarycolor, fontSize: MediaQuery.of(context).size.width * 0.08, fontWeight: FontWeight.bold),)),
                SizedBox(height: MediaQuery.of(context).size.width / 12,),
                Form(
                  key: key,
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width / 6.5,
                          decoration: Provider.of<Auth>(context, listen: false).shadow,
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
                            validator: (v){ if (v!.isEmpty){ return 'please enter your email';}},
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 16,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width / 6.5,
                          decoration: Provider.of<Auth>(context, listen: false).shadow,
                          child: TextFormField(
                            obscureText: hide,
                            controller: password,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    hide
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hide = !hide;
                                    });
                                  },
                                )),
                            validator: (v){ if (v!.isEmpty){ return 'please enter your password';}},
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 12,
                      ),
                      TextButton(
                          onPressed: () {
                            visible ? null : login();
                          },
                          child: visible
                              ? CircularProgressIndicator(
                                  color: Provider.of<Auth>(context, listen: false).secondarycolor,
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.width / 8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Provider.of<Auth>(context, listen: false).secondarycolor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if(key.currentState!.validate()){
      setState(() { visible = !visible; });
      print("${email.text} ${password.text}");
      http.Response response = await http.post(Uri.parse("http://${Provider.of<Auth>(context, listen: false).baseurl}/mydb/login.php"),
          body: { "method" : "login", "email" : email.text, "password" : password.text, "device" : deviceData['device']});
      if(response.statusCode == 200){
        print(response.body);
        setState(() { visible = !visible; });
        var data = jsonDecode(response.body);
        SharedPreferences storage = await SharedPreferences.getInstance();
        storage.setString('token', data['token']);
        Provider.of<Auth>(context, listen: false).user = data['user'][0];
        print("token issss ${storage.getString('token')}${Provider.of<Auth>(context, listen: false).user}");
        switch(data['user'][0]['type']){
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
            break;
        }
      }else{
        print(response.body);
        Fluttertoast.showToast(
          msg: "This user not found or password is incorrect",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() { visible = !visible;});
      }
    }
  }

  Future<void> initPlatformState() async {

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          deviceData =
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
      ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }
}
