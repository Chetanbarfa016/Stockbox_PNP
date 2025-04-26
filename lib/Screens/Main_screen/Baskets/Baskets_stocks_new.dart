// import 'package:flutter/material.dart';
// import 'package:stock_box/Api/Apis.dart';
// import 'package:stock_box/Constants/Colors.dart';
//
// class Basket_stocksnew extends StatefulWidget {
//   Basket_stocksnew({Key? key}) : super(key: key);
//
//   @override
//   State<Basket_stocksnew> createState() => _Basket_stocksnewState();
// }
//
// class _Basket_stocksnewState extends State<Basket_stocksnew> {
//
//   bool show=false;
//
//   // var Basket_data;
//   // bool? Status;
//   // String? Message;
//   // bool loader= false;
//   //
//   // Basket_Api() async {
//   //   var data = await API.Basket_Api();
//   //   setState(() {
//   //     Status = data['status'];
//   //     Message = data['message'];
//   //   });
//   //
//   //   if(Status==true){
//   //     setState(() {});
//   //     Basket_data=data['data'];
//   //
//   //     loader=true;
//   //   }
//   //
//   //   else{
//   //     print("error");
//   //   }
//   // }
//   //
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   Basket_Api();
//   // }
//
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
//         title:const Text("Stocks New",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(top: 20,bottom: 10, right: 15),
//             height: 22,
//             width: 60,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(7),
//                 color: Colors.green
//             ),
//             alignment: Alignment.center,
//             child: const Text(
//               "Buy",
//               style: TextStyle(fontSize: 11, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//
//       body: SingleChildScrollView(
//         child: Container(
//             margin: const EdgeInsets.only(top: 10),
//             child: Column(
//               children: [
//                 Container(
//                   width:MediaQuery.of(context).size.width,
//                   margin:const EdgeInsets.only(left: 20,right: 20,top: 10),
//                   child: Column(
//                     children: [
//                       Container(
//                         margin:const EdgeInsets.only(top: 5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   child:const Text("Investment Amount :",style: TextStyle(fontSize: 13),),
//                                 ),
//                                 Container(
//                                   margin:const EdgeInsets.only(top: 2),
//                                   child:const Text("₹10000",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
//                                 )
//                               ],
//                             ),
//
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   child:const Text("Current Value :",style: TextStyle(fontSize: 13),),
//                                 ),
//                                 Container(
//                                   margin:const EdgeInsets.only(top: 2),
//                                   child:const Text("₹11000",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
//                                 )
//                               ],
//                             )
//
//                           ],
//                         ),
//                       ),
//
//                       Container(
//                         child: Divider(color: Colors.grey.shade300,),
//                       ),
//
//                       Container(
//                         margin:const EdgeInsets.only(top: 3),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   child:const Text("Profit / Loss :",style: TextStyle(fontSize: 13),),
//                                 ),
//                                 Container(
//                                   margin:const EdgeInsets.only(top: 2),
//                                   child:const Text("+1000",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.green),),
//                                 ),
//                               ],
//                             ),
//
//                             // Column(
//                             //   crossAxisAlignment: CrossAxisAlignment.start,
//                             //   children: [
//                             //     Container(
//                             //       child:const Text("Current Value :",style: TextStyle(fontSize: 15),),
//                             //     ),
//                             //     Container(
//                             //       margin:const EdgeInsets.only(top: 2),
//                             //       child:const Text("₹11000",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
//                             //     )
//                             //   ],
//                             // )
//
//                           ],
//                         ),
//                       ),
//
//                       Container(
//                         margin:const EdgeInsets.only(top: 10),
//                         child: Divider(color: Colors.grey.shade700,),
//                       ),
//
//                     ],
//                   ),
//                 ),
//
//                 Container(
//                   margin:const EdgeInsets.only(top:5,bottom: 10),
//                   child: ListView.builder(
//                     itemCount:10,
//                     shrinkWrap: true,
//                     physics:const NeverScrollableScrollPhysics(),
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: const EdgeInsets.only(left: 20, right: 20,),
//                         child: Column(
//                           children: [
//                              Container(
//                                child: Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                  children: [
//                                    Row(
//                                      children: [
//                                        Container(
//                                          child: Text("Invested",style: TextStyle(fontSize: 13,color: Colors.grey.shade600),),
//                                        ),
//                                        Container(
//                                          margin:const EdgeInsets.only(top: 2),
//                                          child:const Text(" ₹5000",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
//                                        ),
//                                      ],
//                                    ),
//
//                                    Row(
//                                      children: [
//                                        Container(
//                                          child: Text("Weightage",style: TextStyle(fontSize: 13,color: Colors.grey.shade600),),
//                                        ),
//                                        Container(
//                                          margin:const EdgeInsets.only(top: 2),
//                                          child:const Text("  20%",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.green),),
//                                        ),
//                                      ],
//                                    ),
//
//                                  ],
//                                ),
//                              ),
//
//                              Container(
//                               margin:const EdgeInsets.only(top: 5),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     child:const Text("TATA STEEL",style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),),
//                                   ),
//
//                                   Row(
//                                     children: [
//                                       Container(
//                                         child:const Text("P & L",style: TextStyle(fontSize: 13),),
//                                       ),
//                                       Container(
//                                         margin:const EdgeInsets.only(top: 2),
//                                         child:const Text(" +32",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.green),),
//                                       )
//                                     ],
//                                   ),
//
//                                 ],
//                               ),
//                             ),
//
//                              Container(
//                               margin:const EdgeInsets.only(top: 5),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         child: Text("Qty.",style: TextStyle(fontSize: 13,color: Colors.grey.shade600),),
//                                       ),
//                                       Container(
//                                         margin:const EdgeInsets.only(top: 2),
//                                         child:const Text("  5",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
//                                       )
//                                     ],
//                                   ),
//
//                                   Row(
//                                     children: [
//                                       Container(
//                                         child:const Text("CMP",style: TextStyle(fontSize: 13,color: Colors.black),),
//                                       ),
//                                       Container(
//                                         child:const Text(" +750",style: TextStyle(fontSize: 13,color: Colors.green),),
//                                       ),
//                                       Container(
//                                         margin:const EdgeInsets.only(top: 2),
//                                         child:const Text(" (+10.00%)",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.green),),
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//
//                              Container(
//                                child: Divider(color: Colors.grey.shade400,),
//                              )
//
//                             ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             )),
//       ),
//
//     );
//   }
// }
