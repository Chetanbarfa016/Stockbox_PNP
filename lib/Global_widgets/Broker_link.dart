// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:pinput/pinput.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stock_box/Constants/Colors.dart';
// import 'package:http/http.dart' as http;
// import 'package:stock_box/Constants/Util.dart';
// import 'package:stock_box/Screens/Main_screen/Broker/Webview_broker.dart';
// import 'package:stock_box/Screens/Main_screen/Dashboard.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// //Angel
// TextEditingController api_key = TextEditingController();
//
// //Alice
// TextEditingController app_code = TextEditingController();
// TextEditingController user_id = TextEditingController();
// TextEditingController api_secret = TextEditingController();
//
//
// //Kotak Neo
// // TextEditingController api_key_kotak = TextEditingController(text: "5R5E2GrofAe3G3fCzdPRMrkN6D4a");
// // TextEditingController api_secret_kotak = TextEditingController(text: '7MrROwMJJiIP1SFZt3aJfoYJ6rUa');
// // TextEditingController user_name_kotak = TextEditingController(text: "client21830");
// // TextEditingController password_kotak = TextEditingController(text: "Sneh@1976");
//
// //Kotak Neo
// TextEditingController api_key_kotak = TextEditingController(text: "");
// TextEditingController api_secret_kotak = TextEditingController(text: '');
// TextEditingController user_name_kotak = TextEditingController(text: "");
// TextEditingController password_kotak = TextEditingController(text: "");
//
// //Market Hub
// TextEditingController api_key_markethub =TextEditingController();
// TextEditingController api_secret_markethub =TextEditingController();
// TextEditingController password_markethub =TextEditingController();
//
// final pinController = TextEditingController();
// final focusNode = FocusNode();
//
// String? Url;
// bool? Status_broker;
//
// BrokerConnect_Api(brokerid,context) async {
//  SharedPreferences prefs= await SharedPreferences.getInstance();
//  String? Id_brokerconnect = prefs.getString('Login_id');
//
//  // print("111: $Id_brokerconnect");
//  // print("222: ${api_key.text}");
//  // print("333: ${api_secret.text}");
//  // print("444: ${user_id.text}");
//  // print("555: $brokerid");
//
//  var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/brokerlink"),
//      headers: {
//       'Content-Type': 'application/json',
//      },
//      body:jsonEncode(
//          {
//           "id":"$Id_brokerconnect",
//           "apikey":"${api_key.text}",
//           "apisecret":"${api_secret.text}",
//           "alice_userid":"${user_id.text}",
//           "brokerid" :"$brokerid"
//          }
//      )
//  );
//  var jsonString = jsonDecode(response.body);
//  print("Jsnnnnnn: $jsonString");
//  Status_broker=jsonString['status'];
//  // print("Status broker : $Status_broker");
//
//  if(Status_broker==true){
//   Url=jsonString['url'];
//   print("Urllllll22222: $Url");
//   Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url, Broker_idd:brokerid,aliceuser_id:user_id.text)));
//   api_key.clear();
//  }
//
//  else{
//   print("Hello");
//  }
//
// }
//
// void copyToClipboard(BuildContext context, String text) {
//  Clipboard.setData(ClipboardData(text: text));
//
//  Fluttertoast.showToast(
//      backgroundColor: Colors.black,
//      msg: "Copied to clipboard!",
//      textColor: Colors.white
//  );
// }
//
//
// class Add_Broker{
//  static Broker_link(context){
//   return showModalBottomSheet(
//    shape:const RoundedRectangleBorder(
//     borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(10),
//         topRight: Radius.circular(10)
//     ),
//    ),
//    clipBehavior: Clip.antiAliasWithSaveLayer,
//    isScrollControlled:true,
//    context: context,
//    builder: (BuildContext context) {
//     return StatefulBuilder(
//         builder: (BuildContext ctx, StateSetter setState) {
//          return Container(
//              height: MediaQuery.of(context).size.height/3,
//              child:Column(
//               children: [
//                Container(
//                 alignment: Alignment.topLeft,
//                 margin:const EdgeInsets.only(top: 15,left: 15),
//                 child:const Text("Supported Broker",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w500),),
//                ),
//
//                Container(
//                 margin:const EdgeInsets.only(top: 25,left: 15,right: 15,bottom: 10),
//                 child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: [
//
//                   GestureDetector(
//                    onTap: (){
//                     Broker_connect_aliceBlue_popup(context);
//                    },
//                    child: Container(
//                     height: 70,
//                     width:70,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                         border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4)
//                     ),
//                     alignment: Alignment.center,
//                     child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                       Container(
//                        child: Image.asset("images/alice_blue.png",height: 35,width: 35,),
//                       ),
//                       Container(
//                           margin:const EdgeInsets.only(top: 3),
//                           child:const Text("Alice Blue",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
//                       ),
//                      ],
//                     ),
//                    ),
//                   ),
//
//                   GestureDetector(
//                    onTap: () async {
//                     Broker_connect_angel_popup(context);
//                    },
//                    child: Container(
//                        height: 70,
//                        width:70,
//                        alignment: Alignment.center,
//                        margin:const EdgeInsets.only(left: 15),
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            border: Border.all(color: Colors.black,width: 0.4),
//                            color: Colors.white
//                        ),
//                        child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                          Container(
//                           child: Image.asset("images/angel_one.png",height: 35,width: 35,),
//                          ),
//                          Container(
//                              margin:const EdgeInsets.only(top: 3),
//                              child:const Text("Angel One",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
//                          ),
//                         ],
//                        )
//                    ),
//                   ),
//
//                   GestureDetector(
//                    onTap: () async {
//                     Broker_connect_KotakNeo_popup(context);
//                    },
//                    child: Container(
//                        height: 70,
//                        width:70,
//                        alignment: Alignment.center,
//                        margin:const EdgeInsets.only(left: 15),
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            border: Border.all(color: Colors.black,width: 0.4),
//                            color: Colors.white
//                        ),
//                        child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                          Container(
//                           child: Image.asset("images/kotak.png",height: 35,width: 35,),
//                          ),
//                          Container(
//                              margin:const EdgeInsets.only(top: 3),
//                              child:const Text("Kotak Neo",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
//                          ),
//                         ],
//                        )
//                    ),
//                   ),
//
//                   GestureDetector(
//                    onTap: (){
//                     Broker_connect_marketHub_popup(context);
//                    },
//                    child: Container(
//                     height: 70,
//                     width:70,
//                     margin:const EdgeInsets.only(left: 15),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                         border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4)
//                     ),
//                     alignment: Alignment.center,
//                     child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                       Container(
//                        margin:const EdgeInsets.only(top: 2),
//                        clipBehavior: Clip.antiAliasWithSaveLayer,
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(6)
//                        ),
//                        child: Image.asset("images/markethub.png",height: 25,width: 25,),
//                       ),
//                       Container(
//                           margin:const EdgeInsets.only(top: 8,),
//                           child: Container(
//                               child:const Text("Market Hub",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),))
//                       ),
//                      ],
//                     ),
//                    ),
//                   ),
//                  ],
//                 ),
//                ),
//
//                Container(
//                 margin:const EdgeInsets.only(top: 15,left: 17,right: 15,bottom: 10),
//                 child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//
//                   GestureDetector(
//                    onTap: (){
//                     Broker_connect_Zerodha_popup(context);
//                    },
//                    child: Container(
//                     height: 70,
//                     width:70,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                         border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4)
//                     ),
//                     alignment: Alignment.center,
//                     child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                       Container(
//                        child: Image.asset("images/zerodha.png",height: 35,width: 35,),
//                       ),
//                       Container(
//                           margin:const EdgeInsets.only(top: 3),
//                           child:const Text("Zerodha",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
//                       ),
//                      ],
//                     ),
//                   ),
//                 ),
//
//                   GestureDetector(
//                    onTap: () async {
//                     Broker_connect_UpStox_popup(context);
//                    },
//                    child: Container(
//                        height: 70,
//                        width:70,
//                        alignment: Alignment.center,
//                        margin:const EdgeInsets.only(left: 15),
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            border: Border.all(color: Colors.black,width: 0.4),
//                            color: Colors.white
//                        ),
//                        child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                          Container(
//                           child: Image.asset("images/upstox.png",height: 30,width: 30,),
//                          ),
//                          Container(
//                              margin:const EdgeInsets.only(top: 5),
//                              child:const Text("UpStox",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
//                          ),
//                         ],
//                        )
//                    ),
//                   ),
//
//                   GestureDetector(
//                    onTap: () async {
//                     Broker_connect_Dhan_popup(context);
//                    },
//                    child: Container(
//                        height: 70,
//                        width:70,
//                        alignment: Alignment.center,
//                        margin:const EdgeInsets.only(left: 15),
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            border: Border.all(color: Colors.black,width: 0.4),
//                            color: Colors.white
//                        ),
//                        child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                          Container(
//                           child: Image.asset("images/dhan.png",height: 30,width: 30,),
//                          ),
//                          Container(
//                              margin:const EdgeInsets.only(top: 5),
//                              child:const Text("Dhan",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
//                          ),
//                         ],
//                        )
//                    ),
//                   ),
//
//                  ],
//                 ),
//                ),
//
//
//               ],
//              )
//          );
//         }
//     );
//
//
//
//    },
//   );
//  }
//
//
//
//
//
//
//  //Angle Broker
//  static Broker_connect_angel_popup(context) {
//
//   return showModalBottomSheet(
//    shape:const RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(10),
//            topRight: Radius.circular(10)
//        )
//    ),
//    clipBehavior: Clip.antiAliasWithSaveLayer,
//    isScrollControlled: true,
//    context: context,
//    builder: (BuildContext context) {
//     return StatefulBuilder(
//      builder: (BuildContext ctx, StateSetter setState) {
//       return Padding(
//        padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//        ),
//        child: SingleChildScrollView(
//         child: Container(
//          padding: const EdgeInsets.all(16.0),
//          constraints: BoxConstraints(
//           minHeight: MediaQuery.of(context).size.height / 3,
//          ),
//          child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//
//           children: [
//            Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//              GestureDetector(
//               onTap: (){
//                AngelOne_Process_popup(context);
//               },
//               child: Container(
//                alignment: Alignment.center,
//                height: 25,
//                width: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(8),
//                    color: Colors.grey.shade300
//                ),
//                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
//               ),
//              ),
//             ],
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Key",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Key';
//               }
//               return null;
//              },
//              controller: api_key,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Api Key",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            GestureDetector(
//             onTap: () {
//              api_secret.text = '';
//              user_id.text = '';
//              BrokerConnect_Api("1",context);
//             },
//             child: Card(
//              clipBehavior: Clip.antiAliasWithSaveLayer,
//              color: Colors.transparent,
//              shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//              ),
//              elevation: 0,
//              child: Container(
//               height: 45,
//               alignment: Alignment.topLeft,
//               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
//               width: MediaQuery.of(context).size.width / 3,
//               decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(8),
//                color: Colors.grey.shade200,
//                gradient: const LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 stops: [
//                  0.1,
//                  0.5,
//                 ],
//                 colors: [
//                  ColorValues.Splash_bg_color1,
//                  ColorValues.Splash_bg_color1,
//                 ],
//                ),
//               ),
//               child: Container(
//                alignment: Alignment.center,
//                child: const Text(
//                 "Submit",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                     color: Colors.white),
//                ),
//               ),
//              ),
//             ),
//            ),
//           ],
//          ),
//         ),
//        ),
//       );
//      },
//     );
//    },
//   );
//  }
//  static AngelOne_Process_popup(context) async {
//   String? AngelRedirectUrl;
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   AngelRedirectUrl=prefs.getString("AngelRedirectUrl");
//
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//        int _currentStep = 0;
//        return StatefulBuilder(
//            builder: (BuildContext context, StateSetter setState) {
//             tapped(int step) {
//              setState(() => _currentStep = step);
//             }
//             continued() {
//              _currentStep < 2 ? setState(() => _currentStep += 1) : null;
//             }
//             cancel() {
//              _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
//             }
//             return Container(
//              height: 400,
//              margin: const EdgeInsets.only(left: 15, right: 15),
//              width: MediaQuery.of(context).size.width,
//              child: AlertDialog(
//               insetPadding: EdgeInsets.zero,
//               elevation: 0,
//               title: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                 Container(
//                     child: const Text(
//                      'Process Detail',
//                      style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
//                     )),
//                 GestureDetector(
//                  onTap: () {
//                   Navigator.pop(context);
//                  },
//                  child: Container(
//                   alignment: Alignment.topRight,
//                   child: const Icon(
//                    Icons.clear,
//                    color: Colors.black,
//                   ),
//                  ),
//                 ),
//                ],
//               ),
//               content: Container(
//                height:400,
//                width: MediaQuery.of(context).size.width,
//                child: SingleChildScrollView(
//                    scrollDirection: Axis.vertical,
//                    child: Column(
//                     children: [
//                      Container(
//                       child:const Text("Kindly follow these steps to link your demat account.",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
//                      ),
//                      Container(
//                       margin: const EdgeInsets.only(top: 5),
//                       child: Stepper(
//                        physics: const ScrollPhysics(),
//                        currentStep: _currentStep,
//                        onStepTapped: (step) => tapped(step),
//                        onStepContinue: continued,
//                        onStepCancel: cancel,
//                        controlsBuilder: (context, controller) {
//                         return const SizedBox.shrink();
//                        },
//                        steps: <Step>[
//                         Step(
//                          title: const Text('Click below link and Login',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            GestureDetector(
//                                onTap: () async {
//                                 String? url="https://smartapi.angelbroking.com/";
//                                 if (await canLaunch(url)) {
//                                  await launch(url);
//                                 } else {
//                                  throw 'Could not launch $url';
//                                 }
//                                },
//                                child: Container(child:const Text("https://smartapi.angelbroking.com/",style: TextStyle(color: ColorValues.Splash_bg_color1,fontSize: 13),),))
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 0
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                         Step(
//                          title: const Text('Enter your Details and the Redirect URL which is given below.',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            Container(
//                             // width: MediaQuery.of(context).size.width/2.2,
//                             child: Text("$AngelRedirectUrl",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
//                            ),
//
//                            Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                              GestureDetector(
//                               onTap: () => copyToClipboard(context, "$AngelRedirectUrl"),
//                               child: Container(
//                                height: 25,
//                                width: 40,
//                                margin:const EdgeInsets.only(left: 20,top: 7),
//                                decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
//                                 gradient:const LinearGradient(
//                                  begin: Alignment.topRight,
//                                  end: Alignment.bottomLeft,
//                                  stops: [
//                                   0.1,
//                                   0.5,
//                                  ],
//                                  colors: [
//                                   ColorValues.Splash_bg_color1,
//                                   ColorValues.Splash_bg_color1,
//                                  ],
//                                 ),
//                                ),
//                                alignment: Alignment.center,
//                                child:const Icon(Icons.copy,color: Colors.white,size: 15,),
//                               ),
//                              )
//                             ],
//                            )
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 1
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                        ],
//                       ),
//                      ),
//                     ],
//                    )
//                ),
//               ),
//              ),
//             );
//            });
//       }) ??
//       false;
//  }
//
//
//  //Alice Broker
//  static Broker_connect_aliceBlue_popup(context) {
//   return showModalBottomSheet(
//    shape:const RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(10),
//            topRight: Radius.circular(10)
//        )
//    ),
//    clipBehavior: Clip.antiAliasWithSaveLayer,
//    isScrollControlled: true,
//    context: context,
//    builder: (BuildContext context) {
//     return StatefulBuilder(
//      builder: (BuildContext ctx, StateSetter setState) {
//       return Padding(
//        // Add padding at the bottom when the keyboard is open
//        padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//        ),
//        child: SingleChildScrollView(
//         child: Container(
//          padding: const EdgeInsets.all(16.0),
//          constraints: BoxConstraints(
//           minHeight: MediaQuery.of(context).size.height / 1.8,
//          ),
//          child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//            Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//              GestureDetector(
//               onTap: (){
//                Alice_Process_popup(context);
//               },
//               child: Container(
//                alignment: Alignment.center,
//                height: 25,
//                width: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(8),
//                    color: Colors.grey.shade300
//                ),
//                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
//               ),
//              ),
//             ],
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "App Code",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter App Code';
//               }
//               return null;
//              },
//              controller: api_key,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter App Code",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "User Id",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter User Id';
//               }
//               return null;
//              },
//              controller: user_id,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter User Id",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Secret",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Secret';
//               }
//               return null;
//              },
//              controller: api_secret,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Secret",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//            GestureDetector(
//             onTap: () {
//              BrokerConnect_Api("2",context);
//             },
//             child: Card(
//              clipBehavior: Clip.antiAliasWithSaveLayer,
//              color: Colors.transparent,
//              shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//              ),
//              elevation: 0,
//              child: Container(
//               height: 45,
//               alignment: Alignment.topLeft,
//               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
//               width: MediaQuery.of(context).size.width / 3,
//               decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(8),
//                color: Colors.grey.shade200,
//                gradient: const LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 stops: [0.1, 0.5],
//                 colors: [
//                  ColorValues.Splash_bg_color1,
//                  ColorValues.Splash_bg_color1,
//                 ],
//                ),
//               ),
//               child: Container(
//                alignment: Alignment.center,
//                child: const Text(
//                 "Submit",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                     color: Colors.white),
//                ),
//               ),
//              ),
//             ),
//            ),
//           ],
//          ),
//         ),
//        ),
//       );
//      },
//     );
//    },
//   );
//  }
//  static Alice_Process_popup(context) async {
//   String? AliceRedirectUrl;
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   AliceRedirectUrl=prefs.getString("AliceRedirectUrl");
//
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//        int _currentStep = 0;
//        return StatefulBuilder(
//            builder: (BuildContext context, StateSetter setState) {
//             tapped(int step) {
//              setState(() => _currentStep = step);
//             }
//             continued() {
//              _currentStep < 2 ? setState(() => _currentStep += 1) : null;
//             }
//             cancel() {
//              _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
//             }
//             return Container(
//              height: 400,
//              margin: const EdgeInsets.only(left: 15, right: 15),
//              width: MediaQuery.of(context).size.width,
//              child: AlertDialog(
//               insetPadding: EdgeInsets.zero,
//               elevation: 0,
//               title: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                 Container(
//                     child: const Text(
//                      'Process Detail',
//                      style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
//                     )),
//                 GestureDetector(
//                  onTap: () {
//                   Navigator.pop(context);
//                  },
//                  child: Container(
//                   alignment: Alignment.topRight,
//                   child: const Icon(
//                    Icons.clear,
//                    color: Colors.black,
//                   ),
//                  ),
//                 ),
//                ],
//               ),
//               content: Container(
//                height:400,
//                width: MediaQuery.of(context).size.width,
//                child: SingleChildScrollView(
//                    scrollDirection: Axis.vertical,
//                    child: Column(
//                     children: [
//                      Container(
//                       child:const Text("Kindly follow these steps to link your demat account.",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
//                      ),
//                      Container(
//                       margin: const EdgeInsets.only(top: 5),
//                       child: Stepper(
//                        physics: const ScrollPhysics(),
//                        currentStep: _currentStep,
//                        onStepTapped: (step) => tapped(step),
//                        onStepContinue: continued,
//                        onStepCancel: cancel,
//                        controlsBuilder: (context, controller) {
//                         return const SizedBox.shrink();
//                        },
//                        steps: <Step>[
//                         Step(
//                          title: const Text('Click below link and Login',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            GestureDetector(
//                                onTap: () async {
//                                 String? url="https://ant.aliceblueonline.com/?appcode=G9EOSWCEIF9ARCB";
//                                 if (await canLaunch(url)) {
//                                  await launch(url);
//                                 } else {
//                                  throw 'Could not launch $url';
//                                 }
//                                },
//                                child: Container(child:const Text("https://ant.aliceblueonline.com/?appcode=G9EOSWCEIF9ARCB",style: TextStyle(color: ColorValues.Splash_bg_color1,fontSize: 13),),))
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 0
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                         Step(
//                          title: const Text('Enter your Details and the Redirect URL which is given below.',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            Container(
//                             // width: MediaQuery.of(context).size.width/2.2,
//                             child: Text("$AliceRedirectUrl",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
//                            ),
//
//                            Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                              GestureDetector(
//                               onTap: () => copyToClipboard(context, "$AliceRedirectUrl"),
//                               child: Container(
//                                height: 25,
//                                width: 40,
//                                margin:const EdgeInsets.only(left: 20,top: 7),
//                                decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
//                                 gradient:const LinearGradient(
//                                  begin: Alignment.topRight,
//                                  end: Alignment.bottomLeft,
//                                  stops: [
//                                   0.1,
//                                   0.5,
//                                  ],
//                                  colors: [
//                                   ColorValues.Splash_bg_color1,
//                                   ColorValues.Splash_bg_color1,
//                                  ],
//                                 ),
//                                ),
//                                alignment: Alignment.center,
//                                child:const Icon(Icons.copy,color: Colors.white,size: 15),
//                               ),
//                              )
//                             ],
//                            )
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 1
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                        ],
//                       ),
//                      ),
//                     ],
//                    )
//                ),
//               ),
//              ),
//             );
//            });
//       }) ??
//       false;
//  }
//
//
//  //Kotak_Neo Broker
//  static Broker_connect_KotakNeo_popup(context) {
//   String? messageotp_kotak;
//   bool? Statusotp_kotak;
//
//
//   Otp_Api_Kotakneo(context) async {
//    SharedPreferences prefs= await SharedPreferences.getInstance();
//    // String? Id_otp_kotak = prefs.getString('Login_id');
//    // SharedPreferences prefs= await SharedPreferences.getInstance();
//    String? Id_brokerconnect = prefs.getString('Login_id');
//    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/kotakneo/checkotp"),
//        body:{
//         // 'id': '$Id_otp_kotak',
//         'id': '$Id_brokerconnect',
//         'otp': '${pinController.text}',
//        }
//    );
//    var jsonString = jsonDecode(response.body);
//    print("Jsnnnnnn: $jsonString");
//    messageotp_kotak=jsonString['message'];
//    Statusotp_kotak=jsonString['status'];
//
//    print("Status Otp: $Statusotp_kotak");
//
//    if(Statusotp_kotak==true){
//     ScaffoldMessenger.of(context).showSnackBar(
//      const SnackBar(
//       content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
//       duration: Duration(seconds: 3),
//       backgroundColor: Colors.green,
//      ),
//     );
//     Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));
//    }
//
//    else{
//     ScaffoldMessenger.of(context).showSnackBar(
//      const SnackBar(
//       content: Text('Error Connecting Broker',style: TextStyle(color: Colors.white)),
//       duration:Duration(seconds: 3),
//       backgroundColor: Colors.red,
//       behavior: SnackBarBehavior.floating,
//      ),
//     );
//     // Navigator.pop(context);
//    }
//   }
//
//   KotakNeo_Password_popup(context) {
//    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
//    const fillColor = Color.fromRGBO(243, 246, 249, 0);
//    const borderColor = ColorValues.Splash_bg_color1;
//
//    final defaultPinTheme = PinTheme(
//     width: 50,
//     height: 50,
//     // padding: EdgeInsets.only(left: 10,right: 10),
//     margin:const EdgeInsets.only(left: 6,right: 6),
//     textStyle: const TextStyle(
//      fontSize: 22,
//      color: Color.fromRGBO(30, 60, 87, 1),
//     ),
//     decoration: BoxDecoration(
//      borderRadius: BorderRadius.circular(10),
//      border: Border.all(color: borderColor),
//     ),
//    );
//    return showModalBottomSheet(
//     shape:const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10)
//         )
//     ),
//     clipBehavior: Clip.antiAliasWithSaveLayer,
//     isScrollControlled: true,
//     context: context,
//     builder: (BuildContext context) {
//      return StatefulBuilder(
//       builder: (BuildContext ctx, StateSetter setState) {
//        return Padding(
//         // Add padding at the bottom when the keyboard is open
//         padding: EdgeInsets.only(
//          bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: SingleChildScrollView(
//          child: Container(
//           padding: const EdgeInsets.all(16.0),
//           constraints: BoxConstraints(
//            minHeight: MediaQuery.of(context).size.height / 2.8,
//           ),
//           child: Column(
//            mainAxisSize: MainAxisSize.min,
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//             // Row(
//             //  mainAxisAlignment: MainAxisAlignment.end,
//             //  children: [
//             //   GestureDetector(
//             //    onTap: (){
//             //     Alice_Process_popup(context);
//             //    },
//             //    child: Container(
//             //     alignment: Alignment.center,
//             //     height: 25,
//             //     width: 100,
//             //     decoration: BoxDecoration(
//             //         borderRadius: BorderRadius.circular(8),
//             //         color: Colors.grey.shade300
//             //     ),
//             //     child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
//             //    ),
//             //   ),
//             //  ],
//             // ),
//             Container(
//              alignment: Alignment.topLeft,
//              margin: const EdgeInsets.only(top: 20, left: 20),
//              child: const Text(
//               "Otp Verification",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//              ),
//             ),
//             Container(
//              alignment: Alignment.topLeft,
//              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//              child: Directionality(
//               textDirection: TextDirection.ltr,
//               child: Pinput(
//                length: 4,
//                controller: pinController,
//                focusNode: focusNode,
//                defaultPinTheme: defaultPinTheme,
//                separatorBuilder: (index) => const SizedBox(width: 8),
//                hapticFeedbackType: HapticFeedbackType.lightImpact,
//                onCompleted: (pin) {
//                 debugPrint('onCompleted: $pin');
//                },
//                onChanged: (value) {
//                 debugPrint('onChanged: $value');
//                },
//                cursor: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                  Container(
//                   margin: const EdgeInsets.only(bottom: 9, left: 5, right: 5),
//                   width: 22,
//                   height: 1,
//                   color: focusedBorderColor,
//                  ),
//                 ],
//                ),
//
//                focusedPinTheme: defaultPinTheme.copyWith(
//                 decoration: defaultPinTheme.decoration!.copyWith(
//                  borderRadius: BorderRadius.circular(10),
//                  border: Border.all(color: focusedBorderColor),
//                 ),
//                ),
//
//                submittedPinTheme: defaultPinTheme.copyWith(
//                 decoration: defaultPinTheme.decoration!.copyWith(
//                  color: fillColor,
//                  borderRadius: BorderRadius.circular(10),
//                  border: Border.all(color: focusedBorderColor),
//                 ),
//                ),
//
//               ),
//              ),
//             ),
//
//
//
//
//             GestureDetector(
//              onTap: () {
//               Otp_Api_Kotakneo(context);
//
//              },
//              child: Card(
//               clipBehavior: Clip.antiAliasWithSaveLayer,
//               color: Colors.transparent,
//               shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(8),
//               ),
//               elevation: 0,
//               child: Container(
//                height: 45,
//                alignment: Alignment.topLeft,
//                margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
//                width: MediaQuery.of(context).size.width / 3,
//                decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.grey.shade200,
//                 gradient: const LinearGradient(
//                  begin: Alignment.topRight,
//                  end: Alignment.bottomLeft,
//                  stops: [0.1, 0.5],
//                  colors: [
//                   ColorValues.Splash_bg_color1,
//                   ColorValues.Splash_bg_color1,
//                  ],
//                 ),
//                ),
//                child: Container(
//                 alignment: Alignment.center,
//                 child: const Text(
//                  "Submit",
//                  style: TextStyle(
//                      fontWeight: FontWeight.w700,
//                      fontSize: 18,
//                      color: Colors.white),
//                 ),
//                ),
//               ),
//              ),
//             )
//            ],
//           ),
//          ),
//         ),
//        );
//       },
//      );
//     },
//    );
//   }
//
//   bool? Status_Kotakneo;
//   BrokerConnect_KotakNeo_Api(context) async {
//    SharedPreferences prefs= await SharedPreferences.getInstance();
//    String? Id_brokerconnect_kotak = prefs.getString('Login_id');
//    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/kotakneo/getaccesstoken"),
//        headers: {
//         'Content-Type': 'application/json',
//        },
//        body:jsonEncode(
//            {
//             // "id":"$Id_brokerconnect_kotak",
//             "id":"$Id_brokerconnect_kotak",
//             "apikey":"${api_key_kotak.text}",
//             "apisecret":"${api_secret_kotak.text}",
//             "user_name":"${user_name_kotak.text}",
//             "pass_word":"${password_kotak.text}",
//            }
//        )
//    );
//    var jsonString = jsonDecode(response.body);
//    print("JsnnnnnnPayout: $jsonString");
//    Status_Kotakneo=jsonString['status'];
//
//    if(Status_Kotakneo==true){
//     KotakNeo_Password_popup(context);
//     api_key_kotak.clear();
//     api_secret_kotak.clear();
//     user_name_kotak.clear();
//     password_kotak.clear();
//    }
//
//    else{
//     print("Hello");
//    }
//
//   }
//
//   return showModalBottomSheet(
//    shape:const RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(10),
//            topRight: Radius.circular(10)
//        )
//    ),
//    clipBehavior: Clip.antiAliasWithSaveLayer,
//    isScrollControlled: true,
//    context: context,
//    builder: (BuildContext context) {
//     return StatefulBuilder(
//      builder: (BuildContext ctx, StateSetter setState) {
//       return Padding(
//        // Add padding at the bottom when the keyboard is open
//        padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//        ),
//        child: SingleChildScrollView(
//         child: Container(
//          padding: const EdgeInsets.all(16.0),
//          constraints: BoxConstraints(
//           minHeight: MediaQuery.of(context).size.height / 1.8,
//          ),
//          child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//            Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//              GestureDetector(
//               onTap: (){
//                KotakNeo_Process_popup(context);
//               },
//               child: Container(
//                alignment: Alignment.center,
//                height: 25,
//                width: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(8),
//                    color: Colors.grey.shade300
//                ),
//                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
//               ),
//              ),
//             ],
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Key",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Key';
//               }
//               return null;
//              },
//              controller: api_key_kotak,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Key",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Secret",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Secret';
//               }
//               return null;
//              },
//              controller: api_secret_kotak,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Secret",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "User Name",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter User Name';
//               }
//               return null;
//              },
//              controller: user_name_kotak,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter User Name",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Password",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Password';
//               }
//               return null;
//              },
//              controller: password_kotak,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Password",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            GestureDetector(
//             onTap: () {
//              BrokerConnect_KotakNeo_Api(context);
//             },
//             child: Card(
//              clipBehavior: Clip.antiAliasWithSaveLayer,
//              color: Colors.transparent,
//              shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//              ),
//              elevation: 0,
//              child: Container(
//               height: 45,
//               alignment: Alignment.topLeft,
//               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
//               width: MediaQuery.of(context).size.width / 3,
//               decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(8),
//                color: Colors.grey.shade200,
//                gradient: const LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 stops: [0.1, 0.5],
//                 colors: [
//                  ColorValues.Splash_bg_color1,
//                  ColorValues.Splash_bg_color1,
//                 ],
//                ),
//               ),
//               child: Container(
//                alignment: Alignment.center,
//                child: const Text(
//                 "Submit",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                     color: Colors.white),
//                ),
//               ),
//              ),
//             ),
//            ),
//           ],
//          ),
//         ),
//        ),
//       );
//      },
//     );
//    },
//   );
//  }
//  static KotakNeo_Process_popup(context) async {
//   String? AliceRedirectUrl;
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   AliceRedirectUrl=prefs.getString("AliceRedirectUrl");
//
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//        int _currentStep = 0;
//        return StatefulBuilder(
//            builder: (BuildContext context, StateSetter setState) {
//             tapped(int step) {
//              setState(() => _currentStep = step);
//             }
//             continued() {
//              _currentStep < 2 ? setState(() => _currentStep += 1) : null;
//             }
//             cancel() {
//              _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
//             }
//             return Container(
//              height: 400,
//              margin: const EdgeInsets.only(left: 15, right: 15),
//              width: MediaQuery.of(context).size.width,
//              child: AlertDialog(
//               insetPadding: EdgeInsets.zero,
//               elevation: 0,
//               title: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                 Container(
//                     child: const Text(
//                      'Process Detail',
//                      style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
//                     )),
//                 GestureDetector(
//                  onTap: () {
//                   Navigator.pop(context);
//                  },
//                  child: Container(
//                   alignment: Alignment.topRight,
//                   child: const Icon(
//                    Icons.clear,
//                    color: Colors.black,
//                   ),
//                  ),
//                 ),
//                ],
//               ),
//               content: Container(
//                height:400,
//                width: MediaQuery.of(context).size.width,
//                child: SingleChildScrollView(
//                    scrollDirection: Axis.vertical,
//                    child: Column(
//                     children: [
//                      Container(
//                       child:const Text("Kindly follow instruction as your broker or sub broker link guide to you and update our link and connect your demat.",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
//                      ),
//                      Container(
//                       margin: const EdgeInsets.only(top: 5),
//                       child: Stepper(
//                        physics: const ScrollPhysics(),
//                        currentStep: _currentStep,
//                        onStepTapped: (step) => tapped(step),
//                        onStepContinue: continued,
//                        onStepCancel: cancel,
//                        controlsBuilder: (context, controller) {
//                         return const SizedBox.shrink();
//                        },
//                        steps: <Step>[
//                         Step(
//                          title: const Text('Click below link and Login',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            GestureDetector(
//                                onTap: () async {
//                                 String? url="https://tradeapi.kotaksecurities.com/devportal/apis";
//                                 if (await canLaunch(url)) {
//                                  await launch(url);
//                                 } else {
//                                  throw 'Could not launch $url';
//                                 }
//                                },
//                                child: Container(child:const Text("https://tradeapi.kotaksecurities.com/devportal/apis",style: TextStyle(color: Colors.blue,fontSize: 13),),))
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 0
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//
//                         Step(
//                          title: const Text('Enter your Details and the Redirect URL which is given below.',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            Container(
//                             // width: MediaQuery.of(context).size.width/2.2,
//                             child:const Text("Login account and click default application and next click on the production key in the sidebar and the consumer key and consumer secret update on your profile and demat password and trading API password both update on your profile. The access code generated is sent to the registered email address & mobile number. A generated access code is valid for the day (till 11:59:59 pm on the same day).",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
//                            ),
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 1
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                        ],
//                       ),
//                      ),
//                     ],
//                    )
//                ),
//               ),
//              ),
//             );
//            });
//       }) ??
//       false;
//  }
//
//
//
//  //Market Hub Broker
//  static Broker_connect_marketHub_popup(context) {
//
//   bool? Status_marketHub;
//   BrokerConnect_MarketHub_Api(context) async {
//    SharedPreferences prefs= await SharedPreferences.getInstance();
//    String? Id_brokerconnect_markethub = prefs.getString('Login_id');
//
//    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/markethub/getaccesstoken"),
//        headers: {
//         'Content-Type': 'application/json',
//        },
//        body:jsonEncode(
//            {
//             // "id":"$Id_brokerconnect_kotak",
//             "id":"$Id_brokerconnect_markethub",
//             "apikey":"${api_key_markethub.text}",
//             "apisecret":"${api_secret_markethub.text}",
//             "pass_word":"${password_markethub.text}",
//            }
//        )
//    );
//    var jsonString = jsonDecode(response.body);
//    print("JsnnnnnnPayout: $jsonString");
//    Status_marketHub=jsonString['status'];
//
//    if(Status_marketHub==true){
//     ScaffoldMessenger.of(context).showSnackBar(
//      const SnackBar(
//       content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
//       duration: Duration(seconds: 3),
//       backgroundColor: Colors.green,
//      ),
//     );
//     Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));
//
//     api_key_markethub.clear();
//     api_secret_markethub.clear();
//     password_markethub.clear();
//    }
//
//    else{
//     ScaffoldMessenger.of(context).showSnackBar(
//      const SnackBar(
//       content: Text('Error Connecting Broker',style: TextStyle(color: Colors.white)),
//       duration: Duration(seconds: 3),
//       backgroundColor: Colors.red,
//      ),
//     );
//     Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));
//    }
//
//   }
//
//   return showModalBottomSheet(
//    shape:const RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(10),
//            topRight: Radius.circular(10)
//        )
//    ),
//    clipBehavior: Clip.antiAliasWithSaveLayer,
//    isScrollControlled: true,
//    context: context,
//    builder: (BuildContext context) {
//     return StatefulBuilder(
//      builder: (BuildContext ctx, StateSetter setState) {
//       return Padding(
//        // Add padding at the bottom when the keyboard is open
//        padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//        ),
//        child: SingleChildScrollView(
//         child: Container(
//          padding: const EdgeInsets.all(16.0),
//          constraints: BoxConstraints(
//           minHeight: MediaQuery.of(context).size.height / 1.8,
//          ),
//          child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//            Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//              GestureDetector(
//               onTap: (){
//                MarketHub_Process_popup(context);
//               },
//               child: Container(
//                alignment: Alignment.center,
//                height: 25,
//                width: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(8),
//                    color: Colors.grey.shade300
//                ),
//                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
//               ),
//              ),
//             ],
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Key",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Key';
//               }
//               return null;
//              },
//              controller: api_key_markethub,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Key",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Secret",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Secret';
//               }
//               return null;
//              },
//              controller: api_secret_markethub,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Secret",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Password",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Password';
//               }
//               return null;
//              },
//              controller: password_markethub,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Password",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            GestureDetector(
//             onTap: () {
//              BrokerConnect_MarketHub_Api(context);
//             },
//             child: Card(
//              clipBehavior: Clip.antiAliasWithSaveLayer,
//              color: Colors.transparent,
//              shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//              ),
//              elevation: 0,
//              child: Container(
//               height: 45,
//               alignment: Alignment.topLeft,
//               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
//               width: MediaQuery.of(context).size.width / 3,
//               decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(8),
//                color: Colors.grey.shade200,
//                gradient: const LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 stops: [0.1, 0.5],
//                 colors: [
//                  ColorValues.Splash_bg_color1,
//                  ColorValues.Splash_bg_color1,
//                 ],
//                ),
//               ),
//               child: Container(
//                alignment: Alignment.center,
//                child: const Text(
//                 "Submit",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                     color: Colors.white),
//                ),
//               ),
//              ),
//             ),
//            ),
//
//           ],
//          ),
//         ),
//        ),
//       );
//      },
//     );
//    },
//   );
//  }
//  static MarketHub_Process_popup(context) async {
//   String? AliceRedirectUrl;
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   AliceRedirectUrl=prefs.getString("AliceRedirectUrl");
//
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//        int _currentStep = 0;
//        return StatefulBuilder(
//            builder: (BuildContext context, StateSetter setState) {
//             tapped(int step) {
//              setState(() => _currentStep = step);
//             }
//             continued() {
//              _currentStep < 2 ? setState(() => _currentStep += 1) : null;
//             }
//             cancel() {
//              _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
//             }
//             return Container(
//              height: 130,
//              margin: const EdgeInsets.only(left: 15, right: 15),
//              width: MediaQuery.of(context).size.width,
//              child: AlertDialog(
//               insetPadding: EdgeInsets.zero,
//               elevation: 0,
//               title: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                 Container(
//                     child: const Text(
//                      'Process Detail',
//                      style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
//                     )),
//                 GestureDetector(
//                  onTap: () {
//                   Navigator.pop(context);
//                  },
//                  child: Container(
//                   alignment: Alignment.topRight,
//                   child: const Icon(
//                    Icons.clear,
//                    color: Colors.black,
//                   ),
//                  ),
//                 ),
//                ],
//               ),
//               content: Container(
//                height:130,
//                width: MediaQuery.of(context).size.width,
//                child: SingleChildScrollView(
//                    scrollDirection: Axis.vertical,
//                    child: Column(
//                     children: [
//                      Container(
//                       child:const Text("Please Update CLIENT CODE , PASSWORD CODE And VERIFICATION CODE for all these details\nPlease contact with Market hub broker then Submit And Login With Api Trading On...",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 13),),
//                      ),
//                     ],
//                    )
//                ),
//               ),
//              ),
//             );
//            });
//       }) ??
//       false;
//  }
//
//  //Zerodha
//  static Broker_connect_Zerodha_popup(context) {
//   return showModalBottomSheet(
//    shape:const RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(10),
//            topRight: Radius.circular(10)
//        )
//    ),
//    clipBehavior: Clip.antiAliasWithSaveLayer,
//    isScrollControlled: true,
//    context: context,
//    builder: (BuildContext context) {
//     return StatefulBuilder(
//      builder: (BuildContext ctx, StateSetter setState) {
//       return Padding(
//        // Add padding at the bottom when the keyboard is open
//        padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//        ),
//        child: SingleChildScrollView(
//         child: Container(
//          padding: const EdgeInsets.all(16.0),
//          constraints: BoxConstraints(
//           minHeight: MediaQuery.of(context).size.height / 1.8,
//          ),
//          child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//            Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//              GestureDetector(
//               onTap: (){
//                Zerodha_Process_popup(context);
//               },
//               child: Container(
//                alignment: Alignment.center,
//                height: 25,
//                width: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(8),
//                    color: Colors.grey.shade300
//                ),
//                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
//               ),
//              ),
//             ],
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Key",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Key';
//               }
//               return null;
//              },
//              controller: api_key,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Key",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Secret",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Secret';
//               }
//               return null;
//              },
//              controller: api_secret,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Secret",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//            GestureDetector(
//             onTap: () {
//              user_id.text="";
//              BrokerConnect_Api("5",context);
//             },
//             child: Card(
//              clipBehavior: Clip.antiAliasWithSaveLayer,
//              color: Colors.transparent,
//              shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//              ),
//              elevation: 0,
//              child: Container(
//               height: 45,
//               alignment: Alignment.topLeft,
//               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
//               width: MediaQuery.of(context).size.width / 3,
//               decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(8),
//                color: Colors.grey.shade200,
//                gradient: const LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 stops: [0.1, 0.5],
//                 colors: [
//                  ColorValues.Splash_bg_color1,
//                  ColorValues.Splash_bg_color1,
//                 ],
//                ),
//               ),
//               child: Container(
//                alignment: Alignment.center,
//                child: const Text(
//                 "Submit",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                     color: Colors.white),
//                ),
//               ),
//              ),
//             ),
//            ),
//           ],
//          ),
//         ),
//        ),
//       );
//      },
//     );
//    },
//   );
//  }
//  static Zerodha_Process_popup(context) async {
//   String? ZerodhaRedirectUrl;
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   ZerodhaRedirectUrl=prefs.getString("ZerodhaRedirectUrl");
//
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//        int _currentStep = 0;
//        return StatefulBuilder(
//            builder: (BuildContext context, StateSetter setState) {
//             tapped(int step) {
//              setState(() => _currentStep = step);
//             }
//             continued() {
//              _currentStep < 2 ? setState(() => _currentStep += 1) : null;
//             }
//             cancel() {
//              _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
//             }
//             return Container(
//              height: 400,
//              margin: const EdgeInsets.only(left: 15, right: 15),
//              width: MediaQuery.of(context).size.width,
//              child: AlertDialog(
//               insetPadding: EdgeInsets.zero,
//               elevation: 0,
//               title: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                 Container(
//                     child: const Text(
//                      'Process Detail',
//                      style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
//                     )),
//                 GestureDetector(
//                  onTap: () {
//                   Navigator.pop(context);
//                  },
//                  child: Container(
//                   alignment: Alignment.topRight,
//                   child: const Icon(
//                    Icons.clear,
//                    color: Colors.black,
//                   ),
//                  ),
//                 ),
//                ],
//               ),
//               content: Container(
//                height:400,
//                width: MediaQuery.of(context).size.width,
//                child: SingleChildScrollView(
//                    scrollDirection: Axis.vertical,
//                    child: Column(
//                     children: [
//                      Container(
//                       child:const Text("Kindly follow these steps to link your demat account.",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
//                      ),
//                      Container(
//                       margin: const EdgeInsets.only(top: 5),
//                       child: Stepper(
//                        physics: const ScrollPhysics(),
//                        currentStep: _currentStep,
//                        onStepTapped: (step) => tapped(step),
//                        onStepContinue: continued,
//                        onStepCancel: cancel,
//                        controlsBuilder: (context, controller) {
//                         return const SizedBox.shrink();
//                        },
//                        steps: <Step>[
//                         Step(
//                          title: const Text('Click below link and Login',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            GestureDetector(
//                                onTap: () async {
//                                 String? url="https://kite.trade/";
//                                 if (await canLaunch(url)) {
//                                  await launch(url);
//                                 } else {
//                                  throw 'Could not launch $url';
//                                 }
//                                },
//                                child: Container(child:const Text("https://kite.trade/",style: TextStyle(color: ColorValues.Splash_bg_color1,fontSize: 13),),))
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 0
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                         Step(
//                          title: const Text('Enter your Details and the Redirect URL which is given below.',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            Container(
//                             // width: MediaQuery.of(context).size.width/2.2,
//                             child: Text("$ZerodhaRedirectUrl",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
//                            ),
//
//                            Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                              GestureDetector(
//                               onTap: () => copyToClipboard(context, "$ZerodhaRedirectUrl"),
//                               child: Container(
//                                height: 25,
//                                width: 40,
//                                margin:const EdgeInsets.only(left: 20,top: 7),
//                                decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
//                                 gradient:const LinearGradient(
//                                  begin: Alignment.topRight,
//                                  end: Alignment.bottomLeft,
//                                  stops: [
//                                   0.1,
//                                   0.5,
//                                  ],
//                                  colors: [
//                                   ColorValues.Splash_bg_color1,
//                                   ColorValues.Splash_bg_color1,
//                                  ],
//                                 ),
//                                ),
//                                alignment: Alignment.center,
//                                child:const Icon(Icons.copy,color: Colors.white,size: 15),
//                               ),
//                              )
//                             ],
//                            )
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 1
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                        ],
//                       ),
//                      ),
//                     ],
//                    )
//                ),
//               ),
//              ),
//             );
//            });
//       }) ??
//       false;
//  }
//
//  //UpStox
//  static Broker_connect_UpStox_popup(context) {
//   return showModalBottomSheet(
//    shape:const RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(10),
//            topRight: Radius.circular(10)
//        )
//    ),
//    clipBehavior: Clip.antiAliasWithSaveLayer,
//    isScrollControlled: true,
//    context: context,
//    builder: (BuildContext context) {
//     return StatefulBuilder(
//      builder: (BuildContext ctx, StateSetter setState) {
//       return Padding(
//        // Add padding at the bottom when the keyboard is open
//        padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//        ),
//        child: SingleChildScrollView(
//         child: Container(
//          padding: const EdgeInsets.all(16.0),
//          constraints: BoxConstraints(
//           minHeight: MediaQuery.of(context).size.height / 1.8,
//          ),
//          child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//            Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//              GestureDetector(
//               onTap: (){
//                Upstox_Process_popup(context);
//               },
//               child: Container(
//                alignment: Alignment.center,
//                height: 25,
//                width: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(8),
//                    color: Colors.grey.shade300
//                ),
//                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
//               ),
//              ),
//             ],
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Key",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Key';
//               }
//               return null;
//              },
//              controller: api_key,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Key",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Secret",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Secret';
//               }
//               return null;
//              },
//              controller: api_secret,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Secret",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//            GestureDetector(
//             onTap: () {
//              user_id.text="";
//              BrokerConnect_Api("6",context);
//             },
//             child: Card(
//              clipBehavior: Clip.antiAliasWithSaveLayer,
//              color: Colors.transparent,
//              shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//              ),
//              elevation: 0,
//              child: Container(
//               height: 45,
//               alignment: Alignment.topLeft,
//               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
//               width: MediaQuery.of(context).size.width / 3,
//               decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(8),
//                color: Colors.grey.shade200,
//                gradient: const LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 stops: [0.1, 0.5],
//                 colors: [
//                  ColorValues.Splash_bg_color1,
//                  ColorValues.Splash_bg_color1,
//                 ],
//                ),
//               ),
//               child: Container(
//                alignment: Alignment.center,
//                child: const Text(
//                 "Submit",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                     color: Colors.white),
//                ),
//               ),
//              ),
//             ),
//            ),
//           ],
//          ),
//         ),
//        ),
//       );
//      },
//     );
//    },
//   );
//  }
//  static Upstox_Process_popup(context) async {
//   String? UpstoxRedirectUrl;
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   UpstoxRedirectUrl=prefs.getString("UpstoxRedirectUrl");
//
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//        int _currentStep = 0;
//        return StatefulBuilder(
//            builder: (BuildContext context, StateSetter setState) {
//             tapped(int step) {
//              setState(() => _currentStep = step);
//             }
//             continued() {
//              _currentStep < 2 ? setState(() => _currentStep += 1) : null;
//             }
//             cancel() {
//              _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
//             }
//             return Container(
//              height: 400,
//              margin: const EdgeInsets.only(left: 15, right: 15),
//              width: MediaQuery.of(context).size.width,
//              child: AlertDialog(
//               insetPadding: EdgeInsets.zero,
//               elevation: 0,
//               title: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                 Container(
//                     child: const Text(
//                      'Process Detail',
//                      style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
//                     )),
//                 GestureDetector(
//                  onTap: () {
//                   Navigator.pop(context);
//                  },
//                  child: Container(
//                   alignment: Alignment.topRight,
//                   child: const Icon(
//                    Icons.clear,
//                    color: Colors.black,
//                   ),
//                  ),
//                 ),
//                ],
//               ),
//               content: Container(
//                height:400,
//                width: MediaQuery.of(context).size.width,
//                child: SingleChildScrollView(
//                    scrollDirection: Axis.vertical,
//                    child: Column(
//                     children: [
//                      Container(
//                       child:const Text("Please Update SECRET KEY and APP KEY for all these details please contact with Laxmi broker then Submit And Login With Api Trading On...",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
//                      ),
//                      Container(
//                       margin: const EdgeInsets.only(top: 5),
//                       child: Stepper(
//                        physics: const ScrollPhysics(),
//                        currentStep: _currentStep,
//                        onStepTapped: (step) => tapped(step),
//                        onStepContinue: continued,
//                        onStepCancel: cancel,
//                        controlsBuilder: (context, controller) {
//                         return const SizedBox.shrink();
//                        },
//                        steps: <Step>[
//                         Step(
//                          title: const Text('Click below link and Login',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            GestureDetector(
//                                onTap: () async {
//                                 String? url="https://account.upstox.com/developer/apps";
//                                 if (await canLaunch(url)) {
//                                  await launch(url);
//                                 } else {
//                                  throw 'Could not launch $url';
//                                 }
//                                },
//                                child: Container(child:const Text("https://account.upstox.com/developer/apps",style: TextStyle(color: ColorValues.Splash_bg_color1,fontSize: 13),),))
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 0
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                         Step(
//                          title: const Text('Enter your Details and the Redirect URL which is given below.',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            Container(
//                             // width: MediaQuery.of(context).size.width/2.2,
//                             child: Text("$UpstoxRedirectUrl",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
//                            ),
//
//                            Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                              GestureDetector(
//                               onTap: () => copyToClipboard(context, "$UpstoxRedirectUrl"),
//                               child: Container(
//                                height: 25,
//                                width: 40,
//                                margin:const EdgeInsets.only(left: 20,top: 7),
//                                decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
//                                 gradient:const LinearGradient(
//                                  begin: Alignment.topRight,
//                                  end: Alignment.bottomLeft,
//                                  stops: [
//                                   0.1,
//                                   0.5,
//                                  ],
//                                  colors: [
//                                   ColorValues.Splash_bg_color1,
//                                   ColorValues.Splash_bg_color1,
//                                  ],
//                                 ),
//                                ),
//                                alignment: Alignment.center,
//                                child:const Icon(Icons.copy,color: Colors.white,size: 15),
//                               ),
//                              )
//                             ],
//                            )
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 1
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                        ],
//                       ),
//                      ),
//                     ],
//                    )
//                ),
//               ),
//              ),
//             );
//            });
//       }) ??
//       false;
//  }
//
//  //Dhan
//  static Broker_connect_Dhan_popup(context) {
//
//   bool? Status_dhanbroker;
//   BrokerConnectDhan_Api() async {
//    SharedPreferences prefs= await SharedPreferences.getInstance();
//    String? Id_brokerconnectdhan = prefs.getString('Login_id');
//
//    print("111aa: $Id_brokerconnectdhan");
//    print("222aa: ${api_key.text}");
//    print("333aa: ${api_secret.text}");
//    print("urlllllaa: ${Util.Local_Url}/dhan/getaccesstoken");
//
//    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/dhan/getaccesstoken"),
//        headers: {
//         'Content-Type': 'application/json',
//        },
//        body:jsonEncode(
//            {
//             "id":"$Id_brokerconnectdhan",
//             "apikey":"${api_key.text}",
//             "apisecret":"${api_secret.text}",
//            }
//        )
//    );
//    var jsonString = jsonDecode(response.body);
//    print("Jsnnnnnn: $jsonString");
//    Status_dhanbroker=jsonString['status'];
//
//    if(Status_dhanbroker==true){
//     ScaffoldMessenger.of(context).showSnackBar(
//      const SnackBar(
//       content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
//       duration: Duration(seconds: 3),
//       backgroundColor: Colors.green,
//      ),
//     );
//     Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));
//
//     api_key.clear();
//     api_secret.clear();
//    }
//
//    else{
//     ScaffoldMessenger.of(context).showSnackBar(
//      const SnackBar(
//       content: Text('Error connecting broker.',style: TextStyle(color: Colors.white)),
//       duration: Duration(seconds: 3),
//       backgroundColor: Colors.red,
//      ),
//     );
//    }
//   }
//
//
//   return showModalBottomSheet(
//    shape:const RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(10),
//            topRight: Radius.circular(10)
//        )
//    ),
//    clipBehavior: Clip.antiAliasWithSaveLayer,
//    isScrollControlled: true,
//    context: context,
//    builder: (BuildContext context) {
//     return StatefulBuilder(
//      builder: (BuildContext ctx, StateSetter setState) {
//       return Padding(
//        // Add padding at the bottom when the keyboard is open
//        padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//        ),
//        child: SingleChildScrollView(
//         child: Container(
//          padding: const EdgeInsets.all(16.0),
//          constraints: BoxConstraints(
//           minHeight: MediaQuery.of(context).size.height / 1.8,
//          ),
//          child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//            Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//              GestureDetector(
//               onTap: (){
//                Dhan_Process_popup(context);
//               },
//               child: Container(
//                alignment: Alignment.center,
//                height: 25,
//                width: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(8),
//                    color: Colors.grey.shade300
//                ),
//                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
//               ),
//             ),
//           ],
//         ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Key",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Key';
//               }
//               return null;
//              },
//              controller: api_key,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Key",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20),
//             child: const Text(
//              "Api Secret",
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//             ),
//            ),
//            Container(
//             alignment: Alignment.topLeft,
//             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//             child: TextFormField(
//              cursorColor: Colors.black,
//              cursorWidth: 1.1,
//              validator: (value) {
//               if (value == null || value.isEmpty) {
//                return 'Please Enter Api Secret';
//               }
//               return null;
//              },
//              controller: api_secret,
//              style: const TextStyle(fontSize: 13),
//              decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(10),
//                borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
//               ),
//               hintText: "Enter Api Secret",
//               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
//               hintStyle: const TextStyle(fontSize: 13),
//               prefixIcon: const Icon(Icons.api),
//              ),
//             ),
//            ),
//            GestureDetector(
//             onTap: () {
//              user_id.text="";
//              BrokerConnectDhan_Api();
//             },
//             child: Card(
//              clipBehavior: Clip.antiAliasWithSaveLayer,
//              color: Colors.transparent,
//              shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//              ),
//              elevation: 0,
//              child: Container(
//               height: 45,
//               alignment: Alignment.topLeft,
//               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
//               width: MediaQuery.of(context).size.width / 3,
//               decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(8),
//                color: Colors.grey.shade200,
//                gradient: const LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 stops: [0.1, 0.5],
//                 colors: [
//                  ColorValues.Splash_bg_color1,
//                  ColorValues.Splash_bg_color1,
//                 ],
//                ),
//               ),
//               child: Container(
//                alignment: Alignment.center,
//                child: const Text(
//                 "Submit",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                     color: Colors.white),
//                ),
//               ),
//              ),
//             ),
//            ),
//           ],
//          ),
//         ),
//        ),
//       );
//      },
//     );
//    },
//   );
//  }
//  static Dhan_Process_popup(context) async {
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//        int _currentStep = 0;
//        return StatefulBuilder(
//            builder: (BuildContext context, StateSetter setState) {
//             tapped(int step) {
//              setState(() => _currentStep = step);
//             }
//             continued() {
//              _currentStep < 2 ? setState(() => _currentStep += 1) : null;
//             }
//             cancel() {
//              _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
//             }
//             return Container(
//              height: 400,
//              margin: const EdgeInsets.only(left: 15, right: 15),
//              width: MediaQuery.of(context).size.width,
//              child: AlertDialog(
//               insetPadding: EdgeInsets.zero,
//               elevation: 0,
//               title: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                 Container(
//                     child: const Text(
//                      'Process Detail',
//                      style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
//                     )),
//                 GestureDetector(
//                  onTap: () {
//                   Navigator.pop(context);
//                  },
//                  child: Container(
//                   alignment: Alignment.topRight,
//                   child: const Icon(
//                    Icons.clear,
//                    color: Colors.black,
//                   ),
//                  ),
//                 ),
//                ],
//               ),
//               content: Container(
//                height:400,
//                width: MediaQuery.of(context).size.width,
//                child: SingleChildScrollView(
//                    scrollDirection: Axis.vertical,
//                    child: Column(
//                     children: [
//                      Container(
//                       child:const Text("For CLIENT ID and ACCESS TOKEN go to your My Profile Dhan and click on DhanHQ Trading APIs & Access to generate ACCESS TOKEN and also select 30 days validity to expiry for token, You will get your Client Id in Profile and Access Token DhanHQTrading APIs & Access.",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
//                      ),
//                      Container(
//                       margin: const EdgeInsets.only(top: 5),
//                       child: Stepper(
//                        physics: const ScrollPhysics(),
//                        currentStep: _currentStep,
//                        onStepTapped: (step) => tapped(step),
//                        onStepContinue: continued,
//                        onStepCancel: cancel,
//                        controlsBuilder: (context, controller) {
//                         return const SizedBox.shrink();
//                        },
//                        steps: <Step>[
//                         Step(
//                          title: const Text('Click below link and Login',style: TextStyle(fontWeight: FontWeight.w600),),
//                          content: Column(
//                           children: <Widget>[
//                            GestureDetector(
//                                onTap: () async {
//                                 String? url="https://dhan.co/";
//                                 if (await canLaunch(url)) {
//                                  await launch(url);
//                                 } else {
//                                  throw 'Could not launch $url';
//                                 }
//                                },
//                                child: Container(child:const Text("https://dhan.co/",style: TextStyle(color: ColorValues.Splash_bg_color1,fontSize: 13),),))
//
//                           ],
//                          ),
//                          isActive: _currentStep >= 0,
//                          state: _currentStep == 0
//                              ? StepState.editing
//                              : StepState.indexed,
//                         ),
//                        ],
//                       ),
//                      ),
//                     ],
//                    )
//                ),
//               ),
//              ),
//             );
//            });
//       }) ??
//       false;
//  }
//
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Broker/Webview_broker.dart';
import 'package:stock_box/Screens/Main_screen/Dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

