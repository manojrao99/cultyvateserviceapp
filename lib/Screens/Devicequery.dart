import 'dart:convert';
import 'package:imei_plugin/imei_plugin.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/devicequery.dart';
class DeviceQuery extends StatefulWidget {
  const DeviceQuery({Key? key}) : super(key: key);

  @override
  State<DeviceQuery> createState() => _DeviceQueryState();
}

class _DeviceQueryState extends State<DeviceQuery> {
List<Devicequerry> devicedata=[];
TextEditingController deviceid=new TextEditingController();
bool isloading=false;
String errormessage="";



parsedatetime(String date){
  print("date $date");
 if(date!="null") {
   DateTime givendate = DateTime.parse(date);
         if(givendate.year!=1980 && givendate.year!=1900 ) {
           String formattedDate = DateFormat('yyyy-MM-dd ,hh:mm a').format(
               givendate);
           // if(formattedDate.contains('1980')){
           //   return "null";
           // }
           // else{
           return formattedDate;
         }
         else{
           return "null";
         }
 }
 else {
   return "null";
 }

  // }

}



void initState() {
  datetimeconvert("2022-08-19T17:23:59");
  super.initState();
}

datetimeconvert(date){
  var z=  DateTime.parse(date);
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(z.toString(), true);


  print("actualdate${dateTime.timeZoneName}");
}

changeTimeTotolocal(dateUtc){


    if(dateUtc!="null") {
      var date=  DateTime.parse(dateUtc);
      print("example date ${date}");
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date.toString(), true);
      print("first date ${dateTime}");

      var dateLocal = dateTime.toLocal();
      print("local time ${dateLocal}");
      if(dateLocal.year!=1980 && dateLocal.year!=1900 ) {
        String formattedDate = DateFormat('yyyy-MM-dd ,hh:mm a').format(dateLocal);
        // if(formattedDate.contains('1980')){
        //   return "null";
        // }
        // else{
        return formattedDate;
      }
      else{
        return "null";
      }
    }
    else {
      return "null";
    }
}

