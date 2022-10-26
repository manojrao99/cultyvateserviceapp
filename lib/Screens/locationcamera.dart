
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resize/resize.dart';
import '/Screens/Farmeraccasation.dart';
import '/models/Utility.dart';
import 'package:screenshot/screenshot.dart';
class LocationCamera extends StatefulWidget {
  int Farmerid;
  int FieldofficerId;
  String ?from;
  int FieldmanagerID;
   LocationCamera({this.from,required this.Farmerid,required this.FieldmanagerID,required this.FieldofficerId});

  @override
  State<LocationCamera> createState() => _LocationCameraState();
}

class _LocationCameraState extends State<LocationCamera>  with TickerProviderStateMixin {
  CameraController? controller;
  XFile? capturedFile;
  Location ?location;
  LocationData ?mylocation;
  bool preview=false;
  bool clickcapture=false;
  GoogleMapController ?mapController;
  Uint8List ? ai ;
  ScreenshotController screenshotController = ScreenshotController();
  double _zoom=15;  String shortaddress = '', mainadress = '', clickdate = '';
  List ?cameras;
  static CameraPosition ?initialcameraposition;
  bool isPrecessing=false;
  bool is_loading=false;
  bool caapthured=false;
  Uint8List? capturedimage;
FlashMode ?falsh;
bool flash=false;
  int ?selectedCameraIdx;
  @override
  void initState() {
    myloc1();
    super.initState();

    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras!.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras?[selectedCameraIdx??0]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }
  Future _initCameraController(CameraDescription cameraDescription) async {
    setState(() {
      isPrecessing = true;
    });
    if (controller != null) {
      await controller?.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller?.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        print('Camera error ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller?.initialize();
    } on CameraException catch (e) {
      // _showCameraException(e);
    }

    if (mounted) {
      setState(() {
        isPrecessing = false;
      });
    }
  }
  Future Postdata(phonenumberone) async {
    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    var  path = 'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/Imagepost/post';
    // var  path= 'http://192.168.1.10:8085/api/farm2fork/Imagepost/post';
    print(path);
    final dio = Dio();
    Map<String, dynamic> returnData = {};
    try {
      final response =
      await dio.post(path,  data: phonenumberone,options: Options(headers: header),queryParameters: {});
      print("responcasklfme ${response.data}");
      if (response.statusCode == 200) {
        if(widget.from=='Farmeraccasation'){
          setState(() {
            print('manoj'+response.data['data'][0]['ImageNV']);
            FarmeracusationState.instance!.imagesid.add(response.data['data'][0]['ID'].toString());
          String image=response.data['data'][0]['ImageNV'];
         FarmeracusationState.instance!.images.add(base64.decode(image));
          });
        }
        print(response.data);
         Fluttertoast.showToast(
             backgroundColor: Colors.green,
             textColor: Colors.black,
             msg:"Image Upload successfully");
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

  void _onSwitchCamera() async {
    selectedCameraIdx =
    selectedCameraIdx! < cameras!.length - 1 ? selectedCameraIdx! + 1 : 0;
    CameraDescription selectedCamera = cameras?[selectedCameraIdx??0];

    await _initCameraController(selectedCamera);
    setState(() {
      // isPreView = false;
    });
  }
  Future<Widget> imagewithlocation(ctx,File _image, File map) async {
    return Stack(
        children: [
          Image.file(
            _image,
            height: MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 5,
            child: Row(
              children: [
                Column(
                  children: [
                    Container(

                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 2,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(ctx).size.width * 0.28,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.file(
                            map,
                            fit: BoxFit.fill,
                          ),
                        ),
                    height: 150,
                    )
                  ],
                ),
                 Container(
                 height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.grey,
                        ),
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shortaddress,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16)),
                        Text(mainadress,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 12,
                            )),
                        Text(
                            'Lat "${mylocation?.latitude}" Long "${mylocation?.longitude}"',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontSize: 12,
                            )),
                        Text(
                            '${DateFormat('EEEE, d MMM, yyyy, h:mm:ss a').format(DateTime.now())}',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontSize: 12,
                            )),
                      ],
                    ),

                ),
              ],
            ),
          ),
        ],
      );

  }
  Widget _cameraTogglesRowWidget(BuildContext ctx) {
    if (cameras == null || cameras!.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras?[selectedCameraIdx??0];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        preview==false?  ElevatedButton.icon(
            onPressed: isPrecessing
                ? null
                : () {
              _onSwitchCamera();
            },
            icon: Icon(
              _getCameraLensIcon(lensDirection),
              size: 35,
            ),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}"),
          ):
        ElevatedButton.icon(
            onPressed: isPrecessing
                ? null
                : ()async {
              var  dataone=  {
                "farmerID":widget.Farmerid==0?null:widget.Farmerid,
                "FieldOfficerID":widget.FieldofficerId==0?null:widget.FieldofficerId,
                "FieldmanagerID":widget.FieldmanagerID ==0?null:widget.FieldmanagerID,
                "image":null,
                "imagenv":base64Url.encode(capturedimage!),
                "Latitude":mylocation!.latitude,
                "Longtitude":mylocation!.longitude,
              };
                await  Postdata(dataone);

            },
            icon: Icon(
              Icons.save,
              size: 35,
            ),
            label: Text('Save'),
          ),
          // Spacer(),
          ElevatedButton.icon(
            onPressed: isPrecessing
                ? null
                : ()async {
              if(!preview) {
                capturedFile = await controller!.takePicture();
                setState((){
                  clickcapture=true;
                  caapthured=true;
                  // isPrecessing=true;
                });
                ai = await mapController!.takeSnapshot();
                clickdate = '${DateFormat('d-M-y').format(DateTime.now())}';
                final ai1 = await File("${capturedFile!.path}2").create();
                final file = File(capturedFile!.path);

                String imgString = Utility.base64String(file.readAsBytesSync());
                print("imaeg $imgString");
                await ai1.writeAsBytes(ai!);
                final image1 = await screenshotController.captureFromWidget(
                    await imagewithlocation(context, File(capturedFile!.path), ai1),
                    delay: Duration(seconds: 2));
                setState(() {
                  capturedimage = image1;
                  caapthured = false;
                  clickcapture=false;
                  preview = true;
                  // isPrecessing=false;


                });
                // Navigator.of(context).pop();
              }
              else{
                setState(() {
                  preview=!preview;
                });
              }
            },
            icon: Icon(
              preview?Icons.camera:Icons.save,
              size: 35,
            ),
            label:preview? Text('Recapture'):Text("capture"),
          ),
        ],
      ),
    );
  }
  Future<bool> myloc1() async {
    ServiceStatus permission;
    permission = await Permission.location.serviceStatus;
    print(permission.isEnabled);
    if (permission.isEnabled) {
      // cam();
      var permission = await Permission.location.isGranted;
      print("${permission} permission");
      if (!permission) {
        await Permission.location.request();
        myloc1();
      } else {
        mylocation = await Location.instance.getLocation();
        print(mylocation);
        initialcameraposition = await CameraPosition(
          target: LatLng(mylocation!.latitude!.roundToDouble(), mylocation!.longitude!.roundToDouble()),
          zoom: 15.5,
        );
        print("indial camera $initialcameraposition");
        final coordinates =
        new Coordinates(mylocation!.latitude, mylocation!.longitude);
        var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        print(
            ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
        // return first;
        setState(() {
          shortaddress =
          '${first.subLocality}, ${first.locality},${first.countryName}';
          mainadress = '${first.addressLine}';
        });
      }
    } else {
      await Location().requestService();
      if (permission.isEnabled) {
        myloc1();
      }
      // else {
      //   Navigator.pop(context);
      // }
    }
    return true;
  }
  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Resize(
        allowtextScaling: true,
        builder: ()
    {
      return isPrecessing ? Center(child: CircularProgressIndicator(),)
          : Material(
            child: SingleChildScrollView(
        child: Container(
            child:clickcapture?Center(
              child: CircularProgressIndicator(),
            ) :Column(
              // alignment: ,
              children: [

                preview?Image.memory(capturedimage!):
                CameraPreview(controller!,
                    child: Stack(
                      children: [
                        Positioned(
                          top:30,
                            left: 15,
                            
                            child: InkWell(
                                    onTap: ()async{
                                      setState(() {
                                        flash=!flash;

                                      print("flashmode ${FlashMode.always}");
                                      });
                                     await flash? controller?.setFlashMode(FlashMode.always):controller?.setFlashMode(FlashMode.off);
                                    },
                              child: Icon(flash?Icons.flash_auto:Icons.flash_off,color: Colors.white,),
                            ),),
                        Positioned(
                          bottom: 5,
                          child: Row(
                            children: [
                              Container(
                                  height: 20.vh,
                                  width: 40.vw,
                                  color: Colors.grey,

                                  child: is_loading ? SizedBox() : GoogleMap(
                                    // initialCameraPosition: _latLng,
                                    zoomControlsEnabled: false,
                                    initialCameraPosition: initialcameraposition!,
                                    onMapCreated: (GoogleMapController a) async {
                                      setState(() {
                                        mapController = a;
                                      });
                                    },
                                    myLocationEnabled: true,

                                  )
                              ),

                              Container(
                                color: Colors.black,
                                height: 20.vh,
                                width: 60.vw,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(shortaddress, style: TextStyle(
                                        color: Colors.white
                                    ),),
                                    Text(mainadress, style: TextStyle(
                                        color: Colors.white
                                    ),),
                                    Text("Lat ${mylocation?.latitude}",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),),
                                    Text("Long ${mylocation?.longitude}",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  height: 100,
                  color: Colors.grey,
                  child: _cameraTogglesRowWidget(context)
                )
              ],
            ),
        ),
      ),
          );
    });
  }
}
