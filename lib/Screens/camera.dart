import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resize/resize.dart';
import '/Screens/gpscam.dart';
import '/Screens/service_mode.dart';
import 'package:screenshot/screenshot.dart';

import '../models/Utility.dart';
class CameraPreviewScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CameraPreviewScreen> with TickerProviderStateMixin {

  CameraController? controller;
  List ?cameras;
  int ?selectedCameraIdx;
  Location ?location;
  LocationData ?mylocation;
  static CameraPosition ?initialcameraposition;
  ScreenshotController screenshotController = ScreenshotController();
  XFile? capturedFile;
  bool isPreView = false;
  bool isPrecessing = false;
  bool falshmode=false;
  LatLng _latLng = LatLng(0.0,0.0);
  bool is_loading=false;
   Uint8List ? ai ;
  Uint8List ?capthured;
  GoogleMapController ?mapController;
  double _zoom=15;  String shortaddress = '', mainadress = '', clickdate = '';

  Location currentLocation = Location();
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
        initialcameraposition = CameraPosition(
          target: LatLng(mylocation!.latitude!.roundToDouble(), mylocation!.longitude!.roundToDouble()),
          zoom: 11.5,
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

  Future getdata(phonenumber) async {
    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    var  path = 'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/service/profile/farmerprofile/${phonenumber}';
    final dio = Dio();
    Map<String, dynamic> returnData = {};
    try {
      final response =
      await dio.post(path,  options: Options(headers: header),queryParameters: {});
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
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {
        isPrecessing = false;
      });
    }
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
          ElevatedButton.icon(
            onPressed: isPrecessing
                ? null
                : () {
              setState(() {
                isPreView = false;
              });
              _onSwitchCamera();
            },
            icon: Icon(
              _getCameraLensIcon(lensDirection),
              size: 35,
            ),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}"),
          ),
          Padding(padding: EdgeInsets.only(left: 10)),
          // Spacer(),
          ElevatedButton.icon(
            onPressed: isPrecessing
                ? null
                : ()async {
              if (isPreView) {
                setState(() {
                  isPreView = false;
                });
              } else {
                try{
                  ai= await mapController!.takeSnapshot();
                }catch(e){
                  print("error isone two $e");
                }
                setState(() {
                  _onCapturePressed(ctx);
                });
              }
            },
            icon: Icon(
              Icons.save,
              size: 35,
            ),
            label: isPreView ? Text('Retake') : Text('Capture'),
          ),
        ],
      ),
    );
  }
  void _saveImage() async {
    try {
      // get status permission
      final status = await Permission.storage.status;

      // check status permission
      if (status.isDenied) {
        // request permission
        await Permission.storage.request();
        return;
      }

      // do save
      // await _doSaveImage();
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        // _isLoading = false;
      });
    }
  }
  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Column(
          children: [

            Center(
                child: capturedImage != null
                    ? Image.memory(

                    capturedImage)
                    : Container()),
          ],
        ),
      ),
    );
  }

  void _onSwitchCamera() async {
    selectedCameraIdx =
    selectedCameraIdx! < cameras!.length - 1 ? selectedCameraIdx! + 1 : 0;
    CameraDescription selectedCamera = cameras?[selectedCameraIdx??0];

    await _initCameraController(selectedCamera);
    setState(() {
      isPreView = false;
    });
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Flash mode set to ${mode.toString().split('.').last}',context);
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void showInSnackBar(String message,context) {
    // ignore: deprecated_member_use

    // _scaffoldKey.currentState. ();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:Text( message)));
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}',context);
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
  Future _writeByteToImageFile(ByteData byteData) async {
    Directory dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    File imageFile = new File(
        "${dir.path}/flutter/${DateTime.now().millisecondsSinceEpoch}.png");
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData.buffer.asUint8List(0));

    return imageFile;
  }
  void _onCapturePressed(context) async {
    setState(() {
      isPrecessing = true;
    });
    //
    try {
      capturedFile = await controller!.takePicture();
      try {
        // final Uint8List ? ai = await mapController?.takeSnapshot();

      }catch(e){
        print("error is $e");
      }

      clickdate = '${DateFormat('d-M-y').format(DateTime.now())}';
      final ai1 = await File("${capturedFile!.path}2").create();
      final file = File(capturedFile!.path);

      String imgString = Utility.base64String(file.readAsBytesSync());
      print("imaeg $imgString");
      await ai1.writeAsBytes(ai!);
      final image1 = await screenshotController.captureFromWidget(await imagewithlocation(context,File(capturedFile!.path), ai1), delay: Duration(seconds: 2));


      // final res =   await _imageSaver.saveImage(imageBytes:image1,directoryName: "welcone");
      // print(res);
  setState(() {
    capthured=image1;
    Gps_CamState.getInstance()!.images.add(image1);
    Gps_CamState.getInstance()!.latlang=LatLng(mylocation!.latitude??0.0, mylocation!.longitude??0);

    // ImagedashboardState.getInstance().loading=false;
  });
      // ShowCapturedWidget(context,image1);

      // final imagepath = await File("${capturedFile!.path}1").create();
      // await imagepath.writeAsBytes(image1);
     // Navigator.of(context).pop();
      // // image = imagepath;?
      //     print("capturedFile ${imagepath}");
      setState(() {
        // capturedFile.path=imagepath as XFile?;
        isPrecessing = false;
        isPreView = true;

      });
    } catch (e) {
      print("saving eroor $e");
    }
  }

  Widget _imagePreviewOrCamera(context) {
    if (isPrecessing) {
      return  Center(child: CircularProgressIndicator());
    }
    if (isPreView) {
      return  Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
            children: [
              Container(
                height:300,
                child: Image.memory(capthured!),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  // margin: EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.rectangle,
                  ),
                  child: IconButton(
                      iconSize: 40,
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        print("capturedFile!.path ${capturedFile!.path}");
                        getBytesFromFile().then((bytes) {
                          Share.file('Share via:', basename(capturedFile!.path),
                              bytes.buffer.asUint8List(), 'image/png');
                        });
                      }),
                ),
              )
            ],

        ),
      );
    } else {
      return
              _cameraPreviewWidget(context);

    }
  }
  Future<Widget> imagewithlocation(ctx,File _image, File map) async {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.file(
          _image,
          height: 80.vh,
          width: 100.vw,

          // fit: BoxFit.fitWidth,
        ),
        Container(
          height:20.vh,
          child: Row(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
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
                        )),
                  ),
                ],
              ),
              Expanded(
                child: Container(
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
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _cameraPreviewWidget(context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return Stack(
      children: [
        CameraPreview(controller!,
            child:  Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Container(
                        height: 20.vh,
                        width: 40.vw,
                        color: Colors.grey,

                        child:is_loading? SizedBox():  GoogleMap(
                          // initialCameraPosition: _latLng,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(mylocation?.latitude??0.0, mylocation?.longitude??0.0),
                            zoom: 11.5,
                          ),
                          onMapCreated: (GoogleMapController a)async{
                            setState(() {
                              mapController=a;
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
                          Text(shortaddress,style: TextStyle(
                              color: Colors.white
                          ),),
                          Text(mainadress,style: TextStyle(
                              color: Colors.white
                          ),),
                          Text("Lat ${mylocation?.latitude}",style: TextStyle(
                              color: Colors.white
                          ),),
                          Text("Long ${mylocation?.longitude}",style: TextStyle(
                              color: Colors.white
                          ),)
                        ],
                      ),
                    )
                  ],
                )

            )

        ),
        Positioned(
            top: 25,
            child: InkWell(
          onTap: ()async{
            setState(() {
              falshmode=!falshmode;
            });
            await controller!.setFlashMode(falshmode==false?FlashMode.off:FlashMode.always);
           print(falshmode);
            // onSetFlashModeButtonPressed(falshmode==false?FlashMode.off:FlashMode.always);
          },
          child: Icon(falshmode?Icons.flash_auto:Icons.flash_off,color: Colors.red,),
        )),
        Positioned(
          bottom: 25,
          child: Container(
           height:10.vh,
              child: _cameraTogglesRowWidget(context)),
        )]
        );



          // Text("sdgj")
        // ],
        ;


  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(capturedFile!.path).readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      controller!.dispose();
    }
  }

  @override
  void initState() {
    _saveImage();
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Resize(
        allowtextScaling: true,
        builder: () {
          return Material(
            child: Scaffold(
              body:
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: _imagePreviewOrCamera(context),


              ),
            ),
          );
        }
    );
    }

  }