Widget DeferanceDateandTine(givendata){
 // var givendate= DateFormat('yyyy-MM-dd ,hh:mm a').format(givendata);
  var date=  DateTime.parse(givendata);
  print("example date ${date}");
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date.toString(), true);
  print("first date ${dateTime}");

  var dateLocal = dateTime.toLocal();
  print("date local${dateLocal}");

  DateTime example=DateTime.parse(dateLocal.toString());
  final time = DateTime(example.year,example.month,example.day,example.hour,example.minute);
  final date2 = DateTime.now();
  final duration=date2.difference(time);
  final hours=duration.inMinutes;

  String t = "";

  double Days = (hours /(24*60)).roundToDouble() ;
  int daysall=double.parse(Days.toString()).round();
  int Hours= ((hours %(24*60)) / 60).round();

  int minutes = (hours%(24*60)) % 60;


  t =(" $daysall days $Hours hours $minutes minutes");


  return Text( "Last communicated on:$t",style: TextStyle(color: Colors.red),);
}
bool statusfalse=false;
String Errormessage="";


  Future<List<Devicequerry>>Devicedata(devicenumber)async{
    setState((){
      isloading=true;
    });
    Map<String, dynamic> response = await getdata(devicenumber);
    print("responce is one :${response}");
    List<Devicequerry> telematicDataList = [];
    try {
      if (response.isNotEmpty) {
        print("inside try");
        print(response['success']);
        print(response is List<dynamic>);
        if (response['success'] != false) {
          for (int i = 0; i < response['data'].length; i++) {
            print("error one tweo");
            Devicequerry deviceQueryModel = Devicequerry.fromJson(response['data'][i]);
            print(deviceQueryModel.aCI1MilliAmps);
           try{
             telematicDataList.add(deviceQueryModel);

           }
           catch(e){
             print("error is $e");
           }
          }
        }
        else{
          setState(() {
            statusfalse=true;
            Errormessage=response['message'];
          });
        }
      }
      setState((){
        isloading=false;
      });
      
      // telematicDataList.followedBy(devicedata.iterator())
      
      return telematicDataList;
    }
    catch(e){
      setState((){
        errormessage="Invalid query... ! ";
        isloading=false;
      });
      print("error is $e");
      throw e;

    }
  }



  Future getdata(devicid) async {

    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    var path="";
    if(val==1){
      path="http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/devicedata/devices/$devicid/DeviceID";
    }
    else{
      path="http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/devicedata/devices/$devicid/HardwareSerialNumber";
    }
    // 'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/devicedata/devices/$devicid';
    print(path);
    final dio = Dio();
    Map<String, dynamic> returnData = {};
    try {
      final response =
      await dio.get(path,  options: Options(headers: header),queryParameters: {});
      if (response.statusCode == 200) {
        returnData = response.data;
        print(returnData);
      }
    } catch (e) {
      print("error is :$e");
      Fluttertoast.showToast(
          msg: 'Cannot get requested data, please try later: ${e.toString()}');
      print("error ios :"+e.toString());
    }
    return returnData;
  }

  Widget Paddinglistview({required String tesxtname ,required String textValue}){

  return Padding(padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(tesxtname),
          Spacer(),
          Text(textValue),
        ],
    ),
  );

  }

  Widget Textdata(Devicequerry data){

      if(data.devicetype=='Field Controller SM+VA+WM'){
        return  Padding(padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Paddinglistview(tesxtname:'Battery % :',textValue:'${data.batteryMV}' ),
              Paddinglistview(tesxtname:'Firmware Version:',textValue:'${data.firmwareVersion}' ),
              Paddinglistview(tesxtname: 'Operating Mode :',textValue:'${data.operatingMode}' ),
              Paddinglistview(tesxtname:'Water Flow Tick Count:',textValue:'${data.waterFlowTickLiters}' ),
              Paddinglistview(tesxtname:'Water Flow Tick Liters:',textValue:'${data.firmwareVersion}' ),
              Paddinglistview(tesxtname: 'Soil Moisture Single PointSensor :',textValue:'${data.soilMoistureSinglePoStringSensor}' ),
              Paddinglistview(tesxtname: 'Level 1:',textValue:'${data.soilMoistureLevelAGL3}' ),
              Paddinglistview(tesxtname:'Level 2:',textValue:'${data.soilMoistureLevelAGL2}' ),
              Paddinglistview(tesxtname:'Level 3:',textValue:'${data.soilMoistureLevelBGL6}' ),
              Paddinglistview(tesxtname: 'Level 4 :',textValue:'${data.soilMoistureLevelBGL7}' ),
            ],
          ),
        );
      }
      else if(data.devicetype=='I/O Controller Backwash'){
        return Column(
          children: [
            Paddinglistview(tesxtname:'RO1 Status :',textValue:'${data.rO1Status}' ),
            Paddinglistview(tesxtname:'RO2 Status :',textValue:'${data.rO2Status}' ),
            Paddinglistview(tesxtname: 'Time:',textValue:'${data.sensorDataPacketDateTime}' ),
          ],
        );
      }
      else if(data.devicetype=='I/O Controller Pump Controller'){
        return Column(
          children: [
            Paddinglistview(tesxtname:'Firmware Version:',textValue:'${data.firmwareVersion}' ),
            Paddinglistview(tesxtname:'Operating Mode :',textValue:'${data.operatingMode}' ),
            Paddinglistview(tesxtname: 'Water Pressure KPA:',textValue:'${data.waterPressureKPA}' ),
            Paddinglistview(tesxtname: 'Water Pressure MPA:',textValue:'${data.waterPressureMPA}' ),
          ],
        );
      }
      else if(data.devicetype=='Energy Meter'){
        return Column(
          children: [
            Paddinglistview(tesxtname:'Current B',textValue:'${data.currentB}' ),
            Paddinglistview(tesxtname:'Current R',textValue:'${data.currentR}' ),
            Paddinglistview(tesxtname: 'Current Y',textValue:'${data.currentY}' ),
            Paddinglistview(tesxtname: 'Frequency',textValue: '${data.EMFREQUENCY}'),
            Paddinglistview(tesxtname: 'Power Factor ',textValue: '${data.powerFactor}'),
            Paddinglistview(tesxtname: 'Voltage B ',textValue:'${data.voltageB}' ),
            Paddinglistview(tesxtname: 'Voltage R',textValue: '${data.voltageR}'),
            Paddinglistview(tesxtname: 'Voltage Y',textValue: '${data.voltageY}')
          ],
        );
      }
      else if(data.devicetype=='LSN50 MPSMS' ||data.devicetype=='LSN50 AWD' ){
        return Column(
          children: [
            Paddinglistview(tesxtname:'Battery % :',textValue:'${data.batteryMV}' ),
            Paddinglistview(tesxtname:'Firmware Version:',textValue:'${data.firmwareVersion}' ),
            Paddinglistview(tesxtname: 'Level 1:',textValue:'${data.soilMoistureLevelAGL3}' ),
            Paddinglistview(tesxtname:'Level 2:',textValue:'${data.soilMoistureLevelAGL2}' ),
            Paddinglistview(tesxtname:'Level 3:',textValue:'${data.soilMoistureLevelBGL6}' ),
            Paddinglistview(tesxtname: 'Level 4 :',textValue:'${data.soilMoistureLevelBGL7}' ),
          ],
        );

      }
      else if(data.devicetype=="Field Controller Water meter"){
        return Column(
          children: [
            Paddinglistview(tesxtname:'Battery % :',textValue:'${data.batteryMV}' ),
            Paddinglistview(tesxtname:'Firmware Version:',textValue:'${data.firmwareVersion}' ),
            Paddinglistview(tesxtname: 'Operating Mode :',textValue:'${data.operatingMode}' ),
            Paddinglistview(tesxtname:'Water Flow Tick Count:',textValue:'${data.waterFlowTickLiters}' ),
            Paddinglistview(tesxtname:'Water Flow Tick Liters:',textValue:'${data.firmwareVersion}' ),
          ],
        );
      }
      else if (data.devicetype=='Weather Station'){
        return Column(
          children: [
            Paddinglistview(tesxtname:'humidity :',textValue:'${data.fHumidity}' ),
            Paddinglistview(tesxtname:'Radiation :',textValue:'${data.radiationWM2}' ),
            Paddinglistview(tesxtname:'Rain :',textValue:'${data.rainMM}' ),
            Paddinglistview(tesxtname:'Temperature :',textValue:'${data.fTemperature}' ),
            Paddinglistview(tesxtname:'Wind direction :',textValue:'${data.windDirectionDegree}' ),
            Paddinglistview(tesxtname:'Wind speed :',textValue:'${data.windSpeedKmHr}' ),
          ],
        );

      }
      else if(data.devicetype=="LSN50 Temperature+Humidity"){
        return Column(
          children: [
            Paddinglistview(tesxtname:'Battery % :',textValue:'${data.batteryMV}' ),
            Paddinglistview(tesxtname:'humidity :',textValue:'${data.fHumidity}' ),
            Paddinglistview(tesxtname:'Temperature :',textValue:'${data.fTemperature}' ),          ],
        );
      }
      else if (data.devicetype=='LSN50 Water level Sensor'){
        return Column(
          children: [
            Paddinglistview(tesxtname:'Battery % :',textValue:'${data.batteryMV}' ),
            Paddinglistview(tesxtname:'Distance :',textValue:'${data.fDistance}'),
            Paddinglistview(tesxtname:'Sensor flag:',textValue:'${data.sensorFlag}' ),
            Paddinglistview(tesxtname:'InterruptFlag :',textValue:'${data.InterruptFlag}' ),
            Paddinglistview(tesxtname:'TempC_DS18B20 :',textValue:'${data.tempCDS18B20}' ),
            Paddinglistview(tesxtname:'SensorFlag :',textValue:'${data.sensorFlag}' ),
          ],
        );
      }
      else if(data.devicetype=='GHG Sensor'){
        return Column(
          children: [
            Paddinglistview(tesxtname:'CH4_PPM :',textValue:'${data.CH4_PPM}' ),
            Paddinglistview(tesxtname:'CO2_PPM :',textValue:'${data.CO2_PPM}' ),
          ],
        );
      }
      else if (data.devicetype=="CO2 Sensor"){
        return Column(
          children: [
            Paddinglistview(tesxtname:'CO2_PPM :',textValue:'${data.CO2_PPM}' ),
          ],
        );
      }
      else{
        return Text("Please contact Manager");
      }


  }

