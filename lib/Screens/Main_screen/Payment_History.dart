import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';

class Payment_History extends StatefulWidget {
  const Payment_History({Key? key}) : super(key: key);

  @override
  State<Payment_History> createState() => _Payment_HistoryState();
}

class _Payment_HistoryState extends State<Payment_History> {


  var MySubscription=[];
  bool? Status;
  String loader="false";
  List<String> time=[];
  List<String> time1=[];
  List Plan_end=[];
  List Plan_start=[];

  mySubscription_Api() async {

    var data = await API.Mysubscription_Api();
    setState(() {
      MySubscription = data['data'];
      Status = data['status'];
    });

    print("Dataaaaaa: $MySubscription");

    if(Status==true){
      setState(() {});

      for(int i=0; i<MySubscription.length; i++){
        time.add(MySubscription[i]['plan_end']);
        Plan_end = time.map((dateTimeString) {
          DateTime dateTime = DateTime.parse(dateTimeString);
          return DateFormat('dd MMM, yyyy').format(dateTime);
        }).toList();
      }

      for(int i=0; i<MySubscription.length; i++){
        time1.add(MySubscription[i]['plan_start']);
        Plan_start = time1.map((dateTimeString1) {
          DateTime dateTime1 = DateTime.parse(dateTimeString1);
          return DateFormat('dd MMM, yyyy').format(dateTime1);
        }).toList();
      }

      MySubscription.length>0?
      loader="true":
      loader="No_data";
    }

    else{
      print("error");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySubscription_Api();
  }


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
            child:const Icon(Icons.arrow_back,color: Colors.black,)),
        title:const Text("Payment History",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),

      body: loader=="true"?
      Container(
        margin:const EdgeInsets.only(top: 22),
        child: ListView.builder(
          itemCount: MySubscription.length,
          itemBuilder: (BuildContext context, int index) {
             return Container(
               child: Card(
                 margin:const EdgeInsets.only(left: 15,right: 15,bottom: 20),
                 child: Theme(
                   data: Theme.of(context).copyWith(
                     dividerColor: Colors.transparent, // Removes the underline
                   ),
                   child: Theme(
                     data: Theme.of(context).copyWith(
                       dividerColor: Colors.transparent, // Removes the underline
                     ),
                     child: ExpansionTile(
                       collapsedShape:const RoundedRectangleBorder(
                         side: BorderSide.none,
                       ),
                       shape:const RoundedRectangleBorder(
                         side: BorderSide.none,
                       ),
                       title: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Container(
                                   width: MediaQuery.of(context).size.width/1.4,
                                   margin:const EdgeInsets.only(top: 5),
                                   child: Text("${MySubscription[index]['categoryDetails']['title']} (${MySubscription[index]['serviceNames'].join(' + ')})",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                 ),

                                 Container(
                                   width: MediaQuery.of(context).size.width/1.4,
                                   child: Row(
                                     children: [
                                       Container(
                                           height: 25,
                                           width: MediaQuery.of(context).size.width/1.8,
                                           margin:const EdgeInsets.only(top: 7),
                                           child: Text("${Plan_start[index]}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
                                       ),
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
                           margin:const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 15),
                           height: 230,
                           width: MediaQuery.of(context).size.width,
                           child:  Card(
                             margin:const EdgeInsets.only(left: 10,right: 10),
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
                                 children: [
                                   Container(
                                       height: 35,
                                       width: double.infinity,
                                       color: ColorValues.Splash_bg_color1,
                                       child:Container(
                                           alignment: Alignment.centerLeft,
                                           margin:const EdgeInsets.only(left: 15,bottom: 3),
                                           child: Text("${MySubscription[index]['categoryDetails']['title']} (${MySubscription[index]['serviceNames'].join(' + ')})",style:const TextStyle(fontWeight: FontWeight.w600,color: Colors.white),))
                                   ),

                                   Container(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Container(
                                           margin:const EdgeInsets.only(top: 15,left: 15),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Container(
                                                 child: Text("Paid Amount",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                               ),

                                               Container(
                                                 margin:const EdgeInsets.only(top: 5),
                                                 child: Text("₹${MySubscription[index]['total']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                               ),

                                             ],
                                           ),
                                         ),

                                         Container(
                                           margin:const EdgeInsets.only(top: 15,right: 15),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Container(
                                                 child: Text("Plan Discount",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                               ),
                                               Container(
                                                 margin:const EdgeInsets.only(top: 5),
                                                 child: Text("₹${MySubscription[index]['discount']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                               ),
                                             ],
                                           ),
                                         ),

                                       ],
                                     ),
                                   ),

                                   Container(
                                     margin:const EdgeInsets.only(left: 10,top: 5,right: 10),
                                     child: Divider(color: Colors.grey.shade600,),
                                   ),

                                   Container(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Container(
                                           margin:const EdgeInsets.only(left: 15),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Container(
                                                 child: Text("Purchase Type",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                               ),

                                               MySubscription[index]['orderid']==""||MySubscription[index]['orderid']==null?
                                               Container(
                                                 margin:const EdgeInsets.only(top: 5),
                                                 child:const Text("Assigned by Admin",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                               ):
                                               Container(
                                                 margin:const EdgeInsets.only(top: 5),
                                                 child:const Text("Online",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                               )

                                             ],
                                           ),
                                         ),

                                         Container(
                                           margin:const EdgeInsets.only(right: 15),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Container(
                                                 child: Text("Plan Validity",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                               ),

                                               Container(
                                                 margin:const EdgeInsets.only(top: 5),
                                                 child: Text("${MySubscription[index]['planDetails']['validity']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                               ),

                                             ],
                                           ),
                                         ),

                                       ],
                                     ),
                                   ),

                                   Container(
                                     margin:const EdgeInsets.only(left: 10,top: 5,right: 10),
                                     child: Divider(color: Colors.grey.shade600,),
                                   ),

                                   Container(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Container(
                                           margin:const EdgeInsets.only(left: 15),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Container(
                                                 child: Text("Order Id",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                               ),
                                               Container(
                                                 margin:const EdgeInsets.only(top: 5),
                                                 child: MySubscription[index]['orderid']==null?
                                                 Text("NA",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),):
                                                 Text("${MySubscription[index]['orderid']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                               ),
                                             ],
                                           ),
                                         ),

                                         MySubscription[index]['coupon']==null||MySubscription[index]['coupon']==""?
                                         const SizedBox():
                                         Container(
                                           margin:const EdgeInsets.only(right: 15),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Container(
                                                 child: Text("Used Coupon",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                               ),
                                               Container(
                                                 margin:const EdgeInsets.only(top: 5),
                                                 child:Text("${MySubscription[index]['coupon']==null? "": MySubscription[index]['coupon']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                               ),
                                             ],
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),

                                 ],
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
        ),
      )
          :
      loader=="false"?

      Container(
         child:const Center(
           child: CircularProgressIndicator(color: Colors.black,),
         )
       ) :

      Container(
         child:const Center(
           child: Text("No Record Found"),
         ),
      ),

    );
  }
}
