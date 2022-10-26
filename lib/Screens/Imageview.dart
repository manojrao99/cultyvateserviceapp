import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
class Imageview extends StatefulWidget {
 LatLng ?imagelatlang;
 String ?image;
   Imageview({
    required this.imagelatlang,
     required this.image
});

  @override
  State<Imageview> createState() => _ImageviewState();
}

class _ImageviewState extends State<Imageview> {
  Future<String> _writeByteToImageFile(ByteData byteData) async {
    Directory dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    File imageFile = new File(
        "${dir.path}/flutter/${DateTime.now().millisecondsSinceEpoch}.png");
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData.buffer.asUint8List(0));
    print(imageFile.path);
    return imageFile.path;
  }
  @override
  Widget build(BuildContext context) {
    print('widget ${widget.imagelatlang!.latitude}');
    print('widget ${widget.imagelatlang!.longitude}');
    return Scaffold(
      body: Center(
        child: Stack(
          children: [

            Image.memory(base64Decode(widget.image.toString(),),width: MediaQuery.of(context).size.width,),
            Positioned(
                right: 10,
                top: 30,

                child: InkWell(
                    onTap: ()async{
                      Uint8List data=base64Decode(widget.image.toString());
                      var path=await _writeByteToImageFile(data.buffer.asByteData());
                     try{
                       ShareExtend.share(path, "image");
                     }
                     catch(e){
                       print(e);
                     }
                    },
                    child: Container(

                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.share,color: Colors.white,size: 50)))),
            Positioned(
              left: 40,
                bottom: 40,
                child: InkWell(
                  onTap: (){
                    Get.to(ImageGooglemap(latLng:LatLng( widget.imagelatlang!.latitude,widget.imagelatlang!.longitude)));
                  },
              child: Text("go")
            ) )
          ],
        ),
      ),
    );
  }
}

class ImageGooglemap extends StatefulWidget {
  // const ImageGooglemap({Key? key}) : super(key: key);
       LatLng latLng;

       ImageGooglemap({required this.latLng});

  State<ImageGooglemap> createState() => _ImageGooglemapState();
}

class _ImageGooglemapState extends State<ImageGooglemap> {

  List<Marker> _markers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Markersadd();
  }
  Markersadd(){
    _markers.add(Marker(markerId: MarkerId("one"),
    position: LatLng(widget.latLng.latitude, widget.latLng.longitude)
    ));
  }
  @override
  Widget build(BuildContext context) {
  
    return Container(
      child: GoogleMap(
        initialCameraPosition:  CameraPosition(
          target:  LatLng(widget.latLng.latitude, widget.latLng.longitude),
          zoom: 15,
        ),
        markers:Set.from( _markers),
        myLocationEnabled: true,

        onMapCreated: (GoogleMapController controller) {
          // _controller.complete(controller);
        },
        // circles: Set<Circle>.of(manok.circles),

      ),
    );
  }
}