String _scanBarcode = 'Unknown';

Future<void> scanQRpc() async {
  String barcodeScanRes;
  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#228B22', 'Cancel', true, ScanMode.QR);
   setState((){
     deviceid.text =barcodeScanRes;
   });
  } on PlatformException {
    barcodeScanRes = 'Failed to get ';
  }
//barcode scanner flutter ant

try{
  setState(() {
    deviceid.text = barcodeScanRes;
    print("after updating ${deviceid.text}");
    _scanBarcode = barcodeScanRes;
  });
}
catch(e){
    print("error is $e");
}
}

int val=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:

      Column(
        children: [
          Container(
            // height: MediaQuery.of(context).size.height/20,
              child:Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height/15,
                      child: Image.asset(
                        'assets/images/cultyvate.png',
                        height: 50,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height/15,
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                                " Device Query",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ] )
                    ),
                    // SizedBox(height: 10,),
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = int.parse(value.toString());
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        Text("Device ID"),
                        Radio(
                          value: 2,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = int.parse(value.toString());
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        Text("Serial Number")
                      ],
                    ),
                    Row(
                        children: [

                          Container(
                            // height: MediaQuery.of(context).size.height/12,
                            width: MediaQuery.of(context).size.width/1.4,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: TextFormField(
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'\s')),
                              ],
                              controller: deviceid,
                              decoration: InputDecoration(
                                labelText:val==1? 'Device ID':'Serial Number',
                                suffixIcon:
                              IconButton(
                              icon: Icon(MdiIcons.barcode),
                              onPressed: () => scanQRpc(),
                            ),
                                border: OutlineInputBorder(),
                                // counter: Offstage(),
                              ),
                            ),
                          ),
                          TextButton(
                            style:  TextButton.styleFrom(

                                backgroundColor: Colors.blueAccent
                            ),
                            onPressed: ()async{
                              if(deviceid.text.trim().length>3) {
                                setState(() {
                                  devicedata = [];
                                  errormessage = "";
                                });

                                devicedata = await Devicedata(deviceid.text.trim());
                              }
                              else{
                                Fluttertoast.showToast(
                                    msg: "Please Enter Valid Device Id",
                                    backgroundColor: Colors.red
                                );
                              }


                            },child: Text("Search",style: TextStyle(fontSize: 10),),),
                        ]
                    )

                  ]
              )
          ),
        isloading==true?Center(
          child: CircularProgressIndicator(),
        ):
          devicedata.length!=0?
              Flexible(child: ListView.builder(
    itemCount: devicedata.length,
    itemBuilder: (BuildContext context, int index) {
      return Column(

      children: [

        DeferanceDateandTine(devicedata[index].sensorDataPacketDateTime),
        Textdata(devicedata[index]),

      ],
      );
    }

    )
              ):Center(child: Text(Errormessage),)

        ],
      )
      ),
    );
  }
}
