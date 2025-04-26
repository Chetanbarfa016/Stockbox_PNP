import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Dashboard.dart';
import 'package:stock_box/Screens/Main_screen/Service_plan.dart';
import 'package:url_launcher/url_launcher.dart';

class My_subscription extends StatefulWidget {
  bool go_home;

   My_subscription({Key? key, required this.go_home}) : super(key: key);

  @override
  State<My_subscription> createState() => _My_subscriptionState(go_home:go_home);
}

class _My_subscriptionState extends State<My_subscription> {
  bool go_home;
  _My_subscriptionState({
    required this.go_home
});

  var MySubscription=[];
  bool? Status;
  String loader="false";
  List<String> time=[];
  List<String> time1=[];
  List entryTime=[];
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
        entryTime = time.map((dateTimeString) {
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

  int? _expandedIndex=0;

  bool? Status_freetrial;
  var MyFreeTrial=[];
  String loader_freetrial="false";

  List<String> time_planend=[];
  List<String> time1_planstart=[];
  List planEndDate=[];
  List PlanStartDate=[];
  int? daysDifference;
  MyFreeTrial_Api() async {
    var data = await API.MyFreeTrial();
    setState(() {
      Status_freetrial = data['status'];
    });

    if(Status_freetrial==true){
      setState(() {});
      MyFreeTrial = data['data'];

      for(int i=0; i<MyFreeTrial.length; i++){
        time_planend.add(MyFreeTrial[i]['enddate']);
        planEndDate = time_planend.map((dateTimeString) {
          DateTime dateTime = DateTime.parse(dateTimeString);
          return DateFormat('dd MMM, yyyy').format(dateTime);
        }).toList();
      }

      for(int i=0; i<MyFreeTrial.length; i++){
        time1_planstart.add(MyFreeTrial[i]['startdate']);
        PlanStartDate = time1_planstart.map((dateTimeString1) {
          DateTime dateTime1 = DateTime.parse(dateTimeString1);
          return DateFormat('dd MMM, yyyy').format(dateTime1);
        }).toList();
      }

      DateTime startDate = DateTime.parse(MyFreeTrial[0]['startdate']);
      DateTime endDate = DateTime.parse(MyFreeTrial[0]['enddate']);

      Duration difference = endDate.difference(startDate);
      daysDifference = difference.inDays;
      print('Difference in days: $daysDifference');

      print("PlanStartDate: $PlanStartDate");
      print("PlanEndDate: $planEndDate");

      MyFreeTrial.length>0?
      loader_freetrial="true":
      loader_freetrial="No_data";
    }

    else{
      print("error");
    }

  }


  bool? Status_expiry;
  String? Message_expiry;
  var ServiceExpiryData=[];
  List<String> time_expiry=[];
  List entryTime_expiry=[];

  Service_Expiry_Api() async {
    var data = await API.Service_Expiry_Apii();
    setState(() {
      Status_expiry = data['status'];
      Message_expiry = data['message'];
    });

    if(Status_expiry==true){
      setState(() {});

      ServiceExpiryData=data['data'];

      for(int i=0; i<ServiceExpiryData.length; i++){
        time_expiry.add(ServiceExpiryData[i]['enddate']);
        entryTime_expiry = time_expiry.map((dateTimeString1) {
          DateTime dateTime1 = DateTime.parse(dateTimeString1);
          return DateFormat('d MMM, yyyy').format(dateTime1);
        }).toList();
      }

    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_expiry',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Service_Expiry_Api();
    mySubscription_Api();
    MyFreeTrial_Api();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        go_home == true ?
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:'false'))):
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
          toolbarHeight: 60,
          titleSpacing: 0,
          backgroundColor: Colors.grey.shade200,
          elevation: 0.5,
          leading: GestureDetector(
            onTap: (){
              go_home==true?
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard())):
              Navigator.pop(context);
            },
              child:const Icon(Icons.arrow_back,color: Colors.black,)
          ),
          title:const Text("My subscriptions",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
        ),
          body: SingleChildScrollView(
          child: Container(
           child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin:const EdgeInsets.only(top: 25),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Icon(Icons.star,color: ColorValues.Splash_bg_color2,size: 20,),
                      ),
                      Container(
                        padding:const EdgeInsets.only(left: 7,right: 7),
                          child: Text("MY SUBSCRIPTIONS",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,letterSpacing: 2.4,color: ColorValues.Splash_bg_color1),)
                      ),

                      Container(
                        child: Icon(Icons.star,color: ColorValues.Splash_bg_color2,size: 20,),
                      ),
                    ],
                  )
                ),

                ServiceExpiryData.length > 0 ?
                Container(
                  width: double.infinity,
                  margin:const EdgeInsets.only(top: 20,left: 15,right: 15),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          columnSpacing: MediaQuery.of(context).size.width/3.25,
                          headingRowHeight: 50,
                          headingRowColor: MaterialStateColor.resolveWith(
                                (Set<MaterialState> states) {
                              if (states
                                  .contains(MaterialState.hovered)) {
                                return ColorValues.Splash_bg_color1.withOpacity(
                                    0.5); // Color when hovered
                              }

                              return ColorValues
                                  .Splash_bg_color1; // Default color
                            },
                          ),
                          columns: <DataColumn> [
                            DataColumn(
                              label: Text('Service Name',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ),
                            DataColumn(
                              label: Text('Expiry Date',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ),

                          ],

                          rows: List<DataRow>.generate(
                              ServiceExpiryData.length, (index) {

                            return DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (Set<MaterialState> states) {
                                      return Colors.white; // Default color
                                    }),
                                cells: <DataCell>[
                                  DataCell(
                                      Container(
                                          child: Text(
                                            '${ServiceExpiryData[index]['serviceName']}',
                                            style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),
                                  ))),


                                  DataCell(Container(
                                    alignment: Alignment.centerRight,
                                      child:Text("${entryTime_expiry[index]}",style:const TextStyle(fontSize: 13),)
                                  )),
                                ]
                            );

                          }))),
                )
                    :

                const SizedBox(height: 0,),


                loader_freetrial=="true"?
                Card(
                  margin:const EdgeInsets.only(left: 15,right: 15,top: 20),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent, // Removes the underline
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent, // Removes the underline
                      ),
                      child: ExpansionTile(
                        initiallyExpanded:true,
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
                                    margin:const EdgeInsets.only(top: 5),
                                    child:const Text("Free",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                  ),

                              Container(
                                width: MediaQuery.of(context).size.width/1.4,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 25,
                                      width: MediaQuery.of(context).size.width/1.8,
                                      margin:const EdgeInsets.only(top: 7),
                                      child: Text("Expires on : ${planEndDate[0]}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
                                       ),

                                    Spacer(),
                                    Container(
                                      alignment: Alignment.center,
                                      margin:const EdgeInsets.only(top: 5,),
                                      padding:const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: MyFreeTrial[0]['status'].toUpperCase() =="ACTIVE"?
                                          Colors.green:Colors.red

                                      ),
                                      child: Text(
                                        "${MyFreeTrial[0]['status'].toUpperCase()}",
                                        style:const TextStyle(fontSize: 10,fontWeight: FontWeight.w700,
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
                            height: 172,
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
                                            child:const Text("Free Trial",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),))
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
                                                  child: Text("$daysDifference Days",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                                )
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
                                                  child: Text("${PlanStartDate[0]}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
                                                  child:const Text("Free",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
                                                  child: Text("Expiry Date",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                                ),

                                                Container(
                                                  margin:const EdgeInsets.only(top: 5),
                                                  child: Text("${planEndDate[0]}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
                ):
                const SizedBox(height: 0,),

                loader == "true" ?
                Container(
                  margin:const EdgeInsets.only(bottom: 15),
                  child: ListView.builder(
                    key: Key('builder ${_expandedIndex.toString()}'),
                    shrinkWrap: true,
                    physics:const NeverScrollableScrollPhysics(),
                    itemCount: MySubscription.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime planEndDate = DateTime.parse(MySubscription[index]['plan_end']!);
                      DateTime today = DateTime.now();

                      bool isExpired = planEndDate.isBefore(today);
                      print("isExpiredisExpired: $isExpired");


                      return Card(
                        margin:const EdgeInsets.only(left: 15,right: 15,top: 20),
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
                                              "${MySubscription[index]['categoryDetails']['title']} (${MySubscription[index]['serviceNames'].join(' + ')})",
                                              style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                          ),
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
                                                  color:isExpired?
                                                  Colors.red:Colors.green

                                              ),
                                              child: isExpired?
                                              const Text(
                                                "EXPIRED",
                                                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,
                                                    color: Colors.white
                                                ),):
                                             const Text(
                                                "ACTIVE",
                                                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,
                                                    color: Colors.white
                                                ),)
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
                                      )
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Container(
                                    child: Column(
                                      children: [
                                            Container(
                                              color:ColorValues.Splash_bg_color1,
                                              // color:const Color(0xffE4EfE9),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 42,
                                                    width: MediaQuery.of(context).size.width/1.7,
                                                    child:Container(
                                                      alignment: Alignment.centerLeft,
                                                      margin:const EdgeInsets.only(left: 15,bottom: 3),
                                                        child: Text("${MySubscription[index]['planDetails']['title']} (${MySubscription[index]['serviceNames'].join(' + ')})",style:const TextStyle(fontWeight: FontWeight.w600,color: Colors.white),))
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      String? descriptionText=MySubscription[index]['planDetails']['description'];
                                                      print("Descccc: $descriptionText");
                                                      Description_popup(descriptionText);
                                                    },
                                                    child: Container(
                                                      height: 20,
                                                      width: 50,
                                                      padding: const EdgeInsets.only(left: 4, right: 4),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          color:Colors.white,
                                                          border: Border.all(color: ColorValues.Splash_bg_color2,width: 0.4)
                                                      ),
                                                      child:const Text(
                                                        'View',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                                      child: Text("${MySubscription[index]['planDetails']['validity']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
                                                      child: Row(
                                                        children: [
                                                          Text("₹${MySubscription[index]['total']}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                                          Text(" ${MySubscription[index]['gstamount'] == 0||MySubscription[index]['gstamount'] == ""||MySubscription[index]['gstamount'] == null?"" :"(Tax Included)"}",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
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
                                                      child: Text("₹${MySubscription[index]['plan_price']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
                                                      child: Text("₹${MySubscription[index]['discount']}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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

                loader == "false"?
                Container(
                  child: Center(child: CircularProgressIndicator(
                    color: ColorValues.Splash_bg_color1,
                  ),
                  ),
                ):

                Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height/6,
                        ),
                        Container(
                            child: const Text("You Have No Active Plans...",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscribe()));
                          },
                          child: Container(
                            margin:const EdgeInsets.only(top: 20),
                            height: 35,
                            width: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorValues.Splash_bg_color1
                            ),
                            alignment: Alignment.center,
                            child:const Text("Subscribe Now",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )

      ),
    );
  }

  Description_popup(descriptionText) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
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
            return Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              height: MediaQuery.of(context).size.height/2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fixed Header
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Divider(color: Colors.grey.shade600)),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Html(
                        data: descriptionText,
                        style: {
                          "p": Style(fontSize: FontSize.medium),
                          "h1": Style(fontSize: FontSize.large, fontWeight: FontWeight.bold),
                        },
                        onLinkTap: (url, _, __) {
                          if (url != null) {
                            _launchURL(url);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
