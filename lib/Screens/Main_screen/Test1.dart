// // import 'dart:convert';
// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:stock_box/Api/Apis.dart';
// // import 'package:stock_box/Constants/Colors.dart';
// // import 'package:intl/intl.dart';
// // import 'package:stock_box/Screens/Main_screen/Broker/Webview_broker.dart';
// // import 'package:stock_box/Screens/Main_screen/Kyc/Kyc_formView.dart';
// // import 'package:http/http.dart' as http;
// //
// // class TradesNew extends StatefulWidget {
// //   String? Samiti;
// //
// //   TradesNew({super.key, required this.Samiti});
// //
// //   @override
// //   State<TradesNew> createState() => _TradesNewState(Samiti: Samiti);
// // }
// //
// // class _TradesNewState extends State<TradesNew>
// //     with SingleTickerProviderStateMixin {
// //   //Angel
// //   TextEditingController api_key = TextEditingController();
// //
// //   //Alice
// //   TextEditingController app_code = TextEditingController();
// //   TextEditingController user_id = TextEditingController();
// //   TextEditingController api_secret = TextEditingController();
// //
// //   String? Url_webview;
// //   bool? Status_broker;
// //
// //   BrokerConnect_Api(brokerid) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? Id_brokerconnect = prefs.getString('Login_id');
// //
// //     var response = await http.post(
// //         Uri.parse(
// //             "https://stockboxpnp.pnpuniverse.com/backend/api/client/brokerlink"),
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode({
// //           "id": "$Id_brokerconnect",
// //           "apikey": "${api_key.text}",
// //           "apisecret": "${api_secret.text}",
// //           "alice_userid": "${user_id.text}",
// //           "brokerid": "$brokerid"
// //         }));
// //     var jsonString = jsonDecode(response.body);
// //     print("JsnnnnnnPayout: $jsonString");
// //
// //     Status_broker = jsonString['status'];
// //
// //     if (Status_broker == true) {
// //       setState(() {});
// //       Url_webview = jsonString['url'];
// //
// //       print("Urllllll22222: $Url_webview");
// //
// //       Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //               builder: (context) => WebView_broker(Url: Url_webview)));
// //       api_key.clear();
// //     } else {
// //       print("Hello");
// //     }
// //   }
// //
// //   String? Samiti;
// //
// //   _TradesNewState({required this.Samiti});
// //
// //   String? Kyc_verification;
// //   String? Dlink_Status;
// //   String? Trading_Status;
// //   String? Broker_id;
// //   String? Api_key;
// //
// //   GetAllTradingStatus() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     Kyc_verification = prefs.getString("Kyc_verification");
// //     print("987654: $Kyc_verification");
// //     Dlink_Status = prefs.getString("Dlink_status");
// //     Trading_Status = prefs.getString("Trading_status");
// //     Broker_id = prefs.getString("Broker_id");
// //     Api_key = prefs.getString("Api_key");
// //   }
// //
// //   late final TabController _tabController;
// //
// //   // bool show=false;
// //
// //   var Signal_data;
// //   String? Message;
// //   bool? loader = false;
// //   List<String> time = [];
// //   List entryTime_live = [];
// //   List entryTime_close = [];
// //
// //   var open_signal = [];
// //   var close_signal = [];
// //
// //   List<double> result = [];
// //
// //   List<bool> show = [];
// //
// //   double percentage = 0.0;
// //
// //   Signal_Api() async {
// //     setState(() {
// //       Signal_data = [];
// //       open_signal.clear();
// //       GetAllTradingStatus();
// //       loader = false;
// //     });
// //
// //     print("Tab idddddd: $Samiti");
// //     var data = await API.Signal_Api(Samiti);
// //     setState(() {
// //       Signal_data = data['data'];
// //       print("Signal dataaa: $Signal_data");
// //       Message = data['message'];
// //       loader = true;
// //     });
// //
// //     for (int i = 0; i < Signal_data.length; i++) {
// //       show.add(false);
// //       if (Signal_data[i]['close_status'] == true) {
// //         time.add(Signal_data[i]['created_at']);
// //         entryTime_close = time.map((dateTimeString) {
// //           DateTime dateTime = DateTime.parse(dateTimeString);
// //           DateTime istTime = dateTime.add(Duration(hours: 5, minutes: 30));
// //           return DateFormat('d MMM, HH:mm').format(istTime);
// //         }).toList();
// //       } else {
// //         time.add(Signal_data[i]['created_at']);
// //         entryTime_live = time.map((dateTimeString) {
// //           DateTime dateTime = DateTime.parse(dateTimeString);
// //           DateTime istTime1 = dateTime.add(Duration(hours: 5, minutes: 30));
// //           return DateFormat('d MMM, HH:mm').format(istTime1);
// //         }).toList();
// //       }
// //
// //       Signal_data[i]['close_status'] == true
// //           ? close_signal.add(Signal_data[i])
// //           : open_signal.add(Signal_data[i]);
// //     }
// //
// //     for (int i = 0; i < close_signal.length; i++) {
// //       double num1 = double.parse(close_signal[i]['closeprice'] == null ||
// //           close_signal[i]['closeprice'] == ""
// //           ? "0.0"
// //           : close_signal[i]['closeprice']);
// //       double num2 = double.parse(
// //           close_signal[i]['price'] == null || close_signal[i]['price'] == ""
// //               ? "0.0"
// //               : close_signal[i]['price']);
// //
// //       if (close_signal[i]['calltype'] == "BUY") {
// //         percentage = ((num1 - num2) / num1) * 100;
// //       } else {
// //         percentage = ((num2 - num1) / num2) * 100;
// //       }
// //
// //       String formattedPercentage = percentage.toStringAsFixed(2);
// //
// //       result.add(double.parse(formattedPercentage));
// //
// //       print("Resultttttpercent: $result");
// //     }
// //
// //     print("Resultttttpercent1111: $result");
// //   }
// //
// //   TextEditingController quantity_placeorder = TextEditingController();
// //   TextEditingController quantity_placeorder_exit = TextEditingController();
// //   bool? Status_placeorder;
// //   String? Message_placeorder;
// //
// //   Place_order_Api(Signal_id, Signal_price, Url_placeorder) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? Iddd = prefs.getString('Login_id');
// //     print("Url_placeorder: $Url_placeorder");
// //     print("Iddd: $Iddd");
// //     print("signalid: $Signal_id");
// //     print("price: $Signal_price");
// //     print("quantity: ${quantity_placeorder.text}");
// //     var response = await http.post(Uri.parse("$Url_placeorder"),
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode({
// //           "id": "$Iddd",
// //           "signalid": "$Signal_id",
// //           "price": "$Signal_price",
// //           "quantity": "${quantity_placeorder.text}"
// //         }));
// //     var jsonString = jsonDecode(response.body);
// //     print("JsnnnnnnPlaceorder: $jsonString");
// //
// //     Status_placeorder = jsonString['status'];
// //     Message_placeorder = jsonString['message'];
// //
// //     if (Status_placeorder == true) {
// //       setState(() {});
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Order Placed Successfuly',
// //               style: TextStyle(color: Colors.white)),
// //           duration: Duration(seconds: 3),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //
// //       quantity_placeorder.clear();
// //
// //       Signal_Api();
// //
// //       Navigator.pop(context);
// //     }
// //
// //     else{
// //       Fluttertoast.showToast(
// //           backgroundColor: Colors.red,
// //           textColor: Colors.white,
// //           msg: "$Message_placeorder"
// //       );
// //     }
// //   }
// //
// //   bool? Status_placeorder_exit;
// //   String? Message_exit;
// //
// //   Exit_order_Api(SignalId_exit, SignalPrice_exit) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? Id_exit = prefs.getString('Login_id');
// //
// //     print("111111: $Id_exit");
// //     print("222222: $SignalId_exit");
// //     print("333333: $SignalPrice_exit");
// //     print("444444: ${quantity_placeorder_exit.text}");
// //
// //     var response = await http.post(
// //         Uri.parse("https://stockboxpnp.pnpuniverse.com/backend/angle/exitplaceorder"),
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode({
// //           "id": "$Id_exit",
// //           "signalid": "$SignalId_exit",
// //           "price": "$SignalPrice_exit",
// //           "quantity": "${quantity_placeorder_exit.text}"
// //         }));
// //     var jsonString = jsonDecode(response.body);
// //     print("JsnnnnnnExitorder: $jsonString");
// //
// //     Status_placeorder_exit = jsonString['status'];
// //     Message_exit = jsonString['message'];
// //
// //     if (Status_placeorder_exit == true) {
// //       setState(() {});
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('$Message_exit',
// //               style: const TextStyle(color: Colors.white)),
// //           duration: const Duration(seconds: 3),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //       quantity_placeorder_exit.clear();
// //
// //       Navigator.pop(context);
// //     } else {
// //       Fluttertoast.showToast(
// //           backgroundColor: Colors.red,
// //           msg: "$Message_exit",
// //           textColor: Colors.white);
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     _tabController = TabController(length: 2, vsync: this);
// //     Signal_Api();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return loader == true
// //         ? Container(
// //         child: Column(
// //           children: [
// //             Container(
// //               height: 40,
// //               width: MediaQuery.of(context).size.width,
// //               margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
// //               decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(10),
// //                   border:
// //                   Border.all(color: Colors.grey.shade400, width: 0.3)),
// //               child: TabBar(
// //                 dividerColor: Colors.transparent,
// //                 // padding: EdgeInsets.only(left: 25,right: 25),
// //                 unselectedLabelColor: Colors.black,
// //                 labelColor: Colors.white,
// //                 labelStyle: const TextStyle(
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //                 indicatorWeight: 0.0,
// //                 isScrollable: false,
// //                 controller: _tabController,
// //                 indicatorSize: TabBarIndicatorSize.tab,
// //                 indicator: BoxDecoration(
// //                   gradient: const LinearGradient(
// //                     begin: Alignment.topRight,
// //                     end: Alignment.bottomLeft,
// //                     // stops: [
// //                     //   0.1,
// //                     //   0.5,
// //                     // ],
// //                     colors: [
// //                       // Color(0xff93A5CF),
// //                       // Color(0xffE4EfE9)
// //                       Color(0xff354273),
// //                       Color(0xff354273),
// //                     ],
// //                   ),
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 tabs: const <Widget>[
// //                   Tab(
// //                     child: SizedBox(
// //                       width: double.infinity,
// //                       child: Align(
// //                         alignment: Alignment.center,
// //                         child: Text('Live Trades'),
// //                       ),
// //                     ),
// //                   ),
// //                   Tab(
// //                     child: SizedBox(
// //                       width: double.infinity,
// //                       child: Align(
// //                         alignment: Alignment.center,
// //                         child: Text('Closed Trades'),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               child: TabBarView(
// //                 controller: _tabController,
// //                 children: <Widget>[
// //                   open_signal.length <= 0
// //                       ? Container(
// //                     child: Center(
// //                         child: Image.asset(
// //                           "images/notrades.png",
// //                           height: 100,
// //                         )),
// //                   )
// //                       : Container(
// //                     margin: const EdgeInsets.only(
// //                       top: 15,
// //                     ),
// //                     child: ListView.builder(
// //                       itemCount: open_signal.length,
// //                       itemBuilder: (BuildContext context, int indexx) {
// //                         return Container(
// //                           margin: const EdgeInsets.only(
// //                               top: 10, bottom: 10, left: 15, right: 15),
// //                           // height: 320,
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(7),
// //                             color: const Color(0x7193a5cf),
// //                           ),
// //                           child: Column(
// //                             children: [
// //                               Container(
// //                                 margin: const EdgeInsets.only(
// //                                     top: 10, left: 10, right: 10),
// //                                 child: Row(
// //                                   mainAxisAlignment:
// //                                   MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     Container(
// //                                       child: Row(
// //                                         children: [
// //                                           const Icon(
// //                                             Icons.lock_clock,
// //                                             size: 18,
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets.only(
// //                                                 left: 10),
// //                                             child: Text(
// //                                               "${entryTime_live[indexx]}",
// //                                               style: const TextStyle(
// //                                                   fontSize: 11,
// //                                                   fontWeight:
// //                                                   FontWeight.w600),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     ),
// //                                     Container(
// //                                       height: 20,
// //                                       // width: 80,
// //                                       padding: EdgeInsets.only(
// //                                           left: 10, right: 10),
// //                                       decoration: BoxDecoration(
// //                                         borderRadius:
// //                                         BorderRadius.circular(15),
// //                                         border: Border.all(
// //                                             color: Colors.black,
// //                                             width: 0.3),
// //                                         color: Colors.white,
// //                                       ),
// //                                       alignment: Alignment.center,
// //                                       child: Text(
// //                                         "${open_signal[indexx]['callduration']}",
// //                                         style: const TextStyle(
// //                                             fontSize: 11),
// //                                       ),
// //                                     )
// //                                   ],
// //                                 ),
// //                               ),
// //
// //                               Container(
// //                                 margin: const EdgeInsets.only(
// //                                     top: 15, left: 15, right: 15),
// //                                 // height: 180,
// //                                 decoration: BoxDecoration(
// //                                     color: Colors.white,
// //                                     borderRadius:
// //                                     BorderRadius.circular(5)),
// //                                 child: Column(
// //                                   children: [
// //                                     Container(
// //                                       margin:
// //                                       const EdgeInsets.only(top: 5),
// //                                       child: Row(
// //                                         children: [
// //                                           // Container(
// //                                           //   child: Image.asset("images/Tata_Power_Logo.png",height: 50,width: 60,),
// //                                           // ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets.only(
// //                                                 left: 15, top: 5),
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                               CrossAxisAlignment
// //                                                   .start,
// //                                               children: [
// //                                                 Container(
// //                                                   child: Row(
// //                                                     children: [
// //                                                       Text(
// //                                                         "${open_signal[indexx]['stock']}",
// //                                                         style: const TextStyle(
// //                                                             fontSize:
// //                                                             13,
// //                                                             fontWeight:
// //                                                             FontWeight
// //                                                                 .w600),
// //                                                       ),
// //                                                       open_signal[indexx]
// //                                                       [
// //                                                       'tradesymbol'] ==
// //                                                           "" ||
// //                                                           open_signal[indexx]
// //                                                           [
// //                                                           'tradesymbol'] ==
// //                                                               null
// //                                                           ? SizedBox()
// //                                                           : Text(
// //                                                         " (${open_signal[indexx]['tradesymbol']})",
// //                                                         style: const TextStyle(
// //                                                             fontSize:
// //                                                             13,
// //                                                             fontWeight:
// //                                                             FontWeight.w600),
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                 ),
// //                                                 Container(
// //                                                   child: Row(
// //                                                     children: [
// //                                                       Container(
// //                                                         margin:
// //                                                         const EdgeInsets
// //                                                             .only(
// //                                                             top: 2),
// //                                                         child: Text(
// //                                                           "₹${open_signal[indexx]['price']}",
// //                                                           style: const TextStyle(
// //                                                               fontSize:
// //                                                               11),
// //                                                         ),
// //                                                       ),
// //
// //                                                       // Container(
// //                                                       //     child:const Icon(Icons.arrow_drop_up,color: Colors.green,)
// //                                                       // ),
// //                                                       //
// //                                                       // Container(
// //                                                       //   child:const Text("67.32(5.45%)",style: TextStyle(fontSize: 11,color: Colors.green),),
// //                                                       // ),
// //                                                     ],
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                     Container(
// //                                       margin: const EdgeInsets.only(
// //                                           top: 10, left: 15, right: 15),
// //                                       height: 40,
// //                                       decoration: BoxDecoration(
// //                                           border: Border.all(
// //                                               color: ColorValues
// //                                                   .Splash_bg_color1,
// //                                               width: 0.5),
// //                                           borderRadius:
// //                                           BorderRadius.circular(
// //                                               10)),
// //                                       child: Column(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment.center,
// //                                         crossAxisAlignment:
// //                                         CrossAxisAlignment.center,
// //                                         children: [
// //                                           // Container(
// //                                           //     margin:const EdgeInsets.only(top: 10),
// //                                           //     child: Row(
// //                                           //       mainAxisAlignment:MainAxisAlignment.center ,
// //                                           //       children: [
// //                                           //         Container(
// //                                           //           child: Text("Suggested Entry: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
// //                                           //         ),
// //                                           //         Container(
// //                                           //           margin:const EdgeInsets.only(left: 8),
// //                                           //           child:const Text("1320.50",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
// //                                           //         )
// //                                           //       ],
// //                                           //     )
// //                                           // ),
// //                                           //
// //                                           // Container(
// //                                           //     margin:const EdgeInsets.only(left: 20,right: 20),
// //                                           //     child: Divider(color: Colors.grey.shade500,)
// //                                           // ),
// //
// //                                           Container(
// //                                             // margin:const EdgeInsets.only(top: 5),
// //                                             child: Row(
// //                                               mainAxisAlignment:
// //                                               MainAxisAlignment
// //                                                   .center,
// //                                               children: [
// //                                                 Container(
// //                                                   child: Text(
// //                                                     "Entry price: ",
// //                                                     style: TextStyle(
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w500,
// //                                                         color: Colors
// //                                                             .grey
// //                                                             .shade700),
// //                                                   ),
// //                                                 ),
// //                                                 Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(
// //                                                       left: 8),
// //                                                   child: Text(
// //                                                     "( ₹${open_signal[indexx]['price']} )",
// //                                                     style: const TextStyle(
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600,
// //                                                         fontSize: 12,
// //                                                         color: ColorValues
// //                                                             .Splash_bg_color1),
// //                                                   ),
// //                                                 )
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                     Container(
// //                                       margin: const EdgeInsets.only(
// //                                           top: 12, left: 10, right: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                               CrossAxisAlignment
// //                                                   .start,
// //                                               children: [
// //                                                 Container(
// //                                                   child: const Text(
// //                                                     "Stoploss:",
// //                                                     style: TextStyle(
// //                                                         fontSize: 12),
// //                                                   ),
// //                                                 ),
// //                                                 Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(top: 5),
// //                                                   child: open_signal[
// //                                                   indexx]
// //                                                   [
// //                                                   'stoploss'] ==
// //                                                       ""
// //                                                       ? const Text(
// //                                                     "- -",
// //                                                     style: TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   )
// //                                                       : Text(
// //                                                     "₹${open_signal[indexx]['stoploss']}",
// //                                                     style: const TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   ),
// //                                                 )
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                               CrossAxisAlignment
// //                                                   .start,
// //                                               children: [
// //                                                 Container(
// //                                                   child: const Text(
// //                                                     "Target:",
// //                                                     style: TextStyle(
// //                                                         fontSize: 12),
// //                                                   ),
// //                                                 ),
// //                                                 Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(top: 5),
// //                                                   child: open_signal[
// //                                                   indexx]
// //                                                   [
// //                                                   'targetprice'] ==
// //                                                       null
// //                                                       ? const Text(
// //                                                     "- -",
// //                                                     style: TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   )
// //                                                       : Text(
// //                                                     "₹${open_signal[indexx]['targetprice']}",
// //                                                     style: const TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                               CrossAxisAlignment
// //                                                   .start,
// //                                               children: [
// //                                                 Container(
// //                                                   child: const Text(
// //                                                     "Hold duration:",
// //                                                     style: TextStyle(
// //                                                         fontSize: 12),
// //                                                   ),
// //                                                 ),
// //                                                 open_signal[indexx][
// //                                                 'segment'] ==
// //                                                     "F" ||
// //                                                     open_signal[indexx]
// //                                                     [
// //                                                     'segment'] ==
// //                                                         "O"
// //                                                     ? Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(
// //                                                       top: 5),
// //                                                   child: Text(
// //                                                     "${open_signal[indexx]['expirydate'].substring(0, 2)}-${open_signal[indexx]['expirydate'].substring(2, 4)}-${open_signal[indexx]['expirydate'].substring(4, 8)}",
// //                                                     style: const TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   ),
// //                                                 )
// //                                                     : Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(
// //                                                       top: 5),
// //                                                   child: Text(
// //                                                     open_signal[indexx]
// //                                                     [
// //                                                     'callduration'] ==
// //                                                         "Intraday"
// //                                                         ? "Intraday"
// //                                                         : open_signal[indexx]['callduration'] ==
// //                                                         "Short Term"
// //                                                         ? "(15-30 days)"
// //                                                         : open_signal[indexx]['callduration'] == "Medium Term"
// //                                                         ? "(Above 3 month)"
// //                                                         : "(Above 1 year)",
// //                                                     style: const TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                     GestureDetector(
// //                                       onTap: () {
// //                                         print("Hello");
// //                                         setState(() {
// //                                           show[indexx] = !show[indexx];
// //                                         });
// //                                         print(
// //                                             "Hello=== ${show[indexx]}");
// //                                       },
// //                                       child: Container(
// //                                         margin: const EdgeInsets.only(
// //                                             left: 8,
// //                                             right: 8,
// //                                             top: 12,
// //                                             bottom: 12),
// //                                         height: 25,
// //                                         width: double.infinity,
// //                                         decoration: BoxDecoration(
// //                                             borderRadius:
// //                                             BorderRadius.circular(
// //                                                 10),
// //                                             color:
// //                                             Colors.grey.shade200),
// //                                         child: Row(
// //                                           mainAxisAlignment:
// //                                           MainAxisAlignment
// //                                               .spaceBetween,
// //                                           children: [
// //                                             Container(
// //                                               margin:
// //                                               const EdgeInsets.only(
// //                                                   left: 8,
// //                                                   bottom: 2),
// //                                               child: Text(
// //                                                 "Entry price :",
// //                                                 style: TextStyle(
// //                                                     fontSize: 12,
// //                                                     color: Colors
// //                                                         .grey.shade700),
// //                                               ),
// //                                             ),
// //                                             // Container(
// //                                             //   margin: const EdgeInsets.only(left: 28),
// //                                             //   child: const Text(
// //                                             //     "",
// //                                             //     style: TextStyle(
// //                                             //         fontSize: 11,
// //                                             //         color: Colors.red,
// //                                             //         fontWeight: FontWeight.w600),
// //                                             //   ),
// //                                             // ),
// //
// //                                             Container(
// //                                               margin:
// //                                               const EdgeInsets.only(
// //                                                   left: 8,
// //                                                   bottom: 2),
// //                                               child: Text(
// //                                                 "₹${open_signal[indexx]['price']}",
// //                                                 style: TextStyle(
// //                                                     fontSize: 12,
// //                                                     color: Colors
// //                                                         .grey.shade700),
// //                                               ),
// //                                             ),
// //
// //                                             Container(
// //                                                 margin: const EdgeInsets
// //                                                     .only(
// //                                                     right: 8,
// //                                                     bottom: 3),
// //                                                 child: Icon(
// //                                                   show[indexx] == true
// //                                                       ? Icons
// //                                                       .arrow_drop_up
// //                                                       : Icons
// //                                                       .arrow_drop_down,
// //                                                   size: 25,
// //                                                   color: Colors.black,
// //                                                 )),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     show[indexx] == true &&
// //                                         open_signal[indexx]
// //                                         ['tag1'] !=
// //                                             ""
// //                                         ? Container(
// //                                       height: 25,
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(8),
// //                                           color: Colors
// //                                               .grey.shade200),
// //                                       margin:
// //                                       const EdgeInsets.only(
// //                                           left: 15,
// //                                           right: 15,
// //                                           top: 5,
// //                                           bottom: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 left: 10),
// //                                             child: const Text(
// //                                               "Target 1",
// //                                               style: TextStyle(
// //                                                   fontSize: 11),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 right: 10),
// //                                             child: Text(
// //                                               "₹${open_signal[indexx]['tag1']}",
// //                                               style:
// //                                               const TextStyle(
// //                                                   fontSize:
// //                                                   11),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     )
// //                                         : const SizedBox(
// //                                       height: 0,
// //                                     ),
// //                                     show[indexx] == true &&
// //                                         open_signal[indexx]
// //                                         ['tag2'] !=
// //                                             ""
// //                                         ? Container(
// //                                       height: 25,
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(8),
// //                                           color: Colors
// //                                               .grey.shade200),
// //                                       margin:
// //                                       const EdgeInsets.only(
// //                                           left: 15,
// //                                           right: 15,
// //                                           top: 5,
// //                                           bottom: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 left: 10),
// //                                             child: const Text(
// //                                               "Target 2",
// //                                               style: TextStyle(
// //                                                   fontSize: 11),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 right: 10),
// //                                             child: Text(
// //                                               "₹${open_signal[indexx]['tag2']}",
// //                                               style:
// //                                               const TextStyle(
// //                                                   fontSize:
// //                                                   11),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     )
// //                                         : const SizedBox(
// //                                       height: 0,
// //                                     ),
// //                                     show[indexx] == true &&
// //                                         open_signal[indexx]
// //                                         ['tag3'] !=
// //                                             ""
// //                                         ? Container(
// //                                       height: 25,
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(8),
// //                                           color: Colors
// //                                               .grey.shade200),
// //                                       margin:
// //                                       const EdgeInsets.only(
// //                                           left: 15,
// //                                           right: 15,
// //                                           top: 5,
// //                                           bottom: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 left: 10),
// //                                             child: const Text(
// //                                               "Target 3",
// //                                               style: TextStyle(
// //                                                   fontSize: 11),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 right: 10),
// //                                             child: Text(
// //                                               "₹${open_signal[indexx]['tag3']}",
// //                                               style:
// //                                               const TextStyle(
// //                                                   fontSize:
// //                                                   11),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     )
// //                                         : const SizedBox(
// //                                       height: 0,
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //
// //                               // Container(
// //                               //   margin:const EdgeInsets.only(top: 7),
// //                               //   child: Row(
// //                               //     mainAxisAlignment: MainAxisAlignment.center,
// //                               //     children: [
// //                               //       Container(
// //                               //         child:const Text("Gain so far : "),
// //                               //       ),
// //                               //
// //                               //       Container(
// //                               //         alignment: Alignment.center,
// //                               //         height: 20,
// //                               //         width: 70,
// //                               //         decoration: BoxDecoration(
// //                               //             borderRadius: BorderRadius.circular(10),
// //                               //             color: Colors.green
// //                               //         ),
// //                               //         child: Row(
// //                               //           mainAxisAlignment: MainAxisAlignment.center,
// //                               //           children: [
// //                               //             const Icon(Icons.arrow_drop_up,color: Colors.white,size: 15,),
// //                               //             Container(
// //                               //               child:const Text("1.50%",style: TextStyle(fontSize: 12,color: Colors.white),),
// //                               //             ),
// //                               //           ],
// //                               //         ),
// //                               //       ),
// //                               //
// //                               //     ],
// //                               //   ),
// //                               // ),
// //
// //                               Container(
// //                                 margin: const EdgeInsets.only(
// //                                     top: 10,
// //                                     left: 15,
// //                                     right: 15,
// //                                     bottom: 10),
// //                                 height: 40,
// //                                 width: double.infinity,
// //                                 decoration: BoxDecoration(
// //                                     color: Colors.grey.shade100,
// //                                     borderRadius:
// //                                     BorderRadius.circular(8)),
// //                                 child: Row(
// //                                   mainAxisAlignment:
// //                                   MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     GestureDetector(
// //                                       onTap: () {
// //                                         String? Description =
// //                                         open_signal[indexx]
// //                                         ['description'];
// //                                         Description_popup(Description);
// //                                       },
// //                                       child: Container(
// //                                         margin: const EdgeInsets.only(
// //                                             left: 20),
// //                                         child: const Text(
// //                                           "View Detail",
// //                                           style: TextStyle(
// //                                               fontSize: 13,
// //                                               fontWeight:
// //                                               FontWeight.w600,
// //                                               color: ColorValues
// //                                                   .Splash_bg_color2),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     open_signal[indexx]['purchased'] ==
// //                                         true
// //                                         ? Container(
// //                                       margin:
// //                                       const EdgeInsets.only(
// //                                           right: 20),
// //                                       height: 25,
// //                                       width: 60,
// //                                       alignment: Alignment.center,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(4),
// //                                           color: Colors.grey),
// //                                       child: Text(
// //                                         "${open_signal[indexx]['calltype']}",
// //                                         style: const TextStyle(
// //                                             fontSize: 12,
// //                                             color: Colors.black),
// //                                       ),
// //                                     )
// //                                         : open_signal[indexx]
// //                                     ['calltype'] ==
// //                                         "BUY" ||
// //                                         open_signal[indexx]
// //                                         ['calltype'] ==
// //                                             "buy"
// //                                         ? GestureDetector(
// //                                       onTap: () {
// //                                         if (Kyc_verification ==
// //                                             "1") {
// //                                           if (Dlink_Status ==
// //                                               "0") {
// //                                             Broker_link_popup();
// //                                           } else {
// //                                             if (Trading_Status ==
// //                                                 "0") {
// //                                               if (Broker_id ==
// //                                                   "1") {
// //                                                 String? Url =
// //                                                     "https://smartapi.angelone.in/publisher-login?api_key=${Api_key}";
// //                                                 Navigator.push(
// //                                                     context,
// //                                                     MaterialPageRoute(
// //                                                         builder: (context) =>
// //                                                             WebView_broker(Url: Url)));
// //                                               } else {
// //                                                 String? Url =
// //                                                     "https://ant.aliceblueonline.com/?appcode=${Api_key}";
// //                                                 Navigator.push(
// //                                                     context,
// //                                                     MaterialPageRoute(
// //                                                         builder: (context) =>
// //                                                             WebView_broker(Url: Url)));
// //                                               }
// //                                             } else {
// //                                               String?
// //                                               Signal_id =
// //                                               open_signal[
// //                                               indexx]
// //                                               ['_id'];
// //                                               String?
// //                                               Signal_price =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'price'];
// //                                               String?
// //                                               Signal_name =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'stock'];
// //                                               String?
// //                                               Entry_type =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'calltype'];
// //                                               String?
// //                                               Segment =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'segment'];
// //
// //                                               String?
// //                                               Expiry_date =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'expirydate'];
// //                                               String?
// //                                               Trade_Symbol =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'tradesymbol'];
// //                                               print("Trade symbol : $Trade_Symbol");
// //
// //                                               String?
// //                                               Lot_size =
// //                                               open_signal[indexx]
// //                                               [
// //                                               'lotsize']
// //                                                   .toString();
// //
// //                                               if (Broker_id ==
// //                                                   "1") {
// //                                                 String?
// //                                                 Url_placeorder =
// //                                                     "https://stockboxpnp.pnpuniverse.com/backend/angle/placeorder";
// //                                                 Place_order_popup(
// //                                                   Signal_id,
// //                                                   Signal_price,
// //                                                   Url_placeorder,
// //                                                   Signal_name,
// //                                                   Entry_type,
// //                                                   Lot_size,
// //                                                   Trade_Symbol,
// //                                                 );
// //                                               } else {
// //                                                 String?
// //                                                 Url_placeorder =
// //                                                     "https://stockboxpnp.pnpuniverse.com/backend/aliceblue/placeorder";
// //                                                 Place_order_popup(
// //                                                   Signal_id,
// //                                                   Signal_price,
// //                                                   Url_placeorder,
// //                                                   Signal_name,
// //                                                   Entry_type,
// //                                                   Lot_size,
// //                                                   Trade_Symbol,
// //                                                 );
// //                                               }
// //                                             }
// //                                           }
// //                                         } else {
// //                                           Navigator.push(
// //                                               context,
// //                                               MaterialPageRoute(
// //                                                   builder:
// //                                                       (context) =>
// //                                                       Kyc_formView()));
// //                                         }
// //                                       },
// //                                       child: Container(
// //                                         margin:
// //                                         const EdgeInsets
// //                                             .only(
// //                                             right: 20),
// //                                         height: 25,
// //                                         width: 60,
// //                                         alignment:
// //                                         Alignment.center,
// //                                         decoration: BoxDecoration(
// //                                             borderRadius:
// //                                             BorderRadius
// //                                                 .circular(
// //                                                 4),
// //                                             color:
// //                                             Colors.green),
// //                                         child: Text(
// //                                           "${open_signal[indexx]['calltype']}",
// //                                           style:
// //                                           const TextStyle(
// //                                               fontSize:
// //                                               12,
// //                                               color: Colors
// //                                                   .white),
// //                                         ),
// //                                       ),
// //                                     )
// //                                         : GestureDetector(
// //                                       onTap: () {
// //                                         if (Kyc_verification ==
// //                                             "1") {
// //                                           if (Dlink_Status ==
// //                                               "0") {
// //                                             Broker_link_popup();
// //                                           } else {
// //                                             if (Trading_Status ==
// //                                                 "0") {
// //                                               if (Broker_id ==
// //                                                   "1") {
// //                                                 String? Url =
// //                                                     "https://smartapi.angelone.in/publisher-login?api_key=${Api_key}";
// //                                                 Navigator.push(
// //                                                     context,
// //                                                     MaterialPageRoute(
// //                                                         builder: (context) =>
// //                                                             WebView_broker(Url: Url)));
// //                                               } else {
// //                                                 String? Url =
// //                                                     "https://ant.aliceblueonline.com/?appcode=${Api_key}";
// //                                                 Navigator.push(
// //                                                     context,
// //                                                     MaterialPageRoute(
// //                                                         builder: (context) =>
// //                                                             WebView_broker(Url: Url)));
// //                                               }
// //                                             } else {
// //                                               String?
// //                                               Signal_id =
// //                                               open_signal[
// //                                               indexx]
// //                                               ['_id'];
// //                                               String?
// //                                               Signal_price =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'price'];
// //                                               String?
// //                                               Signal_name =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'stock'];
// //                                               String?
// //                                               Entry_type =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'calltype'];
// //                                               String?
// //                                               Segment =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'segment'];
// //                                               String?
// //                                               Expiry_date =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'expirydate'];
// //                                               String?
// //                                               Lot_size =
// //                                               open_signal[indexx]
// //                                               [
// //                                               'lotsize']
// //                                                   .toString();
// //                                               String?
// //                                               Trade_Symbol =
// //                                               open_signal[
// //                                               indexx]
// //                                               [
// //                                               'tradesymbol'];
// //
// //                                               if (Broker_id ==
// //                                                   "1") {
// //                                                 String?
// //                                                 Url_placeorder =
// //                                                     "https://stockboxpnp.pnpuniverse.com/backend/angle/placeorder";
// //                                                 Place_order_popup(
// //                                                   Signal_id,
// //                                                   Signal_price,
// //                                                   Url_placeorder,
// //                                                   Signal_name,
// //                                                   Entry_type,
// //                                                   Lot_size,
// //                                                   Trade_Symbol,
// //                                                 );
// //                                               } else {
// //                                                 String?
// //                                                 Url_placeorder =
// //                                                     "https://stockboxpnp.pnpuniverse.com/backend/aliceblue/placeorder";
// //                                                 Place_order_popup(
// //                                                   Signal_id,
// //                                                   Signal_price,
// //                                                   Url_placeorder,
// //                                                   Signal_name,
// //                                                   Entry_type,
// //                                                   Lot_size,
// //                                                   Trade_Symbol,
// //                                                 );
// //                                               }
// //                                             }
// //                                           }
// //                                         } else {
// //                                           Navigator.push(
// //                                               context,
// //                                               MaterialPageRoute(
// //                                                   builder:
// //                                                       (context) =>
// //                                                       Kyc_formView()));
// //                                         }
// //                                       },
// //                                       child: Container(
// //                                         margin:
// //                                         const EdgeInsets
// //                                             .only(
// //                                             right: 20),
// //                                         height: 25,
// //                                         width: 60,
// //                                         alignment:
// //                                         Alignment.center,
// //                                         decoration: BoxDecoration(
// //                                             borderRadius:
// //                                             BorderRadius
// //                                                 .circular(
// //                                                 4),
// //                                             color:
// //                                             Colors.red),
// //                                         child: Text(
// //                                           "${open_signal[indexx]['calltype']}",
// //                                           style:
// //                                           const TextStyle(
// //                                               fontSize:
// //                                               12,
// //                                               color: Colors
// //                                                   .white),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                   close_signal.length <= 0
// //                       ? Container(
// //                     child: Center(
// //                         child: Image.asset(
// //                           "images/notrades.png",
// //                           height: 100,
// //                         )),
// //                   )
// //                       : Container(
// //                     margin: const EdgeInsets.only(top: 15),
// //                     child: ListView.builder(
// //                       itemCount: close_signal.length,
// //                       itemBuilder: (BuildContext context, int index) {
// //                         return Container(
// //                           margin: const EdgeInsets.only(
// //                               top: 10, bottom: 10, left: 15, right: 15),
// //                           // height: 350,
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(7),
// //                             color: const Color(0x7193a5cf),
// //                           ),
// //                           child: Column(
// //                             children: [
// //                               Container(
// //                                 margin: const EdgeInsets.only(
// //                                     top: 10, left: 10, right: 10),
// //                                 child: Row(
// //                                   mainAxisAlignment:
// //                                   MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     Container(
// //                                       child: Row(
// //                                         children: [
// //                                           const Icon(
// //                                             Icons.lock_clock,
// //                                             size: 18,
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets.only(
// //                                                 left: 10),
// //                                             child: Text(
// //                                               "${entryTime_close[index]}",
// //                                               style: const TextStyle(
// //                                                   fontSize: 11,
// //                                                   fontWeight:
// //                                                   FontWeight.w600),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     ),
// //                                     Container(
// //                                       height: 20,
// //                                       // width: 80,
// //                                       padding: EdgeInsets.only(
// //                                           left: 10, right: 10),
// //                                       decoration: BoxDecoration(
// //                                         borderRadius:
// //                                         BorderRadius.circular(15),
// //                                         border: Border.all(
// //                                             color: Colors.black,
// //                                             width: 0.3),
// //                                         color: Colors.white,
// //                                       ),
// //                                       alignment: Alignment.center,
// //                                       child: Text(
// //                                         "${close_signal[index]['callduration']}",
// //                                         style: const TextStyle(
// //                                             fontSize: 11),
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                               Container(
// //                                 margin: const EdgeInsets.only(
// //                                     top: 15, left: 15, right: 15),
// //                                 height: show[index] == true &&
// //                                     close_signal[index]['tag1'] !=
// //                                         "" &&
// //                                     close_signal[index]['tag2'] !=
// //                                         "" &&
// //                                     close_signal[index]['tag3'] !=
// //                                         ""
// //                                     ? 340
// //                                     : show[index] == true &&
// //                                     close_signal[index]
// //                                     ['tag1'] !=
// //                                         "" &&
// //                                     close_signal[index]
// //                                     ['tag2'] !=
// //                                         "" &&
// //                                     close_signal[index]
// //                                     ['tag3'] ==
// //                                         ""
// //                                     ? 310
// //                                     : show[index] == true &&
// //                                     close_signal[index]
// //                                     ['tag1'] !=
// //                                         "" &&
// //                                     close_signal[index]
// //                                     ['tag2'] ==
// //                                         "" &&
// //                                     close_signal[index]
// //                                     ['tag3'] ==
// //                                         ""
// //                                     ? 270
// //                                     : 243,
// //                                 decoration: BoxDecoration(
// //                                     color: Colors.white,
// //                                     borderRadius:
// //                                     BorderRadius.circular(5)),
// //                                 child: Column(
// //                                   children: [
// //                                     Container(
// //                                       margin:
// //                                       const EdgeInsets.only(top: 5),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets.only(
// //                                                 left: 15, top: 5),
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                               CrossAxisAlignment
// //                                                   .start,
// //                                               mainAxisAlignment:
// //                                               MainAxisAlignment
// //                                                   .spaceBetween,
// //                                               children: [
// //                                                 Container(
// //                                                   child: Row(
// //                                                     children: [
// //                                                       Text(
// //                                                         "${close_signal[index]['stock']}",
// //                                                         style: const TextStyle(
// //                                                             fontSize:
// //                                                             13,
// //                                                             fontWeight:
// //                                                             FontWeight
// //                                                                 .w600),
// //                                                       ),
// //                                                       close_signal[index]
// //                                                       [
// //                                                       'tradesymbol'] ==
// //                                                           "" ||
// //                                                           close_signal[index]
// //                                                           [
// //                                                           'tradesymbol'] ==
// //                                                               null
// //                                                           ? SizedBox()
// //                                                           : Text(
// //                                                         " (${close_signal[index]['tradesymbol']})",
// //                                                         style: const TextStyle(
// //                                                             fontSize:
// //                                                             13,
// //                                                             fontWeight:
// //                                                             FontWeight.w600),
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                 ),
// //
// //
// //                                                 Container(
// //                                                     width: MediaQuery.of(context).size.width/1.28,
// //                                                     margin: EdgeInsets.only(top: 3),
// //                                                     child: Row(
// //                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                                       children: [
// //                                                         Container(
// //                                                           child: Text(
// //                                                             "₹${close_signal[index]['price']}",
// //                                                             style:
// //                                                             const TextStyle(
// //                                                                 fontSize:
// //                                                                 11),
// //                                                           ),
// //                                                         ),
// //                                                         Container(
// //                                                           child: Row(
// //                                                             children: [
// //                                                               Container(
// //                                                                 margin: const EdgeInsets
// //                                                                     .only(
// //                                                                     right: 5),
// //                                                                 child: const Text(
// //                                                                   "Entry Type :",
// //                                                                   style: TextStyle(
// //                                                                       fontSize: 13,
// //                                                                       fontWeight:
// //                                                                       FontWeight
// //                                                                           .w500,
// //                                                                       color:
// //                                                                       Colors.grey),
// //                                                                 ),
// //                                                               ),
// //                                                               Container(
// //                                                                 margin: const EdgeInsets
// //                                                                     .only(
// //                                                                   right: 15,),
// //                                                                 child: Text(
// //                                                                   "${close_signal[index]['calltype']}",
// //                                                                   style: const TextStyle(
// //                                                                       fontSize: 13,
// //                                                                       fontWeight:
// //                                                                       FontWeight
// //                                                                           .w600),
// //                                                                 ),
// //                                                               ),
// //                                                             ],
// //                                                           ),
// //                                                         ),
// //                                                       ],
// //                                                     ))
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //
// //                                     Container(
// //                                       margin: const EdgeInsets.only(
// //                                           top: 15, left: 15, right: 15),
// //                                       height: 40,
// //                                       decoration: BoxDecoration(
// //                                           border: Border.all(
// //                                               color: ColorValues
// //                                                   .Splash_bg_color1,
// //                                               width: 0.5),
// //                                           borderRadius:
// //                                           BorderRadius.circular(
// //                                               10)),
// //                                       child: Column(
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets.only(
// //                                                 top: 10),
// //                                             child: Row(
// //                                               mainAxisAlignment:
// //                                               MainAxisAlignment
// //                                                   .center,
// //                                               children: [
// //                                                 Container(
// //                                                   child: Text(
// //                                                     "Suggested Entry: ",
// //                                                     style: TextStyle(
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w500,
// //                                                         color: Colors
// //                                                             .grey
// //                                                             .shade700),
// //                                                   ),
// //                                                 ),
// //                                                 Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(
// //                                                       left: 8),
// //                                                   child: Text(
// //                                                     "₹${close_signal[index]['price']}",
// //                                                     style: const TextStyle(
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600,
// //                                                         color: ColorValues
// //                                                             .Splash_bg_color1),
// //                                                   ),
// //                                                 )
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //
// //                                     Container(
// //                                       margin: const EdgeInsets.only(
// //                                           top: 17, left: 10, right: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                               CrossAxisAlignment
// //                                                   .start,
// //                                               children: [
// //                                                 Container(
// //                                                   child: const Text(
// //                                                     "Stoploss:",
// //                                                     style: TextStyle(
// //                                                         fontSize: 12),
// //                                                   ),
// //                                                 ),
// //                                                 close_signal[index][
// //                                                 'stoploss'] ==
// //                                                     "" ||
// //                                                     close_signal[
// //                                                     index]
// //                                                     [
// //                                                     'stoploss'] ==
// //                                                         null
// //                                                     ? Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(
// //                                                       top: 5),
// //                                                   child:
// //                                                   const Text(
// //                                                     "- -",
// //                                                     style: TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   ),
// //                                                 )
// //                                                     : Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(
// //                                                       top: 5),
// //                                                   child: Text(
// //                                                     "₹${close_signal[index]['stoploss']}",
// //                                                     style: const TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   ),
// //                                                 )
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                               CrossAxisAlignment
// //                                                   .start,
// //                                               children: [
// //                                                 Container(
// //                                                   child: const Text(
// //                                                     "Exit Price:",
// //                                                     style: TextStyle(
// //                                                         fontSize: 12),
// //                                                   ),
// //                                                 ),
// //                                                 Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(top: 5),
// //                                                   child:Text("₹${close_signal[index]['closeprice']}",
// //                                                     style: const TextStyle(
// //                                                         fontSize: 12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   ),
// //                                                   // Text(
// //                                                   //   close_signal[index][
// //                                                   //               'tag3'] !=
// //                                                   //           ""
// //                                                   //       ? "₹${close_signal[index]['tag3']}"
// //                                                   //       : close_signal[index]
// //                                                   //                   [
// //                                                   //                   'tag2'] !=
// //                                                   //               ""
// //                                                   //           ? "₹${close_signal[index]['tag2']}"
// //                                                   //           : "₹${close_signal[index]['tag1']}",
// //                                                   //   style: const TextStyle(
// //                                                   //       fontSize: 12,
// //                                                   //       fontWeight:
// //                                                   //           FontWeight
// //                                                   //               .w600),
// //                                                   // ),
// //                                                 )
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                               CrossAxisAlignment
// //                                                   .start,
// //                                               children: [
// //                                                 Container(
// //                                                   child: const Text(
// //                                                     "Hold duration:",
// //                                                     style: TextStyle(
// //                                                         fontSize: 12),
// //                                                   ),
// //                                                 ),
// //                                                 close_signal[index]['segment'] == "F" || close_signal[index]['segment'] == "O"
// //                                                     ? Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(
// //                                                       top: 5),
// //                                                   child: Text(
// //                                                     "${close_signal[index]['expirydate'].substring(0, 2)}-${close_signal[index]['expirydate'].substring(2, 4)}-${close_signal[index]['expirydate'].substring(4, 8)}",
// //                                                     style: const TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   ),
// //                                                 )
// //                                                     : Container(
// //                                                   margin:
// //                                                   const EdgeInsets
// //                                                       .only(
// //                                                       top: 5),
// //                                                   child: Text(
// //                                                     close_signal[index]
// //                                                     [
// //                                                     'callduration'] ==
// //                                                         "Intraday"
// //                                                         ? "- -"
// //                                                         : close_signal[index]['callduration'] ==
// //                                                         "Short Term"
// //                                                         ? "(15-30 days)"
// //                                                         : close_signal[index]['callduration'] == "Medium Term"
// //                                                         ? "(Above 3 month)"
// //                                                         : "(Above 1 year)",
// //                                                     style: const TextStyle(
// //                                                         fontSize:
// //                                                         12,
// //                                                         fontWeight:
// //                                                         FontWeight
// //                                                             .w600),
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     ),
// //
// //                                     GestureDetector(
// //                                       onTap: () {
// //                                         print("Hello");
// //                                         setState(() {
// //                                           show[index] = !show[index];
// //                                         });
// //                                         print(
// //                                             "Hello=== ${show[index]}");
// //                                       },
// //                                       child: Container(
// //                                         margin: const EdgeInsets.only(
// //                                             left: 15,
// //                                             right: 15,
// //                                             top: 15),
// //                                         height: 25,
// //                                         width: double.infinity,
// //                                         decoration: BoxDecoration(
// //                                             borderRadius:
// //                                             BorderRadius.circular(
// //                                                 10),
// //                                             color:
// //                                             Colors.grey.shade200),
// //                                         child: Row(
// //                                           mainAxisAlignment:
// //                                           MainAxisAlignment
// //                                               .spaceBetween,
// //                                           children: [
// //                                             Container(
// //                                               margin:
// //                                               const EdgeInsets.only(
// //                                                   left: 12),
// //                                               child: Text(
// //                                                 "See Targets :",
// //                                                 style: TextStyle(
// //                                                     fontSize: 12,
// //                                                     color: Colors
// //                                                         .grey.shade700),
// //                                               ),
// //                                             ),
// //                                             Container(
// //                                                 margin: const EdgeInsets
// //                                                     .only(
// //                                                     right: 8,
// //                                                     bottom: 3),
// //                                                 child: Icon(
// //                                                   show == true
// //                                                       ? Icons
// //                                                       .arrow_drop_up
// //                                                       : Icons
// //                                                       .arrow_drop_down,
// //                                                   size: 25,
// //                                                   color: Colors.black,
// //                                                 )),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ),
// //
// //                                     show[index] == true &&
// //                                         close_signal[index]
// //                                         ['tag1'] !=
// //                                             ""
// //                                         ? double.parse(
// //                                         close_signal[index]
// //                                         ['tag1']) <=
// //                                         double.parse(
// //                                             close_signal[index]
// //                                             ['closeprice'])
// //                                         ? Container(
// //                                       height: 25,
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(
// //                                               8),
// //                                           color:
// //                                           Colors.green),
// //                                       margin: const EdgeInsets
// //                                           .only(
// //                                           left: 15,
// //                                           right: 15,
// //                                           top: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 left: 10),
// //                                             child: const Text(
// //                                               "Target 1",
// //                                               style: TextStyle(
// //                                                   fontSize:
// //                                                   11,
// //                                                   color: Colors
// //                                                       .white),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 right:
// //                                                 10),
// //                                             child: Text(
// //                                               "₹${close_signal[index]['tag1']}",
// //                                               style: const TextStyle(
// //                                                   fontSize:
// //                                                   11,
// //                                                   color: Colors
// //                                                       .white),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     )
// //                                         : Container(
// //                                       height: 25,
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(
// //                                               8),
// //                                           color: Colors
// //                                               .grey.shade200),
// //                                       margin: const EdgeInsets
// //                                           .only(
// //                                           left: 15,
// //                                           right: 15,
// //                                           top: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 left: 10),
// //                                             child: const Text(
// //                                               "Target 1",
// //                                               style: TextStyle(
// //                                                   fontSize:
// //                                                   11),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 right:
// //                                                 10),
// //                                             child: Text(
// //                                               "₹${close_signal[index]['tag1']}",
// //                                               style:
// //                                               const TextStyle(
// //                                                   fontSize:
// //                                                   11),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     )
// //                                         : const SizedBox(
// //                                       height: 0,
// //                                     ),
// //
// //                                     show[index] == true &&
// //                                         close_signal[index]
// //                                         ['tag2'] !=
// //                                             ""
// //                                         ? double.parse(
// //                                         close_signal[index]
// //                                         ['tag2']) <=
// //                                         double.parse(
// //                                             close_signal[index]
// //                                             ['closeprice'])
// //                                         ? Container(
// //                                       height: 25,
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(
// //                                               8),
// //                                           color:
// //                                           Colors.green),
// //                                       margin: const EdgeInsets
// //                                           .only(
// //                                           left: 15,
// //                                           right: 15,
// //                                           top: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 left: 10),
// //                                             child: const Text(
// //                                               "Target 2",
// //                                               style: TextStyle(
// //                                                   fontSize:
// //                                                   11,
// //                                                   color: Colors
// //                                                       .white),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 right:
// //                                                 10),
// //                                             child: Text(
// //                                               "₹${close_signal[index]['tag2']}",
// //                                               style: const TextStyle(
// //                                                   fontSize:
// //                                                   11,
// //                                                   color: Colors
// //                                                       .white),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     )
// //                                         : Container(
// //                                       height: 25,
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(
// //                                               8),
// //                                           color: Colors
// //                                               .grey.shade200),
// //                                       margin: const EdgeInsets
// //                                           .only(
// //                                           left: 15,
// //                                           right: 15,
// //                                           top: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 left: 10),
// //                                             child: const Text(
// //                                               "Target 2",
// //                                               style: TextStyle(
// //                                                   fontSize:
// //                                                   11),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 right:
// //                                                 10),
// //                                             child: Text(
// //                                               "₹${close_signal[index]['tag2']}",
// //                                               style:
// //                                               const TextStyle(
// //                                                   fontSize:
// //                                                   11),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     )
// //                                         : const SizedBox(
// //                                       height: 0,
// //                                     ),
// //
// //                                     show[index] == true &&
// //                                         close_signal[index]
// //                                         ['tag3'] !=
// //                                             ""
// //                                         ? double.parse(
// //                                         close_signal[index]
// //                                         ['tag3']) <=
// //                                         double.parse(
// //                                             close_signal[index]
// //                                             ['closeprice'])
// //                                         ? Container(
// //                                       height: 25,
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(
// //                                               8),
// //                                           color:
// //                                           Colors.green),
// //                                       margin: const EdgeInsets
// //                                           .only(
// //                                           left: 15,
// //                                           right: 15,
// //                                           top: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 left: 10),
// //                                             child: const Text(
// //                                               "Target 3",
// //                                               style: TextStyle(
// //                                                   fontSize:
// //                                                   11,
// //                                                   color: Colors
// //                                                       .white),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 right:
// //                                                 10),
// //                                             child: Text(
// //                                               "₹${close_signal[index]['tag3']}",
// //                                               style: const TextStyle(
// //                                                   fontSize:
// //                                                   11,
// //                                                   color: Colors
// //                                                       .white),
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     )
// //                                         : Container(
// //                                       height: 25,
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                           borderRadius:
// //                                           BorderRadius
// //                                               .circular(
// //                                               8),
// //                                           color: Colors
// //                                               .grey.shade200),
// //                                       margin: const EdgeInsets
// //                                           .only(
// //                                           left: 15,
// //                                           right: 15,
// //                                           top: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                         MainAxisAlignment
// //                                             .spaceBetween,
// //                                         children: [
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 left: 10),
// //                                             child: const Text(
// //                                               "Target 3",
// //                                               style: TextStyle(
// //                                                   fontSize:
// //                                                   11),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             margin:
// //                                             const EdgeInsets
// //                                                 .only(
// //                                                 right:
// //                                                 10),
// //                                             child: Text(
// //                                               "₹${close_signal[index]['tag3']}",
// //                                               style:
// //                                               const TextStyle(
// //                                                   fontSize:
// //                                                   11),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     )
// //                                         : const SizedBox(
// //                                       height: 0,
// //                                     ),
// //
// //                                     const Spacer(),
// //
// //                                     close_signal[index]['calltype'] ==
// //                                         'BUY'
// //                                         ? (double.parse(close_signal[index]['closeprice'] == null ? "0.0" : close_signal[index]['closeprice']) >
// //                                         double.parse(
// //                                             close_signal[index]
// //                                             ['price'])
// //                                         ? Container(
// //                                       height: 25,
// //                                       color: Colors.green,
// //                                       alignment:
// //                                       Alignment.center,
// //                                       child: Text(
// //                                           "P&L : ${result[index]}%",
// //                                           style:
// //                                           const TextStyle(
// //                                               fontSize:
// //                                               11,
// //                                               color: Colors
// //                                                   .white)),
// //                                     )
// //                                         : Container(
// //                                       height: 25,
// //                                       color: Colors.red,
// //                                       alignment:
// //                                       Alignment.center,
// //                                       child: Text(
// //                                           "P&L : ${result[index]}%",
// //                                           style:
// //                                           const TextStyle(
// //                                               fontSize:
// //                                               11,
// //                                               color: Colors
// //                                                   .white)),
// //                                     ))
// //                                         : (double.parse(close_signal[index]
// //                                     ['price'] ==
// //                                         null
// //                                         ? "0.0"
// //                                         : close_signal[index]
// //                                     ['price']) >
// //                                         double.parse(
// //                                             close_signal[index]['closeprice'] ==
// //                                                 null
// //                                                 ? "0.0"
// //                                                 : close_signal[index]
// //                                             ['closeprice'])
// //                                         ? Container(
// //                                       height: 25,
// //                                       color: Colors.green,
// //                                       alignment:
// //                                       Alignment.center,
// //                                       child: Text(
// //                                           "P&L : ${result[index]}%",
// //                                           style:
// //                                           const TextStyle(
// //                                               fontSize:
// //                                               11,
// //                                               color: Colors
// //                                                   .white)),
// //                                     )
// //                                         : Container(
// //                                       height: 25,
// //                                       color: Colors.red,
// //                                       alignment:
// //                                       Alignment.center,
// //                                       child: Text(
// //                                           "P&L : ${result[index]}%",
// //                                           style:
// //                                           const TextStyle(
// //                                               fontSize:
// //                                               11,
// //                                               color: Colors
// //                                                   .white)),
// //                                     ))
// //
// //                                     // double.parse(close_signal[index]['closeprice']==null?"0.0":close_signal[index]['closeprice'])>double.parse(close_signal[index]['price'])?
// //                                     // Container(
// //                                     //   height: 25,
// //                                     //   color: Colors.green,
// //                                     //   alignment: Alignment.center,
// //                                     //   child: Text("P&L : ${result[index]}%",style:const TextStyle(fontSize: 11,color: Colors.white),),
// //                                     // ):
// //                                     // Container(
// //                                     //   height: 25,
// //                                     //   color: Colors.red,
// //                                     //   alignment: Alignment.center,
// //                                     //   child: Text("P&L : ${result[index]}%",style:const TextStyle(fontSize: 11,color: Colors.white),),
// //                                     // )
// //                                   ],
// //                                 ),
// //                               ),
// //                               close_signal[index]['purchased'] == false
// //                                   ? Container(
// //                                   margin: const EdgeInsets.only(
// //                                       top: 10,
// //                                       left: 15,
// //                                       right: 15,
// //                                       bottom: 15),
// //                                   height: 35,
// //                                   alignment: Alignment.center,
// //                                   width: double.infinity,
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.grey.shade400,
// //                                     borderRadius:
// //                                     BorderRadius.circular(8),
// //                                   ),
// //                                   child: Row(
// //                                     mainAxisAlignment:
// //                                     MainAxisAlignment.center,
// //                                     children: [
// //                                       const Text(
// //                                         "Trade Closed",
// //                                         style: TextStyle(
// //                                             fontSize: 14,
// //                                             fontWeight:
// //                                             FontWeight.w600,
// //                                             color: Colors.black),
// //                                       ),
// //                                       Container(
// //                                         margin: EdgeInsets.only(
// //                                             left: 8),
// //                                         child: Icon(
// //                                           Icons.arrow_forward,
// //                                           color: Colors.black,
// //                                           size: 18,
// //                                         ),
// //                                       )
// //                                     ],
// //                                   ))
// //                                   : GestureDetector(
// //                                 onTap: () {
// //                                   String? SignalId_exit =
// //                                   close_signal[index]['_id'];
// //                                   String? SignalPrice_exit = close_signal[index]['price'];
// //                                   String? Trade_symbol = close_signal[index]['tradesymbol'];
// //                                   String? Lot_Size = close_signal[index]['lotsize'];
// //
// //                                   String? SignalName_exit =
// //                                   close_signal[index]
// //                                   ['stock'];
// //                                   String? Entrytype_exit =
// //                                   close_signal[index]
// //                                   ['calltype'];
// //                                   String? Order_quantity =
// //                                   close_signal[index][
// //                                   'order_quantity'] ==
// //                                       null
// //                                       ? ""
// //                                       : close_signal[index][
// //                                   'order_quantity']
// //                                       .toString();
// //                                   print("Order: $Order_quantity");
// //                                   Exit_order_popup(
// //                                       SignalId_exit,
// //                                       SignalPrice_exit,
// //                                       SignalName_exit,
// //                                       Entrytype_exit,
// //                                       Order_quantity,
// //                                       Trade_symbol,
// //                                       Lot_Size
// //                                   );
// //                                 },
// //                                 child: Container(
// //                                     margin: const EdgeInsets.only(
// //                                         top: 10,
// //                                         left: 15,
// //                                         right: 15,
// //                                         bottom: 15),
// //                                     height: 35,
// //                                     alignment: Alignment.center,
// //                                     width: double.infinity,
// //                                     decoration: BoxDecoration(
// //                                       color: ColorValues
// //                                           .Splash_bg_color1,
// //                                       borderRadius:
// //                                       BorderRadius.circular(
// //                                           8),
// //                                     ),
// //                                     child: Row(
// //                                       mainAxisAlignment:
// //                                       MainAxisAlignment
// //                                           .center,
// //                                       children: [
// //                                         const Text(
// //                                           "Exit Trade",
// //                                           style: TextStyle(
// //                                               fontSize: 14,
// //                                               fontWeight:
// //                                               FontWeight.w600,
// //                                               color:
// //                                               Colors.white),
// //                                         ),
// //                                         Container(
// //                                           margin: EdgeInsets.only(
// //                                               left: 8),
// //                                           child: Icon(
// //                                             Icons.arrow_forward,
// //                                             color: Colors.white,
// //                                             size: 18,
// //                                           ),
// //                                         )
// //                                       ],
// //                                     )),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ))
// //         : Container(
// //       child: const Center(
// //           child: CircularProgressIndicator(
// //             color: ColorValues.Splash_bg_color1,
// //           )),
// //     );
// //   }
// //
// //   View_analysis_popup() {
// //     return showModalBottomSheet(
// //       isScrollControlled: true,
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //             builder: (BuildContext ctx, StateSetter setState) {
// //               return Container(
// //                   height: MediaQuery.of(context).size.height,
// //                   child: Column(
// //                     children: [
// //                       const SizedBox(
// //                         height: 45,
// //                       ),
// //                       Row(
// //                         children: [
// //                           GestureDetector(
// //                             onTap: () {
// //                               Navigator.pop(context);
// //                             },
// //                             child: Container(
// //                               alignment: Alignment.topLeft,
// //                               margin: const EdgeInsets.only(left: 20),
// //                               child: const Icon(
// //                                 Icons.clear,
// //                                 color: Colors.black,
// //                               ),
// //                             ),
// //                           ),
// //                           Container(
// //                             margin: const EdgeInsets.only(left: 12),
// //                             child: const Text(
// //                               "Analysis",
// //                               style: TextStyle(
// //                                   fontSize: 17, fontWeight: FontWeight.w600),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       Container(
// //                         height: 130,
// //                         width: double.infinity,
// //                         clipBehavior: Clip.antiAliasWithSaveLayer,
// //                         margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
// //                         decoration:
// //                         BoxDecoration(borderRadius: BorderRadius.circular(10)),
// //                         child: Image.network(
// //                             "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSr6J4mg5fgO7zVN-wk27JGuHh8b8Rx7SSAuw&s",
// //                             fit: BoxFit.cover),
// //                       ),
// //                       Container(
// //                         margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
// //                         child: const Text(
// //                           "Exclusive: Bincare moved 346mln for seized crypto exchange Bitzlato",
// //                           maxLines: 2,
// //                           overflow: TextOverflow.ellipsis,
// //                           style: TextStyle(
// //                               fontSize: 19, color: Colors.black, height: 1.4),
// //                         ),
// //                       ),
// //                       Container(
// //                         margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
// //                         child: Text(
// //                           "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages,\n\nIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
// //                           style: TextStyle(
// //                               fontSize: 13,
// //                               color: Colors.grey.shade700,
// //                               height: 1.4),
// //                         ),
// //                       ),
// //                     ],
// //                   ));
// //             });
// //       },
// //     );
// //   }
// //
// //   Broker_link_popup() {
// //     return showModalBottomSheet(
// //       isScrollControlled: true,
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //             builder: (BuildContext ctx, StateSetter setState) {
// //               return Container(
// //                   height: MediaQuery.of(context).size.height / 4.5,
// //                   child: Column(
// //                     children: [
// //                       Container(
// //                         alignment: Alignment.topLeft,
// //                         margin: const EdgeInsets.only(top: 15, left: 15),
// //                         child: const Text(
// //                           "Supported Broker",
// //                           style: TextStyle(
// //                               fontSize: 19,
// //                               color: Colors.black,
// //                               fontWeight: FontWeight.w500),
// //                         ),
// //                       ),
// //                       Container(
// //                         margin: const EdgeInsets.only(
// //                             top: 25, left: 15, right: 15, bottom: 20),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             GestureDetector(
// //                               onTap: () {
// //                                 Broker_connect_aliceBlue_popup();
// //                               },
// //                               child: Container(
// //                                 height: 80,
// //                                 width: 80,
// //                                 decoration: BoxDecoration(
// //                                     borderRadius: BorderRadius.circular(10),
// //                                     color: Colors.white,
// //                                     border: Border.all(
// //                                         color: ColorValues.Splash_bg_color1,
// //                                         width: 0.4)),
// //                                 alignment: Alignment.center,
// //                                 child: Column(
// //                                   mainAxisAlignment: MainAxisAlignment.center,
// //                                   crossAxisAlignment: CrossAxisAlignment.center,
// //                                   children: [
// //                                     Container(
// //                                       child: Image.asset(
// //                                         "images/alice_blue.png",
// //                                         height: 35,
// //                                         width: 35,
// //                                       ),
// //                                     ),
// //                                     Container(
// //                                         margin: const EdgeInsets.only(top: 3),
// //                                         child: const Text(
// //                                           "Alice Blue",
// //                                           style: TextStyle(
// //                                               color: Colors.black,
// //                                               fontSize: 13,
// //                                               fontWeight: FontWeight.w600),
// //                                         )),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                             GestureDetector(
// //                               onTap: () async {
// //                                 Broker_connect_angel_popup();
// //                               },
// //                               child: Container(
// //                                   height: 80,
// //                                   width: 80,
// //                                   alignment: Alignment.center,
// //                                   margin: const EdgeInsets.only(left: 20),
// //                                   decoration: BoxDecoration(
// //                                       borderRadius: BorderRadius.circular(10),
// //                                       border: Border.all(
// //                                           color: Colors.black, width: 0.4),
// //                                       color: Colors.white),
// //                                   child: Column(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     crossAxisAlignment: CrossAxisAlignment.center,
// //                                     children: [
// //                                       Container(
// //                                         child: Image.asset(
// //                                           "images/angel_one.png",
// //                                           height: 35,
// //                                           width: 35,
// //                                         ),
// //                                       ),
// //                                       Container(
// //                                           margin: const EdgeInsets.only(top: 3),
// //                                           child: const Text(
// //                                             "Angel One",
// //                                             style: TextStyle(
// //                                                 color: Colors.black,
// //                                                 fontSize: 13,
// //                                                 fontWeight: FontWeight.w600),
// //                                           )),
// //                                     ],
// //                                   )),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ));
// //             });
// //       },
// //     );
// //   }
// //
// //   Broker_connect_angel_popup() {
// //     return showModalBottomSheet(
// //       isScrollControlled: true,
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //           builder: (BuildContext ctx, StateSetter setState) {
// //             return Padding(
// //               padding: EdgeInsets.only(
// //                 bottom: MediaQuery.of(context)
// //                     .viewInsets
// //                     .bottom, // Adjust for the keyboard
// //               ),
// //               child: SingleChildScrollView(
// //                 child: Container(
// //                   padding: const EdgeInsets.all(16.0),
// //                   // Ensure container height is dynamic
// //                   constraints: BoxConstraints(
// //                     minHeight: MediaQuery.of(context).size.height / 3,
// //                   ),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         alignment: Alignment.topLeft,
// //                         margin: const EdgeInsets.only(top: 20, left: 20),
// //                         child: const Text(
// //                           "Api Key",
// //                           style: TextStyle(
// //                               fontSize: 15, fontWeight: FontWeight.w600),
// //                         ),
// //                       ),
// //                       Container(
// //                         alignment: Alignment.topLeft,
// //                         margin:
// //                         const EdgeInsets.only(top: 20, left: 20, right: 20),
// //                         child: TextFormField(
// //                           cursorColor: Colors.black,
// //                           cursorWidth: 1.1,
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please Enter Api Key';
// //                             }
// //                             return null;
// //                           },
// //                           controller: api_key,
// //                           style: const TextStyle(fontSize: 13),
// //                           decoration: InputDecoration(
// //                             focusedBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                               borderSide: const BorderSide(
// //                                   color: ColorValues.Splash_bg_color1,
// //                                   width: 1.1),
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                               borderSide: const BorderSide(
// //                                   color: ColorValues.Splash_bg_color1,
// //                                   width: 1.1),
// //                             ),
// //                             hintText: "Api Key",
// //                             contentPadding:
// //                             const EdgeInsets.only(left: 15, bottom: 4),
// //                             hintStyle: const TextStyle(fontSize: 13),
// //                             prefixIcon: const Icon(Icons.api),
// //                           ),
// //                         ),
// //                       ),
// //                       GestureDetector(
// //                         onTap: () {
// //                           api_secret.text = '';
// //                           user_id.text = '';
// //                           BrokerConnect_Api("1");
// //                         },
// //                         child: Card(
// //                           clipBehavior: Clip.antiAliasWithSaveLayer,
// //                           color: Colors.transparent,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           elevation: 0,
// //                           child: Container(
// //                             height: 45,
// //                             alignment: Alignment.topLeft,
// //                             margin: const EdgeInsets.only(
// //                                 top: 30, left: 15, right: 30),
// //                             width: MediaQuery.of(context).size.width / 3,
// //                             decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(8),
// //                               color: Colors.grey.shade200,
// //                               gradient: const LinearGradient(
// //                                 begin: Alignment.topRight,
// //                                 end: Alignment.bottomLeft,
// //                                 stops: [
// //                                   0.1,
// //                                   0.5,
// //                                 ],
// //                                 colors: [
// //                                   ColorValues.Splash_bg_color1,
// //                                   ColorValues.Splash_bg_color1,
// //                                 ],
// //                               ),
// //                             ),
// //                             child: Container(
// //                               alignment: Alignment.center,
// //                               child: const Text(
// //                                 "Submit",
// //                                 style: TextStyle(
// //                                     fontWeight: FontWeight.w700,
// //                                     fontSize: 18,
// //                                     color: Colors.white),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   Broker_connect_aliceBlue_popup() {
// //     return showModalBottomSheet(
// //       isScrollControlled: true,
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //           builder: (BuildContext ctx, StateSetter setState) {
// //             return Padding(
// //               padding: EdgeInsets.only(
// //                 bottom: MediaQuery.of(context).viewInsets.bottom,
// //               ),
// //               child: SingleChildScrollView(
// //                 child: Container(
// //                   padding: const EdgeInsets.all(16.0),
// //                   constraints: BoxConstraints(
// //                     minHeight: MediaQuery.of(context).size.height / 1.8,
// //                   ),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         alignment: Alignment.topLeft,
// //                         margin: const EdgeInsets.only(top: 20, left: 20),
// //                         child: const Text(
// //                           "App Code",
// //                           style: TextStyle(
// //                               fontSize: 15, fontWeight: FontWeight.w600),
// //                         ),
// //                       ),
// //                       Container(
// //                         alignment: Alignment.topLeft,
// //                         margin:
// //                         const EdgeInsets.only(top: 20, left: 20, right: 20),
// //                         child: TextFormField(
// //                           cursorColor: Colors.black,
// //                           cursorWidth: 1.1,
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please Enter App Code';
// //                             }
// //                             return null;
// //                           },
// //                           controller: api_key,
// //                           style: const TextStyle(fontSize: 13),
// //                           decoration: InputDecoration(
// //                             focusedBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                               borderSide: const BorderSide(
// //                                   color: ColorValues.Splash_bg_color1,
// //                                   width: 1.1),
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                               borderSide: const BorderSide(
// //                                   color: ColorValues.Splash_bg_color1,
// //                                   width: 1.1),
// //                             ),
// //                             hintText: "Enter App Code",
// //                             contentPadding:
// //                             const EdgeInsets.only(left: 15, bottom: 4),
// //                             hintStyle: const TextStyle(fontSize: 13),
// //                             prefixIcon: const Icon(Icons.api),
// //                           ),
// //                         ),
// //                       ),
// //                       Container(
// //                         alignment: Alignment.topLeft,
// //                         margin: const EdgeInsets.only(top: 20, left: 20),
// //                         child: const Text(
// //                           "User Id",
// //                           style: TextStyle(
// //                               fontSize: 15, fontWeight: FontWeight.w600),
// //                         ),
// //                       ),
// //                       Container(
// //                         alignment: Alignment.topLeft,
// //                         margin:
// //                         const EdgeInsets.only(top: 20, left: 20, right: 20),
// //                         child: TextFormField(
// //                           cursorColor: Colors.black,
// //                           cursorWidth: 1.1,
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please Enter User Id';
// //                             }
// //                             return null;
// //                           },
// //                           controller: user_id,
// //                           style: const TextStyle(fontSize: 13),
// //                           decoration: InputDecoration(
// //                             focusedBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                               borderSide: const BorderSide(
// //                                   color: ColorValues.Splash_bg_color1,
// //                                   width: 1.1),
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                               borderSide: const BorderSide(
// //                                   color: ColorValues.Splash_bg_color1,
// //                                   width: 1.1),
// //                             ),
// //                             hintText: "Enter User Id",
// //                             contentPadding:
// //                             const EdgeInsets.only(left: 15, bottom: 4),
// //                             hintStyle: const TextStyle(fontSize: 13),
// //                             prefixIcon: const Icon(Icons.api),
// //                           ),
// //                         ),
// //                       ),
// //                       Container(
// //                         alignment: Alignment.topLeft,
// //                         margin: const EdgeInsets.only(top: 20, left: 20),
// //                         child: const Text(
// //                           "Api Secret",
// //                           style: TextStyle(
// //                               fontSize: 15, fontWeight: FontWeight.w600),
// //                         ),
// //                       ),
// //                       Container(
// //                         alignment: Alignment.topLeft,
// //                         margin:
// //                         const EdgeInsets.only(top: 20, left: 20, right: 20),
// //                         child: TextFormField(
// //                           cursorColor: Colors.black,
// //                           cursorWidth: 1.1,
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please Enter Api Secret';
// //                             }
// //                             return null;
// //                           },
// //                           controller: api_secret,
// //                           style: const TextStyle(fontSize: 13),
// //                           decoration: InputDecoration(
// //                             focusedBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                               borderSide: const BorderSide(
// //                                   color: ColorValues.Splash_bg_color1,
// //                                   width: 1.1),
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                               borderSide: const BorderSide(
// //                                   color: ColorValues.Splash_bg_color1,
// //                                   width: 1.1),
// //                             ),
// //                             hintText: "Enter Api Secret",
// //                             contentPadding:
// //                             const EdgeInsets.only(left: 15, bottom: 4),
// //                             hintStyle: const TextStyle(fontSize: 13),
// //                             prefixIcon: const Icon(Icons.api),
// //                           ),
// //                         ),
// //                       ),
// //                       GestureDetector(
// //                         onTap: () {
// //                           BrokerConnect_Api("2");
// //                         },
// //                         child: Card(
// //                           clipBehavior: Clip.antiAliasWithSaveLayer,
// //                           color: Colors.transparent,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           elevation: 0,
// //                           child: Container(
// //                             height: 45,
// //                             alignment: Alignment.topLeft,
// //                             margin: const EdgeInsets.only(
// //                                 top: 30, left: 15, right: 30),
// //                             width: MediaQuery.of(context).size.width / 3,
// //                             decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(8),
// //                               color: Colors.grey.shade200,
// //                               gradient: const LinearGradient(
// //                                 begin: Alignment.topRight,
// //                                 end: Alignment.bottomLeft,
// //                                 stops: [0.1, 0.5],
// //                                 colors: [
// //                                   ColorValues.Splash_bg_color1,
// //                                   ColorValues.Splash_bg_color1,
// //                                 ],
// //                               ),
// //                             ),
// //                             child: Container(
// //                               alignment: Alignment.center,
// //                               child: const Text(
// //                                 "Submit",
// //                                 style: TextStyle(
// //                                     fontWeight: FontWeight.w700,
// //                                     fontSize: 18,
// //                                     color: Colors.white),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   Place_order_popup(Signal_id, Signal_price, Url_placeorder, Signal_name, Entry_type, Lot_size, Trade_Symbol) {
// //     return showModalBottomSheet(
// //       isScrollControlled: true,
// //       shape: const RoundedRectangleBorder(
// //           borderRadius: BorderRadius.only(
// //               topLeft: Radius.circular(15), topRight: Radius.circular(15))),
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //             builder: (BuildContext ctx, StateSetter setState) {
// //               return Padding(
// //                 padding: EdgeInsets.only(
// //                   bottom: MediaQuery.of(context).viewInsets.bottom,
// //                 ),
// //                 child: SingleChildScrollView(
// //                   child: Container(
// //                       height: MediaQuery.of(context).size.height / 2.6,
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Container(
// //                             width: MediaQuery.of(context).size.width / 0.75,
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.start,
// //                               children: [
// //                                 Container(
// //                                   alignment: Alignment.topLeft,
// //                                   margin: const EdgeInsets.only(left: 10, top: 15),
// //                                   child: Icon(Icons.clear,
// //                                       color: Colors.grey.shade600, size: 25),
// //                                 ),
// //                                 Container(
// //                                     alignment: Alignment.topLeft,
// //                                     margin:
// //                                     const EdgeInsets.only(left: 10, top: 15),
// //                                     child: Text(
// //                                       "$Signal_name",
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.w600,
// //                                           fontSize: 18),
// //                                     )),
// //                                 Container(
// //                                     alignment: Alignment.topLeft,
// //                                     margin:
// //                                     const EdgeInsets.only(left: 10, top: 15),
// //                                     child: Trade_Symbol==""||Trade_Symbol==null?
// //                                     SizedBox():
// //                                     Text(
// //                                       "($Trade_Symbol)",
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.w600,
// //                                           fontSize: 14),
// //                                     )
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           Container(
// //                             margin:
// //                             const EdgeInsets.only(top: 5, left: 30, right: 45),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 Container(
// //                                     width: 90,
// //                                     alignment: Alignment.topLeft,
// //                                     margin:
// //                                     const EdgeInsets.only(left: 15, top: 15),
// //                                     child: const Text(
// //                                       "Price : ",
// //                                       style: TextStyle(
// //                                           fontWeight: FontWeight.w500,
// //                                           fontSize: 14),
// //                                     )),
// //                                 Container(
// //                                     height: 27,
// //                                     width: 100,
// //                                     alignment: Alignment.center,
// //                                     padding:
// //                                     const EdgeInsets.only(left: 12, right: 12),
// //                                     margin:
// //                                     const EdgeInsets.only(left: 15, top: 15),
// //                                     decoration: BoxDecoration(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         border: Border.all(
// //                                             color: Colors.grey.shade600,
// //                                             width: 0.4)),
// //                                     child: Text(
// //                                       "₹ $Signal_price",
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.w600,
// //                                           fontSize: 12),
// //                                     )),
// //                               ],
// //                             ),
// //                           ),
// //                           Container(
// //                             margin:
// //                             const EdgeInsets.only(left: 30, right: 45, top: 8),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 Container(
// //                                     width: 90,
// //                                     alignment: Alignment.topLeft,
// //                                     margin:
// //                                     const EdgeInsets.only(left: 15, top: 10),
// //                                     child: const Text(
// //                                       "Entry Type : ",
// //                                       style: TextStyle(
// //                                           fontWeight: FontWeight.w500,
// //                                           fontSize: 14),
// //                                     )),
// //                                 Container(
// //                                     height: 27,
// //                                     width: 100,
// //                                     alignment: Alignment.center,
// //                                     padding:
// //                                     const EdgeInsets.only(left: 12, right: 12),
// //                                     margin:
// //                                     const EdgeInsets.only(left: 15, top: 10),
// //                                     decoration: BoxDecoration(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         border: Border.all(
// //                                             color: Colors.grey.shade600,
// //                                             width: 0.4)),
// //                                     child: Text(
// //                                       "$Entry_type",
// //                                       style: TextStyle(
// //                                           fontWeight: FontWeight.w600,
// //                                           fontSize: 12),
// //                                     )),
// //                               ],
// //                             ),
// //                           ),
// //
// //                           Container(
// //                             margin: const EdgeInsets.only(left: 30, right: 45, top: 8),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Container(
// //                                     width: 90,
// //                                     alignment: Alignment.topLeft,
// //                                     margin:
// //                                     const EdgeInsets.only(left: 15, top: 10),
// //                                     child: const Text(
// //                                       "Quantity : ",
// //                                       style: TextStyle(
// //                                           fontWeight: FontWeight.w500,
// //                                           fontSize: 14),
// //                                     )),
// //
// //                                 Column(
// //                                   children: [
// //                                     Container(
// //                                         height: 35,
// //                                         width: 100,
// //                                         alignment: Alignment.center,
// //                                         padding: const EdgeInsets.only(
// //                                             left: 12, right: 12, bottom: 4),
// //                                         margin:
// //                                         const EdgeInsets.only(left: 15, top: 10),
// //                                         decoration: BoxDecoration(
// //                                             borderRadius: BorderRadius.circular(8),
// //                                             border: Border.all(
// //                                                 color: Colors.grey.shade600,
// //                                                 width: 0.4)),
// //                                         child: TextFormField(
// //                                           keyboardType: TextInputType.number,
// //                                           controller: quantity_placeorder,
// //                                           decoration: const InputDecoration(
// //                                               border: InputBorder.none,
// //                                               hintText: "Enter Quantity",
// //                                               hintStyle: TextStyle(
// //                                                   fontSize: 10,
// //                                                   color: Colors.black,
// //                                                   fontWeight: FontWeight.w500)),
// //                                         )),
// //
// //                                     Lot_size=="null"||Lot_size==""?
// //                                     SizedBox():
// //                                     Container(
// //                                       margin:const EdgeInsets.only(top: 10),
// //                                       height: 25,
// //                                       padding:const EdgeInsets.only(left: 12,right: 12),
// //                                       decoration: BoxDecoration(
// //                                           borderRadius: BorderRadius.circular(15),
// //                                           border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.2)
// //                                       ),
// //                                       alignment: Alignment.center,
// //                                       child: Text("Lot Size : $Lot_size",style: TextStyle(fontSize: 11,color: Colors.grey),),
// //                                     )
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   Place_order_Api(
// //                                       Signal_id, Signal_price, Url_placeorder);
// //                                 },
// //                                 child: Container(
// //                                     height: 35,
// //                                     width: MediaQuery.of(context).size.width / 1.3,
// //                                     alignment: Alignment.center,
// //                                     padding:
// //                                     const EdgeInsets.only(left: 12, right: 12),
// //                                     margin: const EdgeInsets.only(top: 25),
// //                                     decoration: BoxDecoration(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         color: ColorValues.Splash_bg_color1),
// //                                     child: const Text(
// //                                       "Submit",
// //                                       style: TextStyle(
// //                                           fontWeight: FontWeight.w600,
// //                                           fontSize: 12,
// //                                           color: Colors.white),
// //                                     )),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       )),
// //                 ),
// //               );
// //             });
// //       },
// //     );
// //   }
// //
// //   Exit_order_popup(SignalId_exit, SignalPrice_exit, SignalName_exit,
// //       Entrytype_exit, Order_quantity,Trade_symbol,Lot_Size) {
// //     quantity_placeorder_exit.text = Order_quantity;
// //     return showModalBottomSheet(
// //       isScrollControlled: true,
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //             builder: (BuildContext ctx, StateSetter setState) {
// //               return Padding(
// //                 padding: EdgeInsets.only(
// //                   bottom: MediaQuery.of(context).viewInsets.bottom,
// //                 ),
// //                 child: SingleChildScrollView(
// //                   child: Container(
// //                     height: MediaQuery.of(context).size.height / 2.6,
// //                     child: Column(
// //                       children: [
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.start,
// //                           children: [
// //                             GestureDetector(
// //                               onTap: () {
// //                                 Navigator.pop(context);
// //                               },
// //                               child: Container(
// //                                 alignment: Alignment.topLeft,
// //                                 margin: const EdgeInsets.only(left: 15, top: 15),
// //                                 child: Icon(Icons.clear,
// //                                     color: Colors.grey.shade600, size: 25),
// //                               ),
// //                             ),
// //                             Container(
// //                                 alignment: Alignment.topLeft,
// //                                 margin: const EdgeInsets.only(left: 15, top: 15),
// //                                 child: Text(
// //                                   "$SignalName_exit",
// //                                   style: const TextStyle(
// //                                       fontWeight: FontWeight.w600, fontSize: 18),
// //                                 )),
// //
// //                             Container(
// //                                 alignment: Alignment.topLeft,
// //                                 margin: const EdgeInsets.only(left: 15, top: 15),
// //                                 child:Trade_symbol==null||Trade_symbol==""?
// //                                 SizedBox():
// //                                 Text(
// //                                   " ($Trade_symbol)",
// //                                   style: const TextStyle(
// //                                       fontWeight: FontWeight.w600, fontSize: 18),
// //                                 )
// //                             ),
// //
// //                           ],
// //                         ),
// //
// //                         Container(
// //                           margin:
// //                           const EdgeInsets.only(top: 5, left: 30, right: 45),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Container(
// //                                   width: 90,
// //                                   alignment: Alignment.topLeft,
// //                                   margin: const EdgeInsets.only(left: 15, top: 15),
// //                                   child: const Text(
// //                                     "Price : ",
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.w500, fontSize: 14),
// //                                   )),
// //                               Container(
// //                                   height: 27,
// //                                   width: 100,
// //                                   alignment: Alignment.center,
// //                                   padding:
// //                                   const EdgeInsets.only(left: 12, right: 12),
// //                                   margin: const EdgeInsets.only(left: 15, top: 15),
// //                                   decoration: BoxDecoration(
// //                                       borderRadius: BorderRadius.circular(8),
// //                                       border: Border.all(
// //                                           color: Colors.grey.shade600, width: 0.4)),
// //                                   child: Text(
// //                                     "₹ $SignalPrice_exit",
// //                                     style: const TextStyle(
// //                                         fontWeight: FontWeight.w600, fontSize: 12),
// //                                   )),
// //                             ],
// //                           ),
// //                         ),
// //                         Container(
// //                           margin:
// //                           const EdgeInsets.only(left: 30, right: 45, top: 8),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Container(
// //                                   width: 90,
// //                                   alignment: Alignment.topLeft,
// //                                   margin: const EdgeInsets.only(left: 15, top: 10),
// //                                   child: const Text(
// //                                     "Entry Type : ",
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.w500, fontSize: 14),
// //                                   )),
// //                               Container(
// //                                   height: 27,
// //                                   width: 100,
// //                                   alignment: Alignment.center,
// //                                   padding:
// //                                   const EdgeInsets.only(left: 12, right: 12),
// //                                   margin: const EdgeInsets.only(left: 15, top: 10),
// //                                   decoration: BoxDecoration(
// //                                       borderRadius: BorderRadius.circular(8),
// //                                       border: Border.all(
// //                                           color: Colors.grey.shade600, width: 0.4)),
// //                                   child: Text(
// //                                     "$Entrytype_exit",
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.w600, fontSize: 12),
// //                                   )),
// //                             ],
// //                           ),
// //                         ),
// //                         Container(
// //                           margin:
// //                           const EdgeInsets.only(left: 30, right: 45, top: 8),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Container(
// //                                   width: 90,
// //                                   alignment: Alignment.topLeft,
// //                                   margin: const EdgeInsets.only(left: 15, top: 10),
// //                                   child: const Text(
// //                                     "Quantity : ",
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.w500, fontSize: 14),
// //                                   )),
// //                               Column(
// //                                 children: [
// //                                   Container(
// //                                       height: 35,
// //                                       width: 100,
// //                                       alignment: Alignment.center,
// //                                       padding: const EdgeInsets.only(
// //                                           left: 12, right: 12, bottom: 4),
// //                                       margin: const EdgeInsets.only(left: 15, top: 10),
// //                                       decoration: BoxDecoration(
// //                                           borderRadius: BorderRadius.circular(8),
// //                                           border: Border.all(
// //                                               color: Colors.grey.shade600, width: 0.4)),
// //                                       child: TextFormField(
// //                                         keyboardType: TextInputType.number,
// //                                         controller: quantity_placeorder_exit,
// //                                         decoration: const InputDecoration(
// //                                             border: InputBorder.none,
// //                                             hintText: "Enter Quantity",
// //                                             hintStyle: TextStyle(
// //                                                 fontSize: 10,
// //                                                 color: Colors.black,
// //                                                 fontWeight: FontWeight.w500)),
// //                                       )),
// //
// //                                   Lot_Size=="null"||Lot_Size==""?
// //                                   SizedBox():
// //                                   Container(
// //                                     margin:const EdgeInsets.only(top: 10),
// //                                     height: 25,
// //                                     padding:const EdgeInsets.only(left: 12,right: 12),
// //                                     decoration: BoxDecoration(
// //                                         borderRadius: BorderRadius.circular(15),
// //                                         border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.2)
// //                                     ),
// //                                     alignment: Alignment.center,
// //                                     child: Text("Lot Size : $Lot_Size",style:const TextStyle(fontSize: 11,color: Colors.grey),),
// //                                   )
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             GestureDetector(
// //                               onTap: () {
// //                                 Exit_order_Api(SignalId_exit, SignalPrice_exit);
// //                               },
// //                               child: Container(
// //                                   height: 35,
// //                                   width: MediaQuery.of(context).size.width / 1.3,
// //                                   alignment: Alignment.center,
// //                                   padding:
// //                                   const EdgeInsets.only(left: 12, right: 12),
// //                                   margin: const EdgeInsets.only(top: 25),
// //                                   decoration: BoxDecoration(
// //                                       borderRadius: BorderRadius.circular(8),
// //                                       color: ColorValues.Splash_bg_color1),
// //                                   child: const Text(
// //                                     "Exit",
// //                                     style: TextStyle(
// //                                         fontWeight: FontWeight.w600,
// //                                         fontSize: 12,
// //                                         color: Colors.white),
// //                                   )),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             });
// //       },
// //     );
// //   }
// //
// //   Description_popup(Description) {
// //     return showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (BuildContext context) {
// //           return StatefulBuilder(
// //               builder: (BuildContext context, StateSetter setState) {
// //                 return Container(
// //                   margin: const EdgeInsets.only(left: 15, right: 15),
// //                   width: MediaQuery.of(context).size.width,
// //                   child: AlertDialog(
// //                     insetPadding: EdgeInsets.zero,
// //                     elevation: 0,
// //                     title: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Container(
// //                             child: const Text(
// //                               'Description',
// //                               style: TextStyle(
// //                                   color: Colors.black,
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.w600),
// //                             )),
// //                         GestureDetector(
// //                           onTap: () {
// //                             Navigator.pop(context);
// //                           },
// //                           child: Container(
// //                             alignment: Alignment.topRight,
// //                             child: const Icon(
// //                               Icons.clear,
// //                               color: Colors.black,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     content: Container(
// //                       // height:300,
// //                       width: double.infinity,
// //                       child: SingleChildScrollView(
// //                         scrollDirection: Axis.vertical,
// //                         child: Column(
// //                           children: [
// //                             const Divider(
// //                               color: Colors.black,
// //                             ),
// //                             Container(
// //                               child: Text("$Description"),
// //                             )
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               });
// //         }) ??
// //         false;
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
//
// class ShareLinkPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title:const Text("Share Link")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Generate and share the link
//             String link = generateLink(path: '/backend/api/refer', queryParams: {'ref': '12334'});
//             shareLink(link);
//           },
//           child:const Text("Share Home Link"),
//         ),
//       ),
//     );
//   }
//
//   /// Function to generate a link
//   String generateLink({required String path, Map<String, String>? queryParams}) {
//     Uri uri = Uri(
//       scheme: 'https',
//       host: 'stockboxpnp.pnpuniverse.com', // Your app's domain
//       path: path,
//       queryParameters: queryParams,
//     );
//     return uri.toString();
//   }
//
//   /// Function to share a link
//   void shareLink(String link) {
//     Share.share('Check out this page: $link');
//   }
// }
//
//
//
//
