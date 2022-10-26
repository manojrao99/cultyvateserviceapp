import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '/Screens/locationcamera.dart';
import '/models/clintslist.dart';
import 'package:numberpicker/numberpicker.dart';
import '/models/villageinformation.dart';
class Farmeracusation extends StatefulWidget {
  const Farmeracusation({Key? key}) : super(key: key);

  @override
  State<Farmeracusation> createState() => FarmeracusationState();
}




class FarmeracusationState extends State<Farmeracusation> {
List<VillageInformation>  returnData=[];
bool viilagedataloading=false;
int _currentIntValue = 10;
double _currentDoubleValue = 3.0;
NumberPicker ?integerNumberPicker;
bool? laserleveling;
bool laserdo=false;

bool ?dsr;
bool dsrdo=false;
TextEditingController farmername=new TextEditingController();
TextEditingController fathername=new TextEditingController();
TextEditingController mobilenumber=new TextEditingController();
TextEditingController dsrdate=TextEditingController();
bool ?transplantaition;
bool transplantaitiondo=false;
TextEditingController transplantaitiondate=new TextEditingController();
bool ?awd;
bool awddo=false;
TextEditingController awddate=new TextEditingController();
bool?notillage;
bool notillagedo=false;
TextEditingController notillafedate=new TextEditingController();
bool ?crm;
bool crmdo=false;
TextEditingController crmdate=new TextEditingController();
NumberPicker ?decimalNumberPicker;
LatLng ?latlang;
Color latlangcolor=Colors.red;

Future<LatLng> _getLocation() async {
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // debugPrint('location: ${position.latitude} ${position.longitude}');
  final coordinates = new Coordinates(position.latitude, position.longitude);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var first = addresses.first;
  print("${first.featureName} : ${first.addressLine}");
  return LatLng(position.latitude, position.longitude);

}
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
bool loading=false;
static FarmeracusationState ? instance;
List<Uint8List> images=[];
@override
  void initState() {
  instance=this;
    // TODO: implement initState
    super.initState();
    getVillages();
    getclints();
  }
  TextEditingController distic=new TextEditingController();
TextEditingController taluc=new TextEditingController();
TextEditingController areaunderby=new TextEditingController();
TextEditingController operatearea=new TextEditingController();
TextEditingController underpaddy=new TextEditingController();
TextEditingController laserdate=new TextEditingController();
TextEditingController residue=new TextEditingController();
TextEditingController latlangcontroller=new TextEditingController();
bool clintlistloading=false;
List<ClintsList> Clintlist=[];
List<String> imagesid=[];
ClintsList ?selectedclint;
Future getclints() async {
  setState((){
    clintlistloading=true;
  });
  Map<String, String> header = {
    "content-type": "application/json",
    "API_KEY": "12345678"
  };
  var path='http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/service/profile/clintlist/';
  // print(path);
  final dio = Dio();

  try {
    final response = await dio.get(path,  options: Options(headers: header),queryParameters: {});
    print("responce is $response");
    if (response.statusCode == 200) {
      print(' actual data is ${response.data['data']}');
      for (int i=0;i<response.data['data'].length;i++){
        print("data ${response.data['data'][i]} ");

        Clintlist.add(ClintsList(
            clintId: response.data['data'][i]['ClintId'],
            clintName:  response.data['data'][i]['clintName']
        ));
      }
      // dropdownvalue =returnData[0];
      setState((){
        clintlistloading=false;
      });
      return returnData;
      returnData.forEach((element) {
        // print("retuenr data ius ,${element.clintName}");
      });

    }
    else{
      setState((){
        clintlistloading=true;
      });
      throw Exception('Failed to Load ClintList');
    }
  } catch (e) {
    setState((){
      clintlistloading=true;
    });
    Fluttertoast.showToast(msg: "Error is :$e");
    rethrow;
    Fluttertoast.showToast(
        msg: 'Cannot get requested data, please try later: ${e.toString()}');
    // print("error ios :"+e.toString());
  }
  // return returnData;
}
  Future getVillages() async {
setState(() {
  viilagedataloading=true;
});
    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    var path='http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/farmeraccusation/getvilageanddistic';
    print(path);
    final dio = Dio();

    try {
      final response = await dio.get(path,  options: Options(headers: header),queryParameters: {});
      print("responce is $response");
      if (response.statusCode == 200) {
        print(' actual data is ${response.data['data']}');
        for (int i=0;i<response.data['data'].length;i++){
          print("data ${response.data['data'][i]} ");

          returnData.add(VillageInformation(
             villagename:response.data['data'][i]['Name'] ,
              districtName:response.data['data'][i]['DistrictName'],
            iD: response.data['data'][i]['ID'],
            talukaName: response.data['data'][i]['TalukaName'],
            talukaID: response.data['data'][i]['TalukaID']

          ));
        }
        // dropdownvalue =returnData[0];
        setState((){
          viilagedataloading=false;
        });
        return returnData;
        // returnData.forEach((element) {
        //   // print("retuenr data ius ,${element.clintName}");
        // });

      }
      else{
        setState((){
          viilagedataloading=false;
        });
        throw Exception('Failed to Load ClintList');
      }
    } catch (e) {
      setState((){
        viilagedataloading=false;
      });
      Fluttertoast.showToast(msg: "Error is :$e");
      rethrow;
      Fluttertoast.showToast(
          msg: 'Cannot get requested data, please try later: ${e.toString()}');
      // print("error ios :"+e.toString());
    }
    // return returnData;
  }
  List<int>numbers=[0,1,2,3,4,5,6,7,8,9];
int operatearea1=0;
int operatearea2=0;
int operatearea3=0;
int operatearea4=0;
VillageInformation ? selectdevalues;
  @override
  Widget build(BuildContext context) {

    Future<String>   _showIntegerDialog(double value,int maxvalue) async {
      double seletedindexvalue=value==null?0.0:value;
      await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
               content : Container(
                 height: 200,
                 child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         // SizedBox(width: 5,),
                       Text("Number")  ,
                         // SizedBox(width: 5,),
                         Text("Decimal")
                       ],
                     ),
                     DecimalNumberPicker(
                       // initialValue: _currentDoubleValue,
                       minValue: 0,
                       maxValue: maxvalue,

                       decimalPlaces: 2,

                       onChanged: (value) {
                           setState(() => seletedindexvalue = value);
                       },

                       value: seletedindexvalue,)
                   ],
                 ),
               ),
              );
            }
            );
          }
      );
      return seletedindexvalue.toString();
    }
    return Scaffold(
      body:SingleChildScrollView(
        child: SafeArea(child:  Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/15,
              child: Image.asset(
                'assets/images/cultyvate.png',
                height: 50,
              ),
            ),
            viilagedataloading?
           Center(
             child: CircularProgressIndicator(),
           ): Container(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Farmer Name:"),
                      Spacer(),
                      Container(
                        height: MediaQuery.of(context).size.height/16,
                        width: MediaQuery.of(context).size.width/1.9,
                        // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: farmername,
                          decoration: InputDecoration(
                            labelText: "Farmer Name",
                            border: OutlineInputBorder(),
                            counter: Offstage(),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 10,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            String pattern =
                                r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                            RegExp exp2 = new RegExp(pattern);
                            // else{
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter Phone number';
                            //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                            //     return 'Please Enter 10 digit valid number';
                            //   }
                            // }
                            return null;
                          },
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Text("Father Name:"),
                      Spacer(),
                      Container(
                        height: MediaQuery.of(context).size.height/16,
                        width: MediaQuery.of(context).size.width/1.9,
                        // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: fathername,
                          decoration: InputDecoration(
                            labelText: "Father Name",
                            border: OutlineInputBorder(),
                            counter: Offstage(),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 10,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            String pattern =
                                r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                            RegExp exp2 = new RegExp(pattern);
                            // else{
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter Phone number';
                            //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                            //     return 'Please Enter 10 digit valid number';
                            //   }
                            // }
                            return null;
                          },
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Mobile Number:"),
                      Spacer(),
                      Container(
                        height: MediaQuery.of(context).size.height/16,
                        width: MediaQuery.of(context).size.width/1.9,
                        // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: mobilenumber,
                          decoration: InputDecoration(
                            labelText: "MobileNumber",
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
                            // else{
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter Phone number';
                            //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                            //     return 'Please Enter 10 digit valid number';
                            //   }
                            // }
                            return null;
                          },
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                   Row(
                     children: [
                       Text("Village:"),
                       Spacer(),
                       Padding(
                         padding: const EdgeInsets.only(right: 0,top: 0,bottom: 0),
                         child: Container(
                           height: MediaQuery.of(context).size.height/18,
                           width: MediaQuery.of(context).size.width/1.9,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.all(
                                 Radius.circular(5)
                               ),
                             border: Border.all(color: Colors.grey,)
                           ),
                           child: DropdownButton(
                             isExpanded: true,
                             underline: SizedBox(),

                             // Initial Value
                             borderRadius:BorderRadius.circular(12,),
                             elevation: 2,
                             // isExpanded: true,


                             style: TextStyle(fontSize: 12,color: Colors.black),
                             hint: Text( "  ${selectdevalues?.villagename??" Plece select"}"),
                             // value:dropdownvalue==null?"chouse value":dropdownvalue!.clintName,

                             // Down Arrow Icon
                             // icon: const Icon(Icons.keyboard_arrow_down),

                             // Array list of items
                             items: returnData.map((VillageInformation items) {
                               // value=
                               return DropdownMenuItem(
                                 value: items,
                                 child: Text(items.villagename.toString()),
                               );
                             }).toList(),
                             onChanged: (newValue) {
                               // print(dropdownvalue!.clintName);
                               for(var z in returnData){
                                 if(newValue==z){
                                   setState(() {
                                     selectdevalues=z;
                                     distic.text=selectdevalues!.districtName!;
                                     taluc.text=selectdevalues!.talukaName!;
                                     //
                                     // dropdownvalue = ClintsList(clintId: z?.clintId,clintName: z?.clintName);
                                     // Dropdownname=dropdownvalue!.clintName.toString();
                                   });                                            }
                               }
                               bool containvalue=returnData.contains(newValue);
                               print("contain value ${containvalue}");
                               var selectedvalue=newValue;

                             },
                             // value: dropdownvalue.,
                           ),
                         ),
                       ),

                     ],
                   ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("District:"),
                      Spacer(),
                      Container(
                        height: MediaQuery.of(context).size.height/14,
                        width: MediaQuery.of(context).size.width/1.9,
                        // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: distic,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "Distic",
                            border: OutlineInputBorder(),
                            counter: Offstage(),
                          ),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            String pattern =
                                r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                            RegExp exp2 = new RegExp(pattern);
                            // else{
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter Phone number';
                            //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                            //     return 'Please Enter 10 digit valid number';
                            //   }
                            // }
                            return null;
                          },
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Text("Taluka:"),
                      Spacer(),
                      Container(
                        height: MediaQuery.of(context).size.height/14,
                        width: MediaQuery.of(context).size.width/1.9,
                        // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: taluc,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "Taluka",
                            border: OutlineInputBorder(),
                            counter: Offstage(),
                          ),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            String pattern =
                                r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                            RegExp exp2 = new RegExp(pattern);
                            // else{
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter Phone number';
                            //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                            //     return 'Please Enter 10 digit valid number';
                            //   }
                            // }
                            return null;
                          },
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Co-operative Name:"),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 0,top: 5,bottom: 0),
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width/1.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)
                              ),
                              border: Border.all(color: Colors.grey,)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: SizedBox(),

                            // Initial Value
                            borderRadius:BorderRadius.circular(12,),
                            elevation: 2,
                            // isExpanded: true,


                            style: TextStyle(fontSize: 12,color: Colors.black),
                            hint: Text( "  ${selectedclint?.clintName??" Plece select"}"),
                            // value:dropdownvalue==null?"chouse value":dropdownvalue!.clintName,

                            // Down Arrow Icon
                            // icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: Clintlist.map((ClintsList items) {
                              // value=
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items.clintName.toString()),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              // print(dropdownvalue!.clintName);
                              for(var z in Clintlist){
                                if(newValue==z){
                                  setState(() {
                                    selectedclint=z;
                                    // distic.text=selectdevalues!.districtName!;
                                    // taluc.text=selectdevalues!.talukaName!;
                                    //
                                    // dropdownvalue = ClintsList(clintId: z?.clintId,clintName: z?.clintName);
                                    // Dropdownname=dropdownvalue!.clintName.toString();
                                  });                                            }
                              }
                              bool containvalue=returnData.contains(newValue);
                              print("contain value ${containvalue}");
                              var selectedvalue=newValue;

                            },
                            // value: dropdownvalue.,
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Operate Area :"),
                      Spacer(),
                      InkWell(

                        child:  Container(
                          height: MediaQuery.of(context).size.height/14,
                          width: MediaQuery.of(context).size.width/1.9,
                          // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: operatearea,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Operate area",
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              String pattern =
                                  r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                              RegExp exp2 = new RegExp(pattern);
                              // else{
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter Phone number';
                              //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                              //     return 'Please Enter 10 digit valid number';
                              //   }
                              // }
                              return null;
                            },
                          ),
                        ),
                        onTap: ()async{
                          if(operatearea.text.isEmpty){
                            setState(() {
                              operatearea.text='0.0';
                            });
                          }
                          String value=await _showIntegerDialog(double.parse(operatearea.text),100);
                          setState(() {
                            operatearea.text=value.toString();
                          });
                        },
                      )
                      // Padding(padding: EdgeInsets.only(right: 25))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Area under paddy :"),
                      Spacer(),
                      InkWell(

                        child:  Container(
                          height: MediaQuery.of(context).size.height/14,
                          width: MediaQuery.of(context).size.width/1.9,
                          // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: underpaddy,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Area under paddy",
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              String pattern =
                                  r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                              RegExp exp2 = new RegExp(pattern);
                              // else{
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter Phone number';
                              //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                              //     return 'Please Enter 10 digit valid number';
                              //   }
                              // }
                              return null;
                            },
                          ),
                        ),
                        onTap: ()async{
                          if(underpaddy.text.isEmpty){
                            setState(() {
                              underpaddy.text='0.0';
                            });
                          }
                          String value=await _showIntegerDialog(double.parse(underpaddy.text),double.parse(operatearea.text).toInt());
                          setState(() {
                            underpaddy.text=value.toString();
                          });
                        },
                      )
                      // Padding(padding: EdgeInsets.only(right: 25))
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Text("Area under residue:"),
                      Spacer(),
                      InkWell(

                        child:  Container(
                          height: MediaQuery.of(context).size.height/14,
                          width: MediaQuery.of(context).size.width/1.9,
                          // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: residue,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Area under residue",
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              String pattern =
                                  r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                              RegExp exp2 = new RegExp(pattern);
                              // else{
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter Phone number';
                              //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                              //     return 'Please Enter 10 digit valid number';
                              //   }
                              // }
                              return null;
                            },
                          ),
                        ),
                        onTap: ()async{
                          if(residue.text.isEmpty){
                            setState(() {
                              residue.text='0.0';
                            });
                          }
                          String value=await _showIntegerDialog(double.parse(residue.text),double.parse(underpaddy.text).toInt());
                          setState(() {
                            residue.text=value.toString();
                          });
                        },
                      )
                      // Padding(padding: EdgeInsets.only(right: 25))
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Flexible(child: Text("Area manage by ${selectedclint?.clintName??""}:"),),
                      Spacer(),
                      InkWell(

                        child:  Container(
                          height: MediaQuery.of(context).size.height/14,
                          width: MediaQuery.of(context).size.width/1.9,
                          // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: areaunderby,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Area under by",
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              String pattern =
                                  r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                              RegExp exp2 = new RegExp(pattern);
                              // else{
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter Phone number';
                              //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                              //     return 'Please Enter 10 digit valid number';
                              //   }
                              // }
                              return null;
                            },
                          ),
                        ),
                        onTap: ()async{
                          if(areaunderby.text.isEmpty){
                            setState(() {
                              areaunderby.text='0.0';
                            });
                          }
                         String value=await _showIntegerDialog(double.parse(areaunderby.text),double.parse(residue.text).toInt());
                        setState(() {
                          areaunderby.text=value.toString();
                        });
                         },
                      )
                      // Padding(padding: EdgeInsets.only(right: 25))
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Text("Latlang:"),
                      Spacer(),
                          InkWell(
                            onTap: ()async{
                              latlang=await _getLocation();
                              if(latlang!.latitude!=0.0 && latlang!.longitude!=0.0){
                                setState((){
                                  latlangcontroller.text='${latlang!.latitude}${latlang!.longitude}';
                                  latlangcolor=Colors.green;
                                });

                              }
                            },
                        child: Container(
                          height: MediaQuery.of(context).size.height/10,
                          width: MediaQuery.of(context).size.width/1.9,
                          child: TextFormField(
                            enabled: false,
                            controller: latlangcontroller,
                            style: TextStyle(fontSize: 12),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                              FilteringTextInputFormatter.deny(
                                  RegExp(r'\s')),
                            ],
                            decoration: InputDecoration(
                                labelText: 'Latlang',
                                suffixIcon:Wrap(
                                  children: [
                                    Padding(padding: EdgeInsets.only(top: 13,right: 2),child: ColorFiltered(
                                      child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                      colorFilter:  ColorFilter.mode(latlangcolor, BlendMode.color),
                                    ),
                                    )

                                  ],
                                ),


                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      // TextFormField(
                      //       autovalidateMode: AutovalidateMode.onUserInteraction,
                      //       // controller: areaunderby,
                      //       // enabled: false,
                      //       decoration: InputDecoration(
                      //         labelText: "Area under by",
                      //         suffixIcon:  InkWell(
                      //           child: Padding(padding: EdgeInsets.only(top: 13,right: 5),child: ColorFiltered(
                      //             child: Image.asset("assets/images/locationping.jpg" ,height: 2,),
                      //             colorFilter:  ColorFilter.mode(latlangcolor, BlendMode.color),
                      //           ),),
                      //           onTap: () async {
                      //             PermissionStatus   status=await askPermission();
                      //             if(status.isGranted &&!status.isPermanentlyDenied) {
                      //               latlang = await _getLocation();
                      //               if (latlang!.latitude != 0.0 &&
                      //                   latlang!.longitude != 0.0) {
                      //                 setState(() {
                      //                   latlangcolor = Colors.green;
                      //                 });
                      //               }
                      //             }
                      //             else{
                      //               print("error");
                      //             }
                      //           },
                      //         ),
                      //         border: OutlineInputBorder(),
                      //         counter: Offstage(),
                      //       ),
                      //       keyboardType: TextInputType.phone,
                      //       maxLength: 10,
                      //       // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      //       validator: (value) {
                      //         String pattern =
                      //             r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                      //         RegExp exp2 = new RegExp(pattern);
                      //         // else{
                      //         //   if (value == null || value.isEmpty) {
                      //         //     return 'Please enter Phone number';
                      //         //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                      //         //     return 'Please Enter 10 digit valid number';
                      //         //   }
                      //         // }
                      //         return null;
                      //       },
                      //     ),
                              // TextFormField()

                      // Padding(padding: EdgeInsets.only(right: 25))
                    ],
                  ),
                  Divider(),
                  Text('Which of the following are you following...?'),
                   Text("Laser leveling....?"),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Yes"),
                        Radio(value: true, groupValue: laserleveling, onChanged: (bool? value){
                          setState(() {
                            laserleveling=value;
                          });
                        }),
                     // Spacer(),
                        Text("No"),
                        Radio(value: false, groupValue: laserleveling, onChanged: (bool? value){

                          setState(() {
                            laserdate.text='';
                            laserleveling=value;
                          });
                        }),
                      ],
                    ),
                  Visibility(
                visible: laserleveling??false,
                      child:Row(
                        children: [
                          Text("Last Date:"),
                          Spacer(),
                          InkWell(

                            child:  Container(
                              height: MediaQuery.of(context).size.height/14,
                              width: MediaQuery.of(context).size.width/1.9,
                              // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: laserdate,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "last date",
                                  border: OutlineInputBorder(),
                                  counter: Offstage(),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) {
                                  String pattern =
                                      r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                                  RegExp exp2 = new RegExp(pattern);
                                  // else{
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter Phone number';
                                  //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                                  //     return 'Please Enter 10 digit valid number';
                                  //   }
                                  // }
                                  return null;
                                },
                              ),
                            ),
                            onTap: ()async{
                              DateTime? pickedDate = await Dtaepicker();

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  laserdate.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          )

                        ],
                      ) ),
                  Visibility(
                    visible: laserleveling==false,
                      child: Row(
                        children: [
                          Text("Are you interested to do...?"),
                          Checkbox(
                            value: laserdo,
                            onChanged: (bool ? value) {
                              setState(() {
                                laserdo= value!;
                              });
                            },
                          ),

                        ],
                      )),
                  Divider(),
                  Text("DSR...?"),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Yes"),
                      Radio(value: true, groupValue: dsr, onChanged: (bool? value){
                        setState(() {
                          dsr=value!;
                        });
                      }),
                      // Spacer(),
                      Text("No"),
                      Radio(value: false, groupValue: dsr, onChanged: (bool? value){

                        setState(() {
                          dsrdate.text='';
                          dsr=value!;
                        });
                      }),
                    ],
                  ),
                  Visibility(
                      visible: dsr??false,
                      child:Row(
                        children: [
                          Text("Last Date:"),
                          Spacer(),
                          InkWell(

                            child:  Container(
                              height: MediaQuery.of(context).size.height/14,
                              width: MediaQuery.of(context).size.width/1.9,
                              // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: dsrdate,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "last date",
                                  border: OutlineInputBorder(),
                                  counter: Offstage(),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) {
                                  String pattern =
                                      r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                                  RegExp exp2 = new RegExp(pattern);
                                  // else{
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter Phone number';
                                  //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                                  //     return 'Please Enter 10 digit valid number';
                                  //   }
                                  // }
                                  return null;
                                },
                              ),
                            ),
                            onTap: ()async{
                              DateTime? pickedDate =  await Dtaepicker();

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  dsrdate.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          )

                        ],
                      ) ),
                  Visibility(
                      visible: dsr==false,
                      child: Row(
                        children: [
                          Text("Are you interested to do...?"),
                          Checkbox(
                            value: dsrdo,
                            onChanged: (bool ? value) {
                              setState(() {
                                dsrdo= value!;
                              });
                            },
                          ),
                        ],
                      )),
                 Divider(),
                 Text('Transplantation....?'),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Yes"),
                      Radio(value: true, groupValue: transplantaition, onChanged: (bool? value){
                        setState(() {
                          transplantaition=value;
                        });
                      }),
                      // Spacer(),
                      Text("No"),
                      Radio(value: false, groupValue: transplantaition, onChanged: (bool? value){

                        setState(() {
                          transplantaitiondate.text='';
                          transplantaition=value;
                        });
                      }),
                    ],
                  ),
                  Visibility(
                      visible: transplantaition??false,
                      child:Row(
                        children: [
                          Text("Last Date:"),
                          Spacer(),
                          InkWell(

                            child:  Container(
                              height: MediaQuery.of(context).size.height/14,
                              width: MediaQuery.of(context).size.width/1.9,
                              // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: transplantaitiondate,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "last date",
                                  border: OutlineInputBorder(),
                                  counter: Offstage(),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) {
                                  String pattern =
                                      r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                                  RegExp exp2 = new RegExp(pattern);
                                  // else{
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter Phone number';
                                  //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                                  //     return 'Please Enter 10 digit valid number';
                                  //   }
                                  // }
                                  return null;
                                },
                              ),
                            ),
                            onTap: ()async{
                              DateTime? pickedDate =  await Dtaepicker();

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  transplantaitiondate.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          )

                        ],
                      ) ),
                  Visibility(
                      visible: transplantaition==false,
                      child: Row(
                        children: [
                          Text("Are you interested to do...?"),
                          Checkbox(
                            value: transplantaitiondo,
                            onChanged: (bool ? value) {
                              setState(() {
                                transplantaitiondo = value!;
                              });
                            },
                          ),
                        ],
                      )),
                  Divider(),
                  Text('AWD..?'),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Yes"),
                      Radio(value: true, groupValue: awd, onChanged: (bool? value){
                        setState(() {
                          awd=value;
                        });
                      }),
                      // Spacer(),
                      Text("No"),
                      Radio(value: false, groupValue: awd, onChanged: (bool? value){

                        setState(() {
                          awddate.text='';
                          awd=value;
                        });
                      }),
                    ],
                  ),
                  Visibility(
                      visible: awd??false,
                      child:Row(
                        children: [
                          Text("Last Date:"),
                          Spacer(),
                          InkWell(

                            child:  Container(
                              height: MediaQuery.of(context).size.height/14,
                              width: MediaQuery.of(context).size.width/1.9,
                              // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: awddate,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "last date",
                                  border: OutlineInputBorder(),
                                  counter: Offstage(),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) {
                                  String pattern =
                                      r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                                  RegExp exp2 = new RegExp(pattern);
                                  // else{
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter Phone number';
                                  //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                                  //     return 'Please Enter 10 digit valid number';
                                  //   }
                                  // }
                                  return null;
                                },
                              ),
                            ),
                            onTap: ()async{
                              DateTime? pickedDate =await Dtaepicker();

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  awddate.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          )

                        ],
                      ) ),
                  Visibility(
                      visible: awd==false,
                      child: Row(
                        children: [
                          Text("Are you interested to do...?"),
                          Checkbox(
                            value: awddo,
                            onChanged: (bool ? value) {
                              setState(() {
                                awddo= value!;
                              });
                            },
                          ),
                        ],
                      )),
                  Divider(),
                  Text("No Tillage...?"),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Yes"),
                      Radio(value: true, groupValue: notillage, onChanged: (bool? value){
                        setState(() {
                          notillage=value;
                        });
                      }),
                      // Spacer(),
                      Text("No"),
                      Radio(value: false, groupValue: notillage, onChanged: (bool? value){

                        setState(() {
                          notillafedate.text='';
                          notillage=value;
                        });
                      }),
                    ],
                  ),
                  Visibility(
                      visible: notillage??false,
                      child:Row(
                        children: [
                          Text("Last Date:"),
                          Spacer(),
                          InkWell(

                            child:  Container(
                              height: MediaQuery.of(context).size.height/14,
                              width: MediaQuery.of(context).size.width/1.9,
                              // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: notillafedate,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "last date",
                                  border: OutlineInputBorder(),
                                  counter: Offstage(),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) {
                                  String pattern =
                                      r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                                  RegExp exp2 = new RegExp(pattern);
                                  // else{
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter Phone number';
                                  //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                                  //     return 'Please Enter 10 digit valid number';
                                  //   }
                                  // }
                                  return null;
                                },
                              ),
                            ),
                            onTap: ()async{
                              DateTime? pickedDate = await Dtaepicker();

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  notillafedate.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          )

                        ],
                      ) ),
                  Visibility(
                      visible: notillage==false,
                      child: Row(
                        children: [
                          Text("Are you interested to do...?"),
                          Checkbox(
                            value: notillagedo,
                            onChanged: (bool ? value) {
                              setState(() {
                                notillagedo= value!;
                              });
                            },
                          ),
                        ],
                      )),
                  Divider(),
                  Text("CRM...?"),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Yes"),
                      Radio(value: true, groupValue: crm, onChanged: (bool? value){
                        setState(() {
                          crm=value;
                        });
                      }),
                      // Spacer(),
                      Text("No"),
                      Radio(value: false, groupValue: crm, onChanged: (bool? value){

                        setState(() {
                          crmdate.text='';
                          crm=value;
                        });
                      }),
                    ],
                  ),
                  Visibility(
                      visible: crm??false,
                      child:Row(
                        children: [
                          Text("Last Date:"),
                          Spacer(),
                          InkWell(

                            child:  Container(
                              height: MediaQuery.of(context).size.height/14,
                              width: MediaQuery.of(context).size.width/1.9,
                              // padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: crmdate,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "last date",
                                  border: OutlineInputBorder(),
                                  counter: Offstage(),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) {
                                  String pattern =
                                      r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
                                  RegExp exp2 = new RegExp(pattern);
                                  // else{
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter Phone number';
                                  //   } else if (value.length != 10 || !exp2.hasMatch(value)) {
                                  //     return 'Please Enter 10 digit valid number';
                                  //   }
                                  // }
                                  return null;
                                },
                              ),
                            ),
                            onTap: ()async{
                              DateTime? pickedDate = await Dtaepicker();

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  crmdate.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          )

                        ],
                      ) ),
                  Visibility(
                      visible: crm==false,
                      child: Row(
                        children: [
                          Text("Are you interested to do...?"),
                          Checkbox(
                            value: crmdo,
                            onChanged: (bool ? value) {
                              setState(() {
                                crmdo= value!;
                              });
                            },
                          ),
                        ],
                      )),

                      Visibility(
                          visible:  loading ,
                          child: Text("")),
                  GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 8.0,
                    shrinkWrap: true,
                    children:<Widget>[... List.generate(images.length, (index) {
                      return    Stack(
                        children: <Widget>[
                          InkWell(
                            child: Image.memory(images[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit
                              .cover),
                            onTap: (){
                              // GetImages("8530871947");
                              // Get.to(ImageView(image:images[index] ));
                            },
                          ),
                        ],
                      );

                    },
                    ) ]+ [InkWell(onTap: ()async{
                      final    status = await Permission.storage.status;
                      final camerastatus=await Permission.camera.status;
                      if(status.isGranted && camerastatus.isGranted){
                        setState(() {
                          loading=true;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationCamera (
                                  Farmerid:0,
                                  FieldofficerId:0,
                                  FieldmanagerID:0,
                                  from: 'Farmeraccasation',
                                )))
                            .then((value) {
setState(() {
  loading=false;
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
                        Image.asset('assets/images/camera.png',height: 80,),
                        Text("Add Image")
                      ],
                    ))],
                  ),

        Center(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
               shadowColor:  Colors.green
              ),
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),onPressed: (){
                print(imagesid.length);
                String commaSeparatedNames= imagesid
                    .map((item) => item)
                    .toList()
                    .join(",");
                print('hgjkgj'+commaSeparatedNames);

                var data={
                "FarmerName":farmername.text,
                  "FatherName":fathername.text,
                  "MobileNumber":mobilenumber.text,
                  "VillageID":selectdevalues!.iD,
                "ClientID":selectedclint!.clintId,
                "OperateArea":operatearea.text.isEmpty?0:operatearea.text,
                  "AreaUnderPaddy":underpaddy.text.isEmpty?0:underpaddy.text,
                  "AreaUnderResidueManagement":residue.text.isEmpty?0:residue.text,
                  "AreaManagerByClient":areaunderby.text.isEmpty?0:areaunderby.text,
                  "Latitude":latlang!.latitude,
                  "Longitude":latlang!.longitude,
                  "LaserLevelingYN":laserleveling!?1:0,
                  "LaserLevelingLastDate":laserdate.text.isEmpty?null:laserdate.text,
                  "LaserLevelingIntrestedYN":laserdo?1:0,
                  "DSRYN":dsr!?1:0,
                  "DSRLastDate":dsrdate.text.isEmpty?null:dsrdate.text,
                  "DSRIntrestedYN":dsrdo!?1:0,
                  "TransplantationYN":transplantaition!?1:0,
                  "TransplantationLastDate":transplantaitiondate.text.isEmpty?null:transplantaitiondate.text,
                  "TransplantationIntrestedYN":transplantaitiondo!?1:0,
                  "AWDYN":	awd!?1:0,
                  "AWDLastDate":awddate.text.isEmpty?null:awddate.text,
                  "AWDIntrestedYN":awddo!?1:0,
                  "NoTillageYN":notillage!?1:0,
                  "NoTillageLastDate":notillafedate.text.isEmpty?null:notillafedate.text,
                  "NoTillageIntrestedYN":notillagedo!?1:0,
                  "CRMYN":crm!?1:0,
                  "CRMLastDate":crmdate.text.isEmpty?null:crmdate.text,
                  "CRMIntrestedYN":crmdo!?1:0,
                  "ServiceAppGPSCamIDs":commaSeparatedNames.isEmpty?null:commaSeparatedNames,
                };
                if(farmername.text.isEmpty || mobilenumber.text.isEmpty ||mobilenumber.text.length !=10|| selectdevalues!.iD==null){
                  Fluttertoast.showToast(msg: "Enter correct values",backgroundColor: Colors.white,textColor: Colors.red);
                }else {
                  Postdata(data);
                }
          }),
        ),
                  ]
              ),
            ),

          ],
        ),),
      )
    );
  }

 Dtaepicker()async{
  DateTime? pickedDate =  await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime.now());
  return pickedDate;
}

Future Postdata(phonenumberone) async {
  Map<String, String> header = {
    "content-type": "application/json",
    "API_KEY": "12345678"
  };
  // var  path = 'http://20.219.2.201/servicesF2Fapp/api/farm2fork/Imagepost/post';
  var  path= 'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/farmeraccusation/postfarmerdetails';
  print(path);
  final dio = Dio();
  Map<String, dynamic> returnData = {};
  try {
    final response =
    await dio.post(path,  data: phonenumberone,options: Options(headers: header),queryParameters: {});
    print("responcasklfme ${response.data['status']==true}");
    if (response.statusCode == 200) {
      print(response.data['status']==true);
      Fluttertoast.showToast(
          backgroundColor: Colors.green,
          textColor: Colors.black,
          msg:"Data saved successfully");
      Navigator.pop(context);
      return response.statusCode;
      returnData = response.data;
    }
    else{
      return response.statusCode;
    }
  } catch (e) {
    print("error one is ${e}");
    Fluttertoast.showToast(
        msg: 'Cannot post  data, please try later: ${e.toString()}');

  }
  return returnData;

}
}
