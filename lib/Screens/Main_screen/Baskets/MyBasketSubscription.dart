import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';

class MyBasketSubscription extends StatefulWidget {
  const MyBasketSubscription({Key? key}) : super(key: key);

  @override
  State<MyBasketSubscription> createState() => _MyBasketSubscriptionState();
}

class _MyBasketSubscriptionState extends State<MyBasketSubscription> {

  int? _expandedIndex=0;

  var MyBasketSubscription=[];
  bool? Status;
  String loader="false";
  List<String> time=[];
  List<String> time1=[];
  List entryTime=[];
  List Plan_start=[];

  myBasketSubscription_Api() async {

    var data = await API.MyBasketsubscription_Api();
    setState(() {
      MyBasketSubscription = data['data'];
      Status = data['status'];
    });

    print("Dataaaaaa: $MyBasketSubscription");

    if(Status==true){
      setState(() {});

      for(int i=0; i<MyBasketSubscription.length; i++){
        time.add(MyBasketSubscription[i]['enddate']);
        entryTime = time.map((dateTimeString) {
          DateTime dateTime = DateTime.parse(dateTimeString);
          return DateFormat('dd MMM, yyyy').format(dateTime);
        }).toList();
      }

      for(int i=0; i<MyBasketSubscription.length; i++){
        time1.add(MyBasketSubscription[i]['startdate']);
        Plan_start = time1.map((dateTimeString1) {
          DateTime dateTime1 = DateTime.parse(dateTimeString1);
          return DateFormat('dd MMM, yyyy').format(dateTime1);
        }).toList();
      }

      MyBasketSubscription.length>0?
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
    myBasketSubscription_Api();
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
        title:const Text("My Basket Subscription",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body: loader=="true"?
      Container(
        // margin:const EdgeInsets.only(bottom: 5),
        child: ListView.builder(
          key: Key('builder ${_expandedIndex.toString()}'),
          shrinkWrap: true,
          // physics:const NeverScrollableScrollPhysics(),
          itemCount: MyBasketSubscription.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin:const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 5),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  initiallyExpanded: index==_expandedIndex,
                  onExpansionChanged: (bool expanded) {
                    setState(() {
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
                            /*Container(
                                        width: MediaQuery.of(context).size.width/1.5,
                                        margin:const EdgeInsets.only(top: 5),
                                        child: Text("${MySubscription[index]['planDetails']['title']} (${MySubscription[index]['serviceNames'].join(' + ')})",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                      ),*/
                            Container(
                                width: MediaQuery.of(context).size.width-110,
                                margin:const EdgeInsets.only(top: 5),
                                child:Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "${MyBasketSubscription[index]['basketDetails']['title']}",
                                        style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                    ),
                                    // Spacer(),
                                    // Container(
                                    //   padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(5),
                                    //       color: MySubscription[index]['planDetails']['status'].toUpperCase() =="ACTIVE"?
                                    //       Colors.green:Colors.red
                                    //
                                    //   ),
                                    //   child: Text(
                                    //     "${MySubscription[index]['planDetails']['status'].toUpperCase()}",
                                    //     style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,
                                    //         color: Colors.white
                                    //     ),),
                                    // ),
                                  ],
                                )),

                            Container(
                              width: MediaQuery.of(context).size.width-110,
                              child: Row(
                                children: [
                                  Container(
                                      height: 25,
                                      width: 190,
                                      margin:const EdgeInsets.only(top: 7),
                                      child: Text("Expires on : ${entryTime[index]}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
                                  ),
                                  Spacer(),
                                  Container(
                                    padding:const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.green

                                    ),
                                    child:const Text(
                                      "ACTIVE",
                                      style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,
                                          color: Colors.white
                                      ),),
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
                      margin:const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 15),
                      // height: 172,
                      width: MediaQuery.of(context).size.width,
                      child:  Card(
                        margin:const EdgeInsets.only(left: 10,right: 10),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: ColorValues.Splash_bg_color1,
                              width:0.4,
                            ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                  height: 42,
                                  width: double.infinity,
                                  color:const Color(0xffE4EfE9),
                                  child:Container(
                                      alignment: Alignment.centerLeft,
                                      margin:const EdgeInsets.only(left: 15,bottom: 3),
                                      child: Text("${MyBasketSubscription[index]['basketDetails']['title']}",style: TextStyle(fontWeight: FontWeight.w600),))
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
                                            child: Text("Plan Duration",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                          ),

                                          Container(
                                            margin:const EdgeInsets.only(top: 5),
                                            child: Text("${MyBasketSubscription[index]['validity']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
                                            child: Text("Purchased on",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                          ),

                                          Container(
                                            margin:const EdgeInsets.only(top: 5),
                                            child: Text("${Plan_start[index]}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                          )
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
                                            child: Text("Purchase Price",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                          ),
                                          Container(
                                            margin:const EdgeInsets.only(top: 5),
                                            child:Row(
                                              children: [
                                                Text("₹${MyBasketSubscription[index]['total']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                                Text(" ${MyBasketSubscription[index]['gstamount'] == 0||MyBasketSubscription[index]['gstamount'] == ""||MyBasketSubscription[index]['gstamount'] == null?"" :"(Tax Included)"}",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                              ],
                                            ),

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
                                            child: Text("Expires On",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                          ),

                                          Container(
                                            margin:const EdgeInsets.only(top: 4),
                                            child: Text("${entryTime[index]}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
                                margin:const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin:const EdgeInsets.only(left: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text("Plan Price",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                          ),
                                          Container(
                                            margin:const EdgeInsets.only(top: 5),
                                            child: Text("₹${MyBasketSubscription[index]['plan_price']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
                                            child: Text("Discount Price",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                          ),

                                          Container(
                                            margin:const EdgeInsets.only(top: 4),
                                            child:const Text("0",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
            );
          },
        ),
      ):
      loader=="false"?
      Container(
        child: Center(child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),),
      ):
      Container(
        child:const Center(child: Text("No Data Found")),
      )
    );
  }
}
