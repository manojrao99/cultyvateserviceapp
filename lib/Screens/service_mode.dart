import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';import 'dart:io' as Io;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resize/resize.dart';
import '/Screens/camera.dart';
import '/models/Images.dart';
import '/models/actualdevices.dart';
import 'package:camera/camera.dart';
import '/models/devicelocations.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:camerax/camerax.dart';
import '../models/farmer_profile.dart';
import '../models/servicemode.dart';

class Imagedashboard extends StatefulWidget {
  const Imagedashboard({Key? key}) : super(key: key);

  @override
  State<Imagedashboard> createState() => ImagedashboardState();
}

class ImagedashboardState extends State<Imagedashboard> {
  static ImagedashboardState ? instance;
  GoogleMapController ?mapController;
  bool cameravisuble=false;
  bool isLoading = false, cameraopen = false;
  String shortaddress = '', mainadress = '', clickdate = '';
  File ?_image;
  String ? _imagename, _description;
  final sscontroller = ScreenshotController();
  Location ?location;
  LocationData ?mylocation;
  static CameraPosition ?initialcameraposition;
  CameraController? controller;
  TextEditingController phonenumber= new TextEditingController();
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
  List<Farmerprofile>Imagesarray=[];
Future GetImages(phonenumbe)async {
  print("number");
  Imagesarray.clear();

  Map<String, String> header = {
    "content-type": "application/json",
    "API_KEY": "12345678"
  };
  var  path = 'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/service/profile/farmerprofile/$phonenumbe';
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
            Farmerprofile telematicModel = Farmerprofile.fromJson(
                response.data['data'][i]);
            setState(() {
              Imagesarray.add(telematicModel);
            });
          }
          catch (e) {
            print("error is error $e");
            // GetDevicedata(phonenumbe);
          }
        }
        setState(() {
          loading=false;
        });
      }
    }


        // GetDevicedata(phonenumbe);
      }

    catch (e) {
    GetDevicedata(phonenumbe);
    print("error ios :" + e.toString());

    Fluttertoast.showToast(
        msg: 'Cannot get requested data, please try later: ${e.toString()}');
  }
  return returnData;

}
  @override
  void initState() {
    instance=this;
    super.initState();
    myloc1();

  }
   _saveImage() async {
    final status;
    try {
      // get status permission
       status = await Permission.storage.status;

      // check status permission
      if (status.isDenied) {
        // request permission
        await Permission.storage.request();
        return  status ;
      }
      else{
        return status;
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
  static ImagedashboardState? getInstance() {
    return instance;
  }
  bool loadingimages=false;

  List images=[];



      bool loading=false;
   List<Farmer_profile>FarmerInfo=[];
  Future<List<Farmer_profile>?> GetDevicedata(phonenumber) async {
    // print("")
    FarmerInfo=[];
    setState(() {
      loading=true;
    });
    // List<Servicemode> Devices = [];
    Map<String, dynamic> response = await getdata(phonenumber);
    print("responce is one :${response}");

    try {
      if (response.isNotEmpty) {
        print("inside try");
        print(response['success']);
        print(response is List<dynamic>);
        if (response['success'] != false) {
          for (int i = 0; i < response['data'].length; i++) {
            try {
              Farmer_profile telematicModel = Farmer_profile.fromJson(
                  response['data'][i]);
              setState(() {
                FarmerInfo.add(telematicModel);
                loading=false;
              });

            }
            catch (e) {
              loading=false;
              print("error is $e");
            }
            // DevicesData.add(Devices);
            FarmerInfo.forEach((element) {
              element.farmerDetails!.forEach((element) {
                print(element.name);

              });
            });
          }
        }
      }
    }
    catch(e){setState(() {
      loading=false;
    });
      throw e;
      print(e);
    }
      }

Widget keyvaluefunction(String title,value){
    return ListTile(title: Text(title),trailing: Text(value));
}

  @override

  Widget build(BuildContext context) {
    return Resize(
        allowtextScaling: true,
        builder: () {
          return

           Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child:

      Container(
      height: MediaQuery.of(context).size.height,
      child:Column(
      children: [
        Container(
          // height: 20.vh,
          child: Column(
              children: [

                Container(
                  height: MediaQuery.of(context).size.height/15,
                  child: Image.asset(
                    'assets/images/cultyvate.png',
                    height:30,
                  ),
                ),
                Container(
                    height:5.vh,
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text(
                            "GPS",
                            style: TextStyle(
                                color: Color.fromRGBO(10 ,192 ,92,2),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Cam",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ] )
                ),
                SizedBox(height: 2,),
                Row(
                    children: [

                      Container(

                        // height: MediaQuery.of(context).size.height/12,
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 8.vh,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: TextFormField(
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: phonenumber,
                          decoration: InputDecoration(
                            labelText: 'Farmer Mobile Number',

                            border: OutlineInputBorder(),
                            // counter: Offstage(),
                          ),
                        ),
                      ),
                      Container(
                        width:65,

                        child: TextButton(
                          onPressed: (){
                            setState((){
                              loading=true;
                              cameravisuble=false;
                              FarmerInfo.clear();

                            });
                            GetImages(phonenumber.text);



                          },child: Text("Search",style: TextStyle(fontSize: 10),),),
                      )
                    ])
              ]),
        ),
        Container(
          // scrollDirection: Axis.vertical,
          height: 70.vh,
          child:loading ?Center(
            child: CircularProgressIndicator(),
          ): Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,


                  itemBuilder: (BuildContext context,index){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("FarmerName: ${Imagesarray[index].farmerDetails![0].name}"),
                        Text("FatherName: ${Imagesarray[index].farmerDetails![0].fatherName}"),
                        Text("Mobilenumber: ${Imagesarray[index].farmerDetails![0].mobileNumberPrimary}"),
                        Text("FieldOfficerName: ${Imagesarray[index].farmerDetails![0].foName}"),
                        Text("FieldOfficerMobile: ${Imagesarray[index].farmerDetails![0].fomobile}"),
                        Text("FiledManagerName: ${Imagesarray[index].farmerDetails![0].fmname}"),
                        Text("FiledManagerMobile: ${Imagesarray[index].farmerDetails![0].fomobile}"),

                      ],
                    );
                  },
                  itemCount: Imagesarray.length,
                ),
              ),
              SingleChildScrollView(
                child:  ListView.builder(
                    shrinkWrap: true,

                    itemBuilder: (BuildContext context,count){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Device Id : ${Imagesarray[0].plotdevices![count].deviceEUIID} "),
                          Text("Device Type : ${Imagesarray[0].plotdevices![count].fType} "),
                        ],
                      );
                    },
                    itemCount: Imagesarray[0].plotdevices!.length,
                  ),
                ),

              Expanded(
                // height: 100,
                // scrollDirection: Axis.vertical,
                // physics: NeverScrollableScrollPhysics(),
                child: GridView.count(


                    // shrinkWrap: true,

                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 8.0,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    children:<Widget>[... List.generate(Imagesarray[0].images!.length, (index) {
                      // print("example ${Imagesarray[index].imageNV.toString()}");\

                      final z;
                      try{
                        z= base64.decode(Imagesarray[0].images![index]. imageNV.toString());
                        return  InkWell(
                          child: Image.memory(z,
                              width: 100,
                              height: 100,
                              fit: BoxFit
                                  .cover),
                          onTap: (){
                            // GetImages("8530871947");
                            Get.to(ImageView(image:z));
                          },
                        );
                      }catch(e){
                        return SizedBox();
                        print(e);
                      }
                    })]




                ),
              ),
              // Container(
              //
              //
              //     child: ListView(
              //       primary: false,
              //       shrinkWrap: true,
              //       physics: NeverScrollableScrollPhysics(),
              //       children: [
              //
              //
              //       ],
              //     ),
              //   height: 60.vh,
              // ),
              // Expanded(child: GridView.count(
              //
              //      crossAxisCount: 3,
              //      crossAxisSpacing: 4.0,
              //      mainAxisSpacing: 8.0,
              //      children:<Widget>[... List.generate(Imagesarray[0].images!.length, (index) {
              //        // print("example ${Imagesarray[index].imageNV.toString()}");\
              //
              //        final z;
              //        try{
              //          z= base64.decode(Imagesarray[0].images![index]. imageNV.toString());
              //          return  InkWell(
              //            child: Image.memory(z,
              //                width: 100,
              //                height: 100,
              //                fit: BoxFit
              //                    .cover),
              //            onTap: (){
              //              // GetImages("8530871947");
              //              Get.to(ImageView(image:z));
              //            },
              //          );
              //        }catch(e){
              //          return SizedBox();
              //          print(e);
              //        }
              //      })]
              //
              //
              //
              //
              //  )),
              Visibility(
                visible: cameravisuble,
                child: Expanded(child:   GridView.count(
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
                            fit: BoxFit
                                .cover,),
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
                              isLoading=true;
                            });
                            images.remove(images[index]);
                            setState(() {
                              isLoading=false;
                            });
                          }),
                        )
                      ],
                    );



                    InkWell(
                      child: Image.memory(
                        images[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit
                            .cover,
                      ),
                      onTap: (){

                      },
                    );

                    InkWell(
                        onTap: ()async{
                          try{
                            String dataonewkkk=base64Encode(images[index]);

                            var data = await testComporessList(base64Decode(dataonewkkk));
                            var  dataone={
                              "farmerID":34,
                              "image":null,
                              "imagenv":base64Encode(data)
                            };


                            Postdata(dataone);
                            // Get.to(ImageView( image: base64Decode(dataonewkkk),));
                            // _write(images[index]);
                            // File decodedimgfile = await File("image.jpg").writeAsBytes(images[index]);
                            // print("path is ${decodedimgfile.path}");
                            // File('my_image.jpg').writeAsBytes(images[index]);
                          }
                          catch(e){
                            print("error is $e");
                          }
                          uint8ListTob64(images[index]);
                          // String s = new String.fromCharCodes(images[index]);
                          // print("string $s");
                          // var outputAsUint8List = new Uint8List.fromList(s.codeUnits);
                          // print("data $outputAsUint8List");

                        },
                        child: Image.memory(images[index]));
                  },
                  ) ]+ [InkWell(onTap: ()async{
                    final    status = await Permission.storage.status;
                    final camerastatus=await Permission.camera.status;
                    if(status.isGranted && camerastatus.isGranted){
                      setState(() {
                        loadingimages=true;
                      });

                      Get.to(CameraPreviewScreen());}
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
                ),),
              ),
              Container(
                  height: 60,
                  child:  Visibility(
                    visible:images.length>0 ,
                    child: InkWell(
                      onTap: (){
                        print("images");
                        images.forEach((element)async {
                          print("imaes element");
                          // String dataonewkkk=base64Encode(element);
                          // var data = await testComporessList(base64Decode(dataonewkkk));
                          // print(base64Encode(data));
                          var  dataone={
                            "farmerID":FarmerInfo[0].farmerDetails![0].iD,
                            "image":null,
                            "imagenv":base64Encode(element)
                          };
                          await Postdata(dataone);
                          images.remove(element);
                          await   GetImages(phonenumber.text);

                        });



                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        color: Colors.blueAccent,
                        height: 20,
                        width: 100.vw,
                        child: Center(child: Text("Post Images")),
                      ),
                    ),
                  ))


              // Container(
              //   height: 60.vh,
              //   child:Column(
              //       children: [
              //         Expanded(
              //           child: GridView.count(
              //               crossAxisCount: 3,
              //               crossAxisSpacing: 4.0,
              //               mainAxisSpacing: 8.0,
              //               children:<Widget>[... List.generate(Imagesarray.length, (index) {
              //                 // print("example ${Imagesarray[index].imageNV.toString()}");\
              //
              //                 final z;
              //                 try{
              //                   z= base64.decode(Imagesarray[index].imageNV.toString());
              //                   return  InkWell(
              //                     child: Image.memory(z,
              //                         width: 100,
              //                         height: 100,
              //                         fit: BoxFit
              //                             .cover),
              //                     onTap: (){
              //                       // GetImages("8530871947");
              //                       Get.to(ImageView(image:z));
              //                     },
              //                   );
              //                 }catch(e){
              //                   return SizedBox();
              //                   print(e);
              //                 }
              //               })]
              //
              //
              //
              //
              //           ),
              //         ),
              //         Expanded(child:   GridView.count(
              //           crossAxisCount: 3,
              //           crossAxisSpacing: 4.0,
              //           mainAxisSpacing: 8.0,
              //           children:<Widget>[... List.generate(images.length, (index) {
              //             return    Stack(
              //               children: <Widget>[
              //                 InkWell(
              //                   child: Image.memory(images[index],
              //                     width: 100,
              //                     height: 100,
              //                     fit: BoxFit
              //                         .cover,),
              //                   onTap: (){
              //                     // GetImages("8530871947");
              //                     Get.to(ImageView(image:images[index] ));
              //                   },
              //                 ),
              //                 Align(
              //                   alignment: Alignment.topRight,
              //                   child: Icon(Icons.delete,color: Colors.red,),
              //                 )
              //               ],
              //             );
              //
              //
              //
              //             InkWell(
              //               child: Image.memory(
              //                 images[index],
              //                 width: 100,
              //                 height: 100,
              //                 fit: BoxFit
              //                     .cover,
              //               ),
              //               onTap: (){
              //
              //               },
              //             );
              //
              //             InkWell(
              //                 onTap: ()async{
              //                   try{
              //                     String dataonewkkk=base64Encode(images[index]);
              //
              //                     var data = await testComporessList(base64Decode(dataonewkkk));
              //                     var  dataone={
              //                       "farmerID":34,
              //                       "image":null,
              //                       "imagenv":base64Encode(data)
              //                     };
              //
              //
              //                     Postdata(dataone);
              //                     // Get.to(ImageView( image: base64Decode(dataonewkkk),));
              //                     // _write(images[index]);
              //                     // File decodedimgfile = await File("image.jpg").writeAsBytes(images[index]);
              //                     // print("path is ${decodedimgfile.path}");
              //                     // File('my_image.jpg').writeAsBytes(images[index]);
              //                   }
              //                   catch(e){
              //                     print("error is $e");
              //                   }
              //                   uint8ListTob64(images[index]);
              //                   // String s = new String.fromCharCodes(images[index]);
              //                   // print("string $s");
              //                   // var outputAsUint8List = new Uint8List.fromList(s.codeUnits);
              //                   // print("data $outputAsUint8List");
              //
              //                 },
              //                 child: Image.memory(images[index]));
              //           },
              //           ) ]+ [InkWell(onTap: ()async{
              //             final    status = await Permission.storage.status;
              //             final camerastatus=await Permission.camera.status;
              //             if(status.isGranted && camerastatus.isGranted){
              //               setState(() {
              //                 loadingimages=true;
              //               });
              //
              //               Get.to(CameraPreviewScreen());}
              //             else{
              //
              //               await Permission.camera.request();
              //
              //               await Permission.storage.request();
              //
              //
              //
              //             }
              //           },child:Column(
              //             children: [
              //               Image.asset('assets/images/camera.png',height: 100,),
              //               Text("Add Image")
              //             ],
              //           ))],
              //         ),),

              //
              //       ]
              //   ) ,
              // ),
            ],
          ),
        )










            ]),
          ),
        )

           );});


  }
  Widget _buildFields(BuildContext context) {
    return Container(
        color: Colors.white,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[... List.generate(Imagesarray[0].images!.length, (index) {
            // print("example ${Imagesarray[index].imageNV.toString()}");\

            final z;
            try{
              z= base64.decode(Imagesarray[0].images![index]. imageNV.toString());
              return  InkWell(
                child: Image.memory(z,
                    width: 100,
                    height: 100,
                    fit: BoxFit
                        .cover),
                onTap: (){
                  // GetImages("8530871947");
                  Get.to(ImageView(image:z));
                },
              );
            }catch(e){
              return SizedBox();
              print(e);
            }
          })]
        ));
  }
  Future<Uint8List> testComporessList(Uint8List list) async {
    final result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1080,
      minWidth: 1080,
      quality: 96,
      rotate: 270,
      format: CompressFormat.webp,
    );
    String dataonewkkk=base64Encode(result);
    print("result is $dataonewkkk");
    print(list.length);
    print(result.length);
    return result;
  }

  Future Postdata(phonenumberone) async {
    Map<String, String> header = {
      "content-type": "application/json",
      "API_KEY": "12345678"
    };
    var  path = 'http://aquaf.centralindia.cloudapp.azure.com/servicesF2Fapp/api/farm2fork/Imagepost/post';
    final dio = Dio();
    Map<String, dynamic> returnData = {};
    try {
      final response =
      await dio.post(path,  data: phonenumberone,options: Options(headers: header),queryParameters: {});
    print("responcasklfme ${response.statusCode}");
      if (response.statusCode == 200) {

        returnData = response.data;
      }
    } catch (e) {
      print("error one is ${e}");
      Fluttertoast.showToast(
          msg: 'Cannot get requested data, please try later: ${e.toString()}');

    }
    return returnData;

  }




  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);
    String header = "data:image/png;base64,";
    print(header + base64String);
    return header + base64String;
  }
  _write(text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.png');
    print('path is '+file.path);
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
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
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
  Future<Widget> imagewithlocation(File _image, File map) async {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.file(
          _image,
          // fit: BoxFit.fitWidth,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
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
                        width: MediaQuery.of(context).size.width * 0.28,
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

}


class ImageView extends StatelessWidget {
  Uint8List image;
   ImageView({required this.image});
     bool ontapIMage=false;
     bool movetogooglemap=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Imageview")),
      body: InkWell (
          
          child: Image.memory(image)),
    );
  }
}