//Angel
TextEditingController api_key = TextEditingController();

//Alice
TextEditingController app_code = TextEditingController();
TextEditingController user_id = TextEditingController();
TextEditingController api_secret = TextEditingController();


//Kotak Neo
// TextEditingController api_key_kotak = TextEditingController(text: "5R5E2GrofAe3G3fCzdPRMrkN6D4a");
// TextEditingController api_secret_kotak = TextEditingController(text: '7MrROwMJJiIP1SFZt3aJfoYJ6rUa');
// TextEditingController user_name_kotak = TextEditingController(text: "client21830");
// TextEditingController password_kotak = TextEditingController(text: "Sneh@1976");

//Kotak Neo
TextEditingController api_key_kotak = TextEditingController(text: "");
TextEditingController api_secret_kotak = TextEditingController(text: '');
TextEditingController user_name_kotak = TextEditingController(text: "");
TextEditingController password_kotak = TextEditingController(text: "");

//Market Hub
TextEditingController api_key_markethub =TextEditingController();
TextEditingController api_secret_markethub =TextEditingController();
TextEditingController password_markethub =TextEditingController();

final pinController = TextEditingController();
final focusNode = FocusNode();

String? Url;
bool? Status_broker;
String? Message_broker;

BrokerConnect_Api(brokerid,context) async {
 SharedPreferences prefs= await SharedPreferences.getInstance();
 String? Id_brokerconnect = prefs.getString('Login_id');

 // print("111: $Id_brokerconnect");
 // print("222: ${api_key.text}");
 // print("333: ${api_secret.text}");
 // print("444: ${user_id.text}");
 // print("555: $brokerid");

 var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/brokerlink"),
     headers: {
      'Content-Type': 'application/json',
     },
     body:jsonEncode(
         {
          "id":"$Id_brokerconnect",
          "apikey":"${api_key.text}",
          "apisecret":"${api_secret.text}",
          "alice_userid":"${user_id.text}",
          "brokerid" :"$brokerid"
         }
     )
 );
 var jsonString = jsonDecode(response.body);
 print("Jsnnnnnn: $jsonString");
 Status_broker=jsonString['status'];
 Message_broker=jsonString['message'];
 print("Message: $Message_broker");
 print("Status: $Status_broker");
 // print("Status broker : $Status_broker");

 if(Status_broker==true){
  Url=jsonString['url'];
  print("Urllllll22222: $Url");
  Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url, Broker_idd:brokerid,aliceuser_id:user_id.text)));
  api_key.clear();
 }

 else{
  Fluttertoast.showToast(
      backgroundColor: Colors.red,
      msg: "$Message_broker",
      textColor: Colors.white
  );
 }

}

