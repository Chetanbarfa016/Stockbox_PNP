// import 'package:flutter/material.dart';
// import 'package:stock_box/Constants/Colors.dart';
// import 'package:stock_box/Global_widgets/Trades/Stocks/Closed.dart';
// import 'package:stock_box/Global_widgets/Trades/Stocks/Live.dart';
//
// class Stocks extends StatefulWidget {
//   const Stocks({Key? key}) : super(key: key);
//
//   @override
//   State<Stocks> createState() => _StocksState();
// }
//
// class _StocksState extends State<Stocks> with SingleTickerProviderStateMixin{
//   late final TabController _tabController;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Container(
//             height: 40,
//             width: MediaQuery.of(context).size.width,
//             margin:const EdgeInsets.only(top: 20,left: 15,right: 15),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.grey.shade400,width: 0.3)
//             ),
//             child: TabBar(
//               dividerColor: Colors.transparent,
//               // padding: EdgeInsets.only(left: 25,right: 25),
//               unselectedLabelColor: Colors.black,
//               labelColor: Colors.white,
//               labelStyle:const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//               indicatorWeight: 0.0,
//               isScrollable: false,
//               controller: _tabController,
//               indicatorSize: TabBarIndicatorSize.tab,
//               indicator: BoxDecoration(
//                 gradient:const LinearGradient(
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                   // stops: [
//                   //   0.1,
//                   //   0.5,
//                   // ],
//                   colors: [
//                     // Color(0xff93A5CF),
//                     // Color(0xffE4EfE9)
//                     Color(0xff354273),
//                     Color(0xff354273),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               tabs: const <Widget>[
//                 Tab(
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text('Live Trades'),
//                     ),
//                   ),
//                 ),
//
//                 Tab(
//                   child: SizedBox(
//                     width: double.infinity, // set width to infinity to make it expand to fit the available space
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text('Closed Trades'),
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: <Widget> [
//
//                 Container(
//                   margin:const EdgeInsets.only(top: 15,),
//                   child: ListView.builder(
//                     itemCount: 10,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         margin:const EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
//                         height: 350,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(7),
//                           color:const Color(0x7193a5cf),
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               margin:const EdgeInsets.only(top: 10,left: 10,right: 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     child: Row(
//                                       children: [
//                                         const Icon(Icons.lock_clock,size: 18,),
//                                         Container(
//                                           margin:const EdgeInsets.only(left: 10),
//                                           child:const Text("26 Dec 2024 | 3:26",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600),),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 20,
//                                     width: 80,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       border: Border.all(color: Colors.black,width: 0.3),
//                                       color: Colors.white,
//                                     ),
//                                     alignment: Alignment.center,
//                                     child:const Text("Short term",style: TextStyle(fontSize: 11),),
//                                   )
//                                 ],
//                               ),
//                             ),
//
//                             Container(
//                               margin:const EdgeInsets.only(top: 15,left: 15,right: 15),
//                               height: 212,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(5)
//                               ),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     margin:const EdgeInsets.only(top: 5),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Tata_Power_Logo.png/640px-Tata_Power_Logo.png",height: 50,width: 60,),
//                                         ),
//                                         Container(
//                                           margin:const EdgeInsets.only(left: 1,top: 5),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child:const Text("TATA POWER",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
//                                               ),
//                                               Container(
//                                                 child:Row(
//                                                   children: [
//                                                     Container(
//                                                       child:const Text("₹1365.54",style: TextStyle(fontSize: 11),),
//                                                     ),
//
//                                                     Container(
//                                                         child:const Icon(Icons.arrow_drop_up,color: Colors.green,)
//                                                     ),
//
//                                                     Container(
//                                                       child:const Text("67.32(5.45%)",style: TextStyle(fontSize: 11,color: Colors.green),),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                   Container(
//                                     margin:const EdgeInsets.only(top: 15,left: 15,right: 15),
//                                     height: 80,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.5),
//                                         borderRadius: BorderRadius.circular(10)
//                                     ),
//
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                             margin:const EdgeInsets.only(top: 10),
//                                             child: Row(
//                                               mainAxisAlignment:MainAxisAlignment.center ,
//                                               children: [
//                                                 Container(
//                                                   child: Text("Suggested Entry: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
//                                                 ),
//                                                 Container(
//                                                   margin:const EdgeInsets.only(left: 8),
//                                                   child:const Text("1320.50",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
//                                                 )
//                                               ],
//                                             )
//                                         ),
//
//                                         Container(
//                                             margin:const EdgeInsets.only(left: 20,right: 20),
//                                             child: Divider(color: Colors.grey.shade500,)
//                                         ),
//
//                                         Container(
//                                           margin:const EdgeInsets.only(top: 5),
//                                           child: Row(
//                                             mainAxisAlignment:MainAxisAlignment.center,
//                                             children: [
//                                               Container(
//                                                 child: Text("Entry range: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
//                                               ),
//                                               Container(
//                                                 margin:const EdgeInsets.only(left: 8),
//                                                 child:const Text("( 1315.50-1335.50 )",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: ColorValues.Splash_bg_color1),),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//
//                                       ],
//                                     ),
//                                   ),
//
//                                   Container(
//                                     margin:const EdgeInsets.only(top: 17,left: 10,right: 10),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Container(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child:const Text("Stoploss:",style: TextStyle(fontSize: 12),),
//                                               ),
//                                               Container(
//                                                 margin:const EdgeInsets.only(top: 5),
//                                                 child:const Text("₹1300.00",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//
//                                         Container(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child:const Text("Target:",style: TextStyle(fontSize: 12),),
//                                               ),
//                                               Container(
//                                                 margin:const EdgeInsets.only(top: 5),
//                                                 child:const Text("₹1500.00",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//
//                                         Container(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child:const Text("Hold duration:",style: TextStyle(fontSize: 12),),
//                                               ),
//                                               Container(
//                                                 margin:const EdgeInsets.only(top: 5),
//                                                 child:const Text("1-3 months",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//
//                                       ],
//                                     ),
//                                   )
//
//                                 ],
//                               ),
//                             ),
//
//                             Container(
//                               margin:const EdgeInsets.only(top: 7),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     child:const Text("Gain so far : "),
//                                   ),
//
//                                   Container(
//                                     alignment: Alignment.center,
//                                     height: 20,
//                                     width: 70,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.green
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         const Icon(Icons.arrow_drop_up,color: Colors.white,size: 15,),
//                                         Container(
//                                           child:const Text("1.50%",style: TextStyle(fontSize: 12,color: Colors.white),),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                 ],
//                               ),
//                             ),
//
//                             Container(
//                               margin:const EdgeInsets.only(top: 10,left: 15,right: 15),
//                               height: 40,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                   color: Colors.grey.shade100,
//                                   borderRadius: BorderRadius.circular(8)
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//
//                                   Container(
//                                     margin:const EdgeInsets.only(left: 20),
//                                     child:const Text("View Chart",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color2),),
//                                   ),
//
//                                   Container(
//                                     margin:const EdgeInsets.only(right: 20),
//                                     height: 25,
//                                     width: 60,
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(4),
//                                         color: Colors.green
//                                     ),
//                                     child:const Text("Buy",style: TextStyle(fontSize: 12,color: Colors.white),),
//                                   ),
//
//                                 ],
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 Container(
//                   margin:const EdgeInsets.only(top: 15),
//                   child: ListView.builder(
//                     itemCount: 10,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         margin:const EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
//                         height: 350,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(7),
//                           color:const Color(0x7193a5cf),
//                         ),
//
//                         child: Column(
//                           children: [
//                             Container(
//                               margin:const EdgeInsets.only(top: 10,left: 10,right: 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     child: Row(
//                                       children: [
//                                         const Icon(Icons.lock_clock,size: 18,),
//                                         Container(
//                                           margin:const EdgeInsets.only(left: 10),
//                                           child:const Text("26 Dec 2024 | 3:26",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600),),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 20,
//                                     width: 80,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       border: Border.all(color: Colors.black,width: 0.3),
//                                       color: Colors.white,
//                                     ),
//                                     alignment: Alignment.center,
//                                     child:const Text("Short term",style: TextStyle(fontSize: 11),),
//                                   )
//                                 ],
//                               ),
//                             ),
//
//                             Container(
//                               margin:const EdgeInsets.only(top: 15,left: 15,right: 15),
//                               height: 200,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(5)
//                               ),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     margin:const EdgeInsets.only(top: 5),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Tata_Power_Logo.png/640px-Tata_Power_Logo.png",height: 50,width: 60,),
//                                         ),
//                                         Container(
//                                           margin:const EdgeInsets.only(left: 1,top: 5),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child:const Text("TATA POWER",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
//                                               ),
//                                               Container(
//                                                   child:Row(
//                                                     children: [
//                                                       Container(
//                                                         child:const Text("₹1365.54",style: TextStyle(fontSize: 11),),
//                                                       ),
//
//                                                       Container(
//                                                           child:const Icon(Icons.arrow_drop_up,color: Colors.green,)
//                                                       ),
//
//                                                       Container(
//                                                         child:const Text("67.32(5.45%)",style: TextStyle(fontSize: 11,color: Colors.green),),
//                                                       ),
//                                                     ],
//                                                   )
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//
//                                   Container(
//                                     margin:const EdgeInsets.only(top: 15,left: 15,right: 15),
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.5),
//                                         borderRadius: BorderRadius.circular(10)
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           margin:const EdgeInsets.only(top: 10),
//                                           child: Row(
//                                             mainAxisAlignment:MainAxisAlignment.center,
//                                             children: [
//                                               Container(
//                                                 child: Text("Suggested Entry: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
//                                               ),
//                                               Container(
//                                                 margin:const EdgeInsets.only(left: 8),
//                                                 child:const Text("1320.50",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                   Container(
//                                     margin:const EdgeInsets.only(top: 17,left: 10,right: 10),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Container(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child:const Text("Stoploss:",style: TextStyle(fontSize: 12),),
//                                               ),
//                                               Container(
//                                                 margin:const EdgeInsets.only(top: 5),
//                                                 child:const Text("₹1300.00",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child:const Text("Target:",style: TextStyle(fontSize: 12),),
//                                               ),
//                                               Container(
//                                                 margin:const EdgeInsets.only(top: 5),
//                                                 child:const Text("₹1500.00",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//
//                                         Container(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child:const Text("Hold duration:",style: TextStyle(fontSize: 12),),
//                                               ),
//                                               Container(
//                                                 margin:const EdgeInsets.only(top: 5),
//                                                 child:const Text("1-3 months",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//
//                                   const Spacer(),
//
//                                   Container(
//                                     height: 25,
//                                     color: Colors.green,
//                                     alignment: Alignment.center,
//                                     child:const Text("Closed trade profitably at ₹1400.20",style: TextStyle(fontSize: 11,color: Colors.white),),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             Container(
//                               margin:const EdgeInsets.only(top: 7),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     child:const Text("Net gain : "),
//                                   ),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     height: 20,
//                                     width: 70,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.green
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         const Icon(Icons.arrow_drop_up,color: Colors.white,size: 15,),
//                                         Container(
//                                           child:const Text("1.50%",style: TextStyle(fontSize: 12,color: Colors.white),),
//                                         )
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//
//                             Container(
//                               margin:const EdgeInsets.only(top: 10,left: 15,right: 15),
//                               height: 50,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade100,
//                                 borderRadius:const BorderRadius.only(
//                                     bottomLeft: Radius.circular(8),
//                                     bottomRight: Radius.circular(8)
//                                 ),
//                               ),
//
//                               child:Column(
//                                 children: [
//                                   Container(
//                                     margin:const EdgeInsets.only(top: 7),
//                                     child:const Text("Closed trade in 27 days",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),),
//                                   ),
//                                   Container(
//                                     margin:const EdgeInsets.only(top: 5),
//                                     child: Text("on 27/08- 01:32 PM at ₹1420.20",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
//                                   ),
//                                 ],
//                               ),
//
//                             ),
//                           ],
//                         ),
//
//                       );
//                     },
//                   ),
//                 ),
//
//
//                 // Stock_livetrades(),
//                 // Stock_closedtrades(),
//               ],
//             ),
//           ),
//
//         ],
//       )
//     );
//   }
// }
