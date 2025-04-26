// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:stock_box/Constants/Colors.dart';
// import '../../Api/Apis.dart';
// import 'Broker Responce Detail.dart';
//
// class BrokerResponse extends StatefulWidget {
//   const BrokerResponse({super.key});
//
//   @override
//   State<BrokerResponse> createState() => _BrokerResponseState();
// }
//
// class _BrokerResponseState extends State<BrokerResponse> {
//
//  String? loader = "true";
//  var BrokerResponse_data =[];
//   BrokerResponse_Fun() async {
//     var data = await API.BrokerResponse_Api();
//
//     if (data['status'] == true) {
//       BrokerResponse_data=data['data'];
//       // boolList = List.filled(BrokerResponse_data.length, false);
//
//       setState(() {
//         BrokerResponse_data.length>0?
//         loader = "false":
//         loader = "No_data";
//       });
//     } else {
//       setState(() {
//         loader = "No_data";
//       });
//     }
//   }
//
//
//
//  BrokerResponse_Detail_Fun(orderid, index, borkerid) async {
//    var data = await API.BrokerResponse_Detail_Api(orderid, borkerid);
//    if(data['status']==true){
//      setState(() {
//        BrokerResponse_data[index]['data'] = data['response'];
//        BrokerResponse_data[index]['status'] = 1;
//      });
//    }else{
//      setState(() {
//        BrokerResponse_data[index]['status'] = 3;
//      });
//    }
//  }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     BrokerResponse_Fun();
//   }
//  int? _expandedIndex=-1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 60,
//         titleSpacing: 0,
//         backgroundColor: Colors.grey.shade200,
//         elevation: 0.5,
//         leading: GestureDetector(
//             onTap: (){
//               Navigator.pop(context);
//             },
//             child:const Icon(Icons.arrow_back,color: Colors.black,)
//         ),
//         title:const Text("Broker Response",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
//       ),
//       body:  loader == "false"?
//       ListView.builder(
//         key: Key('builder ${_expandedIndex.toString()}'),
//         shrinkWrap: true,
//         itemCount: BrokerResponse_data.length,
//         itemBuilder: (BuildContext context, int index) {
//           int yy =  int.parse(DateFormat('yyyy').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
//           int MM = int.parse(DateFormat('MM').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
//           int DD = int.parse(DateFormat('dd').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
//           int HH =  int.parse(DateFormat('HH').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
//           int MMm =  int.parse(DateFormat('mm').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
//           int SS = int.parse(DateFormat('ss').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
//
//           final _utcTime=DateTime.utc(yy,MM,DD,HH,MMm,SS);
//           var LocalTimeTime=_utcTime.toLocal().toString().split(' ')[1].split('.')[0];
//           var LocaldateTime=_utcTime.toLocal().toString().split(' ')[0];
//           return Card(
//             margin:const EdgeInsets.only(left: 10,right: 10,top: 20),
//             child: Theme(
//               data: Theme.of(context).copyWith(
//                 dividerColor: Colors.transparent,
//               ),
//               child: ExpansionTile(
//                 initiallyExpanded: index==_expandedIndex,
//                 onExpansionChanged: (bool expanded) {
//                   setState(() {
//                     BrokerResponse_data[index]['status']==0?
//                     BrokerResponse_Detail_Fun(BrokerResponse_data[index]['orderid'], index,BrokerResponse_data[index]['borkerid'] ):
//                         print("dattt");
//
//                     if (expanded) {
//                       _expandedIndex = index;
//                     } else {
//                       _expandedIndex = -1;
//                     }
//                   });
//                 },
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width-120,
//                             margin:const EdgeInsets.only(top: 5),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "${BrokerResponse_data[index]['signalDetails']['tradesymbol']}",
//                                   style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
//                                 Spacer(),
//                                 Container(
//                                   padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                       color: BrokerResponse_data[index]['ordertype'].toUpperCase() =="BUY"?
//                                       Colors.green:Colors.red
//
//                                   ),
//                                   child: Text(
//                                     "${BrokerResponse_data[index]['ordertype']}",
//                                     style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,
//                                       color: Colors.white
//                                     ),),
//                                 ),
//                                 // Spacer(),
//                                 // Text(
//                                 //   // "${BrokerResponse_data[index]['createdAt']}",
//                                 //   "$LocaldateTime\n${LocalTimeTime}",
//                                 //   style:const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),)
//                               ],
//                             ),
//                           ),
//                           Container(
//                             width: MediaQuery.of(context).size.width-120,
//                             height: 25,
//                             margin:const EdgeInsets.only(top: 5,bottom: 3),
//                             child: Row(
//                               children: [
//                                 Text("price : ₹${BrokerResponse_data[index]['signalDetails']['price']}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
//
//                                 Spacer(),
//                                 Text(
//                                   "$LocaldateTime $LocalTimeTime",
//                                   style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500,
//                                       color: Colors.black
//                                   ),),
//                                 // Spacer(),
//                                 // Text(
//                                 //   // "${BrokerResponse_data[index]['createdAt']}",
//                                 //   "$LocaldateTime\n${LocalTimeTime}",
//                                 //   style:const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),)
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 children: [
//                   Container(
//                       margin:const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
//                       width: MediaQuery.of(context).size.width,
//                       child:BrokerResponse_data[index]['status']==3?
//                       Card(
//                         margin:const EdgeInsets.only(left: 0,right: 0),
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(
//                               color: ColorValues.Splash_bg_color1,
//                               width:0.4,
//                             )
//                         ),
//                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                         child: Container(
//                           child: Column(
//                             children:[
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("message",style:TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),)),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(left: 10),
//                                           child: Text('Order not found for this client',style:TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16))),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ):
//                       BrokerResponse_data[index]['borkerid'].toString()=="1" && BrokerResponse_data[index]['status']==1 &&  BrokerResponse_data[index]['data']['status']==true?
//                       Card(
//                         margin:const EdgeInsets.only(left: 0,right: 0),
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(
//                               color: ColorValues.Splash_bg_color1,
//                               width:0.4,
//                             )
//                         ),
//                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                         child: Container(
//                           child: Column(
//                             children:[
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10, top: 8),
//                                           child: Text("Title",style:TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),)),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(left: 10, top: 8),
//                                           child: Text('Description',style:TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16))),
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: GestureDetector(
//                                         onTap: (){
//                                           String? Single_id = BrokerResponse_data[index]['signalid'];
//                                           Navigator.push(context, MaterialPageRoute(builder: (context)=> Broker_Responce_Detail(Single_id:Single_id)));
//                                         },
//                                         child: Container(
//                                             margin: const EdgeInsets.only(left: 0, top: 8),
//                                             padding: EdgeInsets.only(top: 3, bottom: 3),
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(8),
//                                               color: ColorValues.Splash_bg_color1,
//                                             ),
//                                             alignment: Alignment.center,
//                                             child: Text('Details',style:TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 16))),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               const Divider(color: Colors.black,),
//
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Created At",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("${BrokerResponse_data[index]['data']['data']['updatetime']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Symbol",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("${BrokerResponse_data[index]['data']['data']['tradingsymbol']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Quantity",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("${BrokerResponse_data[index]['data']['data']['quantity']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Broker",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text(
//                                           BrokerResponse_data[index]['borkerid']=="1"?"Angel":"Aliceblue"
//                                               "${BrokerResponse_data[index]['borkerid']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Order ID",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("${BrokerResponse_data[index]['data']['data']['orderid']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Order Status",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child:Text("${BrokerResponse_data[index]['data']['data']['orderstatus'].toUpperCase()}",
//                                           style:TextStyle(
//                                               color: BrokerResponse_data[index]['data']['data']['orderstatus'].toUpperCase()=="REJECTED"?
//                                               Colors.red:
//                                               Colors.green,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10, right: 5, top: 6, bottom: 15),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin:const EdgeInsets.only(right: 10),
//                                           child: Text("Order Detail",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("${BrokerResponse_data[index]['data']['data']['text']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ):
//                       BrokerResponse_data[index]['borkerid'].toString()=="2" && BrokerResponse_data[index]['status']==1?
//                       Card(
//                         margin:const EdgeInsets.only(left: 0,right: 0),
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(
//                               color: ColorValues.Splash_bg_color1,
//                               width:0.4,
//                             )
//                         ),
//                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                         child: Container(
//                           child: Column(
//                             children:[
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10, top: 8),
//                                           child: Text("Title",style:TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),)),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(left: 10, top: 8),
//                                           child: Text('Description',style:TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16))),
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: GestureDetector(
//                                         onTap: (){
//                                           String? Single_id = BrokerResponse_data[index]['signalid'];
//                                           Navigator.push(context, MaterialPageRoute(builder: (context)=> Broker_Responce_Detail(Single_id:Single_id)));
//                                         },
//                                         child: Container(
//                                             margin: const EdgeInsets.only(left: 0, top: 8),
//                                             padding: EdgeInsets.only(top: 3, bottom: 3),
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(8),
//                                               color: ColorValues.Splash_bg_color1,
//                                             ),
//                                             alignment: Alignment.center,
//                                             child: Text('Details',style:TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 16))),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               const Divider(color: Colors.black,),
//
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Created At",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Symbol",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("${BrokerResponse_data[index]['data'][0]['Trsym']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Quantity",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("${BrokerResponse_data[index]['data'][0]['Qty']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Broker",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text(
//                                           BrokerResponse_data[index]['borkerid']=="1"?"Angel":"Aliceblue"
//                                               "${BrokerResponse_data[index]['borkerid']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Order ID",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("${BrokerResponse_data[index]['orderid']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("Order Status",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child:Text("${BrokerResponse_data[index]['data'][0]['Status'].toUpperCase()}",
//                                           style:TextStyle(
//                                               color: BrokerResponse_data[index]['data'][0]['Status'].toUpperCase()=="REJECTED"?
//                                               Colors.red:
//                                               Colors.green,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               const Divider(color: Colors.grey,),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10, right: 5, top: 6, bottom: 15),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin:const EdgeInsets.only(right: 10),
//                                           child: Text("Order Detail",
//                                               style:TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15))),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Text("${BrokerResponse_data[index]['data'][0]['rejectionreason']}",
//                                           style:TextStyle(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: 14)),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ):
//                       BrokerResponse_data[index]['status']==1 &&   BrokerResponse_data[index]['data']['status']==false?
//                       Card(
//                         margin:const EdgeInsets.only(left: 0,right: 0),
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(
//                               color: ColorValues.Splash_bg_color1,
//                               width:0.4,
//                             )
//                         ),
//                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                         child: Container(
//                           child: Column(
//                             children:[
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(right: 10),
//                                           child: Text("message",style:TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),)),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Container(
//                                           margin: const EdgeInsets.only(left: 10),
//                                           child: Text('${BrokerResponse_data[index]['data']['message']}',style:TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16))),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ):
//                       Card(
//                         margin:const EdgeInsets.only(left: 0,right: 0),
//                         elevation: 1,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(
//                               color: ColorValues.Splash_bg_color1,
//                               width:0.4,
//                             )
//                         ),
//                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                         child:  Container(
//                           height: 40, width: 40,
//                             padding: EdgeInsets.only(top: 5, bottom: 5),
//                             alignment: Alignment.center,
//                             child: CircularProgressIndicator()),
//                       )
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ):
//       loader == "No_data"?
//       Container(
//         alignment: Alignment.center,
//         child: Center(
//             child: Image.asset(
//               "images/notrades.png",
//               height: 100,
//             )),
//       ):
//       Container(
//         child: Center(
//           child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
//         ),
//       )
//
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Constants/Colors.dart';

import '../../Api/Apis.dart';
import 'Broker Responce Detail.dart';

class BrokerResponse extends StatefulWidget {
  const BrokerResponse({super.key});

  @override
  State<BrokerResponse> createState() => _BrokerResponseState();
}

class _BrokerResponseState extends State<BrokerResponse> {

  String? loader = "true";
  var BrokerResponse_data =[];
  BrokerResponse_Fun() async {
    var data = await API.BrokerResponse_Api();

    if (data['status'] == true) {
      BrokerResponse_data=data['data'];
      // boolList = List.filled(BrokerResponse_data.length, false);

      setState(() {
        BrokerResponse_data.length>0?
        loader = "false":
        loader = "No_data";
      });
    } else {
      setState(() {
        loader = "No_data";
      });
    }
  }



  BrokerResponse_Detail_Fun(orderid, index, borkerid) async {
    var data = await API.BrokerResponse_Detail_Api(orderid, borkerid);
    if(data['status']==true){
      setState(() {
        BrokerResponse_data[index]['data'] = data['response'];
        BrokerResponse_data[index]['status'] = 1;
      });
    }else{
      setState(() {
        BrokerResponse_data[index]['status'] = 3;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BrokerResponse_Fun();
  }
  int? _expandedIndex=-1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          titleSpacing: 0,
          backgroundColor: Colors.grey.shade200,
          elevation: 0.5,
          leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child:const Icon(Icons.arrow_back,color: Colors.black,)
          ),
          title:const Text("Broker Response",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
        ),
        body:  loader == "false"?
        ListView.builder(
          key: Key('builder ${_expandedIndex.toString()}'),
          shrinkWrap: true,
          itemCount: BrokerResponse_data.length,
          itemBuilder: (BuildContext context, int index) {
            int yy =  int.parse(DateFormat('yyyy').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
            int MM = int.parse(DateFormat('MM').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
            int DD = int.parse(DateFormat('dd').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
            int HH =  int.parse(DateFormat('HH').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
            int MMm =  int.parse(DateFormat('mm').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));
            int SS = int.parse(DateFormat('ss').format(DateTime.parse(BrokerResponse_data[index]['createdAt'])));

            final _utcTime=DateTime.utc(yy,MM,DD,HH,MMm,SS);
            var LocalTimeTime=_utcTime.toLocal().toString().split(' ')[1].split('.')[0];
            var LocaldateTime=_utcTime.toLocal().toString().split(' ')[0];
            return Card(
              margin:const EdgeInsets.only(left: 10,right: 10,top: 20),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  initiallyExpanded: index==_expandedIndex,
                  onExpansionChanged: (bool expanded) {
                    setState(() {

                      print("brokerResponse_data[index]['status'] == ${BrokerResponse_data[index]['status']}");
                      BrokerResponse_data[index]['status']==0?
                      BrokerResponse_Detail_Fun(BrokerResponse_data[index]['orderid'], index,BrokerResponse_data[index]['borkerid'] ):
                      print("dattt");

                      if (expanded) {
                        _expandedIndex = index;
                      } else {
                        _expandedIndex = -1;
                      }
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width-120,
                              margin:const EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "${BrokerResponse_data[index]['signalDetails']['tradesymbol']}",
                                    style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: BrokerResponse_data[index]['ordertype'].toUpperCase() =="BUY"?
                                        Colors.green:Colors.red

                                    ),
                                    child: Text(
                                      "${BrokerResponse_data[index]['ordertype']}",
                                      style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,
                                          color: Colors.white
                                      ),),
                                  ),
                                  // Spacer(),
                                  // Text(
                                  //   // "${BrokerResponse_data[index]['createdAt']}",
                                  //   "$LocaldateTime\n${LocalTimeTime}",
                                  //   style:const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),)
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width-120,
                              height: 25,
                              margin:const EdgeInsets.only(top: 5,bottom: 3),
                              child: Row(
                                children: [
                                  Text("price : ₹${BrokerResponse_data[index]['signalDetails']['price']}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),

                                  Spacer(),
                                  Text(
                                    "$LocaldateTime $LocalTimeTime",
                                    style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500,
                                        color: Colors.black
                                    ),),
                                  // Spacer(),
                                  // Text(
                                  //   // "${BrokerResponse_data[index]['createdAt']}",
                                  //   "$LocaldateTime\n${LocalTimeTime}",
                                  //   style:const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                        margin:const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child:BrokerResponse_data[index]['status']==3?
                        Card(
                          margin:const EdgeInsets.only(left: 0,right: 0),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: ColorValues.Splash_bg_color1,
                                width:0.4,
                              )
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            child: Column(
                              children:[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("message",style:TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),)),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Text('Order not found for this client',style:TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ):
                        BrokerResponse_data[index]['borkerid'].toString()=="1" && BrokerResponse_data[index]['status']==1 &&  BrokerResponse_data[index]['data']['status']==true?
                        Card(
                          margin:const EdgeInsets.only(left: 0,right: 0),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: ColorValues.Splash_bg_color1,
                                width:0.4,
                              )
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            child: Column(
                              children:[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10, top: 8),
                                            child: Text("Title",style:TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),)),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                            margin: const EdgeInsets.only(left: 10, top: 8),
                                            child: Text('Description',style:TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: (){
                                            String? Single_id = BrokerResponse_data[index]['signalid'];
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Broker_Responce_Detail(Single_id:Single_id)));
                                          },
                                          child: Container(
                                              margin: const EdgeInsets.only(left: 0, top: 8),
                                              padding: EdgeInsets.only(top: 3, bottom: 3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: ColorValues.Splash_bg_color1,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text('Details',style:TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16))),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.black,),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("Created At",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("${BrokerResponse_data[index]['data']['data']['updatetime']}",
                                            style:TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("Symbol",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("${BrokerResponse_data[index]['data']['data']['tradingsymbol']}",
                                            style:TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("Quantity",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("${BrokerResponse_data[index]['data']['data']['quantity']}",
                                            style:TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("Broker",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                            BrokerResponse_data[index]['borkerid']=="1"?"Angel" :
                                            BrokerResponse_data[index]['borkerid']=="2"?
                                            "Aliceblue":
                                            BrokerResponse_data[index]['borkerid']=="3"?
                                            "Kotak":
                                            BrokerResponse_data[index]['borkerid']=="4"?
                                            "Market Hub":
                                            BrokerResponse_data[index]['borkerid']=="5"?
                                            "Zerodha":
                                            BrokerResponse_data[index]['borkerid']=="6"?
                                            "UpStox":
                                            "Dhan"
                                                "${BrokerResponse_data[index]['borkerid']}",
                                            style:TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("Order ID",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("${BrokerResponse_data[index]['data']['data']['orderid']}",
                                            style:TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("Order Status",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child:Text("${BrokerResponse_data[index]['data']['data']['orderstatus'].toUpperCase()}",
                                            style:TextStyle(
                                                color: BrokerResponse_data[index]['data']['data']['orderstatus'].toUpperCase()=="REJECTED"?
                                                Colors.red:
                                                Colors.green,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 5, top: 6, bottom: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin:const EdgeInsets.only(right: 10),
                                            child: Text("Order Detail",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("${BrokerResponse_data[index]['data']['data']['text']}",
                                            style:TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ):
                        BrokerResponse_data[index]['borkerid'].toString()=="2" && BrokerResponse_data[index]['status']==1?
                        Card(
                          margin:const EdgeInsets.only(left: 0,right: 0),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: ColorValues.Splash_bg_color1,
                                width:0.4,
                              )
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            child: Column(
                              children:[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10, top: 8),
                                            child: Text("Title",style:TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),)),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                            margin: const EdgeInsets.only(left: 10, top: 8),
                                            child: Text('Description',style:TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: (){
                                            String? Single_id = BrokerResponse_data[index]['signalid'];
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Broker_Responce_Detail(Single_id:Single_id)));
                                          },
                                          child: Container(
                                              margin: const EdgeInsets.only(left: 0, top: 8),
                                              padding: EdgeInsets.only(top: 3, bottom: 3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: ColorValues.Splash_bg_color1,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text('Details',style:TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16))),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.black,),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("Created At",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("",
                                            style:TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("Symbol",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("${BrokerResponse_data[index]['data'][0]['Trsym']}",
                                            style:TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text("Quantity",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("${BrokerResponse_data[index]['data'][0]['Qty']}",
                                            style:TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child:const Text("Broker",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                            BrokerResponse_data[index]['borkerid']=="1"?"Angel" :
                                            BrokerResponse_data[index]['borkerid']=="2"?
                                            "Aliceblue":
                                            BrokerResponse_data[index]['borkerid']=="3"?
                                            "Kotak":
                                            BrokerResponse_data[index]['borkerid']=="4"?
                                            "Market Hub":
                                            BrokerResponse_data[index]['borkerid']=="5"?
                                            "Zerodha":
                                            BrokerResponse_data[index]['borkerid']=="6"?
                                            "UpStox":
                                            "Dhan"
                                                "${BrokerResponse_data[index]['borkerid']}",
                                            style:const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child:const Text("Order ID",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("${BrokerResponse_data[index]['orderid']}",
                                            style:const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child:const Text("Order Status",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child:Text("${BrokerResponse_data[index]['data'][0]['Status'].toUpperCase()}",
                                            style:TextStyle(
                                                color: BrokerResponse_data[index]['data'][0]['Status'].toUpperCase()=="REJECTED"?
                                                Colors.red:
                                                Colors.green,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 5, top: 6, bottom: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin:const EdgeInsets.only(right: 10),
                                            child:const Text("Order Detail",
                                                style:TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15))),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text("${BrokerResponse_data[index]['data'][0]['rejectionreason']}",
                                            style:const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ):
                        BrokerResponse_data[index]['status']==1 &&   BrokerResponse_data[index]['data']['status']==false?
                        Card(
                          margin:const EdgeInsets.only(left: 0,right: 0),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: ColorValues.Splash_bg_color1,
                                width:0.4,
                              )
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            child: Column(
                              children:[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child:const Text("message",style:TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),)),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Text('${BrokerResponse_data[index]['data']['message']}',style:const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ):
                        Card(
                          margin:const EdgeInsets.only(left: 0,right: 0),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: ColorValues.Splash_bg_color1,
                                width:0.4,
                              )
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child:  Container(
                              height: 40, width: 40,
                              padding:const EdgeInsets.only(top: 5, bottom: 5),
                              alignment: Alignment.center,
                              child:const CircularProgressIndicator()),
                        )
                    ),
                  ],
                ),
              ),
            );
          },
        ):
        loader == "No_data"?
        Container(
          alignment: Alignment.center,
          child: Center(
              child: Image.asset(
                "images/notrades.png",
                height: 100,
              )),
        ):
        Container(
          child: Center(
            child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
          ),
        )

    );
  }
}