void copyToClipboard(BuildContext context, String text) {
 Clipboard.setData(ClipboardData(text: text));

 Fluttertoast.showToast(
     backgroundColor: Colors.black,
     msg: "Copied to clipboard!",
     textColor: Colors.white
 );
}


class Add_Broker{

 static Broker_link(context){
  return showModalBottomSheet(
   shape:const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10)
    ),
   ),
   clipBehavior: Clip.antiAliasWithSaveLayer,
   isScrollControlled:true,
   context: context,
   builder: (BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext ctx, StateSetter setState) {
         return Container(
             height: MediaQuery.of(context).size.height/3,
             child:Column(
              children: [
               Container(
                alignment: Alignment.topLeft,
                margin:const EdgeInsets.only(top: 15,left: 15),
                child:const Text("Supported Broker",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w500),),
               ),

               Container(
                margin:const EdgeInsets.only(top: 25,left: 15,right: 15,bottom: 10),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [

                  GestureDetector(
                   onTap: (){
                    Broker_connect_aliceBlue_popup(context);
                   },
                   child: Container(
                    height: 70,
                    width:70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4)
                    ),
                    alignment: Alignment.center,
                    child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                      Container(
                       child: Image.asset("images/alice_blue.png",height: 35,width: 35,),
                      ),
                      Container(
                          margin:const EdgeInsets.only(top: 3),
                          child:const Text("Alice Blue",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
                      ),
                     ],
                    ),
                   ),
                  ),

                  GestureDetector(
                   onTap: () async {
                    Broker_connect_angel_popup(context);
                   },
                   child: Container(
                       height: 70,
                       width:70,
                       alignment: Alignment.center,
                       margin:const EdgeInsets.only(left: 15),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           border: Border.all(color: Colors.black,width: 0.4),
                           color: Colors.white
                       ),
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         Container(
                          child: Image.asset("images/angel_one.png",height: 35,width: 35,),
                         ),
                         Container(
                             margin:const EdgeInsets.only(top: 3),
                             child:const Text("Angel One",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
                         ),
                        ],
                       )
                   ),
                  ),

                  GestureDetector(
                   onTap: () async {
                    Broker_connect_KotakNeo_popup(context);
                   },
                   child: Container(
                       height: 70,
                       width:70,
                       alignment: Alignment.center,
                       margin:const EdgeInsets.only(left: 15),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           border: Border.all(color: Colors.black,width: 0.4),
                           color: Colors.white
                       ),
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         Container(
                          child: Image.asset("images/kotak.png",height: 35,width: 35,),
                         ),
                         Container(
                             margin:const EdgeInsets.only(top: 3),
                             child:const Text("Kotak Neo",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
                         ),
                        ],
                       )
                   ),
                  ),

                  GestureDetector(
                   onTap: (){
                    Broker_connect_marketHub_popup(context);
                   },
                   child: Container(
                    height: 70,
                    width:70,
                    margin:const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4)
                    ),
                    alignment: Alignment.center,
                    child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                      Container(
                       margin:const EdgeInsets.only(top: 2),
                       clipBehavior: Clip.antiAliasWithSaveLayer,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(6)
                       ),
                       child: Image.asset("images/markethub.png",height: 25,width: 25,),
                      ),
                      Container(
                          margin:const EdgeInsets.only(top: 8,),
                          child: Container(
                              child:const Text("Market Hub",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),))
                      ),
                     ],
                    ),
                   ),
                  ),
                 ],
                ),
               ),

               Container(
                margin:const EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 10),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [

                  GestureDetector(
                   onTap: (){
                    Broker_connect_Zerodha_popup(context);
                   },
                   child: Container(
                    height: 70,
                    width:70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4)
                    ),
                    alignment: Alignment.center,
                    child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                      Container(
                       child: Image.asset("images/zerodha.png",height: 35,width: 35,),
                      ),
                      Container(
                          margin:const EdgeInsets.only(top: 3),
                          child:const Text("Zerodha",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
                      ),
                     ],
                    ),
                   ),
                  ),

                  GestureDetector(
                   onTap: () async {
                    Broker_connect_UpStox_popup(context);
                   },
                   child: Container(
                       height: 70,
                       width:70,
                       alignment: Alignment.center,
                       margin:const EdgeInsets.only(left: 15),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           border: Border.all(color: Colors.black,width: 0.4),
                           color: Colors.white
                       ),
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         Container(
                          child: Image.asset("images/upstox.png",height: 30,width: 30,),
                         ),
                         Container(
                             margin:const EdgeInsets.only(top: 5),
                             child:const Text("UpStox",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
                         ),
                        ],
                       )
                   ),
                  ),

                  GestureDetector(
                   onTap: () async {
                    Broker_connect_Dhan_popup(context);
                   },
                   child: Container(
                       height: 70,
                       width:70,
                       alignment: Alignment.center,
                       margin:const EdgeInsets.only(left: 15),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           border: Border.all(color: Colors.black,width: 0.4),
                           color: Colors.white
                       ),
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         Container(
                          child: Image.asset("images/dhan.png",height: 30,width: 30,),
                         ),
                         Container(
                             margin:const EdgeInsets.only(top: 5),
                             child:const Text("Dhan",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600),)
                         ),
                        ],
                       )
                   ),
                  ),

                  Container(
                   height: 70,
                   width:70,
                   alignment: Alignment.center,
                   margin:const EdgeInsets.only(left: 15),
                   color: Colors.transparent,
                  ),

                 ],
                ),
               ),


              ],
             )
         );
        }
    );



   },
  );
 }


 //Angle Broker
 static Broker_connect_angel_popup(context) {
  final _formKey = GlobalKey<FormState>();

  return showModalBottomSheet(
   shape:const RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
           topLeft: Radius.circular(10),
           topRight: Radius.circular(10)
       )
   ),
   clipBehavior: Clip.antiAliasWithSaveLayer,
   isScrollControlled: true,
   context: context,
   builder: (BuildContext context) {
    return StatefulBuilder(
     builder: (BuildContext ctx, StateSetter setState) {
      return Padding(
       padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
       ),
       child: SingleChildScrollView(
        child: Container(
         padding: const EdgeInsets.all(16.0),
         constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 3,
         ),
         child:  Form(
          key: _formKey,
          child:Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,

           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
              GestureDetector(
               onTap: (){
                AngelOne_Process_popup(context);
               },
               child: Container(
                alignment: Alignment.center,
                height: 25,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300
                ),
                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
               ),
              ),
             ],
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Key",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Key';
               }
               return null;
              },
              controller: api_key,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:  BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:  BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Api Key",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            GestureDetector(
             onTap: () {
              if (_formKey.currentState!.validate()){
               api_secret.text = '';
               user_id.text = '';
               BrokerConnect_Api("1",context);
              }


             },
             child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Container(
               height: 45,
               alignment: Alignment.topLeft,
               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
               width: MediaQuery.of(context).size.width / 3,
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
               child: Container(
                alignment: Alignment.center,
                child: const Text(
                 "Submit",
                 style: TextStyle(
                     fontWeight: FontWeight.w700,
                     fontSize: 18,
                     color: Colors.white),
                ),
               ),
              ),
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
   },
  );
 }
 static AngelOne_Process_popup(context) async {
  String? AngelRedirectUrl;
  SharedPreferences prefs= await SharedPreferences.getInstance();
  AngelRedirectUrl=prefs.getString("AngelRedirectUrl");

  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
       int _currentStep = 0;
       return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
         return Container(
          height: 300,
          margin: const EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: AlertDialog(
           insetPadding: EdgeInsets.zero,
           elevation: 0,
           title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text(
              'Process Detail',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
             ),
             GestureDetector(
              onTap: () {
               Navigator.pop(context);
              },
              child: const Icon(Icons.clear, color: Colors.black),
             ),
            ],
           ),
           content: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                "Kindly follow these steps to link your demat account.",
                style: TextStyle(fontWeight: FontWeight.w600, color: ColorValues.Splash_bg_color1),
               ),
               const SizedBox(height: 10),

               /// ✅ **Step 1: Always Visible**
               Card(
                elevation: 2,
                child: Container(
                 width: MediaQuery.of(context).size.width,
                 padding: const EdgeInsets.all(10),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 1: Click below link and Login',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   GestureDetector(
                    onTap: () async {
                     String url = "https://smartapi.angelbroking.com/";
                     if (await canLaunch(url)) {
                      await launch(url);
                     } else {
                      throw 'Could not launch $url';
                     }
                    },
                    child: Text(
                     "https://smartapi.angelbroking.com/",
                     style: TextStyle(color: ColorValues.Splash_bg_color1, fontSize: 13),
                    ),
                   ),
                  ],
                 ),
                ),
               ),

               /// ✅ **Step 2: Always Visible**
               Card(
                elevation: 2,
                child: Padding(
                 padding: const EdgeInsets.all(10),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 2: Enter your Details and the Redirect URL which is given below.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   Text(
                    "$AngelRedirectUrl",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                   ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     GestureDetector(
                      onTap: () => copyToClipboard(context, "$AngelRedirectUrl"),
                      child: Container(
                       height: 25,
                       width: 40,
                       margin: const EdgeInsets.only(left: 20, top: 7),
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorValues.Splash_bg_color1, width: 0.4),
                        gradient: LinearGradient(
                         begin: Alignment.topRight,
                         end: Alignment.bottomLeft,
                         stops: [0.1, 0.5],
                         colors: [
                          ColorValues.Splash_bg_color1,
                          ColorValues.Splash_bg_color1,
                         ],
                        ),
                       ),
                       alignment: Alignment.center,
                       child: const Icon(Icons.copy, color: Colors.white, size: 15),
                      ),
                     )
                    ],
                   ),
                  ],
                 ),
                ),
               ),
              ],
             ),
            ),
           ),
          ),
         );
        },
       )
       ;
      }) ??
      false;
 }


 //Alice Broker
 static Broker_connect_aliceBlue_popup(context) {

  final _formKey = GlobalKey<FormState>();
  return showModalBottomSheet(
   shape:const RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
           topLeft: Radius.circular(10),
           topRight: Radius.circular(10)
       )
   ),
   clipBehavior: Clip.antiAliasWithSaveLayer,
   isScrollControlled: true,
   context: context,
   builder: (BuildContext context) {
    return StatefulBuilder(
     builder: (BuildContext ctx, StateSetter setState) {
      return Padding(
       // Add padding at the bottom when the keyboard is open
       padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
       ),
       child: SingleChildScrollView(
        child: Container(
         padding: const EdgeInsets.all(16.0),
         constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 1.8,
         ),
         child: Form(
          key: _formKey,
          child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
              GestureDetector(
               onTap: (){
                Alice_Process_popup(context);
               },
               child: Container(
                alignment: Alignment.center,
                height: 25,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300
                ),
                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
               ),
              ),
             ],
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "App Code",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter App Code';
               }
               return null;
              },
              controller: api_key,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter App Code",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "User Id",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.number,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter User Id';
               }
               return null;
              },
              controller: user_id,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter User Id",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Secret",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Secret';
               }
               return null;
              },
              controller: api_secret,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Secret",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),
            GestureDetector(
             onTap: () {
              if (_formKey.currentState!.validate()){
               BrokerConnect_Api("2",context);
              }


             },
             child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Container(
               height: 45,
               alignment: Alignment.topLeft,
               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
               width: MediaQuery.of(context).size.width / 3,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                gradient: LinearGradient(
                 begin: Alignment.topRight,
                 end: Alignment.bottomLeft,
                 stops: [0.1, 0.5],
                 colors: [
                  ColorValues.Splash_bg_color1,
                  ColorValues.Splash_bg_color1,
                 ],
                ),
               ),
               child: Container(
                alignment: Alignment.center,
                child: const Text(
                 "Submit",
                 style: TextStyle(
                     fontWeight: FontWeight.w700,
                     fontSize: 18,
                     color: Colors.white),
                ),
               ),
              ),
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
   },
  );
 }
 static Alice_Process_popup(context) async {
  String? AliceRedirectUrl;
  SharedPreferences prefs= await SharedPreferences.getInstance();
  AliceRedirectUrl=prefs.getString("AliceRedirectUrl");

  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
       int _currentStep = 0;
       return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
         tapped(int step) {
          setState(() => _currentStep = step);
         }

         continued() {
          _currentStep < 2 ? setState(() => _currentStep += 1) : null;
         }

         cancel() {
          _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
         }

         return Container(
          height: 300,
          margin: const EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: AlertDialog(
           insetPadding: EdgeInsets.zero,
           elevation: 0,
           title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text(
              'Process Detail',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
             ),
             GestureDetector(
              onTap: () {
               Navigator.pop(context);
              },
              child: const Icon(
               Icons.clear,
               color: Colors.black,
              ),
             ),
            ],
           ),
           content: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text(
                "Kindly follow these steps to link your demat account.",
                style: TextStyle(fontWeight: FontWeight.w600, color: ColorValues.Splash_bg_color1),
               ),
               const SizedBox(height: 10),

               /// ✅ **Step 1: Always Expanded**
               Card(
                elevation: 2,
                child: Padding(
                 padding: const EdgeInsets.all(10),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 1: Click below link and Login',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   GestureDetector(
                    onTap: () async {
                     String url = "https://ant.aliceblueonline.com/?appcode=G9EOSWCEIF9ARCB";
                     if (await canLaunch(url)) {
                      await launch(url);
                     } else {
                      throw 'Could not launch $url';
                     }
                    },
                    child: Text(
                     "https://ant.aliceblueonline.com/?appcode=G9EOSWCEIF9ARCB",
                     style: TextStyle(color: ColorValues.Splash_bg_color1, fontSize: 13),
                    ),
                   ),
                  ],
                 ),
                ),
               ),

               /// ✅ **Step 2: Always Expanded**
               Card(
                elevation: 2,
                child: Padding(
                 padding: const EdgeInsets.all(10),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 2: Enter your Details and the Redirect URL which is given below.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   Text(
                    "$AliceRedirectUrl",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                   ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     GestureDetector(
                      onTap: () => copyToClipboard(context, "$AliceRedirectUrl"),
                      child: Container(
                       height: 25,
                       width: 40,
                       margin: const EdgeInsets.only(left: 20, top: 7),
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorValues.Splash_bg_color1, width: 0.4),
                        gradient: LinearGradient(
                         begin: Alignment.topRight,
                         end: Alignment.bottomLeft,
                         stops: [0.1, 0.5],
                         colors: [
                          ColorValues.Splash_bg_color1,
                          ColorValues.Splash_bg_color1,
                         ],
                        ),
                       ),
                       alignment: Alignment.center,
                       child: const Icon(Icons.copy, color: Colors.white, size: 15),
                      ),
                     )
                    ],
                   ),
                  ],
                 ),
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
      }) ??
      false;
 }


 //Kotak_Neo Broker
 static Broker_connect_KotakNeo_popup(context) {
  String? messageotp_kotak;
  bool? Statusotp_kotak;
  final _formKey = GlobalKey<FormState>();

  Otp_Api_Kotakneo(context) async {
   SharedPreferences prefs= await SharedPreferences.getInstance();
   // String? Id_otp_kotak = prefs.getString('Login_id');
   // SharedPreferences prefs= await SharedPreferences.getInstance();
   String? Id_brokerconnect = prefs.getString('Login_id');
   var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/kotakneo/checkotp"),
       body:{
        // 'id': '$Id_otp_kotak',
        'id': '$Id_brokerconnect',
        'otp': '${pinController.text}',
       }
   );
   var jsonString = jsonDecode(response.body);
   print("Jsnnnnnn: $jsonString");
   messageotp_kotak=jsonString['message'];
   Statusotp_kotak=jsonString['status'];

   print("Status Otp: $Statusotp_kotak");

   if(Statusotp_kotak==true){
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(
      content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
     ),
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));
   }

   else{
    Fluttertoast.showToast(
        msg: "$messageotp_kotak",
        backgroundColor: Colors.red,
        textColor: Colors.white
    );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //   content: Text('$messageotp_kotak',style: TextStyle(color: Colors.white)),
    //   duration:Duration(seconds: 3),
    //   backgroundColor: Colors.red,
    //   behavior: SnackBarBehavior.floating,
    //  ),
    // );
    // Navigator.pop(context);
   }
  }

  KotakNeo_Password_popup(context) {
   const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
   const fillColor = Color.fromRGBO(243, 246, 249, 0);
   var borderColor = ColorValues.Splash_bg_color1;

   final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    // padding: EdgeInsets.only(left: 10,right: 10),
    margin:const EdgeInsets.only(left: 6,right: 6),
    textStyle: const TextStyle(
     fontSize: 22,
     color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
     borderRadius: BorderRadius.circular(10),
     border: Border.all(color: borderColor),
    ),
   );
   return showModalBottomSheet(
    shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
        )
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
     return StatefulBuilder(
      builder: (BuildContext ctx, StateSetter setState) {
       return Padding(
        // Add padding at the bottom when the keyboard is open
        padding: EdgeInsets.only(
         bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
         child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(
           minHeight: MediaQuery.of(context).size.height / 2.8,
          ),
          child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            // Row(
            //  mainAxisAlignment: MainAxisAlignment.end,
            //  children: [
            //   GestureDetector(
            //    onTap: (){
            //     Alice_Process_popup(context);
            //    },
            //    child: Container(
            //     alignment: Alignment.center,
            //     height: 25,
            //     width: 100,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(8),
            //         color: Colors.grey.shade300
            //     ),
            //     child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
            //    ),
            //   ),
            //  ],
            // ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Otp Verification",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
               length: 4,
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
            ),




            GestureDetector(
             onTap: () {
              Otp_Api_Kotakneo(context);

             },
             child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Container(
               height: 45,
               alignment: Alignment.topLeft,
               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
               width: MediaQuery.of(context).size.width / 3,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                gradient: LinearGradient(
                 begin: Alignment.topRight,
                 end: Alignment.bottomLeft,
                 stops: [0.1, 0.5],
                 colors: [
                  ColorValues.Splash_bg_color1,
                  ColorValues.Splash_bg_color1,
                 ],
                ),
               ),
               child: Container(
                alignment: Alignment.center,
                child: const Text(
                 "Submit",
                 style: TextStyle(
                     fontWeight: FontWeight.w700,
                     fontSize: 18,
                     color: Colors.white),
                ),
               ),
              ),
             ),
            )
           ],
          ),
         ),
        ),
       );
      },
     );
    },
   );
  }

  bool? Status_Kotakneo;
  BrokerConnect_KotakNeo_Api(context) async {
   SharedPreferences prefs= await SharedPreferences.getInstance();
   String? Id_brokerconnect_kotak = prefs.getString('Login_id');
   var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/kotakneo/getaccesstoken"),
       headers: {
        'Content-Type': 'application/json',
       },
       body:jsonEncode(
           {
            // "id":"$Id_brokerconnect_kotak",
            "id":"$Id_brokerconnect_kotak",
            "apikey":"${api_key_kotak.text}",
            "apisecret":"${api_secret_kotak.text}",
            "user_name":"${user_name_kotak.text}",
            "pass_word":"${password_kotak.text}",
           }
       )
   );
   var jsonString = jsonDecode(response.body);
   print("JsnnnnnnPayout: $jsonString");
   Status_Kotakneo=jsonString['status'];

   if(Status_Kotakneo==true){
    KotakNeo_Password_popup(context);
    api_key_kotak.clear();
    api_secret_kotak.clear();
    user_name_kotak.clear();
    password_kotak.clear();
   }
   else{
    Fluttertoast.showToast(
        msg: "${jsonString['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    print("Hello");
   }

  }

  return showModalBottomSheet(
   shape:const RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
           topLeft: Radius.circular(10),
           topRight: Radius.circular(10)
       )
   ),
   clipBehavior: Clip.antiAliasWithSaveLayer,
   isScrollControlled: true,
   context: context,
   builder: (BuildContext context) {
    return StatefulBuilder(
     builder: (BuildContext ctx, StateSetter setState) {
      return Padding(
       // Add padding at the bottom when the keyboard is open
       padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
       ),
       child: SingleChildScrollView(
        child: Container(
         padding: const EdgeInsets.all(16.0),
         constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 1.8,
         ),
         child:  Form(
          key: _formKey,
          child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
              GestureDetector(
               onTap: (){
                KotakNeo_Process_popup(context);
               },
               child: Container(
                alignment: Alignment.center,
                height: 25,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300
                ),
                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
               ),
              ),
             ],
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Key",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Key';
               }
               return null;
              },
              controller: api_key_kotak,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Key",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Secret",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Secret';
               }
               return null;
              },
              controller: api_secret_kotak,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Secret",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "User Name",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter User Name';
               }
               return null;
              },
              controller: user_name_kotak,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter User Name",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Password",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Password';
               }
               return null;
              },
              controller: password_kotak,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Password",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            GestureDetector(
             onTap: () {
              if (_formKey.currentState!.validate()){
               BrokerConnect_KotakNeo_Api(context);
              }


             },
             child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Container(
               height: 45,
               alignment: Alignment.topLeft,
               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
               width: MediaQuery.of(context).size.width / 3,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                gradient: LinearGradient(
                 begin: Alignment.topRight,
                 end: Alignment.bottomLeft,
                 stops: [0.1, 0.5],
                 colors: [
                  ColorValues.Splash_bg_color1,
                  ColorValues.Splash_bg_color1,
                 ],
                ),
               ),
               child: Container(
                alignment: Alignment.center,
                child: const Text(
                 "Submit",
                 style: TextStyle(
                     fontWeight: FontWeight.w700,
                     fontSize: 18,
                     color: Colors.white),
                ),
               ),
              ),
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
   },
  );
 }
 static KotakNeo_Process_popup(context) async {
  String? AliceRedirectUrl;
  SharedPreferences prefs= await SharedPreferences.getInstance();
  AliceRedirectUrl=prefs.getString("AliceRedirectUrl");

  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
       int _currentStep = 0;
       return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
         return Container(
          height: 400,
          margin: const EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: AlertDialog(
           insetPadding: EdgeInsets.zero,
           elevation: 0,
           title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text(
              'Process Detail',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
             ),
             GestureDetector(
              onTap: () {
               Navigator.pop(context);
              },
              child: const Icon(Icons.clear, color: Colors.black),
             ),
            ],
           ),
           content: SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               /// **Instruction Text**
                Text(
                "Kindly follow instruction as your broker or sub broker link guide to you and update our link and connect your demat.",
                style: TextStyle(fontWeight: FontWeight.w600, color: ColorValues.Splash_bg_color1),
               ),
               const SizedBox(height: 10),

               /// ✅ **Step 1: Always Visible**
               Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                 padding: const EdgeInsets.all(12),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 1: Click below link and Login',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   GestureDetector(
                    onTap: () async {
                     String url = "https://tradeapi.kotaksecurities.com/devportal/apis";
                     if (await canLaunch(url)) {
                      await launch(url);
                     } else {
                      throw 'Could not launch $url';
                     }
                    },
                    child: const Text(
                     "https://tradeapi.kotaksecurities.com/devportal/apis",
                     style: TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                   ),
                  ],
                 ),
                ),
               ),

               /// ✅ **Step 2: Always Visible**
               Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                 padding: const EdgeInsets.all(12),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 2: Enter your Details and the Redirect URL which is given below.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   const Text(
                    "Login account and click default application and next click on the production key in the sidebar and the consumer key and consumer secret update on your profile and demat password and trading API password both update on your profile. The access code generated is sent to the registered email address & mobile number. A generated access code is valid for the day (till 11:59:59 pm on the same day).",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                   ),
                  ],
                 ),
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
      }) ??
      false;
 }



 //Market Hub Broker
 static Broker_connect_marketHub_popup(context) {
  final _formKey = GlobalKey<FormState>();
  bool? Status_marketHub;
  String? Message_marketHub;
  BrokerConnect_MarketHub_Api(context) async {
   SharedPreferences prefs= await SharedPreferences.getInstance();
   String? Id_brokerconnect_markethub = prefs.getString('Login_id');

   var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/markethub/getaccesstoken"),
       headers: {
        'Content-Type': 'application/json',
       },
       body:jsonEncode(
           {
            // "id":"$Id_brokerconnect_kotak",
            "id":"$Id_brokerconnect_markethub",
            "apikey":"${api_key_markethub.text}",
            "apisecret":"${api_secret_markethub.text}",
            "pass_word":"${password_markethub.text}",
           }
       )
   );
   var jsonString = jsonDecode(response.body);
   print("JsnnnnnnPayout: $jsonString");
   Status_marketHub=jsonString['status'];
   Message_marketHub=jsonString['message'];

   if(Status_marketHub==true){
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(
      content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
     ),
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));

    api_key_markethub.clear();
    api_secret_markethub.clear();
    password_markethub.clear();
   }

   else{
    Fluttertoast.showToast(
        msg: "$Message_marketHub",
        backgroundColor: Colors.red,
        textColor: Colors.white
    );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //   content: Text("$Message_marketHub",style: TextStyle(color: Colors.white)),
    //   duration: Duration(seconds: 3),
    //   backgroundColor: Colors.red,
    //  ),
    // );
    // Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));
   }

  }

  return showModalBottomSheet(
   shape:const RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
           topLeft: Radius.circular(10),
           topRight: Radius.circular(10)
       )
   ),
   clipBehavior: Clip.antiAliasWithSaveLayer,
   isScrollControlled: true,
   context: context,
   builder: (BuildContext context) {
    return StatefulBuilder(
     builder: (BuildContext ctx, StateSetter setState) {
      return Padding(
       // Add padding at the bottom when the keyboard is open
       padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
       ),
       child: SingleChildScrollView(
        child: Container(
         padding: const EdgeInsets.all(16.0),
         constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 1.8,
         ),
         child:  Form(
          key: _formKey,
          child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
              GestureDetector(
               onTap: (){
                MarketHub_Process_popup(context);
               },
               child: Container(
                alignment: Alignment.center,
                height: 25,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300
                ),
                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
               ),
              ),
             ],
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Key",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Key';
               }
               return null;
              },
              controller: api_key_markethub,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Key",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Secret",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Secret';
               }
               return null;
              },
              controller: api_secret_markethub,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Secret",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Password",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Password';
               }
               return null;
              },
              controller: password_markethub,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Password",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            GestureDetector(
             onTap: () {
              if (_formKey.currentState!.validate()){
               BrokerConnect_MarketHub_Api(context);
              }
             },
             child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Container(
               height: 45,
               alignment: Alignment.topLeft,
               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
               width: MediaQuery.of(context).size.width / 3,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                gradient: LinearGradient(
                 begin: Alignment.topRight,
                 end: Alignment.bottomLeft,
                 stops: [0.1, 0.5],
                 colors: [
                  ColorValues.Splash_bg_color1,
                  ColorValues.Splash_bg_color1,
                 ],
                ),
               ),
               child: Container(
                alignment: Alignment.center,
                child: const Text(
                 "Submit",
                 style: TextStyle(
                     fontWeight: FontWeight.w700,
                     fontSize: 18,
                     color: Colors.white),
                ),
               ),
              ),
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
   },
  );
 }
 static MarketHub_Process_popup(context) async {
  String? AliceRedirectUrl;
  SharedPreferences prefs= await SharedPreferences.getInstance();
  AliceRedirectUrl=prefs.getString("AliceRedirectUrl");

  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
       int _currentStep = 0;
       return StatefulBuilder(
           builder: (BuildContext context, StateSetter setState) {
            tapped(int step) {
             setState(() => _currentStep = step);
            }
            continued() {
             _currentStep < 2 ? setState(() => _currentStep += 1) : null;
            }
            cancel() {
             _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
            }
            return Container(
             height: 130,
             margin: const EdgeInsets.only(left: 15, right: 15),
             width: MediaQuery.of(context).size.width,
             child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              elevation: 0,
              title: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                Container(
                    child: const Text(
                     'Process Detail',
                     style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
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
               height:130,
               width: MediaQuery.of(context).size.width,
               child: SingleChildScrollView(
                   scrollDirection: Axis.vertical,
                   child: Column(
                    children: [
                     Container(
                      child:const Text("Please Update CLIENT CODE , PASSWORD CODE And VERIFICATION CODE for all these details please contact with Market hub broker then Submit And Login With Api Trading On...",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 13),),
                     ),
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

 //Zerodha
 static Broker_connect_Zerodha_popup(context) {
  final _formKey = GlobalKey<FormState>();

  return showModalBottomSheet(
   shape:const RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
           topLeft: Radius.circular(10),
           topRight: Radius.circular(10)
       )
   ),
   clipBehavior: Clip.antiAliasWithSaveLayer,
   isScrollControlled: true,
   context: context,
   builder: (BuildContext context) {
    return StatefulBuilder(
     builder: (BuildContext ctx, StateSetter setState) {
      return Padding(
       // Add padding at the bottom when the keyboard is open
       padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
       ),
       child: SingleChildScrollView(
        child: Container(
         padding: const EdgeInsets.all(16.0),
         constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 1.8,
         ),
         child:  Form(
          key: _formKey,
          child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
              GestureDetector(
               onTap: (){
                Zerodha_Process_popup(context);
               },
               child: Container(
                alignment: Alignment.center,
                height: 25,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300
                ),
                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
               ),
              ),
             ],
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Key",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Key';
               }
               return null;
              },
              controller: api_key,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Key",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Secret",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Secret';
               }
               return null;
              },
              controller: api_secret,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Secret",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),
            GestureDetector(
             onTap: () {
              if (_formKey.currentState!.validate()){
               user_id.text="";
               BrokerConnect_Api("5",context);
              }
             },
             child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Container(
               height: 45,
               alignment: Alignment.topLeft,
               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
               width: MediaQuery.of(context).size.width / 3,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                gradient: LinearGradient(
                 begin: Alignment.topRight,
                 end: Alignment.bottomLeft,
                 stops: [0.1, 0.5],
                 colors: [
                  ColorValues.Splash_bg_color1,
                  ColorValues.Splash_bg_color1,
                 ],
                ),
               ),
               child: Container(
                alignment: Alignment.center,
                child: const Text(
                 "Submit",
                 style: TextStyle(
                     fontWeight: FontWeight.w700,
                     fontSize: 18,
                     color: Colors.white),
                ),
               ),
              ),
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
   },
  );
 }
 static Zerodha_Process_popup(context) async {
  String? ZerodhaRedirectUrl;
  SharedPreferences prefs= await SharedPreferences.getInstance();
  ZerodhaRedirectUrl=prefs.getString("ZerodhaRedirectUrl");

  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
       int _currentStep = 0;
       return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
         return Container(
          height: 300,
          margin: const EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: AlertDialog(
           insetPadding: EdgeInsets.zero,
           elevation: 0,
           title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text(
              'Process Detail',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
             ),
             GestureDetector(
              onTap: () {
               Navigator.pop(context);
              },
              child: const Icon(Icons.clear, color: Colors.black),
             ),
            ],
           ),
           content: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               /// **Instruction Text**
                Text(
                "Kindly follow these steps to link your demat account.",
                style: TextStyle(fontWeight: FontWeight.w600, color: ColorValues.Splash_bg_color1),
               ),
               const SizedBox(height: 10),

               /// ✅ **Step 1: Click Link & Login**
               Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                 padding: const EdgeInsets.all(12),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 1: Click below link and Login',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   GestureDetector(
                    onTap: () async {
                     String url = "https://kite.trade/";
                     if (await canLaunch(url)) {
                      await launch(url);
                     } else {
                      throw 'Could not launch $url';
                     }
                    },
                    child: Text(
                     "https://kite.trade/",
                     style: TextStyle(color: ColorValues.Splash_bg_color1, fontSize: 13),
                    ),
                   ),
                  ],
                 ),
                ),
               ),

               /// ✅ **Step 2: Enter Details & Copy URL**
               Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                 padding: const EdgeInsets.all(12),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 2: Enter your Details and the Redirect URL which is given below.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   Text(
                    "$ZerodhaRedirectUrl",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                   ),

                   /// ✅ **Copy Button**
                   Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     GestureDetector(
                      onTap: () => copyToClipboard(context, "$ZerodhaRedirectUrl"),
                      child: Container(
                       height: 25,
                       width: 40,
                       margin: const EdgeInsets.only(left: 20, top: 7),
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorValues.Splash_bg_color1, width: 0.4),
                        gradient: LinearGradient(
                         begin: Alignment.topRight,
                         end: Alignment.bottomLeft,
                         stops: [0.1, 0.5],
                         colors: [
                          ColorValues.Splash_bg_color1,
                          ColorValues.Splash_bg_color1,
                         ],
                        ),
                       ),
                       alignment: Alignment.center,
                       child: const Icon(Icons.copy, color: Colors.white, size: 15),
                      ),
                     )
                    ],
                   ),
                  ],
                 ),
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
      }) ??
      false;
 }

 //UpStox
 static Broker_connect_UpStox_popup(context) {
  final _formKey = GlobalKey<FormState>();

  return showModalBottomSheet(
   shape:const RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
           topLeft: Radius.circular(10),
           topRight: Radius.circular(10)
       )
   ),
   clipBehavior: Clip.antiAliasWithSaveLayer,
   isScrollControlled: true,
   context: context,
   builder: (BuildContext context) {
    return StatefulBuilder(
     builder: (BuildContext ctx, StateSetter setState) {
      return Padding(
       // Add padding at the bottom when the keyboard is open
       padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
       ),
       child: SingleChildScrollView(
        child: Container(
         padding: const EdgeInsets.all(16.0),
         constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 1.8,
         ),
         child:  Form(
          key: _formKey,
          child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
              GestureDetector(
               onTap: (){
                Upstox_Process_popup(context);
               },
               child: Container(
                alignment: Alignment.center,
                height: 25,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300
                ),
                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
               ),
              ),
             ],
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Key",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Key';
               }
               return null;
              },
              controller: api_key,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Key",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Secret",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Secret';
               }
               return null;
              },
              controller: api_secret,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Secret",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),
            GestureDetector(
             onTap: () {
              if (_formKey.currentState!.validate()){
               user_id.text="";
               BrokerConnect_Api("6",context);
              }
             },
             child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Container(
               height: 45,
               alignment: Alignment.topLeft,
               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
               width: MediaQuery.of(context).size.width / 3,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                gradient: LinearGradient(
                 begin: Alignment.topRight,
                 end: Alignment.bottomLeft,
                 stops: [0.1, 0.5],
                 colors: [
                  ColorValues.Splash_bg_color1,
                  ColorValues.Splash_bg_color1,
                 ],
                ),
               ),
               child: Container(
                alignment: Alignment.center,
                child: const Text(
                 "Submit",
                 style: TextStyle(
                     fontWeight: FontWeight.w700,
                     fontSize: 18,
                     color: Colors.white),
                ),
               ),
              ),
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
   },
  );
 }
 static Upstox_Process_popup(context) async {
  String? UpstoxRedirectUrl;
  SharedPreferences prefs= await SharedPreferences.getInstance();
  UpstoxRedirectUrl=prefs.getString("UpstoxRedirectUrl");

  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
       int _currentStep = 0;
       return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
         return Container(
          height: 400,
          margin: const EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: AlertDialog(
           insetPadding: EdgeInsets.zero,
           elevation: 0,
           title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text(
              'Process Detail',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
             ),
             GestureDetector(
              onTap: () {
               Navigator.pop(context);
              },
              child: const Icon(Icons.clear, color: Colors.black),
             ),
            ],
           ),
           content: SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               /// **Instruction Text**
                Text(
                "Please update SECRET KEY and APP KEY. For all these details, please contact Laxmi broker, then submit and login with API Trading.",
                style: TextStyle(fontWeight: FontWeight.w600, color: ColorValues.Splash_bg_color1),
               ),
               const SizedBox(height: 10),

               /// ✅ **Step 1: Click Link & Login**
               Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                 padding: const EdgeInsets.all(12),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 1: Click below link and Login',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   GestureDetector(
                    onTap: () async {
                     String url = "https://account.upstox.com/developer/apps";
                     if (await canLaunch(url)) {
                      await launch(url);
                     } else {
                      throw 'Could not launch $url';
                     }
                    },
                    child: Text(
                     "https://account.upstox.com/developer/apps",
                     style: TextStyle(color: ColorValues.Splash_bg_color1, fontSize: 13),
                    ),
                   ),
                  ],
                 ),
                ),
               ),

               /// ✅ **Step 2: Enter Details & Copy URL**
               Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                 padding: const EdgeInsets.all(12),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 2: Enter your Details and the Redirect URL which is given below.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   Text(
                    "$UpstoxRedirectUrl",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                   ),

                   /// ✅ **Copy Button**
                   Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     GestureDetector(
                      onTap: () => copyToClipboard(context, "$UpstoxRedirectUrl"),
                      child: Container(
                       height: 25,
                       width: 40,
                       margin: const EdgeInsets.only(left: 20, top: 7),
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorValues.Splash_bg_color1, width: 0.4),
                        gradient: LinearGradient(
                         begin: Alignment.topRight,
                         end: Alignment.bottomLeft,
                         stops: [0.1, 0.5],
                         colors: [
                          ColorValues.Splash_bg_color1,
                          ColorValues.Splash_bg_color1,
                         ],
                        ),
                       ),
                       alignment: Alignment.center,
                       child: const Icon(Icons.copy, color: Colors.white, size: 15),
                      ),
                     )
                    ],
                   ),
                  ],
                 ),
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

       // StatefulBuilder(
        //    builder: (BuildContext context, StateSetter setState) {
        //     tapped(int step) {
        //      setState(() => _currentStep = step);
        //     }
        //     continued() {
        //      _currentStep < 2 ? setState(() => _currentStep += 1) : null;
        //     }
        //     cancel() {
        //      _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
        //     }
        //     return Container(
        //      height: 400,
        //      margin: const EdgeInsets.only(left: 15, right: 15),
        //      width: MediaQuery.of(context).size.width,
        //      child: AlertDialog(
        //       insetPadding: EdgeInsets.zero,
        //       elevation: 0,
        //       title: Row(
        //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //        children: [
        //         Container(
        //             child: const Text(
        //              'Process Detail',
        //              style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
        //             )),
        //         GestureDetector(
        //          onTap: () {
        //           Navigator.pop(context);
        //          },
        //          child: Container(
        //           alignment: Alignment.topRight,
        //           child: const Icon(
        //            Icons.clear,
        //            color: Colors.black,
        //           ),
        //          ),
        //         ),
        //        ],
        //       ),
        //       content: Container(
        //        height:400,
        //        width: MediaQuery.of(context).size.width,
        //        child: SingleChildScrollView(
        //            scrollDirection: Axis.vertical,
        //            child: Column(
        //             children: [
        //              Container(
        //               child:const Text("Please Update SECRET KEY and APP KEY for all these details please contact with Laxmi broker then Submit And Login With Api Trading On...",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
        //              ),
        //              Container(
        //               margin: const EdgeInsets.only(top: 5),
        //               child: Stepper(
        //                physics: const ScrollPhysics(),
        //                currentStep: _currentStep,
        //                onStepTapped: (step) => tapped(step),
        //                onStepContinue: continued,
        //                onStepCancel: cancel,
        //                controlsBuilder: (context, controller) {
        //                 return const SizedBox.shrink();
        //                },
        //                steps: <Step>[
        //                 Step(
        //                  title: const Text('Click below link and Login',style: TextStyle(fontWeight: FontWeight.w600),),
        //                  content: Column(
        //                   children: <Widget>[
        //                    GestureDetector(
        //                        onTap: () async {
        //                         String? url="https://account.upstox.com/developer/apps";
        //                         if (await canLaunch(url)) {
        //                          await launch(url);
        //                         } else {
        //                          throw 'Could not launch $url';
        //                         }
        //                        },
        //                        child: Container(child:const Text("https://account.upstox.com/developer/apps",style: TextStyle(color: ColorValues.Splash_bg_color1,fontSize: 13),),))
        //
        //                   ],
        //                  ),
        //                  isActive: _currentStep >= 0,
        //                  state: _currentStep == 0
        //                      ? StepState.editing
        //                      : StepState.indexed,
        //                 ),
        //                 Step(
        //                  title: const Text('Enter your Details and the Redirect URL which is given below.',style: TextStyle(fontWeight: FontWeight.w600),),
        //                  content: Column(
        //                   children: <Widget>[
        //                    Container(
        //                     // width: MediaQuery.of(context).size.width/2.2,
        //                     child: Text("$UpstoxRedirectUrl",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
        //                    ),
        //
        //                    Row(
        //                     mainAxisAlignment: MainAxisAlignment.end,
        //                     children: [
        //                      GestureDetector(
        //                       onTap: () => copyToClipboard(context, "$UpstoxRedirectUrl"),
        //                       child: Container(
        //                        height: 25,
        //                        width: 40,
        //                        margin:const EdgeInsets.only(left: 20,top: 7),
        //                        decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(5),
        //                         border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
        //                         gradient:const LinearGradient(
        //                          begin: Alignment.topRight,
        //                          end: Alignment.bottomLeft,
        //                          stops: [
        //                           0.1,
        //                           0.5,
        //                          ],
        //                          colors: [
        //                           ColorValues.Splash_bg_color1,
        //                           ColorValues.Splash_bg_color1,
        //                          ],
        //                         ),
        //                        ),
        //                        alignment: Alignment.center,
        //                        child:const Icon(Icons.copy,color: Colors.white,size: 15),
        //                       ),
        //                      )
        //                     ],
        //                    )
        //
        //                   ],
        //                  ),
        //                  isActive: _currentStep >= 0,
        //                  state: _currentStep == 1
        //                      ? StepState.editing
        //                      : StepState.indexed,
        //                 ),
        //                ],
        //               ),
        //              ),
        //             ],
        //            )
        //        ),
        //       ),
        //      ),
        //     );
        //    })

      }) ??
      false;
 }

 //Dhan
 static Broker_connect_Dhan_popup(context) {

  final _formKey = GlobalKey<FormState>();
  bool? Status_dhanbroker;
  String? Message_dhanbroker;
  BrokerConnectDhan_Api() async {
   SharedPreferences prefs= await SharedPreferences.getInstance();
   String? Id_brokerconnectdhan = prefs.getString('Login_id');

   print("111aa: $Id_brokerconnectdhan");
   print("222aa: ${api_key.text}");
   print("333aa: ${api_secret.text}");
   print("urlllllaa: ${Util.Local_Url}/dhan/getaccesstoken");

   var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/dhan/getaccesstoken"),
       headers: {
        'Content-Type': 'application/json',
       },
       body:jsonEncode(
           {
            "id":"$Id_brokerconnectdhan",
            "apikey":"${api_key.text}",
            "apisecret":"${api_secret.text}",
           }
       )
   );

   var jsonString = jsonDecode(response.body);
   print("Jsnnnnnn: $jsonString");
   Status_dhanbroker=jsonString['status'];
   Message_dhanbroker=jsonString['message'];

   if(Status_dhanbroker==true){
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(
      content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
     ),
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));

    api_key.clear();
    api_secret.clear();
   }

   else{
    Fluttertoast.showToast(
        msg: "${Message_dhanbroker}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    // ScaffoldMessenger.of(context).showSnackBar(
    //  const SnackBar(
    //   content: Text('Error connecting broker.',style: TextStyle(color: Colors.white)),
    //   duration: Duration(seconds: 3),
    //   backgroundColor: Colors.red,
    //  ),
    // );

   }
  }


  return showModalBottomSheet(
   shape:const RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
           topLeft: Radius.circular(10),
           topRight: Radius.circular(10)
       )
   ),
   clipBehavior: Clip.antiAliasWithSaveLayer,
   isScrollControlled: true,
   context: context,
   builder: (BuildContext context) {
    return StatefulBuilder(
     builder: (BuildContext ctx, StateSetter setState) {
      return Padding(
       // Add padding at the bottom when the keyboard is open
       padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
       ),
       child: SingleChildScrollView(
        child: Container(
         padding: const EdgeInsets.all(16.0),
         constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 1.8,
         ),
         child:  Form(
          key: _formKey,
          child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
              GestureDetector(
               onTap: (){
                Dhan_Process_popup(context);
               },
               child: Container(
                alignment: Alignment.center,
                height: 25,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300
                ),
                child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
               ),
              ),
             ],
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Key",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Key';
               }
               return null;
              },
              controller: api_key,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Key",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),

            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20),
             child: const Text(
              "Api Secret",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
             ),
            ),
            Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
             child: TextFormField(
              cursorColor: Colors.black,
              cursorWidth: 1.1,
              validator: (value) {
               if (value == null || value.isEmpty) {
                return 'Please Enter Api Secret';
               }
               return null;
              },
              controller: api_secret,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
               ),
               hintText: "Enter Api Secret",
               contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
               hintStyle: const TextStyle(fontSize: 13),
               prefixIcon: const Icon(Icons.api),
              ),
             ),
            ),
            GestureDetector(
             onTap: () {
              if (_formKey.currentState!.validate()){
               user_id.text="";
               BrokerConnectDhan_Api();
              }
             },
             child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Container(
               height: 45,
               alignment: Alignment.topLeft,
               margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
               width: MediaQuery.of(context).size.width / 3,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                gradient: LinearGradient(
                 begin: Alignment.topRight,
                 end: Alignment.bottomLeft,
                 stops: [0.1, 0.5],
                 colors: [
                  ColorValues.Splash_bg_color1,
                  ColorValues.Splash_bg_color1,
                 ],
                ),
               ),
               child: Container(
                alignment: Alignment.center,
                child: const Text(
                 "Submit",
                 style: TextStyle(
                     fontWeight: FontWeight.w700,
                     fontSize: 18,
                     color: Colors.white),
                ),
               ),
              ),
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
   },
  );
 }
 static Dhan_Process_popup(context) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
       int _currentStep = 0;
       return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
         return Container(
          height: 400,
          margin: const EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: AlertDialog(
           insetPadding: EdgeInsets.zero,
           elevation: 0,
           title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text(
              'Process Detail',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
             ),
             GestureDetector(
              onTap: () {
               Navigator.pop(context);
              },
              child: const Icon(Icons.clear, color: Colors.black),
             ),
            ],
           ),
           content: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               /// **Instruction Text**
                Text(
                "For CLIENT ID and ACCESS TOKEN go to your My Profile in Dhan and click on DhanHQ Trading APIs & Access to generate ACCESS TOKEN. Also, select 30 days validity for token expiry. You will get your Client Id in Profile and Access Token under DhanHQ Trading APIs & Access.",
                style: TextStyle(fontWeight: FontWeight.w600, color: ColorValues.Splash_bg_color1),
               ),
               const SizedBox(height: 10),

               /// ✅ **Step 1: Click Link & Login**
               Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                 padding: const EdgeInsets.all(12),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                    'Step 1: Click below link and Login',
                    style: TextStyle(fontWeight: FontWeight.w600),
                   ),
                   const SizedBox(height: 5),
                   GestureDetector(
                    onTap: () async {
                     String url = "https://dhan.co/";
                     if (await canLaunch(url)) {
                      await launch(url);
                     } else {
                      throw 'Could not launch $url';
                     }
                    },
                    child: Text(
                     "https://dhan.co/",
                     style: TextStyle(color: ColorValues.Splash_bg_color1, fontSize: 13),
                    ),
                   ),
                  ],
                 ),
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
      }) ??
      false;
 }

}
