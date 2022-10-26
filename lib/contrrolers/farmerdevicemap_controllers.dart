import 'dart:ui';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:vector_math/vector_math.dart';

class FarmerDeviceMap_conttroler extends GetxController {
  // var count = 0.obs;
  Set<Circle> circles={} ;
  addcircles({circleId,color, required double radisrang,required Color fillcolor}){
    circles.add(Circle(circleId:CircleId(circleId),
        strokeColor: color,
      radius: radisrang,
      fillColor:fillcolor,
      strokeWidth: 10
    ),
    );

  }



}