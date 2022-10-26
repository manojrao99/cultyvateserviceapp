import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import "dart:math" show pi;
import 'package:clippy_flutter/triangle.dart';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import '/models/devicelocations.dart';

import '../models/actualdevices.dart';
import '../models/clintslist.dart';
import '../models/length.dart';

class Faremer_Devices extends StatefulWidget {
  const Faremer_Devices({Key? key}) : super(key: key);

  @override
  State<Faremer_Devices> createState() => _Faremer_DevicesState();
}

class _Faremer_DevicesState extends State<Faremer_Devices> {
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  CustomInfoWindowController _circleWindowController = CustomInfoWindowController();
  CustomInfoWindowController _polilinecontroller = CustomInfoWindowController();
  Completer<GoogleMapController> _controller = Completer();
  String markerFlag = "";
  LatLng tapedlatlang=LatLng(0.00, 0.00);
   GoogleMapController? mapController;
  final Set<Polyline>_polyline={};

   late LatLng position;

  Set<Circle> circles={};
  late LatLng _onclicklatlong;
  LatLng _latLng = LatLng(0.0,0.0);
    double _zoom=15;
  List<Marker> _markers = [];
  List<Marker>_gatewaymarkers=[];
  Location currentLocation = Location();
  // final Set<Polyline>_polyline={};
  TextEditingController fnumber=TextEditingController();
  bool is_loading=false;
  int val=1;
  List<ClintsList> returnData = [];
  // Future<ClintsList>? _futureAlbum;
  @override
  void initState() {
    geclints();
    // TODO: implement initState
    getlivelocation();
    super.initState();
  }
bool clintlistloading=false;
  Future geclints() async {
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

           returnData.add(ClintsList(
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
          print("retuenr data ius ,${element.clintName}");
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


  Future<Uint8List> getBytesFromAsset({required String path,required int width})async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
        format: ui.ImageByteFormat.png))!
        .buffer.asUint8List();
  }



  Future<void> updateCameraLocation(
      LatLng source,
      LatLng destination,
      GoogleMapController mapController,
      ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }


  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

getlivelocation()async{
  setState((){
    is_loading=true;
  });
  final Uint8List customMarker= await getBytesFromAsset(
    path:"assets/images/avataar.png", //paste the custom image path
    width: 80 ,

    // size of custom image as marker
  );

  currentLocation.onLocationChanged.listen((LocationData loc) async{
    if (mounted) {
      //   setState(() {
      _latLng = await LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0);
      setState(() {
        is_loading = false;
      });
    }

    print("latlang is $_latLng");
  }
  );

}
  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }
  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }


  List <Findlength>calculateDistance(lat1, lon1, lat2, lon2){
    List<Findlength> data=[];
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    var kilometters = dist * 60 * 1.1515;
    data.add(Findlength(meters: kilometters*1000,kilometers: kilometters));
    dist = dist * 1.609344;
    return data;
  }

  addmetterstokatkong({meters,my_lat,my_long}){
    double coef = meters / 111.32;

    double new_lat = my_lat + coef;

// pi / 180 ~= 0.01745
    double new_long = my_long + coef /cos(my_lat * 0.01745);
    return LatLng(new_lat, new_long);
  }

 LatLng gatewaylatlong=LatLng(0.0, 0.0);

   Findlength PolilineDistancebetween({required LatLng gatewaylat,required LatLng polyline}){

   print("polyline distance ${polyline}");
   double distanceInMeters = Geolocator.distanceBetween(gatewaylat.latitude, gatewaylat.longitude, polyline.latitude, polyline.longitude);
        print(distanceInMeters);
   return Findlength(meters: distanceInMeters,kilometers: distanceInMeters/1000);
 }
  PolilineLatlang({gatewaylatlang,polilinglatlang}){
     print("gatewaylatlang ${gatewaylatlong}");
    List<LatLng> latlang=[];
    latlang.add(gatewaylatlang);
    latlang.add(polilinglatlang);
    return latlang;

  }

  ToNorthPosition(LatLng center, double northDistance)
  {
    double r_earth = 6378;
    var new_latitude = center.latitude + (northDistance / r_earth) * (180 / pi);
    return  LatLng(new_latitude, center.longitude);
  }
  ToSouthPosition(LatLng center, double southDistance)
  {
    double r_earth = 6378;
    // var pi = Math.PI;
    var new_latitude = center.latitude - (southDistance / r_earth) * (180 / pi);
    return  LatLng(new_latitude, center.longitude);
  }
