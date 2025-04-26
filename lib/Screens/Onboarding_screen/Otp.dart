import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pinput/pinput.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Screens/Onboarding_screen/Login.dart';
import 'package:stock_box/Constants/Util.dart';

class Otps extends StatefulWidget {
  String? Otp;
  String? Email;
  Otps({Key? key,required this.Otp, required this.Email}) : super(key: key);

  @override
  State<Otps> createState() => _OtpsState(Otp:Otp,Email:Email);
}

class _OtpsState extends State<Otps> {

  String? Otp;
  String? Email;
  _OtpsState({
     required this.Otp,
     required this.Email
});


  final formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  String? message;
  bool? Status_otp;

  Otp_Api() async {
    openAlertBox();
    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/otp_submit"),
        body:{
          'email': '$Email',
          'otp': '$Otp',
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    message=jsonString['message'];
    Status_otp=jsonString['status'];

    print("Status Otp: $Status_otp");

    if(Status_otp==true){
      setState(() {

      });
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('$message, Please login your account',style: TextStyle(color: Colors.white)),
          duration:Duration(seconds: 3),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong Otp',style: TextStyle(color: Colors.white)),
          duration:Duration(seconds: 3),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Navigator.pop(context);
    }

  }


    bool? Status_resend;
    String? Message_resend;
    String? Otp_resend;
    bool resend_status=false;

    ResendOtp_Api() async {
     var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/resend"),
        body:{
          'email': '$Email',
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");

    Status_resend=jsonString['status'];
    Message_resend=jsonString['message'];
    Otp_resend=jsonString['otp'].toString();
    print("111111Otp : $Status_resend");
    print("2222222Otp : $Message_resend");
    print("3333333Otp : $Otp_resend");

    if(Status_resend==true){
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('$Message_resend',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        resend_status=true;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_resend',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    var borderColor = ColorValues.Splash_bg_color1;

    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
    );

    return WillPopScope(
      onWillPop: () async{
         return false;
      },
      child: Scaffold(
         body: Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               const SizedBox(height: 65,),
                GestureDetector(
                  onTap: (){
                    GoBack();
                  },
                  child: Container(
                    margin:const EdgeInsets.only(left: 20),
                    alignment: Alignment.topLeft,
                    child:const Icon(Icons.arrow_back,color: Colors.black,size: 30,),
                  ),
                ),

                 SizedBox(height: MediaQuery.of(context).size.height/7),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 20),
                  child:const Text(
                    "OTP Verification",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 25),
                  child:  Text(
                    "Enter the code from the email we sent to $Email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                Container(
                  margin:const EdgeInsets.only(top: 40),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            length: 6,
                            controller: pinController,
                            focusNode: focusNode,
                            defaultPinTheme: defaultPinTheme,
                            separatorBuilder: (index) => const SizedBox(width: 8),
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) {
                              debugPrint('onCompleted: $pin');
                            },
                            onChanged: (value) {
                              debugPrint('onChanged: $value');
                            },
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 9, left: 5, right: 5),
                                  width: 22,
                                  height: 1,
                                  color: focusedBorderColor,
                                ),
                              ],
                            ),

                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: focusedBorderColor),
                              ),
                            ),

                            submittedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                color: fillColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: focusedBorderColor),
                              ),
                            ),

                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50,),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child:const Text("Didn't receive any code?",style: TextStyle(color: Colors.black),),
                      ),

                      GestureDetector(
                        onTap: (){
                          ResendOtp_Api();
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15),
                          child: Text("RESEND",style: TextStyle(color: ColorValues.Splash_bg_color1),),
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 10,),

                GestureDetector(
                  onTap: (){
                    resend_status==true?
                    Otp=Otp_resend:
                    Otp=Otp;

                    if(pinController.text==""||pinController.text==null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Enter OTP.',style: TextStyle(color: Colors.white)),
                          duration:Duration(seconds: 3),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }

                    else if(pinController.text!=Otp){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Enter Valid OTP.',style: TextStyle(color: Colors.white)),
                          duration:Duration(seconds: 3),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }

                    else{
                      Otp_Api();
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
                    child: Container(
                      height: 50,
                      margin:const EdgeInsets.only(left: 30, right: 30),
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
                            "Verify",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
                          )
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
          child: AlertDialog(
            insetPadding:const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              height: 120, // Static height
              width: 50,  // Static width
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.black),
                   const SizedBox(height: 10),
                    Text(
                      "Verifying..",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  GoBack() {
    return showModalBottomSheet(
      shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8)
        )
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(top: 15, left: 15),
                        child: const Text(
                          "Are you sure you want to go back ?",
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 2.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: ColorValues.Splash_bg_color1,
                                        width: 0.4)),
                                alignment: Alignment.center,
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                      color: ColorValues.Splash_bg_color1),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                int count = 0;
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 2.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                    Border.all(color: ColorValues.Splash_bg_color1, width: 0.4),
                                    color: ColorValues.Splash_bg_color1
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ));
            });
      },
    );
  }

}
