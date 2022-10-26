import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import '/Screens/Devicequery.dart';
import '/Screens/Farmeraccasation.dart';
import '/Screens/farmerdevicemap.dart';
import '/Screens/farmerdevices_locations.dart';
import '/Screens/gpscam.dart';
import '/googlemap.dart';
import '/scanpage.dart';
import '/stayles.dart';
import 'Screens/service_mode.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool drawerIsOpen = false;
  Location ?location;
  LocationData ?mylocation;
  final GlobalKey<DrawerControllerState> _drawerKey =
  GlobalKey<DrawerControllerState>();
  @override
  Widget build(BuildContext context) {
    void openDrawer() {
      _drawerKey.currentState?.open();
      drawerIsOpen = true;
      setState(() {});
    }

    void closeDrawer() {
      _drawerKey.currentState?.close();
      drawerIsOpen = false;
      setState(() {});
    }
    // toggleDrawer() async {
    //   if (_drawerKey.currentState.) {
    //     _drawerKey.currentState.openDrawer();
    //   } else {
    //     _drawerKey.currentState.openEndDrawer();
    //   }
    // }
    void _closeDrawer() {
      Navigator.of(context).pop();
    }

    return Scaffold(
      drawer: Drawer(
        key: _drawerKey,

          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      // height: MediaQuery.of(context).size.height ,
                      width: MediaQuery.of(context).size.width * 80 / 100,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width:2,height: 5, ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Image(
                              image: AssetImage(
                                  '${assetImagePath}cultyvate.png'),
                            ),
                          ),
                          const SizedBox(width:2 ),
                          IconButton(onPressed: _closeDrawer, icon: Icon(Icons.close))
                          // IconButton(
                          //   icon:
                          //   const FaIcon(FontAwesomeIcons.xmark),
                          //   onPressed: () => closeDrawer(),
                          // ),
                        ],
                      ),
                    ),

                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 15),
                    //   decoration: BoxDecoration(color: cultLightGrey),
                    //   width:MediaQuery.of(context).size.width* 80 / 100,
                    //   child: Row(
                    //     children: [
                    //
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: Column(
                    //           children: [
                    //             Text(
                    //               'Hello Raghu!',
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 14),
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //               MainAxisAlignment.start,
                    //               crossAxisAlignment:
                    //               CrossAxisAlignment.center,
                    //               children: [
                    //                 SizedBox(
                    //                     height: 14,
                    //                     width: 14,
                    //                     child: Center(
                    //                         child: SizedBox(
                    //                             height: 18,
                    //                             width:18,
                    //                             child: const Image(
                    //                                 image: AssetImage(
                    //                                     '${assetImagePath}location_pin.png'))))),
                    //                 Container(
                    //                   height: 20,
                    //                   padding: const EdgeInsets.only(
                    //                       left: 10),
                    //                   child: Center(
                    //                       child: Text(
                    //                         'Village name',
                    //                         style: TextStyle(
                    //                             fontSize: 12),
                    //                       )),
                    //                 ),
                    //               ],
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 5),
                      width:MediaQuery.of(context).size.width* 80 / 100,
                      child: Column(
                        children: [
                          InkWell(
                          onTap: (){
                    Get.to(myapp());
                    },
                        child:  Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  height: 40,
                                  width: 40,
                                  child: Icon(Icons.qr_code_scanner_rounded)
                                ),

                              const Text(
                                'Scan Farmer Details',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          ),
                          InkWell(
                            onTap: (){
                         Get.to(Faremer_Devices());
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  height: 40,
                                  width: 40,
                                  child: Image.asset("assets/images/Google_map.svg.png"),
                                ),
                                const Text(
                                  'Farmer Device Location',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Get.to(DeviceQuery());
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  height: 40,
                                  width: 40,
                                  child: const Image(
                                    image: AssetImage(
                                        "assets/images/searchicon.png"),
                                  ),
                                ),
                                const Text(
                                  'Device Query ',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
      InkWell(
        onTap: (){
          Get.to(Gps_Cam());
        },
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              height: 40,
              width: 50,
              child:  Image.asset("assets/images/gpscameraicon.png",height: 100,width: 80,),
            ),
            const Text(
              'Gps Cam ',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
                    InkWell(
                      onTap: (){
                        Get.to(FarmerDeviceMap());
                      },
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            height: 40,
                            width: 50,
                            child:  Image.asset("assets/images/FarmersideDrawer.png",height: 100,width: 80,),
                          ),
                          const Text(
                            'Farmer Device Map',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),




                  ],
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      // height: 100,
                        decoration:
                        const BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Divider(
                              color: Colors.grey,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    margin:
                                    const EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 20),
                                    child: const Image(
                                        image: AssetImage(
                                            '${assetImagePath}support.png'))),
                                Column(
                                  children: [
                                    Text(
                                      'Contact Support',
                                      style:
                                      TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '+XXXXXXXXXXXX',
                                      style:
                                      TextStyle(fontSize: 12),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Text(
                              'Terms & Conditions',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )),
                  ],
                )

              ]),

      ),
      body: Material(
          child: Stack(
          children: [
            Material(
              child: SafeArea(child:
          SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: cultLightGrey),
                padding: const EdgeInsets.all(20),
              child: Column(
              children: [
                // SizedBox(height: 10),
                ListTile(
                  leading:
                  Builder(
                    builder: (context) => IconButton(
                      icon: Image.asset("assets/images/hamburger.png"),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),

                  ),
                  title: Image.asset(
                    'assets/images/cultyvate.png',
                    height: 50,
                  ) ,
                  trailing: Image.asset("assets/images/bell_no_message.png"),
                ),

                // Material(
                //   borderRadius: BorderRadius.circular(10),
                //   elevation: 10,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(vertical: 5),
                //     margin: const EdgeInsets.all(2),
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         border: Border.all(color: Colors.white),
                //         borderRadius: BorderRadius.circular(2)),
                //     // height: 60,
                //     // width: ScreenUtil.defaultSize.width,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Row(
                //           children: [
                //             CircleAvatar(
                //                 radius: 25,
                //                 backgroundColor: cultLightGrey,
                //                 backgroundImage: const AssetImage(
                //                     '${assetImagePath}avataar.png')),
                //             Padding(
                //               padding: const EdgeInsets.only(left: 10),
                //               child: Column(
                //                 children: [
                //                   Text(
                //                     'Hello Raghu!',
                //                     style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 14),
                //                   ),
                //                   Row(
                //                     mainAxisAlignment:
                //                     MainAxisAlignment.start,
                //                     crossAxisAlignment:
                //                     CrossAxisAlignment.center,
                //                     children: [
                //                       SizedBox(
                //                           height:14,
                //                           width: 14,
                //                           child: Center(
                //                               child: SizedBox(
                //                                   height: 18,
                //                                   width: 18,
                //                                   child: const Image(
                //                                       image: AssetImage(
                //                                           '${assetImagePath}location_pin.png'))))),
                //                       Container(
                //                         height: 20,
                //                         padding:
                //                         const EdgeInsets.only(left: 10),
                //                         child: Center(
                //                             child: Text(
                //                               'Village name',
                //                               style: TextStyle(fontSize: 12),
                //                             )),
                //                       ),
                //                     ],
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //         const Padding(
                //           padding: EdgeInsets.only(right: 10.0),
                //           child: Image(
                //               image: AssetImage(
                //                   '${assetImagePath}horizontal.png')),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: 10),
                // Stack(children: [
                //   Container(
                //     width: double.infinity,
                //     height: 150,
                //     decoration: BoxDecoration(
                //         image: DecorationImage(
                //             fit: BoxFit.cover,
                //             image: AssetImage('${assetImagePath}farm.png')),
                //         borderRadius: BorderRadius.circular(10)),
                //   ),
                //   Container(
                //     width: double.infinity,
                //     height: 150,
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 10.0, vertical: 5),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: Color.fromRGBO(17, 143, 128, .9)),
                //   ),
                //   Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 10.0, vertical: 10),
                //     child: Column(children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Column(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               const Image(
                //                   image: AssetImage(
                //                       '${assetImagePath}gateway.png')),
                //               const SizedBox(width: 10),
                //               Padding(
                //                 padding: const EdgeInsets.all(5.0),
                //                 child: Text(
                //                   'Online',
                //                   style: TextStyle(
                //                       color: Colors.white, fontSize: 14),
                //                 ),
                //               ),
                //             ],
                //           ),
                //           SizedBox(
                //             width:20,
                //           ),
                //           Column(
                //             children: [
                //               InkWell(
                //                 // onTap: () => getFarmerData(),
                //                 child: Text(
                //                   'Farmland 1',
                //                   style: TextStyle(
                //                     // fontFamily: 'Poppins',
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 18,
                //                       color: Colors.white),
                //                 ),
                //               ),
                //               Text(
                //                 '402567',
                //                 style: TextStyle(
                //                     fontSize: 14, color: Colors.white54),
                //               ),
                //               SizedBox(height: 5),
                //               Text('Timer based irrigation',
                //                   style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: 14,
                //                       fontWeight: FontWeight.bold))
                //             ],
                //           ),
                //           SizedBox(
                //             width: 30,
                //           ),
                //           SizedBox(
                //             height: 25,
                //             width: 25,
                //             child: InkWell(
                //               child: const Image(
                //                   fit: BoxFit.fill,
                //                   image: AssetImage(
                //                       '${assetImagePath}calendar.png')),
                //               // onTap: () => Navigator.of(context).push(
                //               //     MaterialPageRoute(
                //               //         builder: (context) =>
                //               //         const ScheduleCalendar())),
                //             ),
                //           )
                //         ],
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 10.0, horizontal: 10),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               children: [
                //                 Row(children: [
                //                   const Image(
                //                       image: AssetImage(
                //                           '${assetImagePath}pump_white.png')),
                //                   SizedBox(
                //                     width: 10,
                //                   ),
                //                   Text('Pump - On',
                //                       style: TextStyle(
                //                           color: Colors.white,
                //                           fontSize: 14)),
                //                 ]),
                //                 SizedBox(
                //                   height: 10,
                //                 ),
                //                 Row(
                //                     mainAxisAlignment:
                //                     MainAxisAlignment.center,
                //                     children: const [
                //
                //                       SizedBox(
                //                         width: 10,
                //                       ),
                //                       Text('Since 10: 30',
                //                           style: TextStyle(
                //                               color: Colors.white))
                //                     ]),
                //               ],
                //             ),
                //             Column(
                //               children: const [
                //                 SizedBox(
                //                   child: Image(
                //                       height: 30,
                //                       width: 30,
                //                       image: AssetImage(
                //                           '${assetImagePath}flow_white.png')),
                //                 ),
                //                 SizedBox(height: 5),
                //                 Text(
                //                   'Today: 1370 kL',
                //                   style: TextStyle(color: Colors.white),
                //                 )
                //               ],
                //             )
                //           ],
                //         ),
                //       )
                //     ]),
                //   ),
                // ]),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    InkWell(
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          height: 120,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(2)),
                          // height: 60,
                          // width: ScreenUtil.defaultSize.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Padding(padding: EdgeInsets.only(top: 0)),
                              Center(child: Icon(Icons.qr_code_scanner_rounded,size: 60,)),
                              SizedBox(height: 10,),
                              Text("Scan Farmer Details")
                              // FaIcon(FontAwesomeIcons.sprayCan)
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Get.to(myapp());
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(builder: (BuildContext context) => myapp()));

                      },
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          height: 120,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(2)),
                          // height: 60,
                          // width: ScreenUtil.defaultSize.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Padding(padding: EdgeInsets.only(top: 0)),
                              Center(child: Image.asset("assets/images/Google_map.svg.png",height: 60,)),
                              SizedBox(height: 10,),
                              Text("Farmer Device Location"),
                              // FaIcon(FontAwesomeIcons.sprayCan)
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        // Fluttertoast.showToast(
                        //     msg: "Comping Up shortly",
                        //     backgroundColor: Colors.red
                        // );

                         Get.to(Faremer_Devices());
                        //
                        // Get.to(Faremer_Devices());
                      },
                    )



                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    InkWell(
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          height: 120,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(2)),
                          // height: 60,
                          // width: ScreenUtil.defaultSize.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Padding(padding: EdgeInsets.only(top: 0)),
                              Center(child: Image.asset("assets/images/searchicon.png",height: 60,)),
                              SizedBox(height: 10,),
                              Text("Device Query"),
                              // FaIcon(FontAwesomeIcons.sprayCan)
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Get.to(DeviceQuery());
                        // Get.to(Devicelocations_find());
                      },
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          height: 120,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(2)),
                          // height: 60,
                          // width: ScreenUtil.defaultSize.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Padding(padding: EdgeInsets.only(top: 0)),
                              Center(child: Image.asset("assets/images/gpscameraicon.png",height: 70,width: 250,)),
                              SizedBox(height: 10,),
                              Text("Gps Cam"),
                              // FaIcon(FontAwesomeIcons.sprayCan)
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Get.to(Gps_Cam());
                        // Get.to(Devicelocations_find());
                      },
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 10,
                            child: Container(
                              width: MediaQuery.of(context).size.width/2.5,
                              height: 120,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(2)),
                              // height: 60,
                              // width: ScreenUtil.defaultSize.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Padding(padding: EdgeInsets.only(top: 0)),
                                  Center(child: Image.asset("assets/images/FarmerDevicemapicon.png",height: 60,)),
                                  SizedBox(height: 10,),
                                  Text("Farmer Device Map"),
                                  // FaIcon(FontAwesomeIcons.sprayCan)
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            // Fluttertoast.showToast(
                            //     msg: "Comping Up shortly",
                            //     backgroundColor: Colors.red
                            // );

                            Get.to(FarmerDeviceMap());
                            //
                            // Get.to(Faremer_Devices());
                          },
                        ),
                        Positioned(
                            top: 5,
                            left: 20,
                            child: Text("Beta Release",style: TextStyle(color: Colors.red),))
                      ],
                    ),

                    SizedBox(width: 10,),
                  Stack(
                    children: [
                      InkWell(
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 10,
                          child: Container(
                            width: MediaQuery.of(context).size.width/2.5,
                            height: 120,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(2)),
                            // height: 60,
                            // width: ScreenUtil.defaultSize.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Padding(padding: EdgeInsets.only(top: 0)),
                                Center(child: Image.asset("assets/images/notepad.jpg",height: 60,)),
                                SizedBox(height: 10,),
                                Text("Farmer Accusation"),
                                // FaIcon(FontAwesomeIcons.sprayCan)
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          // Fluttertoast.showToast(
                          //     msg: "Comping Up shortly",
                          //     backgroundColor: Colors.red
                          // );

                          Get.to(Farmeracusation());
                          //
                          // Get.to(Faremer_Devices());
                        },
                      ),
                      Positioned(
                          top: 5,
                          left: 20,
                          child: Text("Beta Release",style: TextStyle(color: Colors.red),))
                    ],
                  )
                  ],
                )


            ],
          ),
          ),
          )
          ) ,
                
                
              ),

          ]

          )
      ),
    );
  }
}

