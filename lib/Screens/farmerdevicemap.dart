
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import '/models/adddevices_Devicemap.dart';
class FarmerDeviceMap extends StatefulWidget {
  const FarmerDeviceMap({Key? key}) : super(key: key);

  @override
  State<FarmerDeviceMap> createState() => _FarmerDeviceMapState();
}

class _FarmerDeviceMapState extends State<FarmerDeviceMap> {
  Color gateway_location_color = Colors.red;
  Set<Circle> circles={};
  List<Marker> _markers = [];
  List<Marker>_gatewaymarkers=[];
  Location currentLocation = Location();
  LatLng? _latLng;
  bool is_loading=false;
   LatLng  Devicelatlang =LatLng(0.00, 0.00);
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  CustomInfoWindowController _circleWindowController=CustomInfoWindowController();
 List<LatLng> locationslist=[];
  GoogleMapController? mapcontroller;

 getlivelocation()async{
    setState((){
      is_loading=true;
    });

    currentLocation.onLocationChanged.listen((LocationData loc) async {
      if (mounted) {
        _latLng = await LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0);
        // setState(() {

        setState(() {
          locationslist.add(_latLng!);
          is_loading = false;
        });


        print("latlang is $_latLng");
      }
    }
    );

  }
  Future<LatLng> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    // debugPrint('location: ${position.latitude} ${position.longitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    return LatLng(position.latitude, position.longitude);

  }

  @override
  void initState() {
    getlivelocation();
    // TODO: implement initState
    super.initState();
  }
  bool updatecontroller=false;
  List<DeviceList> DeviceListdetails=[];
  ToSouthPosition(LatLng center, double southDistance)
  {
    double r_earth = 6378;
    // var pi = Math.PI;
    var new_latitude = center.latitude - (southDistance / r_earth) * (180 / pi);
    return  LatLng(new_latitude, center.longitude);
  }
  Completer<GoogleMapController> _controller = Completer();

  // on below line we are specifying our camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(37.42796133580664, -122.885749655962),
    zoom: 14.4746,
  );

  Future<void> animateTo(double lat, double lng) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }
  @override
  Widget build(BuildContext context) {
    var height =MediaQuery.of(context).size.height;
    var appbarhight=AppBar().preferredSize.height;;
    print("height ${height} appbarhight ${appbarhight}");
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            color: Colors.black,
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title:  Image.asset(
          'assets/images/cultyvate.png',
          height: 50,
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
child: Column(

  children: [
    SizedBox(
      height: 100,
    ),
  ListView.builder(
    shrinkWrap: true,
      itemCount: DeviceListdetails.length,
      itemBuilder: (BuildContext context,int index){
        var indexnumer=index+1;
    return DeviceListdetails.length >0? Row(
      children: [
        DeviceListdetails[index].isgatewaytype! ?Container(
            width: 45,
            child: Image.asset("assets/images/gatewaylocationmarker.png")) : Container(
          width: 45,child: Image.asset("assets/images/normaldevicelocation.png" ),

        ),
        Text(indexnumer.toString(),textAlign: TextAlign.start,),
        SizedBox(width: 10,),
        Text(DeviceListdetails.length>0 ?DeviceListdetails[index].farmername.toString():"",textAlign: TextAlign.start),
     Spacer(),
        InkWell(
          child: Icon(Icons.edit),
          onTap: (){
            bool editgatewaytype=DeviceListdetails[index].isgatewaytype!;
            TextEditingController editcontroller=TextEditingController();
            setState(() {
              editcontroller.text=DeviceListdetails[index].farmername.toString();
            });
            try{
              showDialog(
                  context: context,
                  builder: (BuildContext context)
                  {

                    return StatefulBuilder(builder: (context, setState) {
                      return SimpleDialog(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text("Farmer Name :"),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/12,
                              width: MediaQuery.of(context).size.width/1.4,
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: editcontroller,
                                decoration: InputDecoration(
                                  // labelText: val==1?'Farmer Mobile number':val==2?"FieldOfficer Mobile number":"FieldManager Mobile number",
                                  border: OutlineInputBorder(),
                                  counter: Offstage(),
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 15,
                                // inputFormatters: [FilteringTextInputFormatter.],

                              ),
                            ),
                            ListTile(
                              title: Text("Farmer Location"),
                              trailing:  InkWell(
                                  child: Padding(padding: EdgeInsets.only(top: 13,right: 5),child: ColorFiltered(
                                    child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                    colorFilter:  ColorFilter.mode(gateway_location_color, BlendMode.color),
                                  ),),
                                  onTap: () async {
                                    LatLng devicelocation = await _getLocation();
                                    setState((){
                                      Devicelatlang= devicelocation;
                                    });

                                  }
                              ),
                            ),

                            Padding(padding: EdgeInsets.only(left: 20),child: Text("Latitude :${Devicelatlang.latitude}",style: TextStyle(fontSize: 15),),),
                            Padding(padding: EdgeInsets.only(left: 20,bottom: 10),child: Text("Longitude:${Devicelatlang.longitude}",style: TextStyle(fontSize: 15),),),


                            ListTile(
                              leading:Checkbox(
                                value:DeviceListdetails.length>0 ? editgatewaytype:false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    editgatewaytype= value!;
                                  });
                                },
                              ), //Ch ,
                              title: Text("Gateway"),
                              trailing: TextButton(child: Text("Delete"),onPressed: (){
                                var toRemove = [];
                                setState((){
                                  _markers.forEach((element) {
                                    print("element is");
                                    if(DeviceListdetails[index].deviceLatlang==element.position) {
                                      try {
                                        setState(() {
                                          toRemove.add(element);
                                        });
                                      } catch (e) {
                                        print("error is $e");
                                      }
                                    }
                                  });
                                });
                                setState((){

                                  _markers.removeWhere((remove) =>toRemove.contains(remove) );
                                  DeviceListdetails.removeAt(index);
                                });
                                Navigator.pop(context);
                              }),
                            ),
                            TextButton(onPressed: (){
                              DeviceListdetails[index].farmername=editcontroller.text;
                              if(editgatewaytype !=DeviceListdetails[index].isgatewaytype) {
                                _markers.forEach((marker) {
                                  if(DeviceListdetails[index].deviceLatlang==marker.position){
                                    setState((){
                                      marker.icon!=editgatewaytype? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed):BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
                                      DeviceListdetails[index].isgatewaytype=editgatewaytype;
                                    });

                                  }
                                });
                              }
                              Navigator.of(context).pop();
                              // DeviceListdetails[index].isgatewaytype=
                            }, child: Text("Update"))

                          ]);
                    }
                    );

                  }).then((value) {
                _markers.clear();
                circles.clear();
                int devicelist = 0;
                DeviceListdetails.forEach((element) {
                  setState(() {
                    devicelist++;
                    if (element.isgatewaytype!) {
                      _markers.add(Marker(
                          markerId: MarkerId('${element.farmername}+${devicelist}'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          position: element.deviceLatlang!,
                          onTap: (){
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
                                              Text("FarmerName:${element.farmername}",
                                                maxLines: 1,),
                                              Text("Is Gateway :${element.isgatewaytype}"),
                                              // Text("Device Type:${farmlanddevices.type.toString()}"),
                                              Text(LatLng(
                                                element.deviceLatlang?.latitude ?? 0.00,
                                                element.deviceLatlang?.longitude ?? 0.00,)
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
                                element.deviceLatlang!
                            );
                          }
                      )

                      );
                      circles.add(
                        Circle(circleId: CircleId('${element.farmername}+${devicelist}'),
                            visible: true,
                            // fillColor: Colors.green,
                            radius: 1000,
                            strokeWidth: 2,
                            consumeTapEvents: true,

                            center: element.deviceLatlang!,
                            strokeColor: HexColor("#0bd6e0"),
                            onTap: (){
                              _customInfoWindowController.hideInfoWindow!();
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
                                                Text("1500Meters From Gateway")

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
                                      element.deviceLatlang!.latitude ?? 0.00,
                                      element.deviceLatlang!.longitude  ?? 0.00), -1));
                            }
                        ),
                      );
                      circles.add(
                          Circle(
                              circleId: CircleId(
                                  "'${element.farmername}+${devicelist}'yellow"),
                              visible: true,
                              // fillColor: Colors.green,
                              radius: 1500,
                              strokeWidth: 2,
                              consumeTapEvents: true,

                              center: element.deviceLatlang!,
                              strokeColor: Colors.yellow,
                              onTap: () {
                                _customInfoWindowController.hideInfoWindow!();
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
                                                  Text("Farmer Name: ${element.farmername}",maxLines: 1,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        element.deviceLatlang!.latitude ?? 0.00,
                                        element.deviceLatlang!.longitude ?? 0.00), 2));
                              }


                          )
                      );
                      circles.add(
                        Circle(
                            circleId: CircleId("${element.farmername}+${devicelist}blue"),
                            visible: true,
                            // fillColor: Colors.green,
                            radius: 2000,
                            strokeWidth: 2,
                            consumeTapEvents: true,

                            center: element.deviceLatlang!,
                            strokeColor: Colors.blueAccent,

                            onTap: () {
                              _customInfoWindowController.hideInfoWindow!();
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
                                                Text("Farmer Name: ${element.farmername}",maxLines: 1,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      element.deviceLatlang!.latitude ?? 0.00,
                                      element.deviceLatlang!.longitude ?? 0.00), 2));

                            }
                        ),

                      );
                    }
                    else {
                      _markers.add(Marker(
                          markerId: MarkerId(
                              '${element
                                  .farmername}+${devicelist}'),
                          position: element
                              .deviceLatlang!,
                          visible: true,
                          consumeTapEvents: true,

                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen),
                          onTap: (){
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
                                              Text("FarmerName:${element.farmername}",
                                                maxLines: 1,),
                                              Text("Is Gateway :${element.isgatewaytype}"),
                                              // Text("Device Type:${farmlanddevices.type.toString()}"),
                                              Text(LatLng(
                                                element.deviceLatlang?.latitude ?? 0.00,
                                                element.deviceLatlang?.longitude ?? 0.00,)
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
                                element.deviceLatlang!
                            );
                          }
                      ),

                      );
                    }
                  });
                });
              });
            }catch(e)
            {
              print(e);
            }
          },
        ),
        Padding(padding: EdgeInsets.only(right: 25))
      ],
    )

        :SizedBox();


  })
  ],
),
        // backgroundColor: Colors.black,
      ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Form(
                  // key: _key,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child:updatecontroller?Center(
                      child: CircularProgressIndicator(),
                    ): Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // height: MediaQuery.of(context).size.height/20,
                              child:Column(
                                  children: [

                                    Container(
                                        height: 50,
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
                                                " Device Map",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ] )
                                    ),


                                          Container(
                                            height: 50,
                                              child: TextButton(
                                                  child: Text("Add devices"),
                                                  onPressed: (){
                                                    bool checkbox=false;
                                                    bool errormessage=false;
                                                    String message='';
                                                    TextEditingController farmername=new TextEditingController();
                                                    setState(() {
                                                      Devicelatlang=LatLng(0.0, 0.0);
                                                    });
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return StatefulBuilder(builder: (context,setState){
                                                          return SimpleDialog(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: Text("Farmer Name:"),
                                                              ),
                                                              Container(

                                                                height: MediaQuery.of(context).size.height/12,
                                                                width: MediaQuery.of(context).size.width/1.4,

                                                                padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                                                child: TextFormField(
                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                  controller: farmername,
                                                                  decoration: InputDecoration(
                                                                    // labelText: val==1?'Farmer Mobile number':val==2?"FieldOfficer Mobile number":"FieldManager Mobile number",
                                                                    border: OutlineInputBorder(),
                                                                    counter: Offstage(),
                                                                  ),
                                                                  keyboardType: TextInputType.text,
                                                                  maxLength: 15,
                                                                  // inputFormatters: [FilteringTextInputFormatter.],

                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text("Farmer Location"),
                                                                trailing:  InkWell(
                                                                    child: Padding(padding: EdgeInsets.only(top: 13,right: 5),child: ColorFiltered(
                                                                      child: Image.asset("assets/images/locationping.jpg" ,height: 20,),
                                                                      colorFilter:  ColorFilter.mode(gateway_location_color, BlendMode.color),
                                                                    ),),
                                                                    onTap: () async {
                                                                      LatLng devicelocation = await _getLocation();
                                                                      setState((){
                                                                        errormessage=false;
                                                                        Devicelatlang= devicelocation;
                                                                      });

                                                                    }
                                                                ),
                                                              ),
                                                                Padding(
                                                                padding: const EdgeInsets.only(left: 20,bottom: 10),child:  Text("Latitude :${Devicelatlang.latitude}",style: TextStyle(fontSize: 15),)),
                                                          Padding(
                                                          padding: const EdgeInsets.only(left: 20),child:Text("Longitude :${Devicelatlang.longitude}",style: TextStyle(fontSize: 15),)),

                                                              ListTile(
                                                                leading:Checkbox(
                                                                  value:checkbox,
                                                                  onChanged: (bool? value) {
                                                                    setState(() {
                                                                      checkbox= value!;
                                                                    });
                                                                  },
                                                                ), //Ch ,
                                                                title: Text("Gateway"),
                                                              ),
                                                              TextButton(onPressed: ()async{
                                                               if(Devicelatlang==LatLng(0.0, 0.0)){
                                                               setState((){
                                                                 errormessage=true;
                                                                 message="Please click on location icon";
                                                               });
                                                               }
                                                               else{
                                                                 if(farmername.text.length>0){
                                                                   var contain = DeviceListdetails.where((cont) => cont.deviceLatlang == Devicelatlang);
                                                                   print("contain ${contain.isNotEmpty}");
                                                                   if(contain.isNotEmpty){
                                                                     setState((){
                                                                       errormessage=true;
                                                                       message="Already this Latlang used other device";
                                                                     });

                                                                   }
                                                                   else {
                                                                     setState(() {
                                                                       try {
                                                                         DeviceListdetails
                                                                             .add(
                                                                             DeviceList(
                                                                               farmername: farmername
                                                                                   .text,
                                                                               deviceLatlang: Devicelatlang,
                                                                               isgatewaytype: checkbox,
                                                                             ));
                                                                       }
                                                                       catch (e) {
                                                                         print(
                                                                             "error is $e");
                                                                       }
                                                                       locationslist.add(Devicelatlang);

                                                                     });
                                                                     if(_markers.length>1) {
                                                                       LatLngBounds centerlatlang = await getBounds(_markers);
                                                                       setState(() {
                                                                         mapcontroller?.animateCamera(CameraUpdate.newLatLngBounds(centerlatlang, 50));
                                                                       });
                                                                       Navigator.pop(context);
                                                                     }
                                                                     else{
                                                                       setState(() {
                                                                         mapcontroller?.animateCamera(CameraUpdate.newLatLng(Devicelatlang!));
                                                                       });
                                                                       Navigator.pop(context);
                                                                     }


                                                                   }
                                                                 }
                                                                 else{
                                                                   setState((){
                                                                     errormessage=true;
                                                                     message="Enter FarmerName";
                                                                   });
                                                                 }
                                                               }
                                                              }, child: Text("Add to list")),
                                                              Visibility(

                                                                  child: Padding(padding: EdgeInsets.only(left: 20),
                                                                    child: Text(message,style: TextStyle(color: Colors.red),),

                                                                  ),
                                                              visible: errormessage,
                                                              ),
                                                            ],
                                                          );
                                                        });



                                                      },
                                                    ).then((value)async{
                                                      final Uint8List customMarker= await getBytesFromAsset(
                                                        path:"assets/images/gatewaymarker.png", //paste the custom image path
                                                        width: 80 ,

                                                        // size of custom image as marker
                                                      );
                                                      int devicelist=0;
                                                      DeviceListdetails.forEach((element) {
                                                        setState(() {
                                                          devicelist++;
                                                          if(element.isgatewaytype!){
                                                            _markers.add(Marker(markerId: MarkerId( '${element.farmername}+${devicelist}'),
                                                             icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                                                              position: element.deviceLatlang!,
                                                              onTap: (){
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
                                                                                  Text("FarmerName:${element.farmername}",
                                                                                    maxLines: 1,),
                                                                                  Text("Is Gateway :${element.isgatewaytype}"),
                                                                                  // Text("Device Type:${farmlanddevices.type.toString()}"),
                                                                                  Text(LatLng(
                                                                                    element.deviceLatlang?.latitude ?? 0.00,
                                                                                    element.deviceLatlang?.longitude ?? 0.00,)
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
                                                                    element.deviceLatlang!
                                                                );
                                                              }
                                                            ));
                                                            circles.add(
                                                              Circle(circleId: CircleId('${element.farmername}+${devicelist}'),
                                                                  visible: true,
                                                                  // fillColor: Colors.green,
                                                                  radius: 1000,
                                                                  strokeWidth: 2,
                                                                  consumeTapEvents: true,

                                                                  center: element.deviceLatlang!,
                                                                  strokeColor: HexColor("#0bd6e0"),
                                                              onTap: (){
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
                                                                                  Text("Farmer Name: ${element.farmername}",maxLines: 1,),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                                       element.deviceLatlang!.latitude ?? 0.00,
                                                                        element.deviceLatlang!.longitude ?? 0.00), 2));
                                                              }
                                                              ),);
                                                            circles.add(
                                                                Circle(
                                                                    circleId: CircleId("'${element.farmername}+${devicelist}'yellow"),
                                                                    visible: true,
                                                                    // fillColor: Colors.green,
                                                                    radius: 1500,
                                                                    strokeWidth: 2,
                                                                    consumeTapEvents: true,

                                                                    center:element.deviceLatlang!,
                                                                    strokeColor:Colors.yellow,
                                                                    onTap: () {
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
                                                                                        Text("Farmer Name: ${element.farmername}",maxLines: 1,),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                                              element.deviceLatlang!.latitude ?? 0.00,
                                                                              element.deviceLatlang!.longitude ?? 0.00), 2));

                                                                    }

                                                                )
                                                            );
                                                            circles.add(
                                                              Circle(circleId: CircleId("${element.farmername}+${devicelist}blue"),
                                                                  visible: true,
                                                                  // fillColor: Colors.green,
                                                                  radius: 2000,
                                                                  strokeWidth: 2,
                                                                  consumeTapEvents: true,

                                                                  center: element.deviceLatlang!,
                                                                  strokeColor:Colors.blueAccent,

                                                                  onTap: (){

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
                                                                                      Text("Farmer Name: ${element.farmername}",maxLines: 1,),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                                            element.deviceLatlang!.latitude ?? 0.00,
                                                                            element.deviceLatlang!.longitude ?? 0.00), 2));
                                                              }
                                                              ),

                                                            );
                                                          }
                                                          else {
                                                            _markers.add(Marker(
                                                              markerId: MarkerId(
                                                                  '${element
                                                                      .farmername}+${devicelist}'),
                                                              position: element
                                                                  .deviceLatlang!,
                                                              icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                                                              onTap: (){    _customInfoWindowController.addInfoWindow!(
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
                                                                                Text("FarmerName:${element.farmername}",
                                                                                  maxLines: 1,),
                                                                                Text("Is Gateway :${element.isgatewaytype}"),
                                                                                // Text("Device Type:${farmlanddevices.type.toString()}"),
                                                                                Text(LatLng(
                                                                                  element.deviceLatlang?.latitude ?? 0.00,
                                                                                  element.deviceLatlang?.longitude ?? 0.00,)
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
                                                                  element.deviceLatlang!
                                                              );}
                                                            ));
                                                          }
                                                        });
                                                      });
                                                    });
                                                  }
                                              )

                                          ),




                                  ]
                              )
                          ),
                          Container(
                            height: height-(appbarhight+155),
                            // width: double.infinity,
                            margin: EdgeInsets.all(10),
                            // color: Colors.red,
                            child: is_loading?Center(child: CircularProgressIndicator(),): Stack(
                              children: <Widget>[
                                GoogleMap(
                                  zoomControlsEnabled: true,
                                  zoomGesturesEnabled: true,
                                  scrollGesturesEnabled: true,
                                  compassEnabled: true,

                                  onTap: (position) {
                                    _customInfoWindowController.hideInfoWindow!();
                                    _circleWindowController.hideInfoWindow!();
                                  },
                                  onCameraMove: (position) {
                                    _customInfoWindowController.onCameraMove!();
                                    _circleWindowController.onCameraMove!();
                                  },
                                initialCameraPosition: CameraPosition( //innital position in map
                                  target: _latLng!, //initial position
                                  zoom: 14.0, //initial zoom level
                                ),

                                  onMapCreated: (GoogleMapController controller) async {

                                    // _controller.complete(controller);
                                    // // GoogleMapController controller = await _controller.future;
                                    // controller.animateCamera(CameraUpdate.newLatLng(
                                    //   // on below line we have given positions of Location 5
                                    //    _latLng!
                                    // ));
                                    setState(() {
                                      mapcontroller=controller!;
                                    });
                                    _customInfoWindowController.googleMapController = controller;
                                    _circleWindowController.googleMapController=controller;
                                  },
                                  myLocationEnabled: true,
                                  markers: Set.from(_markers),
                                  // polylines:Set.from(_polyline) ,
                                  circles: Set.from(circles),
                              padding: EdgeInsets.only(
                                  bottom:MediaQuery.of(context).size.height*0.25),

                                ),
                                CustomInfoWindow(
                                  controller: _customInfoWindowController,
                                  height: 100,
                                  width: 250,
                                  offset: 50,
                                ),
                                CustomInfoWindow(
                                  controller: _circleWindowController,
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

  // return new LatLng(centralLatitude * (180/pi), centralLongitude * (180/pi));
  // }

  static LatLngBounds getLatLngBounds(List<LatLng> list) {
   late double x0, x1, y0, y1;
    for (final latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
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
}
