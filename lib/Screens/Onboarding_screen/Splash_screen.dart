import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Dashboard.dart';
import 'package:stock_box/Screens/Onboarding_screen/Intro.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget{
  bool? showOnboarding;
  SplashScreen({super.key,this.showOnboarding});
  @override
  _SplashScreenState createState() => _SplashScreenState(showOnboarding:showOnboarding);
}

class _SplashScreenState extends State<SplashScreen> {
  String? Login_Status;
  bool? showOnboarding;
  _SplashScreenState({
    this.showOnboarding
});

  get_Status() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Login_Status= prefs.getString("login_status");
    print(Login_Status);
  }

  var BasicSettingData=[];
  String? Logo='';
  String? Name='';
  bool loader=false;
  BasicSetting_Apii() async {
    var data = await API.BesicSetting_Api();
    print("Data11111: $data");
    if(data['status']==true){
      setState(() {
        Logo = data['data']['logo'];
        Name = data['data']['website_title'];
        loader=true;
      });
    }else{}
  }

  @override
  void initState() {
    super.initState();
    BasicSetting_Apii();
    requestNotificationPermission();
    get_Status();
    Timer( Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
             Login_Status=="true"?
             Dashboard(popup_data:'true',showOnboarding:showOnboarding):
             Intro(showOnboarding:showOnboarding)
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [ColorValues.Splash_bg_color1,ColorValues.Splash_bg_color1,]
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                // Image.asset(
                //   "images/icon.png",
                //   height: 50,
                //   width: 150,
                // ),
                loader==true?
                Image.network(Logo!,height: 50,width: 150,):
                SizedBox(),

                Container(
                  margin:const EdgeInsets.only(top: 20),
                  child:  Text("${Name!}",textAlign:TextAlign.center,
                    style:const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 200,),
             loader==true?
             const CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
            ):
                const SizedBox()
          ],
        ),

      ),
    );
  }
}
