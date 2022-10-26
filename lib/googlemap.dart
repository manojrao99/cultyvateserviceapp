// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:clippy_flutter/triangle.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:hexcolor/hexcolor.dart';
// import 'models/devicelocations.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// // import ‘package:flutter/services.dart’ show rootBundle;
// import 'dart:ui' as ui;
// // import ‘dart:ui’ as ui;
// import 'package:dio/dio.dart';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get_connect/http/src/response/response.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'loca';
// import 'package:location/location.dart';
// class Devicelocations_find extends StatefulWidget {
//   const Devicelocations_find({Key? key}) : super(key: key);
//
//   @override
//   State<Devicelocations_find> createState() => _Devicelocations_findState();
// }
//
// class _Devicelocations_findState extends State<Devicelocations_find> {
// bool is_loading=false;
//   GoogleMapController? _controller;
//   Location currentLocation = Location();
//   Set<Marker> _markers={};
// TextEditingController fnumber = TextEditingController();
// CustomInfoWindowController _customInfoWindowController =
// CustomInfoWindowController();
//
//   Future<Uint8List> getBytesFromAsset({required String path,required int width})async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//         data.buffer.asUint8List(),
//         targetWidth: width
//     );
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(
//         format: ui.ImageByteFormat.png))!
//         .buffer.asUint8List();
//   }
// late LocationData position;
// List<LatLng> latlng = [];
// static LatLng _lat1 = LatLng(13.035606, 77.562381);
// static double getDistanceFromGPSPointsInRoute(List<LatLng> gpsList) {
//   double totalDistance = 0.0;
//
//   for (var i = 0; i < gpsList.length; i++) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((gpsList[i + 1].latitude - gpsList[i].latitude) * p) / 2 +
//         c(gpsList[i].latitude * p) *
//             c(gpsList[i + 1].latitude * p) *
//             (1 - c((gpsList[i + 1].longitude - gpsList[i].longitude) * p)) /
//             2;
//     double distance = 12742 * asin(sqrt(a));
//     totalDistance += distance;
//     print('Distance is ${12742 * asin(sqrt(a))}');
//   }
//   print('Total distance is $totalDistance');
//   return totalDistance;
// }
//
// Widget printmenthid(){
// return AlertDialog(
//   title: Text("asfjhnj"),
// );
// }
//
//
// LatLongconvert(firstlatitude,firstlongtitude,secondlatitude,secondlongtitude){
//   List<LatLng> latlng = [];
//   LatLng first = LatLng(firstlatitude, firstlongtitude);
//   LatLng second = LatLng(secondlatitude, secondlongtitude );
//  setState((){
//    latlng.add(first);
//    latlng.add(second);
//
//  });
// return this.latlng;
// }
//
//   void getLocation() async{
//     setState((){
//       is_loading=true;
//     });
//     final Uint8List customMarker= await getBytesFromAsset(
//         path:"assets/images/avataar.png", //paste the custom image path
//         width: 80 ,
//
//       // size of custom image as marker
//     );
//     // ByteData bytes = await rootBundle.load('assets/images/flutter.png');
//     var location = await currentLocation.getLocation();
//     currentLocation.onLocationChanged.listen((LocationData loc){
//     setState((){
//       position=loc;
//     });
//       _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
//         target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
//         // zoom: 30.0,
//       )));
//       print(loc.latitude);
//       print(loc.longitude);
//       setState(() {
//         LatLng _new = LatLng(loc.latitude!.toDouble(), loc.longitude!.toDouble());
//         LatLng _news = LatLng(12.8199026, 77.5510563 );
//
//         latlng.add(_new);
//         latlng.add(_news);
//         _markers.add(Marker(markerId: MarkerId('Home'),
//
//             icon:BitmapDescriptor.fromBytes( customMarker),
//             position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
//           onTap: (){
//                   print("location done");
//             _customInfoWindowController.addInfoWindow!(
//               Column(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.account_circle,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                             SizedBox(
//                               width: 8.0,
//                             ),
//                             Text(
//                               "I am here",
//                               style:
//                               Theme.of(context).textTheme.headline6!.copyWith(
//                                 color: Colors.white,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       width: double.infinity,
//                       height: double.infinity,
//                     ),
//                   ),
//                   Triangle.isosceles(
//                     edge: Edge.BOTTOM,
//                     child: Container(
//                       color: Colors.blue,
//                       width: 20.0,
//                       height: 10.0,
//                     ),
//                   ),
//                 ],
//               ),
//               _lat1
//               // _latLng,
//             );
//             }
//
//         ));
//         // _markers.add(Marker(markerId: MarkerId('work'),
//         //     position: LatLng(12.8199026 ?? 0.0, 77.5510563 ?? 0.0)
//         // ));
//         // _markers.add(Marker(markerId: MarkerId('manoj'),
//         //     // icon:,
//         //     position: LatLng(12.6199028 ?? 0.0, 77.6510565 ?? 0.0)
//         // ));
//         // _polyline.add(Polyline(
//         //   polylineId: PolylineId("25"),
//         //
//         //   visible: true,
//         //   points: latlng,
//         //   width: 3,
//         //
//         //   color: Colors.blue,
//         //   onTap:(){
//         //     // Text("ajhfbjhqa");
//         //     print("manoj");
//         //     AlertDialog(
//         //       backgroundColor: Colors.white,
//         //       title: Text("welcome"),);
//         //     getDistanceFromGPSPointsInRoute(latlng);
//         //   }
//         // ));
//         is_loading=false;
//
//       });
//     });
//
//   }
// final Set<Polyline>_polyline={};
//
//  Set<Circle> circles={} ;
// // http://localhost:3000/farmerlatlong/7013944309
//
//
//   Future<List<FarmerDetails>?> getTelematics() async {
//     List<FarmerDetails> telematicDataList = [];
//     Map<String, dynamic> response = await getdata(fnumber.text);
//     print("responce is one :${response}");
//
//    try{
//      if (response.isNotEmpty ) {
//        print("inside try");
//        print(response['success']);
//        print(response is List<dynamic>);
//        if (response['success'] !=false) {
//          for (int i = 0; i < response['data'].length; i++) {
//            print("error one tweo");
//            FarmerDetails telematicModel = FarmerDetails.fromJson(response['data']);
//            telematicDataList.add(telematicModel);
//          }
//          telematicDataList.forEach((element) {
//         setState((){
//           circles=  Set.from([
//                 Circle(
//                   circleId: CircleId("1000metters"),
//                   center: LatLng(element.lat??0.0, element.long??0.0),
//                   // fillColor: Colors.blueAccent,
//                   strokeColor: HexColor("#00FFFF"),
//                   strokeWidth: 1,
//                   radius: 1000,
//                 ),
//                 Circle(
//                   circleId: CircleId("1500metters"),
//                   center: LatLng(element.lat??0.0, element.long??0.0),
//                   // fillColor: Colors.blueAccent,
//                   strokeColor: HexColor("#FFFF00"),
//                   strokeWidth: 1,
//                   radius: 1500,
//                 ),
//                 Circle(
//                   circleId: CircleId("2000metters"),
//                   center: LatLng(element.lat??0.0, element.long??000),
//                   // fillColor: Colors.blueAccent,
//                   strokeColor: HexColor("#1E90FF").withOpacity(1),
//                   strokeWidth: 1,
//                   radius: 2000,
//                 )
//
//
//               ]);
//           _markers.add(Marker(markerId: MarkerId('Farmland'),
//             position: LatLng(element.lat ?? 0.0, element.long ?? 0.0),
//           ));
//         });
//            element.farmlands!.forEach((farmland) {
//              farmland.blocks!.forEach((block) {
//              setState((){
//                _markers.add(Marker(markerId: MarkerId('blocks'),
//                    position: LatLng(block.latitude ?? 0.0, block.longitude?? 0.0)
//
//
//                ));
//                _polyline.add(Polyline(
//                    polylineId: PolylineId("${block.name}"),
//
//                    visible: true,
//                    points: LatLongconvert(element.lat,element.long,block.latitude,block.longitude),
//                    width: 3,
//
//                    color: Colors.blue,
//                    onTap:(){
//                      getDistanceFromGPSPointsInRoute(latlng);
//                    }
//                ));
//              });
//                block.plots!.forEach((plots) {
//                  setState((){
//                    _markers.add(Marker(markerId: MarkerId('plots'),
//                        // icon:,
//                        position: LatLng(plots.latitude?? 0.0, plots.longitude?? 0.0)
//
//                    ));
//                    _polyline.add(Polyline(
//                        polylineId: PolylineId("${block.name}"),
//
//                        visible: true,
//                        points: LatLongconvert(element.lat,element.long,plots.latitude,plots.longitude),
//                        width: 3,
//
//                        color: Colors.blue,
//                        onTap:(){
//                          print("manoj");
//                          AlertDialog(
//                            backgroundColor: Colors.white,
//                            title: Text("welcome"),);
//                          getDistanceFromGPSPointsInRoute(latlng);
//                        }
//                    ));
//                  });
//
//                });
//              });
//            });
//
//
//
//          });
//
//
//
//        }
//        else{
//          Fluttertoast.showToast(
//              msg: response['message'],
//            backgroundColor: Colors.red
//          );
//          print("error ios :"+e.toString());
//          print("catch error is :${e}");
//        }
//      }
//
//    }
//    catch(e){
//      Fluttertoast.showToast(
//          msg: 'Cannot get requested data, please try later: ${e.toString()}');
//      print("error ios :"+e.toString());
//      print("catch error is :${e}");
//    }
//     telematicDataList.forEach((element) {
//
//     element.farmlands!.forEach((element) {
//       print("farmland id is :${element.farmlandName}");
//
//     });
//     });
//
//     // print("telematric details :${telematicDataList.}")
//      return telematicDataList;
//   }
//
//
// Future getdata(phonenumber) async {
//
//     Map<String, String> header = {
//       "content-type": "application/json",
//       "API_KEY": "12345678"
//     };
//     var path='http://192.168.226.1:3000/profile/$phonenumber';
//     // print(path);
//     final dio = Dio();
//     Map<String, dynamic> returnData = {};
//     try {
//       final response =
//       await dio.get(path,  options: Options(headers: header),queryParameters: {});
//       if (response.statusCode == 200) {
//         returnData = response.data;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: 'Cannot get requested data, please try later: ${e.toString()}');
//       print("error ios :"+e.toString());
//     }
//     return returnData;
//   }
//
//
//   //
//   // // print(path);
//   // List<FarmerDetails> _farmerdetails =[];
//   // try {
//   //   final response = await http.get(Uri.parse('http://192.168.226.1:3000/profile/$phonenumber'));
//   //   // Response response =
//   //   // await dio.get(path,  options: Options(headers: header),queryParameters: {});
//   //   if (response.statusCode == 200) {
//   //     try {
//   //       final jsonItems = json
//   //           .decode(response.body)['data']
//   //           .cast<Map<String, dynamic>>();
//   //     }
//   //     catch(e){
//   //       print("catch : eeee : $e");
//   //     }
//   //     // paymentList = jsonItems.map<PaymentModel>((json) {
//   //     //   return PaymentModel.fromJson(json);
//   //     // }).toList();
//   //     // final jsonItems = json.decode(response.body)['data'];
//   //     // print("json item: ${jsonItems}");
//   //
//   //
//   //     // try{
//   //     //   final item=jsonItems.cast<String,dynamic>();
//   //     //   _farmerdetails.addAll(item<FarmerDetails>((json) {
//   //     //     return FarmerDetails.fromJson(json);
//   //     //   }).toList());
//   //     //   // _farmerdetails.forEach((element) {
//   //     //   //   print("testing : ${element.lat}");
//   //     //   // });
//   //     // }
//   //     // catch(e){
//   //     //   print("catch error :$e");
//   //     // }
//   //     Map<String, dynamic> map = json.decode(response.body);
//   //     final data = map["data"];
//   //     print("manoj:#${data}");
//   //     List values= [];
//   //     values = json.decode(response.body)['data'];
//   //     if(values.length>0) {
//   //       for (int i = 0; i < values.length; i++) {
//   //         if (values[i] != null) {
//   //           Map<String, dynamic> map = values[i];
//   //           _farmerdetails.add(FarmerDetails.fromJson(map));
//   //           debugPrint('Id-------${map}');
//   //         }
//   //       }
//   //     }
//   //   }
//   //
//   // } catch (e) {
//   //   Fluttertoast.showToast(
//   //       msg: 'Cannot get requested data, please try later: ${e.toString()}');
//   //   print(e.toString());
//   // }
//   // return returnData;
// // }
//
//   @override
//   void initState(){
//     super.initState();
//
//       getLocation();
//   }
//
// // http://localhost:3000/farmerlatlong/98545987
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Scaffold(
//         body: SafeArea(
//             child: SingleChildScrollView(
//                 child: Form(
//                   // key: _key,
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                   Container(
//                     // height: MediaQuery.of(context).size.height/20,
//                     child:Column(
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.height/15,
//                           child: Image.asset(
//                             'assets/images/cultyvate.png',
//                             height: 50,
//                           ),
//                         ),
//                         Container(
//                             height: MediaQuery.of(context).size.height/18,
//                             padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
//                             child:Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children:[
//                                   Text(
//                                     "Farmer",
//                                     style: TextStyle(
//                                         color: Color.fromRGBO(10 ,192 ,92,2),
//                                         fontSize: 30,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     " Device Location",
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 30,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ] )
//                         ),
//                         SizedBox(height: 10,),
//                         Row(
//                           children: [
//                             Container(
//                               height: MediaQuery.of(context).size.height/12,
//                               width: MediaQuery.of(context).size.width/1.4,
//                               padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
//                               child: TextFormField(
//                                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                                 controller: fnumber,
//                                 decoration: InputDecoration(
//                                   labelText: 'Farmer Mobile number',
//                                   border: OutlineInputBorder(),
//                                   counter: Offstage(),
//                                 ),
//                                 keyboardType: TextInputType.phone,
//                                 maxLength: 10,
//                                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                                 validator: (value) {
//                                   String pattern =
//                                       r'(^[6-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}]*$)';
//                                   RegExp exp2 = new RegExp(pattern);
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter Phone number';
//                                   } else if (value.length != 10 || !exp2.hasMatch(value)) {
//                                     return 'Please Enter 10 digit valid number';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             InkWell(
//                               child: Container(
//                                 color: Colors.blueAccent,
//                                 height: MediaQuery.of(context).size.height/18,
//                                 width: 40,
//                                 child:Center(
//                                   child:  Text("GO"),
//                                 ),
//                               ),
//                               onTap: (){
//                                 getTelematics();
//                               },
//                             )
//                           ],
//                         ),
//                         SizedBox(height: 10,),
//
//                       ],
//                     ),
//                   ),
//                    Container(
//                      height: MediaQuery.of(context).size.height/1.4,
//                      width: double.infinity,
//                      margin: EdgeInsets.all(10),
//                      // color: Colors.red,
//                      child: is_loading?Center(
//                        child: CircularProgressIndicator(),
//                      ): GoogleMap(
//                      mapType: MapType.terrain,
//                      polylines: _polyline,
//                      zoomControlsEnabled: true,
//                        zoomGesturesEnabled: true,
//                      //   myLocationEnabled: true,
//                        myLocationButtonEnabled: true,
//                      // zoomGesturesEnabled: true,
//                        circles: circles,
//                      compassEnabled: true,
//
//                          // minMaxZoomPreference: MinMaxZoomPreference(13,17),
//                        initialCameraPosition:CameraPosition(
//                          target: LatLng(position.latitude!.toDouble(), position.longitude!.toDouble()),
//
//                          // zoom: 12.0,
//                        ),
//                      // initialCameraPosition: _kGooglePlex,
//                      //   onMapCreated: (GoogleMapController controller){
//                      //     _controller = controller.;
//                      //   },
//                        markers: Set.from(_markers),
//                    ),
//                    ),
//                           CustomInfoWindow(
//                             controller: _customInfoWindowController,
//                             height: 75,
//                             width: 150,
//                             offset: 50,
//                           ),
//
//                    // Container(
//
//                    // )
//
//
//
//
//
//
//                         ]
//                     )
//                 )
//             )
//         )
//     );
//
//   }
//
//
//
//
// }
