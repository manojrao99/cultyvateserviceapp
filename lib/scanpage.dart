import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

class myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> _key = new GlobalKey();
  late LatLng gateway_latlng = LatLng(0.0, 0.0);
  late LatLng mpsms_latlang = LatLng(0.0, 0.0);
  late LatLng pump_latlang = LatLng(0.0, 0.0);
  late LatLng valve_latlang = LatLng(0.0, 0.0);
  late LatLng watermeter_latlang = LatLng(0.0, 0.0);
  late LatLng backwash_latlang = LatLng(0.0, 0.0);
  late LatLng others_latlang = LatLng(0.0, 0.0);
  String ? MobileDeviceIMEINo;
  bool isloading = false;
  bool dataupdating = false;
  Color gateway_location_color = Colors.red;
  Color mpsms_location_color = Colors.red;
  Color pump_location_color = Colors.red;
  Color valve_location_color = Colors.red;
  Color warermetter_location_color = Colors.red;
  Color backwash_location_color = Colors.red;
  Color others_location_color = Colors.red;
  late PermissionStatus _permissionGranted;
  // LocationPermission permission;
  TextEditingController fnumber = new TextEditingController();
  TextEditingController gatway = new TextEditingController();
  TextEditingController mpsms = new TextEditingController();
  TextEditingController pc = new TextEditingController();
  TextEditingController valve = new TextEditingController();
  TextEditingController wm = new TextEditingController();
  TextEditingController backwash = new TextEditingController();
  TextEditingController others = new TextEditingController();
  late PermissionStatus status;
   askPermission() async {
     PermissionStatus   status = await Permission.location.request();
    if (status.isDenied == true) {
      askPermission();
    }
    else {
      return status;
    }
  }






    String _scanBarcode = 'Unknown';

  //Qr code
  Future<void> scanQRgatway() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#228B22', 'Cancel', true, ScanMode.QR,);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get ';
    }
//barcode scanner flutter ant
    setState(() {
      gatway.text = barcodeScanRes;
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanQRspsms() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#228B22', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get ';
    }
//barcode scanner flutter ant
    setState(() {
      mpsms.text = barcodeScanRes;
      _scanBarcode = barcodeScanRes;
    });
  }
    void initState(){

    super.initState();
    getimei();

  }

  Future<void> getimei()async{
    setState((){
      isloading=true;

    });
    MobileDeviceIMEINo = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    setState((){
      isloading=false;

    });
  }

  Future<void> scanQRpc() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#228B22', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get ';
    }
//barcode scanner flutter ant

    setState(() {
      pc.text = barcodeScanRes;
      _scanBarcode = barcodeScanRes;
    });
  }
  Future<LatLng> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // debugPrint('location: ${position.latitude} ${position.longitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    return LatLng(position.latitude, position.longitude);

  }
  Future<void> scanQRvalve() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#228B22', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get ';
    }
