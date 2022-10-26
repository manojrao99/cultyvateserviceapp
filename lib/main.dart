// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/dashboard.dart';

void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: login(),
    );
  }
}

class login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _login();
  }
}

class _login extends State<login> {
  var width,hieght;
  bool error = false;
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    hieght = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/images/cultyvate.png',
                  height: 50,
                ),
                SizedBox(
                    height: hieght/12
                ),
                Card(
                  // color: Color(0xFFB9F6CA),
                  color: Colors.white,
                  elevation: 20,
                  child: SizedBox(
                    width: width,
                    height: hieght/2,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              counter: Offstage(),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: TextFormField(
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              counter: Offstage(),
                            ),
                          ),
                        ),
                        error
                            ? Text(
                          'Invalid Username and Password',
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        )
                            : Text(''),
                        MaterialButton(
                          height: hieght/12,
                          minWidth: 300,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)
                          ),
                          onPressed: () {
                            if (username.text == "user" &&
                                password.text == "cultYvate") {
                              setState(() {
                                error = false;
                              });
                              Get.to(Dashboard());
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
                            } else {
                              setState(() {
                                error = true;
                              });
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(onPressed: null, icon: Icon(MdiIcons.instagram,size: 35,color: Colors.red,)),
                //     IconButton(onPressed: null, icon: Icon(MdiIcons.facebook,size: 35,color: Colors.blue,)),
                //     IconButton(onPressed: null, icon: Icon(MdiIcons.linkedin,size: 35,color: Colors.blueAccent,)),
                //     IconButton(onPressed: null, icon: Icon(MdiIcons.youtube,size: 35,color: Colors.red,)),
                //   ],
                // )
              ])),
        ));
  }
}
