
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Dashboard.dart';
import 'package:stock_box/Screens/Main_screen/Notification.dart';
import 'package:stock_box/Screens/Onboarding_screen/Forgot_password.dart';
import 'package:stock_box/Screens/Onboarding_screen/Signup.dart';
import 'package:stock_box/main.dart';

bool Sow_popup_first_time= true;

class Login extends StatefulWidget {
  bool? showOnboarding;
   Login({super.key,this.showOnboarding});

  @override
  State<Login> createState() => _LoginState(showOnboarding:showOnboarding);
}

class _LoginState extends State<Login> {
  bool? showOnboarding;
  _LoginState({
   this.showOnboarding
});
  TextEditingController username =TextEditingController();
  TextEditingController password =TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true, passwordVisible = false;


  bool? Status;
  String? loader = "false";
  String? message;

  String? Login_id;
  String? Angelredirecturl;
  String? Aliceredirecturl;
  String? Zerodharedirecturl;
  String? Upstoxdharedirecturl;
  var Login_data;
  String? login_status= "true";

  set_status() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login_status', login_status!);
  }

  String? Token;
  Login_Api() async {
    openAlertBox();
    var data = await API.login_Api(username.text,password.text,device_token);
    print("Data: $data");
    setState(() {
      Status = data['status'];
      message = data['message'];
      Login_data=data['data'];
      print("Statussss: $Status");
    });

    if(Status==true){

      setState(() {
        Sow_popup_first_time= true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successfully...',style: TextStyle(color: Colors.white)),
          duration:Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Login_id= Login_data['id'];
      Angelredirecturl= Login_data['angleredirecturl'];
      Aliceredirecturl= Login_data['aliceredirecturl'];
      Zerodharedirecturl= Login_data['zerodharedirecturl'];
      Upstoxdharedirecturl= Login_data['upstoxredirecturl'];
      Token= Login_data['token'];
      print("Login_id: $Login_id");

      SharedPreferences prefs= await SharedPreferences.getInstance();
      prefs.setString("Login_id",Login_id!);
      prefs.setString("AngelRedirectUrl",Angelredirecturl!);
      prefs.setString("AliceRedirectUrl",Aliceredirecturl!);
      prefs.setString("ZerodhaRedirectUrl",Zerodharedirecturl!);
      prefs.setString("UpstoxRedirectUrl",Upstoxdharedirecturl!);
      prefs.setString("Token",Token!);

      set_status();
      Timer(Duration(seconds: 20), () {
        showPopupAfterDelay();
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:'true',showOnboarding:showOnboarding)));

    }

    else{

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$message',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);

    }

  }
  double _rating = 0;
  void showPopupAfterDelay() async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final prefs = await SharedPreferences.getInstance();
    final isPopupDismissed = prefs.getBool('isPopupDismissed') ?? false;

    if (!isPopupDismissed) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 160,
                    margin: const EdgeInsets.only(left: 45, right: 45),
                    width: MediaQuery.of(context).size.width,
                    child: AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      elevation: 0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child:const Text(
                                'Rate Us',
                                style: TextStyle(color:Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.topRight,
                              child: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      content: Container(
                        height:215,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Container(
                                  child: Text("How Would You Rate Our\nApp Experience ?",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 0.8,color: Colors.black.withOpacity(0.65),fontSize: 17),),
                                ),
                                Container(
                                  margin:const EdgeInsets.only(top: 20),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RatingBar.builder(
                                      initialRating: _rating,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: ColorValues.Splash_bg_color1,
                                        size: 15,
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          _rating = rating;
                                        });
                                        print(rating);
                                      },
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () async {
                                    await prefs.setBool('isPopupDismissed', true);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(left: 25, right: 25,top: 25),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: ColorValues.Splash_bg_color1
                                    ),
                                    child:const Text("Submit",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                    Future.delayed(const Duration(seconds: 20), () {
                                      showPopupAfterDelay(); // show again
                                    });
                                  },
                                  child: Container(
                                    margin:const EdgeInsets.only(top: 15),
                                    child: Text("No, Thanks",style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.75),fontWeight: FontWeight.w600),),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                    ),
                  );
                });
          }) ??
          false;
    }
  }

  late FirebaseMessaging messaging;
  String? device_token;

  Firebase_Notification(){
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print("==========Data:${event.data}");
      print("Firebase message: ${event.notification!.body}");
      print("33333333333: ${event.data.toString()}");
      print("44444444444: ${event.data['type'].toString()}");

      // NotificationService().showNotification(body: '${event.notification!.body}');


    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      print("8888888888888: ${message.data.toString()}");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Notificationn()),
      );

    }
    );

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");

      },
    );

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print('device_tokennnnnnnnnnnnnn =  $value');
      device_token = value;
      // postToken();
      // setToken();
    }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase_Notification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorValues.Splash_bg_color1,
              ColorValues.Splash_bg_color1,
              ColorValues.Splash_bg_color1,
            ],
          ),
        ),

        child: SingleChildScrollView(
          physics:const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/3.3,
                child: Column(
                  children: [
                    const SizedBox(height: 60,),

                    Container(
                      margin:const EdgeInsets.only(bottom: 5, left: 35, right: 10,top: 15),
                      alignment: Alignment.topLeft,
                      child:const Text("Hello", style:
                      TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800
                      ),
                      ),
                    ),

                    Container(
                      margin:const EdgeInsets.only(left: 35, right: 10),
                      alignment: Alignment.topLeft,
                      child:const Text("Sign in!", style:
                      TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800
                      ),
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius:const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: Colors.grey.shade100,
                ),
                height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height/3.3,
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                       const SizedBox(height: 30,),
                        Container(
                          margin:const EdgeInsets.only(top: 30, left: 35, right: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topLeft,
                          child:const Text("Email / Mobile No.", style:
                          TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          // height: 45,
                          margin:const EdgeInsets.only(top: 10, left: 35, right: 35),
                          // padding:const EdgeInsets.only(left: 15, right: 15),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(12),
                          //   border: Border.all(
                          //       color: ColorValues.Splash_bg_color2,
                          //       width: 0.3
                          //   ),
                          // ),
                          child: TextFormField(
                            cursorColor: Colors.black,
                            cursorWidth: 1.1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email / Mobile No.';
                              }
                              return null;
                            },
                            controller: username,
                            style:const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width:1.1)
                              ),
                              hintText: "Email / Mobile No.",
                              contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                              hintStyle:const TextStyle(
                                  fontSize: 13
                              ),
                              prefixIcon:const Icon(Icons.email)
                            ),
                          )
                        ),
                    
                        Container(
                          margin:const EdgeInsets.only(top: 20, left: 35, right: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topLeft,
                          child:const Text("Password", style:
                          TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                    
                        Container(
                          // height: 45,
                          margin:const EdgeInsets.only(top: 10, left: 35, right: 35),
                          // padding:const EdgeInsets.only(left: 15, right: 15),
                          //
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(12),
                          //   border: Border.all(
                          //       color: ColorValues.Splash_bg_color2,
                          //       width: 0.3
                          //   ),
                          // ),
                    
                          child: TextFormField(
                            obscureText: obscureText,
                            cursorColor: Colors.black,
                            cursorWidth: 1.1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                            controller: password,
                            style:const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1)
                              ),
                              hintText: "Password",
                              contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                              hintStyle:const TextStyle(
                                  fontSize: 13
                              ),
                                prefixIcon:const Icon(Icons.password),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                    if (passwordVisible == false) {
                                      obscureText = true;
                                    } else if (passwordVisible == true) {
                                      obscureText = false;
                                    }
                                  }
                                  );
                                },
                              ),
                            ),
                          )
                    
                        ),
                    
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Forgot_password()));
                          },
                          child: Container(
                            margin:const EdgeInsets.only(top: 12, left: 35, right: 35),
                            // padding:const EdgeInsets.only(),
                            alignment: Alignment.topRight,
                            child:const Text("Forgot password ?", style:
                            TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                    
                    
                        GestureDetector(
                          onTap: (){
                    
                            if (_formKey.currentState!.validate()) {
                              Login_Api();
                            }
                            else{
                              print("Hello");
                            }
                    
                          },
                    
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // margin: EdgeInsets.only(left: 35, right: 35, top: 25, bottom: 15),
                            elevation: 0,
                            child:Container(
                              height: 50,
                              margin:const EdgeInsets.only(top: 40, left: 30, right: 30),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [
                                    0.1,
                                    0.5,
                                  ],
                                  colors: [
                                    ColorValues.Splash_bg_color1,
                                    ColorValues.Splash_bg_color1,
                                  ],
                                ),
                              ),
                    
                              child:Container(
                                  alignment: Alignment.center,
                                  child:const Text(
                                    "SIGN IN",
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
                                  ),
                              ),
                    
                            ),
                          ),
                        ),
                    
                        Container(
                          margin:const EdgeInsets.only(top: 12),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? ", style:
                              TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                    
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup(referralCode: '',)));
                                },
                                child: Text("Sign Up", style:
                                TextStyle(color: ColorValues.Splash_bg_color1, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                    
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/3,)
                    
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }

  openAlertBox() async {
    setState(() {});
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 37,
                      width: 37,
                      color:Colors.transparent,
                      child:const CircularProgressIndicator(color: Colors.black,)
                  ),
                ],
              )
          );
        }
    );
  }

}