//barcode scanner flutter ant
    setState(() {
      valve.text = barcodeScanRes;
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanQRwm() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#228B22', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get';
    }
//barcode scanner flutter ant
    setState(() {
      wm.text = barcodeScanRes;
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanQRother() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#228B22', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get';
    }
//barcode scanner flutter ant
    setState(() {
      others.text = barcodeScanRes;
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanQRbackwash() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#228B22', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get';
    }
//barcode scanner flutter ant
    setState(() {
      backwash.text = barcodeScanRes;
      _scanBarcode = barcodeScanRes;
    });
  }

  clear() {
    setState((){
      gateway_latlng=LatLng(0.0, 0.0);
      mpsms_latlang=LatLng(0.0, 0.0);
      pump_latlang=LatLng(0.0, 0.0);
      valve_latlang=LatLng(0.0, 0.0);
      watermeter_latlang=LatLng(0.0, 0.0);
      backwash_latlang=LatLng(0.0, 0.0);
      others_latlang=LatLng(0.0, 0.0);
      gateway_location_color=Colors.red;
      mpsms_location_color=Colors.red;
      pump_location_color=Colors.red;
      valve_location_color=Colors.red;
      warermetter_location_color=Colors.red;
      backwash_location_color=Colors.red;
      others_location_color=Colors.red;

      fnumber.text = "";
      gatway.text = "";
      wm.text = "";
      mpsms.text = "";
      pc.text = "";
      valve.text = "";
      others.text="";
      backwash.text="";
      dataupdating=false;
    });

  }

  datasave() async {
    // setState((){
    //   dataupdating=true;
    // });
    var response = await http.post(
        Uri.parse(
            // "http://192.168.1.121:8085/api/farm2fork/service/appfarmerdetails"
            "http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/service/appfarmerdetails"
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode({

          "FarmerPhoneNumber":fnumber.text,
          "GatewaySerialNo":gatway.text,
          "GatewayLatitude":gateway_latlng.latitude,
          "GatewayLongitude":gateway_latlng.longitude,
          "PumpcontrollerSerialNo":pc.text,
          "PumpcontrollerLatitude":pump_latlang.latitude,
          "PumpcontrollerLongitude":pump_latlang.longitude,
          "BackWashSerialNo":backwash.text,
          "BackWashLatitude":backwash_latlang.latitude,
          "BackWashLongitude":backwash_latlang.longitude,
          "WatermeterSerialNo":wm.text,
          "WatermeterLatitude":watermeter_latlang.latitude,
          "WatermeterLongitude":watermeter_latlang.longitude,
          "ValveSerialNo":valve.text,
          "ValveLatitude":valve_latlang.latitude,
          "ValveLongitude":valve_latlang.longitude,
          "SoilMoisterSensorSerialNo":mpsms.text,
          "SoilMoisterSensorLatitude":mpsms_latlang.latitude,
          "SoilMoisterSensorLongitude":mpsms_latlang.longitude,
          "OthersSerialNo":others.text,
          "OthersLatitude":others_latlang.latitude,
          "OthersLongitude":others_latlang.longitude,
          "MobileDeviceIMEINo":MobileDeviceIMEINo,
          "CompanyID":0,
          "BranchID":0
          //
          //
          // "Phonenumber": fnumber.text,
          // "Gateway": gatway.text,
          // "Pumpcontroller": pc.text,
          // "Valve": valve.text,
          // "Watermeter": wm.text,
          // "Mpsms": mpsms.text,
          // "BackWash": backwash.text,
          // "Others": others.text
        }));
    var responsee = json.decode(response.body);
    if (responsee['status'] == "Success") {
      clear();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Data Saved Successfully"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );

      // Fluttertoast.showToast(
      //     msg: 'Data Save Successfully', toastLength: Toast.LENGTH_LONG);

    } else {
      setState((){
        dataupdating=false;
      });
      Fluttertoast.showToast(
          msg: 'please check internet connection',
          toastLength: Toast.LENGTH_LONG);
    }
  }

  var width, hieght;
  static const IconData qr_code_scanner_rounded =
  IconData(0xf00cc, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    hieght = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Form(
              key: _key,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/cultyvate.png',
                    height: 50,
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text(
                              "Farmer",
                              style: TextStyle(
                                  color: Color.fromRGBO(10 ,192 ,92,2),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " Device Details",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ] )
                  ),isloading?CircularProgressIndicator():
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: fnumber,
                        decoration: InputDecoration(
                          labelText: 'Farmer Mobile number',
                          border: OutlineInputBorder(),
                          counter: Offstage(),
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          String pattern =
                              r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                          RegExp exp2 = new RegExp(pattern);
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone number';
                          } else if (value.length != 10 || !exp2.hasMatch(value)) {
                            return 'Please Enter 10 digit valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Align(alignment: Alignment.centerRight,child: Padding(padding: EdgeInsets.only(right: 10)
                    ,child: Text("latitude:${gateway_latlng.latitude} longitude:${gateway_latlng.longitude}"),
                    ),),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        controller: gatway,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                              FilteringTextInputFormatter.deny(
                                  RegExp(r'\s')),
                          ],
                        decoration: InputDecoration(

                            labelText: 'Gateway',
                            suffixIcon:
                            Wrap(
                              children: [
                                IconButton(
                                  icon: Icon(MdiIcons.barcode),
                                  onPressed: () => scanQRgatway(),
                                ),
                                InkWell(
                                  child: Padding(padding: EdgeInsets.only(top: 13,right: 5),child: ColorFiltered(
                                    child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                    colorFilter:  ColorFilter.mode(gateway_location_color, BlendMode.color),
                                  ),),
                                  onTap: () async {
                                    PermissionStatus   status=await askPermission();
                                    if(status.isGranted &&!status.isNull) {
                                      gateway_latlng = await _getLocation();
                                      if (gateway_latlng.latitude != 0.0 &&
                                          gateway_latlng.longitude != 0.0) {
                                        setState(() {
                                          gateway_location_color = Colors.green;
                                        });
                                      }
                                    }
                                    else{
                                      print("error");
                                    }
                                  },
                                ),
                              ],
                            ),

                            border: OutlineInputBorder()),
                      ),
                    ),
                    Align(alignment: Alignment.centerRight,child: Padding(padding: EdgeInsets.only(right: 10)
                      ,child: Text("latitude:${mpsms_latlang.latitude} longitude:${mpsms_latlang.longitude}"),
                    ),),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        controller: mpsms,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),
                        ],
                        decoration: InputDecoration(
                            labelText: 'MPSMS',

                            suffixIcon:Wrap(
                              // : CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(MdiIcons.barcode),
                                  onPressed: () => scanQRspsms(),
                                ),
                                InkWell(
                                  onTap: ()async{
                                PermissionStatus status=await askPermission();
                                if(status.isGranted){
                                  mpsms_latlang=await _getLocation();
                                  if(mpsms_latlang.latitude!=0.0&&mpsms_latlang.longitude!=0.0) {
                                    setState(() {
                                      mpsms_location_color = Colors.green;
                                    });
                                  }
                                }
                                else{
                                  askPermission();
                                }

                                  },
                                  child:    Padding(padding: EdgeInsets.only(top: 13,right: 5),child:  InkWell(
                                    child:ColorFiltered(
                                      child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                      colorFilter:  ColorFilter.mode(mpsms_location_color, BlendMode.color),
                                    ),
                                  ),),
                                )
                              ],
                            ),

                            border: OutlineInputBorder()),
                      ),
                    ),
                    Align(alignment: Alignment.centerRight,child: Padding(padding: EdgeInsets.only(right: 10)
                      ,child: Text("latitude:${pump_latlang.latitude} longitude:${pump_latlang.longitude}"),
                    ),),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        controller: pc,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),
                        ],
                        decoration: InputDecoration(
                            labelText: 'Pump Controller',
                            suffixIcon: Wrap(
                              children: [
                                IconButton(
                                  icon: Icon(MdiIcons.barcode),
                                  onPressed: () => scanQRpc(),
                                ),
                                  InkWell(
                                  onTap: ()async{
                                    pump_latlang=await _getLocation();
                                    if(pump_latlang.latitude!=0.0&&pump_latlang.longitude!=0.0) {
                                      setState(() {
                                        pump_location_color = Colors.green;
                                      });
                                    }
                                  },
                                  child:Padding(padding: EdgeInsets.only(top: 13,right: 5),child:ColorFiltered(
                                    child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                    colorFilter:  ColorFilter.mode(pump_location_color, BlendMode.color),
                                  ),
                                ),)
                              ],
                            ),


                            border: OutlineInputBorder()),
                      ),
                    ),
                    Align(alignment: Alignment.centerRight,child: Padding(padding: EdgeInsets.only(right: 10)
                      ,child: Text("latitude:${valve_latlang.latitude} longitude:${valve_latlang.longitude}"),
                    ),),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        controller: valve,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),
                        ],
                        decoration: InputDecoration(
                            labelText: 'Valve',
                            suffixIcon:
                            Wrap(
                              children: [

                                IconButton(
                                  icon: Icon(MdiIcons.barcode),
                                  onPressed: () => scanQRvalve(),
                                ),

                                InkWell(
                                  onTap: ()async{

                                    valve_latlang=await _getLocation();
                                    if(valve_latlang.latitude!=0.0&&valve_latlang.longitude!=0.0) {
                                      setState(() {
                                        valve_latlang;
                                        valve_location_color = Colors.green;
                                      });
                                    }
                                  },
                                  child: Padding(padding: EdgeInsets.only(top: 13,right: 5),child: ColorFiltered(
                                    child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                    colorFilter:  ColorFilter.mode(valve_location_color, BlendMode.color),
                                  ),
                                ),)
                              ],
                            ),

                            border: OutlineInputBorder()),
                      ),
                    ),
                    Align(alignment: Alignment.centerRight,child: Padding(padding: EdgeInsets.only(right: 10)
                      ,child: Text("latitude:${watermeter_latlang.latitude} longitude:${watermeter_latlang.longitude}"),
                    ),),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        controller: wm,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),
                        ],
                        decoration: InputDecoration(
                            labelText: 'Water Meter',
                            suffixIcon: Wrap(
                              children: [
                                IconButton(
                                  icon: Icon(MdiIcons.barcode),
                                  onPressed: () => scanQRwm(),
                                ),
                             InkWell(
                                  onTap: ()async{
                                    watermeter_latlang =await _getLocation();
                                    if(watermeter_latlang.latitude!=0.0&&watermeter_latlang.longitude!=0.0){
                                      setState((){
                                        warermetter_location_color=Colors.green;
                                      });

                                    }

                                  },
                                  child:    Padding(padding: EdgeInsets.only(top: 13,right: 5),child: ColorFiltered(
                                    child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                    colorFilter:  ColorFilter.mode(warermetter_location_color, BlendMode.color),
                                  ),
                                ),)
                              ],
                            ),


                            border: OutlineInputBorder()),
                      ),
                    ),
                    Align(alignment: Alignment.centerRight,child: Padding(padding: EdgeInsets.only(right: 10)
                      ,child: Text("latitude:${backwash_latlang.latitude} longitude:${backwash_latlang.longitude}"),
                    ),),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        controller: backwash,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),
                        ],
                        decoration: InputDecoration(
                            labelText: 'Back Wash',
                            suffixIcon:Wrap(
                              children: [
                                IconButton(
                                  icon: Icon(MdiIcons.barcode),
                                  onPressed: () => scanQRbackwash(),
                                ),
                                InkWell(
                                  onTap: ()async{
                                    backwash_latlang=await _getLocation();
                                    if(backwash_latlang.latitude!=0.0 && backwash_latlang.longitude!=0.0){
                                      setState((){
                                        backwash_location_color=Colors.green;
                                      });

                                    }
                                  },
                                  child: Padding(padding: EdgeInsets.only(top: 13,right: 5),child: ColorFiltered(
                                    child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                    colorFilter:  ColorFilter.mode(backwash_location_color, BlendMode.color),
                                  ),
                                ),)
                              ],
                            ),


                            border: OutlineInputBorder()),
                      ),
                    ),
                    Align(alignment: Alignment.centerRight,child: Padding(padding: EdgeInsets.only(right: 10)
                      ,child: Text("latitude:${others_latlang.latitude} longitude:${others_latlang.longitude}"),
                    ),),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        controller: others,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),
                        ],
                        decoration: InputDecoration(
                            labelText: 'Others',
                            suffixIcon: Wrap(
                              children: [
                                IconButton(
                                  icon: Icon(MdiIcons.barcode),
                                  onPressed: () => scanQRother(),
                                ),
                                 InkWell(
                                  onTap: ()async{
                                    askPermission();
                                    others_latlang=await _getLocation();
                                    if(others_latlang.latitude!=0.0 && others_latlang.longitude!=0.0){
                                      setState((){
                                        others_location_color=Colors.green;
                                      });

                                    }
                                  },
                                  child:Padding(padding: EdgeInsets.only(top: 13,right: 5),child: ColorFiltered(
                                    child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                    colorFilter:  ColorFilter.mode(others_location_color, BlendMode.color),
                                  ),
                                ),)
                              ],
                            ),


                            border: OutlineInputBorder()),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 shadowColor: Colors.green
                               ),
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),

                            onPressed: () async {
                              // if (_key.currentState!.validate()) {
                              if(fnumber.text.length >=10)
                                datasave();
                              else{
                                Fluttertoast.showToast(
                                    msg: "Enter 10 digits valid phone number",
                                    backgroundColor: Colors.red
                                );
                              }

                              // }
                            },
                          ),
                          SizedBox(
                            width: 30,
                          ),

                          ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                     shadowColor:
                                 Colors.grey,

                               ),
                              child: Text(
                                "Clear",
                                style: TextStyle(color: Colors.white),
                              ),

                              onPressed: () => clear())
                        ])
                  ],
                ),
                  ],
                )
            )),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<PermissionStatus>('_permissionGranted', _permissionGranted));
  }
}
