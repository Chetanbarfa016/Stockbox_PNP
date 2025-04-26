// import 'package:expansion_tile_card/expansion_tile_card.dart';
// import 'package:flutter/material.dart';
// import 'package:stock_box/Api/Apis.dart';
//
// class Cash_signal extends StatefulWidget {
//   const Cash_signal({Key? key}) : super(key: key);
//
//   @override
//   State<Cash_signal> createState() => _Cash_signalState();
// }
//
// class _Cash_signalState extends State<Cash_signal> {
//
//   bool show=false;
//
//    var Signal_data;
//    bool? Message;
//    bool? loader=false;
//
//   Signal_Api() async {
//     var data = await API.Signal_Api();
//     setState(() {
//       Signal_data = data['signals'];
//       print("Signal dataaa: $Signal_data");
//       Message = data['message'];
//       loader=true;
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Signal_Api();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.only(top: 10),
//         child: ListView.builder(
//           itemCount: Signal_data.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return Container(
//               // height: 130,
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade400, width: 0.3),
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade50),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(top: 6, left: 8),
//                         child: Text(
//                           "Opened :",
//                           style: TextStyle(
//                               fontSize: 12, color: Colors.grey.shade700),
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.only(top: 6, right: 8),
//                         child: const Text(
//                           "Jan-18, 6:10 PM",
//                           style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.only(top: 8, left: 8),
//                             height: 22,
//                             width: 55,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(7),
//                               color: Colors.green,
//                             ),
//                             alignment: Alignment.center,
//                             child:  Text(
//                               "${Signal_data[index]['Signal_data']} !!",
//                               style:
//                                   TextStyle(fontSize: 11, color: Colors.white),
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(top: 8, left: 10),
//                             child: const Text(
//                               "HARDUSDT",
//                               style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         margin: const EdgeInsets.only(top: 8, right: 8),
//                         height: 22,
//                         width: 75,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(7),
//                             color: Colors.grey.shade200),
//                         alignment: Alignment.center,
//                         child: const Text(
//                           "In progress",
//                           style: TextStyle(fontSize: 11, color: Colors.black),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: 3),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: const EdgeInsets.only(top: 6, left: 8),
//                               child: Text(
//                                 "Entry price :",
//                                 style: TextStyle(
//                                     fontSize: 12, color: Colors.grey.shade700),
//                               ),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.only(top: 6, left: 8),
//                               child: const Text(
//                                 "0.14",
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         Container(
//                           margin: EdgeInsets.only(right: 12),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.only(top: 6),
//                                 child: Text(
//                                   "Exit price :",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey.shade700),
//                                 ),
//                               ),
//                               Container(
//                                 margin: const EdgeInsets.only(top: 6, left: 8),
//                                 child: const Text(
//                                   "0.20",
//                                   style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.only(top: 6, left: 8),
//                             child: Text(
//                               "Entry time :",
//                               style: TextStyle(
//                                   fontSize: 12, color: Colors.grey.shade700),
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(top: 6, left: 8),
//                             child: const Text(
//                               "9 sept, 10:20",
//                               style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       Container(
//                         margin: EdgeInsets.only(right: 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: const EdgeInsets.only(top: 6),
//                               child: Text(
//                                 "Exit time :",
//                                 style: TextStyle(
//                                     fontSize: 12, color: Colors.grey.shade700),
//                               ),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.only(top: 6, left: 8),
//                               child: const Text(
//                                 "9 sept, 11:52",
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.only(top: 6, left: 8),
//                             child: Text(
//                               "PnL :",
//                               style: TextStyle(
//                                   fontSize: 12, color: Colors.grey.shade700),
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(top: 6, left: 8),
//                             child: const Text(
//                               "₹ 100",
//                               style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       Container(
//                         margin: EdgeInsets.only(right: 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: const EdgeInsets.only(top: 6),
//                               child: Text(
//                                 "Holding time :",
//                                 style: TextStyle(
//                                     fontSize: 12, color: Colors.grey.shade700),
//                               ),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.only(top: 6, left: 8),
//                               child: const Text(
//                                 "2 hrs. 10 min",
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//
//                   // Container(
//                   //   margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
//                   //   height: 25,
//                   //   width: double.infinity,
//                   //   decoration: BoxDecoration(
//                   //       borderRadius: BorderRadius.circular(10),
//                   //       color: Colors.grey.shade200),
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //     children: [
//                   //       Container(
//                   //         margin: const EdgeInsets.only(left: 8),
//                   //         child: Text(
//                   //           "Current price :",
//                   //           style: TextStyle(
//                   //               fontSize: 12, color: Colors.grey.shade700),
//                   //         ),
//                   //       ),
//                   //       Container(
//                   //         margin: const EdgeInsets.only(left: 8),
//                   //         child: Text(
//                   //           "0.0869",
//                   //           style: TextStyle(
//                   //               fontSize: 12, color: Colors.grey.shade700),
//                   //         ),
//                   //       ),
//                   //       Container(
//                   //         margin: const EdgeInsets.only(right: 8),
//                   //         child: const Text(
//                   //           "-37.93%",
//                   //           style: TextStyle(
//                   //               fontSize: 11,
//                   //               color: Colors.red,
//                   //               fontWeight: FontWeight.w600),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//
//                   GestureDetector(
//                     onTap: (){
//                       setState(() {
//                         show=!show;
//                       });
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(left: 8, right: 8, top: 12),
//                       height: 25,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.grey.shade200),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.only(left: 8),
//                             child: Text(
//                               "Current price :",
//                               style: TextStyle(
//                                   fontSize: 12, color: Colors.grey.shade700),
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(left: 8),
//                             child: Text(
//                               "0.0869",
//                               style: TextStyle(
//                                   fontSize: 12, color: Colors.grey.shade700),
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(left: 8),
//                             child: const Text(
//                               "-37.93%",
//                               style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                           Container(
//                               margin: const EdgeInsets.only(right: 8,bottom: 3),
//                               child:
//                               Icon(
//                                 show==true?
//                                 Icons.arrow_drop_up:
//                                 Icons.arrow_drop_down,
//                                 size: 25,color: Colors.black,)
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   show==true?
//                   Container(
//                     height: 25,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.grey.shade200
//                     ),
//                     margin:const EdgeInsets.only(left: 15,right: 15,top: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           margin:const EdgeInsets.only(left: 10),
//                           child:const Text("Target 1",style: TextStyle(fontSize: 11),),
//                         ),
//                         Container(
//                           margin:const EdgeInsets.only(right: 10),
//                           child:const Text("200",style: TextStyle(fontSize: 11),),
//                         )
//                       ],
//                     ),
//                   )
//                       :
//                   SizedBox(
//                     height: 0,
//                   ),
//
//                   show==true?
//                   Container(
//                     height: 25,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.grey.shade200
//                     ),
//                     margin:const EdgeInsets.only(left: 15,right: 15,top: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           margin:const EdgeInsets.only(left: 10),
//                           child:const Text("Target 2",style: TextStyle(fontSize: 11),),
//                         ),
//                         Container(
//                           margin:const EdgeInsets.only(right: 10),
//                           child:const Text("300",style: TextStyle(fontSize: 11),),
//                         )
//                       ],
//                     ),
//                   )
//                       :
//                   SizedBox(
//                     height: 0,
//                   ),
//
//                   show==true?
//                   Container(
//                     height: 25,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.grey.shade200
//                     ),
//                     margin: EdgeInsets.only(left: 15,right: 15,top: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 10),
//                           child: Text("Target 3",style: TextStyle(fontSize: 11),),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(right: 10),
//                           child: Text("400",style: TextStyle(fontSize: 11),),
//                         )
//                       ],
//                     ),
//                   )
//                       :
//                   SizedBox(
//                     height: 0,
//                   ),
//
//                   Container(
//                     margin:const EdgeInsets.only(top: 5, bottom: 12),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           height: 25,
//                           width: 140,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color:const Color(0xffE4EfE9),
//                           ),
//                           margin: const EdgeInsets.only(top: 6, left: 8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "View Chart",
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                               Icon(
//                                 Icons.candlestick_chart,
//                                 size: 15,
//                                 color: Colors.grey.shade600,
//                               )
//                             ],
//                           ),
//                         ),
//
//                         GestureDetector(
//                           onTap: (){
//                             View_analysis_popup();
//                             },
//                           child: Container(
//                             height: 25,
//                             width: 140,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color:const Color(0xffE4EfE9),
//                             ),
//                             margin: const EdgeInsets.only(top: 6, right: 8),
//                             alignment: Alignment.center,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   "View Analysis",
//                                   style: TextStyle(fontSize: 12),
//                                 ),
//                                 Container(
//                                     margin:const EdgeInsets.only(left: 3),
//                                     child: Icon(
//                                       Icons.computer,
//                                       size: 12,
//                                       color: Colors.grey.shade600,
//                                     ))
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ));
//   }
//
// }
