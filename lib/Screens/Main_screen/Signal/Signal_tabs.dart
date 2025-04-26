import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Global_widgets/Logout.dart';
import 'package:stock_box/Screens/Main_screen/Signal/Signal_view.dart';
import 'package:stock_box/Screens/Onboarding_screen/Splash_screen.dart';

class Signal extends StatefulWidget {
  const Signal({Key? key}) : super(key: key);

  @override
  State<Signal> createState() => _SignalState();
}

class _SignalState extends State<Signal> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Widget> _tabs = [];
  List<Widget> _tabViews = [];
  bool loder = false;
  String? Samiti;
  funnction() async {
    var response = await http.get(Uri.parse(Util.SignalTabs_Api),);
    print(response.body);
    var jsonString = jsonDecode(response.body);
    print("Jsonnnnn: $jsonString");

    for (int i = 0; i < jsonString['data'].length; i++) {
      _tabs.add(Tab(text: jsonString['data'][i]['title'],));

       Samiti = jsonString['data'][i]['_id'];
      print("Samiti: $Samiti");

      _tabViews.add(SignalNew(Samiti: Samiti));
    }

    // Initialize the TabController after creating all tabs
    _tabController = TabController(length: _tabs.length, vsync: this);


    setState(() {
      loder = true;
    });
  }

  // var Signal_data=[];
  // String? loader="false";
  //
  // List open_signal=[];
  // List close_signal=[];
  //
  // Signal_Api() async {
  //
  //   var data = await API.Signal_Api(Samiti);
  //   setState(() {
  //     Signal_data = data['data'];
  //     print("Signal dataaa: $Signal_data");
  //   });
  //
  //   for(int i=0; i<Signal_data.length; i++){
  //
  //     Signal_data[i]['close_status']==true?
  //     close_signal.add(Signal_data[i]):
  //     open_signal.add(Signal_data[i]);
  //
  //     print("Lengthhhhhh23456: ${open_signal.length}");
  //
  //   }
  //
  // }

    String? Delete_status;
    String? Active_status;
    getAccountStatus() async {
      SharedPreferences prefs= await SharedPreferences.getInstance();
      Delete_status= prefs.getString("Delete_status");
      Active_status= prefs.getString("Active_status");

      Delete_status=="1"||Active_status=="0"?
      handleLogout(context):
      print("Account not deleted");
    }

  bool? Status_token;
  checkToken_Api() async {
    var data = await API.checkToken();
    setState(() {
      Status_token = data['status'];

      print("Status_tokennnnnnnn: $Status_token");
    });

    if(Status_token==true){

    }
    else{
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login_status', 'false');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAccountStatus();
    funnction();
    checkToken_Api();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 20,
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Signals",
          style: TextStyle(
              fontSize: 19, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        // actions: <Widget>[
        //   GestureDetector(
        //     onTap: () {
        //       Closed_signals();
        //     },
        //     child: Container(
        //       margin: const EdgeInsets.only(right: 15, top: 14, bottom: 14),
        //       width: 100,
        //       alignment: Alignment.center,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(15),
        //         border: Border.all(color: ColorValues.Splash_bg_color2),
        //       ),
        //       child: const Text(
        //         "Closed Signal",
        //         style: TextStyle(
        //             fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        physics:const NeverScrollableScrollPhysics(),
          child: loder == true
              ? Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 5, bottom: 25),
                child: Column(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        top: 0, left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      indicatorWeight: 0.0,
                      // isScrollable: true,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [ColorValues.Splash_bg_color3, ColorValues.Splash_bg_color1],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tabs: _tabs,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: _tabViews,
                    ),
                  ),
                ],
              ),
              ),
            ],
          )
              : Container(
            height: MediaQuery.of(context).size.height-150,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorValues.Splash_bg_color1,
              ),
            ),
          )
      ),
    );
  }

  bool view=false;

 /* Closed_signals(){
    return showModalBottomSheet(
      isScrollControlled:true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin:const EdgeInsets.only(top: 40,left: 15),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              child:const Icon(Icons.clear),
                            ),
                          ),
                          Container(
                            margin:const EdgeInsets.only(left: 10),
                            child:const Text("Closed Signals",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                          )
                        ],
                      ),
                    ),

                    Container(
                        height: MediaQuery.of(context).size.height-70,
                        margin: const EdgeInsets.only(top: 5),
                        child: ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              // height: 130,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400, width: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade50),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, left: 8),
                                        child: Text(
                                          "Closed :",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, right: 8),
                                        child: const Text(
                                          "Mar-18, 6:10 PM",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, left: 8),
                                        child: Text(
                                          "Opened :",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, right: 8),
                                        child: const Text(
                                          "Jan-18, 6:10 PM",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(top: 8, left: 8),
                                            height: 22,
                                            width: 55,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: Colors.green,
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "LONG !!",
                                              style:
                                              TextStyle(fontSize: 11, color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 8, left: 10),
                                            child: const Text(
                                              "HARDUSDT",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(top: 8, right: 8),
                                        height: 22,
                                        width: 75,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7),
                                            color: Colors.green),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Target 1",
                                          style: TextStyle(fontSize: 11, color: Colors.white),
                                        ),
                                      ),

                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, left: 8),
                                        child: Text(
                                          "Entry price :",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, right: 8),
                                        child: const Text(
                                          "0.14",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, left: 8),
                                        child: Text(
                                          "Stop loss 40% :",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, right: 8),
                                        child: const Text(
                                          "0.1",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),

                                  GestureDetector(
                                    // onTap: (){
                                    //   view=true;
                                    //   print(view);
                                    // },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                      height: 25,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.grey.shade200),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(left: 8),
                                            child: Text(
                                              "View Targets :",
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.grey.shade700),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(right: 8,bottom: 3),
                                            child:const Icon(Icons.arrow_drop_down,size: 25,color: Colors.grey,)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // view==true ?
                                  //     Container(
                                  //       height: 40,
                                  //       width: double.infinity,
                                  //       margin: EdgeInsets.only(left: 10,right: 10),
                                  //       color: Colors.red,
                                  //     ):
                                  //     SizedBox(height: 0,),

                                  Container(
                                    margin:const EdgeInsets.only(top: 5, bottom: 8,left: 10,right: 10),
                                    child: Text("Comment: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                    style: TextStyle(fontSize: 11,color: Colors.grey.shade600),
                                    )
                                  ),

                                ],
                              ),
                            );
                          },
                        )),
                  ],
                ),
              );
            }
        );
      },
    );
  }*/
}