Circlelatlang({required LatLng circlelatlang,meters})async{
  double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);

return distanceInMeters;
  }


   static double getDistanceFromGPSPointsInRoute(List<LatLng> gpsList) {
  double totalDistance = 0.0;

  for (var i = 0; i < gpsList.length; i++) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((gpsList[i + 1].latitude - gpsList[i].latitude) * p) / 2 +
        c(gpsList[i].latitude * p) *
            c(gpsList[i + 1].latitude * p) *
            (1 - c((gpsList[i + 1].longitude - gpsList[i].longitude) * p)) /
            2;
    double distance = 12742 * asin(sqrt(a));
    totalDistance += distance;
    print('Distance is ${12742 * asin(sqrt(a))}');
  }
  print('Total distance is $totalDistance');
  return totalDistance;
}

String Farmername="";

  var items = [
    'client 1',
    'client 2',
    'client 3',
    'client 4',
    'client 5',
  ];
     ClintsList ? dropdownvalue ;
     String Dropdownname="choose Client";
   LatLng circleLatlang({required LatLng gateway,required int metterts}){
          var latitude=gateway.latitude;
          var longtitude=gateway.longitude+1;

         if(metterts==1000){
           return LatLng(latitude+0.5, longtitude+0.5);
         }
         else if(metterts==1500){
            return LatLng(latitude+0.8, longtitude+0.8);
          }
          else {
            return LatLng(latitude, longtitude+15);
          }

   }



 // double  Markercolor=BitmapDescriptor.hueRed;
   Markercolorchange(markerid,Devices plotdevices)async{
       String markeridid="MarkerId($markerid)";
       // Set<Marker> resetmarkers=_markers;
        // _markers.toSet(_markers.where((element) => element.markerId==markeridid));
       _markers.forEach((element) {
      print("marker id ${markeridid.runtimeType}  ${markeridid}foeexach block ${element.markerId.toString().runtimeType} ${element.markerId.toString()}");
      if (markeridid == element.markerId.toString()) {
        print("matched");
        setState(()async{
          // element.
          // setProperty(1, element.icon, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
          // await resetmarkers.remove(element);
          // await resetmarkers.add(Marker(markerId: MarkerId(element.markerId.toString()),
          //     consumeTapEvents: true,
          //     visible: true,
          //     draggable: false,
          //     // istaped: false,
          //     // infoWindow: InfoWindow(title: "wehhjr"),
          //
          //     icon: BitmapDescriptor.defaultMarkerWithHue(
          //         BitmapDescriptor.hueGreen),
          //     position: element.position,
          //     onTap: () {
          //       Markercolorchange(plotsdevices.deviceID.toString(),plotsdevices);
          //       // gatewaylatlong!=LatLng(0.0,0.0)?
          //
          //       _customInfoWindowController.addInfoWindow!(
          //           Column(
          //             children: [
          //               Expanded(
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     borderRadius: BorderRadius.circular(4),
          //                   ),
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Column(
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       children: [
          //                         // plotsdevices.
          //                         Text("FarmerName:${Farmername}"),
          //                         Text("Device ID :${plotdevices.deviceEUIID}"),
          //                         Text("Device Name:${plotdevices.name
          //                             .toString()}"),
          //                         // Text("Device Type:${plotsdevices.type.toString()}"),
          //                         Text(LatLng(plotdevices.latitude ?? 0.00,
          //                           plotdevices.longitude ?? 0,).toString())
          //
          //                       ],
          //                     ),
          //                   ),
          //                   width: double.infinity,
          //                   height: double.infinity,
          //                 ),
          //               ),
          //               Triangle.isosceles(
          //                 edge: Edge.BOTTOM,
          //                 child: Container(
          //                   color: Colors.white,
          //                   width: 20.0,
          //                   height: 10.0,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           LatLng(plotdevices.latitude ?? 0.00,
          //               plotdevices.longitude ?? 0.00)
          //         // _latLng,
          //       );
          //     }
          //
          // ));
        });
      }
      else{

      }
    }  );
     // setState(()async{
     //   _markers=await resetmarkers;
     // });
   }

  ToEastPosition(LatLng center, double eastDistance)
  {
    double r_earth = 6378;
    // var pi = Math.PI;
    var new_longitude = center.latitude + (eastDistance / r_earth) * (180 / pi) / cos(center.longitude * pi / 180);
    return new LatLng(center.latitude, new_longitude);
  }
  Future<List<Devicedata>?> getTelematics() async {


        final Uint8List customMarker= await getBytesFromAsset(
        path:"assets/images/gateway.png", //paste the custom image path
        width: 80 ,

      // size of custom image as marker
    );
    // print("")
    List<Devicedata> Devices = [];
    _gatewaymarkers.clear();
    circles.clear();
        _circleWindowController.hideInfoWindow!();
    _polyline.clear();
    _markers.clear();
     setState((){   gatewaylatlong=LatLng(0.0, 0.0);});
        final Uint8List gateway= await getBytesFromAsset(
        path:"assets/images/gateway.png", //paste the custom image path
        width: 150 ,

      // size of custom image as marker
    );
    Map<String, dynamic> response = await getdata(fnumber.text);
    print("responce is one :${response}");

    try {
      if (response.isNotEmpty) {
        print("inside try");
        print(response['success']);
        print(response is List<dynamic>);
        if (response['success'] != false) {
          for (int i = 0; i < response['data'].length; i++) {
            print("erro tweomanoj");
            try {
              Devicedata telematicModel = Devicedata.fromJson(
                  response['data'][i]);
              setState(() {
                Devices.add(telematicModel);
              });
            }
            catch (e) {
              print("error is $e");
            }
          }
          print("length ${Devices.length}");
          if (Devices.length != 0) {
            for (int i = 0; i < Devices.length; i++) {
              for (int j = 0; j < Devices[i].farmlandDevices!.length; j++) {
                if (Devices[i].farmlandDevices![j].latitude != null &&
                    Devices[i].farmlandDevices![j].longtitude != null) {
                  if (Devices[i].farmlandDevices![j].devicetype == "GWY") {
                    print("latitude and logtitude check${LatLng(
                        Devices[i].farmlandDevices![j].latitude ?? 00,
                        Devices[i].farmlandDevices![j].longtitude ?? 0)}");
                    _gatewaymarkers.add(Marker(markerId: MarkerId(
                      Devices[i]!.farmlandDevices![j].deviceid.toString() +
                          j.toString(),),
                        icon: BitmapDescriptor.fromBytes(customMarker),
                        position: LatLng(
                            Devices[i].farmlandDevices![j].latitude ?? 0.00,
                            Devices[i].farmlandDevices![j].longtitude ?? 0.00),
                        onTap: () {
                          _circleWindowController.hideInfoWindow!();

                          _customInfoWindowController.addInfoWindow!(
                              Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // plotsdevices.
                                            Text("FarmerName:${Devices[i]
                                                .farmername}",
                                              maxLines: 1,),
                                            Text("Device ID :${Devices[i]
                                                .farmlandDevices![j]
                                                .deviceid}"),
                                            Text("Device Name:${Devices[i]
                                                .farmlandDevices![j]
                                                .devicename.toString()}"),
                                            // Text("Device Type:${farmlanddevices.type.toString()}"),
                                            Text(LatLng(
                                              Devices[i].farmlandDevices![j]
                                                  .latitude ?? 0.00,
                                              Devices[i].farmlandDevices![j]
                                                  .longtitude ?? 0,)
                                                .toString())

                                          ],
                                        ),
                                      ),
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Triangle.isosceles(
                                    edge: Edge.BOTTOM,
                                    child: Container(
                                      color: Colors.white,
                                      width: 20.0,
                                      height: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                              LatLng(Devices[i].farmlandDevices![j].latitude ??
                                  0.00,
                                  Devices[i].farmlandDevices![j].longtitude ??
                                      0.00)
                          );
                        }

                    ));
                    // setState((){
                    //   gateway=LatLng(Devices[i].farmlandDevices![j].latitude??0.0, Devices[i].farmlandDevices![j].longtitude??0.0);
                    // });


                    circles.add(
                      Circle(circleId: CircleId(
                          "${Devices[i].farmlandDevices![j].deviceid}"),
                          visible: true,
                          // fillColor: Colors.green,
                          radius: 1000,
                          strokeWidth: 2,
                          consumeTapEvents: true,

                          center: LatLng(
                              Devices[i].farmlandDevices![j].latitude ?? 00,
                              Devices[i].farmlandDevices![j].longtitude ?? 0),
                          strokeColor: HexColor("#0bd6e0")),);
                    circles.add(
                        Circle(
                            circleId: CircleId("${Devices[i].farmlandDevices![j]
                                .deviceid}yellow"),
                            visible: true,
                            // fillColor: Colors.green,
                            radius: 1500,
                            strokeWidth: 2,
                            consumeTapEvents: true,

                            center: LatLng(
                                Devices[i].farmlandDevices![j].latitude ?? 00,
                                Devices[i].farmlandDevices![j].longtitude ?? 0),
                            strokeColor: Colors.yellow,
                            onTap: () {
                              {
                                _circleWindowController.addInfoWindow!(
                                    Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius
                                                  .circular(4),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                      "1500Meters From Gateway")

                                                ],
                                              ),
                                            ),
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                        Triangle.isosceles(
                                          edge: Edge.BOTTOM,
                                          child: Container(
                                            color: Colors.white,
                                            width: 20.0,
                                            height: 10.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ToSouthPosition(LatLng(
                                        Devices[i].farmlandDevices![j]
                                            .latitude ?? 0.00,
                                        Devices[i].farmlandDevices![j]
                                            .longtitude ?? 0.00), -1));
                              }
                            }

                        )
                    );
                    circles.add(
                      Circle(circleId: CircleId(
                          "${Devices[i].farmlandDevices![j].deviceid}blue"),
                          visible: true,
                          // fillColor: Colors.green,
                          radius: 2000,
                          strokeWidth: 2,
                          consumeTapEvents: true,

                          center: LatLng(
                              Devices[i].farmlandDevices![j].latitude ?? 00,
                              Devices[i].farmlandDevices![j].longtitude ?? 0),
                          strokeColor: Colors.blueAccent,

                          onTap: () {
                            _circleWindowController.addInfoWindow!(
                                Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Text("Farmer Name: ${Devices[i]
                                                  .farmername}", maxLines: 1,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  Container(
                                                    height: 15,
                                                    width: 15,
                                                    color: HexColor("#0bd6e0"),
                                                  ),
                                                  Text("1000 meters"),
                                                  // Text("(1 Km)"),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  Container(
                                                    height: 15,
                                                    width: 15,
                                                    color: Colors.yellow,
                                                  ),
                                                  // Spacer(),
                                                  Text("1500 meters"),
                                                  // Text("(1.5 Km)"),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  Container(
                                                    height: 15,
                                                    width: 15,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  Text("2000 meters"),
                                                  // Text("(2 Km)"),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Triangle.isosceles(
                                      edge: Edge.BOTTOM,
                                      child: Container(
                                        color: Colors.white,
                                        width: 20.0,
                                        height: 10.0,
                                      ),
                                    ),
                                  ],
                                ),
                                ToSouthPosition(LatLng(
                                    Devices[i].farmlandDevices![j].latitude ??
                                        0.00,
                                    Devices[i].farmlandDevices![j].longtitude ??
                                        0.00), 2));
                          }
                      ),

                    );
                  }
                }
              }
            }

            Devices.forEach((devices) {
              print("in side one ${devices}");
              print("farmland devices ${devices.farmerid == 982}");
              print(devices.farmlandDevices!.length);

              devices.farmlandDevices!.forEach((farmlanddevices) {
                print("mampk ${farmlanddevices.devicetype}");
                print(farmlanddevices.devicetype == "GWY");
                if (farmlanddevices.devicetype == "GWY") {
                  devices.plotDevices!.forEach((element) {
                    _polyline.add(Polyline(polylineId: PolylineId(
                        "polyline" + element.deviceid.toString()),
                        color: Colors.red,
                        visible: true,


                        width: 2,
                        consumeTapEvents: true,
                        points: PolilineLatlang(polilinglatlang: LatLng(
                            element.latitude ?? 0.00,
                            element.longtitude ?? 0.00),
                            gatewaylatlang: LatLng(
                                farmlanddevices.latitude ?? 0.0,
                                farmlanddevices.longtitude ?? 0.0)),
                        onTap: () {
                          _customInfoWindowController.hideInfoWindow!();
                          // _circleWindowController.hideInfoWindow!();
                          print("taped");
                          var distance = PolilineDistancebetween(
                              gatewaylat: LatLng(
                                  farmlanddevices.latitude ?? 0.0,
                                  farmlanddevices.longtitude ?? 0.0),
                              polyline: LatLng(element.latitude ?? 0.00,
                                  element.longtitude ?? 0.00));
                          _circleWindowController.addInfoWindow!(
                            Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          Text("Distance From Gateway"),
                                          Text("In meters: ${distance.meters!
                                              .toStringAsFixed(2)}"),
                                          Text("In Kilometers :${distance
                                              .kilometers!.toStringAsFixed(2)}")

                                        ],
                                      ),
                                    ),
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Triangle.isosceles(
                                  edge: Edge.BOTTOM,
                                  child: Container(
                                    color: Colors.white,
                                    width: 20.0,
                                    height: 10.0,
                                  ),
                                ),
                              ],
                            ),
                            LatLng(element.latitude ?? 0.00,
                                element.longtitude ?? 0.00),
                          );
                        }
                    ));
                  });
                }
              });
              devices.plotDevices!.forEach((plotdevices) {
                _markers.add(Marker(
                    markerId: MarkerId(plotdevices.deviceid.toString(),
                    ),
                    position: LatLng(plotdevices.latitude ?? 0.00,
                        plotdevices.longtitude ?? 0.00),
                    onTap: () {
                      _circleWindowController.hideInfoWindow!();
                      _customInfoWindowController.addInfoWindow!(
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // plotsdevices.
                                        Text("FarmerName:${devices.farmername}",
                                          maxLines: 1,),
                                        Text("Device ID :${plotdevices
                                            .deviceid}"),
                                        Text("Device Name:${plotdevices
                                            .devicename.toString()}",
                                          maxLines: 1,),
                                        // Text("Device Type:${farmlanddevices.type.toString()}"),
                                        Text(LatLng(
                                          plotdevices.latitude ?? 0.00,
                                          plotdevices.longtitude ?? 0,)
                                            .toString())

                                      ],
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Triangle.isosceles(
                                edge: Edge.BOTTOM,
                                child: Container(
                                  color: Colors.white,
                                  width: 20.0,
                                  height: 10.0,
                                ),
                              ),
                            ],
                          ),
                          LatLng(plotdevices.latitude ?? 0.00,
                              plotdevices.longtitude ?? 0.00)
                      );
                    }));
              });
            }
            );
          }
          else {
            Fluttertoast.showToast(msg: "No Data Found Contact Management");
          }
          _markers.addAll(_gatewaymarkers);
          if (_gatewaymarkers.length == 0) {

          };
        }
        else {
          Fluttertoast.showToast(
              msg: response['message'],
              backgroundColor: Colors.red
          );
        }
      }
      if (_markers.length > 0) {
        LatLngBounds centerlatlang = await getBounds(_markers);
        setState(() {
          mapController?.animateCamera(
              CameraUpdate.newLatLngBounds(centerlatlang, 50));
        });
      }

      // else {
      //   setState(() {
      //     mapController?.animateCamera(CameraUpdate.newLatLng(Devicelatlang!));
      //   });
      // }
    }
    catch(e){
      Fluttertoast.showToast(
          msg: 'Cannot get requested data, please try later: ${e.toString()}');
      print("error ios :"+e.toString());
      print("catch error is :${e}");
    }

    // print("telematric details :${telematicDataList.}")
    return Devices;
  }
  Future getdata(phonenumber) async {

    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    var path="";
             if(val==1){
            path=   'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/service/profile/farmerdevicesdata/${phonenumber}';
             }
             else if(val==2){
               path=   'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/service/profile/feeldofficerdata/91${phonenumber}';
             }
             else if(val==3){
               path=   'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/service/profile/fieldmanager/91${phonenumber}';
             }
            else{
               path=   'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/service/profile/clintdevicedata/${dropdownvalue!.clintId}';
             }

    // print(path);
    final dio = Dio();
    Map<String, dynamic> returnData = {};
    try {
      final response =
      await dio.get(path,  options: Options(headers: header),queryParameters: {});
      if (response.statusCode == 200) {
        returnData = response.data;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Cannot get requested data, please try later: ${e.toString()}');
      // print("error ios :"+e.toString());
    }
    return returnData;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Form(
                  // key: _key,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                                        height: MediaQuery.of(context).size.height/19,
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                                        child:Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children:[
                                              Text(
                                                "Farmer",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(10 ,192 ,92,2),
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                " Device Location",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ] )
                                    ),
                                    
                               Container(
                                 margin: EdgeInsets.only(left: 10),
                                 height: 20,
                                 child:  Row(
                                   children: [
                                     Container(
                                       margin: EdgeInsets.only(left: 5),
                                       width: 7,
                                       child:
                                       Radio(
                                         value: 1,
                                         groupValue: val,
                                         onChanged: (value) {
                                           setState(() {
                                             val = int.parse(value.toString());
                                           });
                                         },
                                         activeColor: Colors.green,
                                       ),),
                                     Padding(padding: EdgeInsets.only(left: 5)),
                                     Text("Farmer",style: TextStyle(fontSize: 12),),

                                     Container(
                                         margin: EdgeInsets.only(left: 8),
                                         width: 7,
                                         child:
                                         Radio(
                                           value: 2,
                                           groupValue: val,
                                           onChanged: (value) {
                                             setState(() {
                                               val = int.parse(value.toString());
                                             });
                                           },
                                           activeColor: Colors.green,
                                         )),
                                     Padding(padding: EdgeInsets.only(left: 10)),
                                     Text("Field Officer ",style: TextStyle(fontSize: 12),),
                                     Container(
                                       margin: EdgeInsets.only(left: 5),
                                       width: 7,
                                       child:
                                       Radio(
                                         value: 3,
                                         groupValue: val,
                                         onChanged: (value) {
                                           setState(() {
                                             val = int.parse(value.toString());
                                           });
                                         },
                                         activeColor: Colors.green,
                                       ),
                                     ),
                                     Padding(padding: EdgeInsets.only(left: 8)),
                                     Text("Field Manager ",style: TextStyle(fontSize: 12),),

                                     Container(
                                       margin: EdgeInsets.only(left: 8),
                                       width: 7,
                                       child:
                                       Radio(
                                         value: 4,
                                         groupValue: val,
                                         onChanged: (value) {
                                                 if(clintlistloading==false) {
                                                   setState(() {
                                                     val = int.parse(
                                                         value.toString());
                                                   });
                                                 }
                                                 else{
                                                   Fluttertoast.showToast(
                                                     msg:"Client details is loading" ,
                                                     textColor: Colors.red,
                                                     backgroundColor: Colors.white
                                                   );
                                                 }
                                         },
                                         activeColor: Colors.green,
                                       ),
                                     ),
                                     Padding(padding: EdgeInsets.only(left: 10)),
                                     val==4 && clintlistloading==false?

                                    Container(
                                      height: 20,
                                      child:  DropdownButton(
                                        underline: SizedBox(),
                                        // Initial Value
                                        style: TextStyle(fontSize: 12,color: Colors.black),
                                        hint: Text(Dropdownname),
                                        // value:dropdownvalue==null?"chouse value":dropdownvalue!.clintName,

                                        // Down Arrow Icon
                                        icon: const Icon(Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: returnData.map((ClintsList items) {
                                          // value=
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items.clintName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          // print(dropdownvalue!.clintName);
                                          for(var z in returnData){
                                            if(newValue==z){
                                              setState(() {

                                                dropdownvalue = ClintsList(clintId: z?.clintId,clintName: z?.clintName);
                                                Dropdownname=dropdownvalue!.clintName.toString();
                                              });                                            }
                                          }
                                          bool containvalue=returnData.contains(newValue);
                                          print("contain value ${containvalue}");
                                          var selectedvalue=newValue;

                                        },
                                        // value: dropdownvalue.,
                                      ),
                                    ):Text("Client"),

                                   ],
                                 ),
                               ),
                                     Row(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height/12,
                                            width: MediaQuery.of(context).size.width/1.4,
                                            padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              controller: fnumber,
                                              decoration: InputDecoration(
                                                labelText: val==1?'Farmer Mobile number':val==2?"FieldOfficer Mobile number":"FieldManager Mobile number",
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
                                             if(val==4){}
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
                                          InkWell(
                                            child: Center(
                                              child: Container(
                                                color: Colors.blueAccent,
                                                height: MediaQuery.of(context).size.height/25,
                                                width: 70,
                                                child:Center(
                                                  child:  Text("Search"),
                                                ),
                                              ),
                                            ),
                                          onTap: (){
                                              _circleWindowController.hideInfoWindow!();
                                              _customInfoWindowController.hideInfoWindow!();
                                         if(val==4){
                                           if(dropdownvalue!.clintId==null){
                                             Fluttertoast.showToast(
                                            msg: "Please select Client",
                                               backgroundColor: Colors.red,
                                               textColor: Colors.black
                                             );
                                           }
                                           else {
                                             getTelematics();
                                           }
                                         }
                                         else{
                                           if(fnumber.text.length >=10) {
                                             getTelematics();
                                           }
                                           else{
                                             Fluttertoast.showToast(
                                                 msg: "Enter 10 digits valid phone number",
                                                 backgroundColor: Colors.red
                                             );
                                           }
                                         }
                                          },
                                          )
                                        ]
                                    )
                                  ]
                              )
                          ),
        Container(
            height: MediaQuery.of(context).size.height/1.5,
            width: double.infinity,
            margin: EdgeInsets.all(10),
            // color: Colors.red,
            child:clintlistloading && is_loading  ?Center(child: CircularProgressIndicator(),): Stack(
              children: <Widget>[
                GoogleMap(
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                    _circleWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                    _circleWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    mapController=controller;
                    _customInfoWindowController.googleMapController = controller;
                    _circleWindowController.googleMapController=controller;
                  },
                  myLocationEnabled: true,
                  markers: Set.from(_markers),
                  polylines:Set.from(_polyline) ,
                  circles: Set.from(circles),
                  initialCameraPosition: CameraPosition(
                    target: _latLng,
                    zoom: _zoom,
                  ),
                ),
                CustomInfoWindow(
                  controller: _circleWindowController,
                  height: 100,
                  width: 200,
                  offset: 50,
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 100,
                  width: 250,
                  offset: 50,
                ),
              ],
            ),)
                        ]
                    )
                )
            )
        )
    );
  }
  LatLngBounds getBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }
}
