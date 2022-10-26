import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'package:fluttertoast/fluttertoast.dart';import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import '/Screens/Imageview.dart';
import '/Screens/camera.dart';
import '/Screens/locationcamera.dart';
import '/Screens/service_mode.dart';
import '/models/Images.dart';

import '../models/FielmanagerInformation_gpscam.dart';
import '../models/FielofficergpscamInformation.dart';
class Gps_Cam extends StatefulWidget {
  const Gps_Cam({Key? key}) : super(key: key);

  @override
  State<Gps_Cam> createState() => Gps_CamState();
}

class Gps_CamState extends State<Gps_Cam> {
    // ScrollController? scrollController1;
    LinkedScrollControllerGroup ? _controllers;
    ScrollController ?scrollController1;
 ScrollController ?scrollController2;

  static Gps_CamState ? instance;
  int val=1;
  void initState() {
    instance=this;
    super.initState();
    scrollController1 = ScrollController();
    scrollController2 = ScrollController();

    scrollController1!.addListener(() {
      if (scrollController1!.offset != scrollController2!.offset) {
        scrollController2!.jumpTo(scrollController1!.offset);
      }
    });
    scrollController2!.addListener(() {
      if (scrollController1!.offset != scrollController2!.offset) {
        scrollController1!.jumpTo(scrollController2!.offset);
      }
    });

  }
  static Gps_CamState? getInstance() {
    return instance;
  }
    static final tracking = TrackingScrollController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool loading=false;
  bool cameravisuble=false;
  List images=[];
  LatLng? latlang;
  List<Farmerprofile>Imagesarray=[];
  TextEditingController phonenumber= new TextEditingController();
  Future GetImages(phonenumbe)async {
    print("number");
    Imagesarray.clear();

    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    var  path = 'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/service/profile/farmerprofile/$phonenumbe';
    // var path='http://192.168.15.188:8085/api/farm2fork/service/profile/farmerprofile/$phonenumbe';
    print("manoj"+path);
    final dio = Dio();
    Map<String, dynamic> returnData = {};
    try {
      final response =
      await dio.get(path, options: Options(headers: header), queryParameters: {});
      print("responce ${response.data}");
      if (response.statusCode == 200) {
        if (response.data['success'] != false ) {
          if(response.data['data'].length>0) {
            for (int i = 0; i < response.data['data'].length; i++) {
              try {
                Farmerprofile telematicModel = Farmerprofile.fromJson(
                    response.data['data'][i]);
                setState(() {
                  Imagesarray.add(telematicModel);
                });
              }
              catch (e) {
                print(e);
                Fluttertoast.showToast(
                    msg: ' No data found..!');
                cameravisuble = false;
                // print("error is error $e");
                // GetDevicedata(phonenumbe);
              }
            }
          }
          else{
           setState(() {
             loading=false;
           });
            Fluttertoast.showToast(
                msg: ' No data found..!');
          }

          setState(() {

            loading=false;
            if(Imagesarray.isNotEmpty){
              cameravisuble=true;
            }  else{

              Fluttertoast.showToast(
                  msg: ' No data found..!');
              cameravisuble=false;
            }

          });
        }
        else{
          setState(() {
            loading=false;
          });
          Fluttertoast.showToast(
              msg: 'No data found...!');
        }
      }


      // GetDevicedata(phonenumbe);
    }

    catch (e) {
      setState(() {
        loading=false;
      });
      Fluttertoast.showToast(
          msg: 'Error is : ${e.toString()}');
      print("error ios :" + e.toString());
    }
    return returnData;

  }
  List<Fieldofficer>Fieldofficerdata=[];
  Future GetFieldofficerDtaa(phonenumbe)async {
    print("number");
    Fieldofficerdata.clear();

    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    // var path='http://192.168.15.188:8085/api/farm2fork/Information/Fieldofficer/91$phonenumbe';
    var  path = 'http://20.219.2.201/servicesF2Fapp/api/farm2fork/Information/Fieldofficer/91$phonenumbe';
    print(path);
    final dio = Dio();
    Map<String, dynamic> returnData = {};
    try {
      final response =
      await dio.get(path, options: Options(headers: header), queryParameters: {});
      // print("responce ${response.data}");
      if (response.statusCode == 200) {
        if (response.data['success'] != false) {
          print(response.data['data']);
          for (int i = 0; i < response.data['data'].length; i++) {
            try {
              Fieldofficer feldofficerdata = Fieldofficer.fromJson(response.data['data'][i]);
              setState(() {
                Fieldofficerdata.add(feldofficerdata);
              });
            }
            catch (e) {
              Fluttertoast.showToast(
                  msg: 'Cannot get requested data, please try later: ${e.toString()}');
              print("error is error $e");
              // GetDevicedata(phonenumbe);
            }
          }
          setState(() {

            loading=false;
            if(Fieldofficerdata.isNotEmpty){
              cameravisuble=true;
            }
            else{

              Fluttertoast.showToast(
                  msg: 'No data found...!');
              cameravisuble=false;
            }
          });
        }
      }


      // GetDevicedata(phonenumbe);
    }

    catch (e) {
      setState(() {
        loading=false;
      });
      print("error ios :" + e.toString());

      Fluttertoast.showToast(
          msg: 'Cannot get requested data, please try later: ${e.toString()}');
    }
    return returnData;

  }
  List<FieldMangerInformation> Fieldmanagerdata=[];
  Future GetFieldManagerDtaa(phonenumbe)async {
    print("number");
    Fieldmanagerdata.clear();

    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    // var path='http://192.168.15.188:8085/api/farm2fork/Information/Fieldmanager/91$phonenumbe';
    var  path = 'http://20.219.2.201/servicesF2Fapp/api/farm2fork/Information/Fieldmanager/91$phonenumbe';
    print(path);
    final dio = Dio();
    Map<String, dynamic> returnData = {};
    try {
      final response =
      await dio.get(path, options: Options(headers: header), queryParameters: {});
      // print("responce ${response.data}");
      if (response.statusCode == 200) {
        if (response.data['success'] != false) {
          print(response);
          for (int i = 0; i < response.data['data'].length; i++) {
            try {
              FieldMangerInformation feldmanagerrdata = FieldMangerInformation.fromJson(
                  response.data['data'][i]);
              setState(() {
                Fieldmanagerdata.add(feldmanagerrdata);
              });
            }
            catch (e) {
              print("error is error $e");
              Fluttertoast.showToast(
                  msg: 'Cannot get requested data, please try later: ${e.toString()}');

              // GetDevicedata(phonenumbe);
            }
          }
          setState(() {
            if(Fieldmanagerdata.isNotEmpty){
              cameravisuble=true;
            }
            else{

            Fluttertoast.showToast(
            msg: 'No data found');
              cameravisuble=false;
            }
            loading=false;

          });
        }
      }


      // GetDevicedata(phonenumbe);
    }

    catch (e) {
      setState(() {
        loading=false;
      });
      print("error ios :" + e.toString());

      Fluttertoast.showToast(
          msg: 'Cannot get requested data, please try later: ${e.toString()}');
    }
    return returnData;

  }
   ViewTextFormate({required List<String> keys,required List<String> values}){
      // print("valieval)
    return   Table(
            defaultColumnWidth: FixedColumnWidth(MediaQuery
                .of(context)
                .size
                .width / 2.2),
            border: TableBorder.all(
                color: Colors.black,
                width: 1),
            children: [
              TableRow(children: [
    ListView.builder(
      itemCount: keys.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context,index) {
        return
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(keys[index].toString()),
                    ),]);}),

     ListView.builder(
     itemCount: values.length,
     shrinkWrap: true,
     physics: const NeverScrollableScrollPhysics(),
     itemBuilder: (BuildContext context,index) {
     return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(values[index].toString()),
                    ),
                    ]);}),
              ],
              )
            ]
        );


    // listtext=[];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:NotificationListener<ScrollNotification>(
        child:  SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
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
                                    "Gps",
                                    style: TextStyle(
                                        color: Color.fromRGBO(10 ,192 ,92,2),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    " Cam ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ] )
                        ),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10,right: 10),
                              height: 20,
                              child:  Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: val,
                                    onChanged: (value) {
                                      setState(() {
                                        Fieldofficerdata.clear();
                                        Fieldmanagerdata.clear();
                                        Imagesarray.clear();
                                        phonenumber.clear();
                                        cameravisuble=false;
                                        val = int.parse(value.toString());
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                  // Padding(padding: EdgeInsets.only(left: 10)),
                                  Text("Farmer",style: TextStyle(fontSize: 12),),


                                  // Padding(padding: EdgeInsets.only(left: 5)),
                                  Radio(
                                    value: 2,
                                    groupValue: val,
                                    onChanged: (value) {
                                      setState(() {
                                        Fieldofficerdata.clear();
                                        Fieldmanagerdata.clear();
                                        Imagesarray.clear();
                                        phonenumber.clear();
                                        cameravisuble=false;
                                        val = int.parse(value.toString());
                                        print(val);
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                  // Container(
                                  //     margin: EdgeInsets.only(left: 8),
                                  //     width: 7,
                                  //     child:
                                  //     Radio(
                                  //       value: 2,
                                  //       groupValue: val,
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           phonenumber.clear();
                                  //           cameravisuble=false;
                                  //           val = int.parse(value.toString());
                                  //           print(val);
                                  //         });
                                  //       },
                                  //       activeColor: Colors.green,
                                  //     )),
                                  // Padding(padding: EdgeInsets.only(left: 8)),
                                  Text("Field Officer ",style: TextStyle(fontSize: 12),),

                                  Radio(
                                    // materialTapTargetSize: 10,
                                    value: 3,
                                    groupValue: val,
                                    onChanged: (value) {
                                      setState(() {
                                        Fieldofficerdata=[];
                                        Fieldmanagerdata=[];
                                        Imagesarray=[];
                                        // Imagesarray.clear();
                                        phonenumber.clear();
                                        cameravisuble=false;
                                        val = int.parse(value.toString());
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                  Text("Field Manager ",style: TextStyle(fontSize: 12),),


                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width/1.5,
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: phonenumber,
                                    decoration: InputDecoration(
                                      labelText:val==1? 'Farmer Mobile number':val==2?'Fieldofficer Mobile number':'Fieldmanager Mobile number',
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
                                ) ,
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: TextButton(
                                    style:  TextButton.styleFrom(
                                        backgroundColor: Colors.blueAccent
                                    ),
                                    onPressed: (){
                                      setState((){
                                        loading=true;
                                        cameravisuble=false;
                                        // FarmerInfo.clear();

                                      });
                                      if(val==1) {
                                        Fieldofficerdata.clear();
                                        Fieldmanagerdata.clear();
                                        GetImages(phonenumber.text);
                                      }
                                      else if (val==2){
                                        Imagesarray.clear();
                                        Fieldmanagerdata.clear();
                                        GetFieldofficerDtaa(phonenumber.text);
                                      }
                                      else if(val==3){
                                        Imagesarray.clear();
                                        Fieldofficerdata.clear();
                                        GetFieldManagerDtaa(phonenumber.text);
                                      }


                                    },child: Text("Search",style: TextStyle(fontSize: 10),),),
                                ),
                              ],
                            ),

                            loading?Center(child: CircularProgressIndicator()):

                            Container(
                              height: MediaQuery.of(context).size.height/1.5,
                              child: ListView(
                                controller: tracking,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                // controller: scrollController1,
                                children: [
                                  SingleChildScrollView(
                                    controller: scrollController1,
                                    child: val==1?
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),

                                      itemBuilder: (BuildContext context,index){
                                        return SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [


                                                ViewTextFormate(keys: ["FarmerName"], values:['${Imagesarray[index].farmerDetails![0].name}']   ),
                                                ViewTextFormate(keys: [ "FatherName" ],values:['${Imagesarray[index].farmerDetails![0].fatherName}']),
                                                ViewTextFormate(keys: ['Mobilenumber' ],values:[' ${Imagesarray[index].farmerDetails![0].mobileNumberPrimary}']),
                                                ViewTextFormate(keys: ['FieldOfficerName'],values:[' ${Imagesarray[index].farmerDetails![0].foName}']),
                                                ViewTextFormate(keys: [ 'FiledManagerName'],values:[ '${Imagesarray[index].farmerDetails![0].fmname}']),
                                                ViewTextFormate(keys: [ 'FiledManagerMobile'],values:[' ${Imagesarray[index].farmerDetails![0].filedManagerMobile}' ]),

                                                //
                                                // Text("FiledManagerName: "),
                                                // Text("FiledManagerMobile:"),

                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: Imagesarray.length,
                                    ):

                                    val==2?ListView.builder(
                                      shrinkWrap: true,


                                      itemBuilder: (BuildContext context,index){
                                        print('feldofficer data ${Fieldofficerdata[index].filedManagerMobileNumber} ');
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Name: ${Fieldofficerdata[0].filedOfficerName}"),
                                              Text("MobileNumber: ${Fieldofficerdata[0].filedOfficerMobileNumber}"),
                                              Text("Email: ${Fieldofficerdata[0].filedOfficerfEmail}"),
                                            ],
                                          ),
                                        );
                                      },
                                      itemCount: Fieldofficerdata.length==0?0: 1,
                                    ):
                                    ListView.builder(
                                      shrinkWrap: true,


                                      itemBuilder: (BuildContext context,index){
                                        // print('feldofficer data ${Fieldofficerdata[index].filedManagerMobileNumber} ');
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(" Name: ${Fieldmanagerdata[0].name}"),
                                              Text(" Email: ${Fieldmanagerdata[0].fEmail}"),
                                              Text(" MobileNumber: ${Fieldmanagerdata[0].mobileNumber1}"),

                                            ],
                                          ),
                                        );
                                      },
                                      itemCount: Fieldmanagerdata.length==0?0: 1,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    controller: scrollController2,
                                    child: Visibility(

                                      visible: Imagesarray.length>0 &&val==1,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),

                                        itemBuilder: (BuildContext context,count){
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                ViewTextFormate(keys: ["Device Id","Device Type"], values: ["${Imagesarray[0].plotdevices![count].deviceEUIID}","${Imagesarray[0].plotdevices![count].DeviceName}"])
                                                // ViewTextFormate(val:[ TextForamte(key:' :' ,value:' '),
                                                //   TextForamte(key:':' ,value:' ') ]


                                                // ),
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount: Imagesarray.length>0? Imagesarray[0].plotdevices!.length:0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  SingleChildScrollView(
                                    // controller: scrollController2,
                                    child:   val==1? Visibility(
                                        visible: Imagesarray.length>0,
                                        child: GridView.count(


                                            shrinkWrap: true,

                                            crossAxisCount: 3,
                                            crossAxisSpacing: 4.0,
                                            mainAxisSpacing: 8.0,
                                            scrollDirection: Axis.vertical,
                                            physics: NeverScrollableScrollPhysics(),
                                            children:<Widget>[... List.generate(Imagesarray.length>0?Imagesarray[0].images!.length:0, (index) {
                                              // print("example ${Imagesarray[index].imageNV.toString()}");\
                                              if (Imagesarray[0].images![index]
                                                  .imageNV != null) {
                                                final z;
                                                try {
                                                  z = base64.decode(
                                                      Imagesarray[0]
                                                          .images![index]
                                                          .imageNV.toString());
                                                  return InkWell(
                                                    child: Image.memory(z,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit
                                                            .cover),
                                                    onTap: () {
                                                      // GetImages("8530871947");
                                                      print("@@@@@@@@@@@@@@@@@@@@");
                                                      print(Imagesarray[0].images![index].latitude!);
                                                      print(Imagesarray[0].images![index].longitude!);
                                                      Get.to(Imageview(
                                                          image: Imagesarray[0]
                                                              .images![index]
                                                              .imageNV.toString(),imagelatlang:LatLng(Imagesarray[0].images![index].latitude!, Imagesarray[0].images![index].longitude!) ,));
                                                    },
                                                  );
                                                } catch (e) {
                                                  // return
                                                  return SizedBox();
                                                  print(e);
                                                }
                                              }
                                              else {
                                                return SizedBox(); ;
                                              }
                                            })

                                            ]




                                        )):

                                    val==2?Visibility(
                                        visible:Fieldofficerdata.length>0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GridView.count(


                                              shrinkWrap: true,

                                              crossAxisCount: 3,
                                              crossAxisSpacing: 4.0,
                                              mainAxisSpacing: 8.0,
                                              scrollDirection: Axis.vertical,
                                              physics: NeverScrollableScrollPhysics(),
                                              children:<Widget>[... List.generate(Fieldofficerdata.length, (index) {

                                                final z;
                                                if (Fieldofficerdata[index]
                                                    .imageNV != null) {
                                                  try {
                                                    z = base64.decode(
                                                        Fieldofficerdata[index]
                                                            .imageNV
                                                            .toString());

                                                    return InkWell(
                                                      child: Image.memory(z,
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit
                                                              .cover),
                                                      onTap: () {
                                                        // GetImages("8530871947");
                                                        Get.to(Imageview(
                                                            image: Fieldofficerdata[index]
                                                                .imageNV
                                                                .toString(),
                                                        imagelatlang:LatLng(Fieldofficerdata[index].latitude??00, Fieldofficerdata[index].longitude??00) ,
                                                        ));
                                                      },
                                                    );
                                                  } catch (e) {
                                                    return SizedBox();
                                                    print(e);
                                                  }
                                                }
                                                else {
                                                  return SizedBox();
                                                }
                                              }

                                                )

                                              ]

                                          ),
                                        )):Visibility(
                                        visible:Fieldmanagerdata.length>0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GridView.count(


                                              shrinkWrap: true,

                                              crossAxisCount: 3,
                                              crossAxisSpacing: 4.0,
                                              mainAxisSpacing: 8.0,
                                              scrollDirection: Axis.vertical,
                                              physics: NeverScrollableScrollPhysics(),
                                              children:<Widget>[... List.generate(Fieldmanagerdata.length, (index) {
                                                // print("example ${Imagesarray[index].imageNV.toString()}");\
                                                if (Fieldmanagerdata[index]
                                                    .imageNV != null) {
                                                  final z;
                                                  try {
                                                    z = base64.decode(
                                                        Fieldmanagerdata[index]
                                                            .imageNV
                                                            .toString());
                                                    return InkWell(
                                                      child: Image.memory(z,
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit
                                                              .cover),
                                                      onTap: () {
                                                        // GetImages("8530871947");
                                                        Get.to(Imageview(
                                                            image: Fieldmanagerdata[index].imageNV,imagelatlang: LatLng(Fieldmanagerdata[index].latitude!,Fieldmanagerdata[index].longitude!),));
                                                      },
                                                    );
                                                  } catch (e) {
                                                    print("error is $e");
                                                    return SizedBox();
                                                    print(e);
                                                  }
                                                }
                                                else {
                                                 return SizedBox();

                                                }

                                              }
                                             )]

                                          ),
                                        )),
                                  ),
                                       SingleChildScrollView(
                                    child: Visibility(
                                      visible: cameravisuble,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        height: 200,
                                        child: GridView.count(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 4.0,
                                          mainAxisSpacing: 8.0,
                                          children:<Widget>[... List.generate(images.length, (index) {
                                            return    Stack(
                                              children: <Widget>[
                                                InkWell(
                                                  child: Image.memory(images[index],
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,),
                                                  onTap: (){
                                                    // GetImages("8530871947");
                                                    Get.to(ImageView(image:images[index] ));
                                                  },
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: InkWell(

                                                      child: Icon(Icons.delete,color: Colors.red,),onTap: (){
                                                    setState(() {
                                                      loading=true;
                                                    });
                                                    images.remove(images[index]);
                                                    setState(() {
                                                      loading=false;
                                                    });
                                                  }),
                                                )
                                              ],
                                            );

                                          },
                                          ) ]+ [InkWell(onTap: ()async{
                                            final    status = await Permission.storage.status;
                                            final camerastatus=await Permission.camera.status;
                                            if(status.isGranted && camerastatus.isGranted){
                                              // setState(() {
                                              //   loading=true;
                                              // });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => LocationCamera (
                                                        Farmerid:val==1? Imagesarray[0].farmerDetails![0].iD!:0,
                                                       FieldofficerId:val==2? Fieldofficerdata![0].fieldOfficerID!:0,
                                                        FieldmanagerID:val==3? Fieldmanagerdata![0].iD!:0,

                                                      )))
                                                  .then((value) {
                                                    if(val==1){
                                                      GetImages(phonenumber.text);
                                                    }
                                                    else if(val==2){
                                                      GetFieldofficerDtaa(phonenumber.text);
                                                    }
                                                    else if(val==3){
                                                      GetFieldManagerDtaa(phonenumber.text);
                                                    }
                                                setState(() {
                                                  loading=true;
                                                });
                                              } );
                                            // Get.to(CameraPreviewScreen());
                                            }
                                            else{

                                              await Permission.camera.request();

                                              await Permission.storage.request();



                                            }
                                          },child:Column(
                                            children: [
                                              Image.asset('assets/images/camera.png',height: 100,),
                                              Text("Add Image")
                                            ],
                                          ))],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Container(
                                        height: 60,
                                        child:  Visibility(
                                          visible:images.length>0&&cameravisuble ,
                                          child: InkWell(
                                            onTap: (){
                                              print("images");
                                              images.forEach((element)async {
                                                // print('data ${Fieldofficerdata![0].fieldOfficerID}');
                                                // print(base64Encode(data));
                                                var  dataone=  {
                                                  "farmerID":Imagesarray.length>0? Imagesarray[0].farmerDetails![0].iD:null,
                                                  "FieldOfficerID":Fieldofficerdata.length>0?Fieldofficerdata![0].fieldOfficerID:null,
                                                  "FieldmanagerID":Fieldmanagerdata.length>0?Fieldmanagerdata![0].iD:null,
                                                  "image":null,
                                                  "imagenv":base64Url.encode(element),
                                                  "Latitude":latlang!.latitude,
                                                  "Longtitude":latlang!.longitude,
                                                };
                                                print(dataone);
                                                if(val==1) {
                                                  var z = await Postdata(dataone);
                                                  if (z == 200) {
                                                    images.remove(element);
                                                    // await GetImages(phonenumber.text);
                                                  }
                                                }
                                                else if(val==2){
                                                  var z = await Postdata(dataone);
                                                  if (z == 200) {
                                                    images.remove(element);
                                                    // await GetFieldofficerDtaa(phonenumber.text);
                                                  }
                                                }
                                                else if(val==3){
                                                  var z = await Postdata(dataone);
                                                  if (z == 200) {
                                                    images.remove(element);
                                                    // await GetFieldManagerDtaa(phonenumber.text);
                                                  }
                                                }
                                              });



                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              color: Colors.blueAccent,
                                              height: 20,
                                              width: MediaQuery.of(context).size.width,
                                              child: Center(child: Text("Post Images")),
                                            ),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              margin: EdgeInsets.only(bottom: 500),
                            )


                          ],
                        ),
                      ],
                    ),
                  )
              ),
            )),
      ),
      )
    );

  }
  Future Postdata(phonenumberone) async {
    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    var  path = 'http://20.219.2.201/servicesF2Fapp/api/farm2fork/Imagepost/post';
    // var  path= 'http://192.168.8.159:8086/api/farm2fork/Imagepost/post';
    print(path);
    final dio = Dio();
    Map<String, dynamic> returnData = {};
    try {
      final response =
      await dio.post(path,  data: phonenumberone,options: Options(headers: header),queryParameters: {});
      print("responcasklfme ${response.statusCode}");
      if (response.statusCode == 200) {
        if(val==1){
          GetImages(phonenumber.text);
        }
        else if (val==2){
          GetFieldofficerDtaa(phonenumber.text);
        }
        else if (val==3){
          GetFieldManagerDtaa(phonenumber.text);
        }
         return response.statusCode;
        returnData = response.data;
      }
      else{
        return response.statusCode;
      }
    } catch (e) {
      print("error one is ${e}");
      Fluttertoast.showToast(
          msg: 'Cannot get requested data, please try later: ${e.toString()}');

    }
    return returnData;

  }
}

class TextForamte{
  String ?key;
  String ?value;
  TextForamte({@required key,@required value});

}