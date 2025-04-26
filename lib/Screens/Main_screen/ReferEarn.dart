import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Global_widgets/dynamic_link_handler.dart';

class Referral extends StatefulWidget {
  const Referral({Key? key}) : super(key: key);

  @override
  State<Referral> createState() => _ReferralState();
}

class _ReferralState extends State<Referral> with TickerProviderStateMixin {

  late final TabController _tabController;

  // void _shareContent() {
  //   Share.share('https://www.stockbox.com/user/referral-earn/Tg346781fFF');
  // }

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    Fluttertoast.showToast(
        backgroundColor: Colors.black,
        msg: "Copied to clipboard!",
        textColor: Colors.white
    );
  }

  String? Referral_token;
  GetReferralLink() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    Referral_token=prefs.getString("Refer_token");
    print("343434: $Referral_token");
    setState(() {});
  }

  bool? Status1;
  String? Message1;
  var ReferEarnData=[];
  List<String> time=[];
  List entryTime=[];

  ReferEarn_Api() async {
    var data = await API.ReferandEarn_Api();
    setState(() {
      Status1 = data['status'];
      Message1 = data['message'];
    });

    if(Status1==true){
      setState(() {});

      ReferEarnData=data['data'];
      for(int i=0; i<ReferEarnData.length; i++){
        time.add(ReferEarnData[i]['created_at']);
        entryTime = time.map((dateTimeString) {
          DateTime dateTime = DateTime.parse(dateTimeString);
          return DateFormat('d MMM, yyyy').format(dateTime);
        }).toList();
      }
      print("DDDDD: $ReferEarnData");
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message1',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }

  }


  bool? Status_setting;
  var setting_data=[];
  String? loader_setting="false";
  String? FreetrialDays;
  String? SenderEarn='';
  String? ReceiverEarn='';
  String? Refer_title='';
  String? Refer_description='';
  String? Wallet_amount='';
  String? Refer_image='';
  String? Refer_desc='';
  String? title='';

  BasicSetting_Apii() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    Wallet_amount=prefs.getString("Wallet_amount");
    var data = await API.BesicSetting_Api();
    print("Data: $data");
    setState(() {
      Status_setting = data['status'];
      Refer_image=data["data"]['refer_image'];
      Refer_desc=data["data"]['refersendmsg'];
      title=data["data"]['website_title'];
      print("090909: $Refer_image");
    });

    if(Status_setting==true){
      setState(() {});
      // setting_data=data['data'];
      // print("DDDDD: $Status_setting");
      FreetrialDays=data['data']['freetrial'].toString();
      SenderEarn=data['data']['sender_earn'].toString();
      ReceiverEarn=data['data']['receiver_earn'].toString();
      Refer_title=data['data']['refer_title'].toString();
      Refer_description=data['data']['refer_description'].toString();

      data['data'].length>0?
      loader_setting="true":
      loader_setting="No_data";
    }else{

    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    GetReferralLink();
    ReferEarn_Api();
    BasicSetting_Apii();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loader_setting=="true"?
        SingleChildScrollView(
          physics:const NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    // height: MediaQuery.of(context).size.height/1.83,
                    height:340,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops:const [
                          0.1,
                          0.5,
                        ],
                        colors: [
                          ColorValues.Splash_bg_color1,
                          ColorValues.Splash_bg_color1,
                        ],
                      ),
                    ),

                    child: Column(
                      children: [
                        const SizedBox(height: 35,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin:const EdgeInsets.only(left: 20,top: 12),
                                child:const Icon(Icons.arrow_back_ios,color: Colors.white,),
                              ),
                            ),
                            Container(
                              margin:const EdgeInsets.only(left: 10,top: 12),
                              child:const Text("Refer & Earn",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                            ),
                          ],
                        ),
                        Container(
                          margin:const EdgeInsets.only(top: 10),
                          child: Text("₹$Wallet_amount",style:const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w700),),
                        ),

                        Container(
                          child:const Text("Total Rewards",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w400),),
                        ),

                        Container(
                          margin:const EdgeInsets.only(top: 10,bottom: 7),
                          height: 160,
                          child: Image.asset("images/referimagee.png"),
                        ),

                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: 5,
                  right: 5,
                  top: 309,
                  bottom: 5,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      width:MediaQuery.of(context).size.width,
                      color: Colors.white,

                      child: Column(
                        children: [
                          Container(
                            margin:const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin:const EdgeInsets.only(left: 10),
                                  height: 40,
                                  width: 40,
                                  child:Image.asset("images/handshake.png"),
                                ),
                                Container(
                                  margin:const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Invite Your Friends",style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.w600),),
                                      ),
                                      Container(
                                        child:const Text("Share your link with your friends to register",style: TextStyle(fontSize: 10,color: Colors.black),),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin:const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin:const EdgeInsets.only(left: 10),
                                  height: 40,
                                  width: 40,
                                  child:Image.asset("images/reward.png"),
                                ),

                                Container(
                                  margin:const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Get Rewards",style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.w600),),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width/1.4,
                                        child: Text("$Refer_description",style:const TextStyle(fontSize: 10,color: Colors.black),),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            margin:const EdgeInsets.only(top: 25,left: 15,right: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              // padding: EdgeInsets.only(left: 25,right: 25),
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.white,
                              labelStyle:const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              indicatorWeight: 3.0,
                              isScrollable: false,
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: const[
                                      0.1,
                                      0.7,
                                    ],
                                    colors: [
                                      ColorValues.Splash_bg_color1,
                                      ColorValues.Splash_bg_color4,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),

                              tabs:const  <Widget>[
                                Tab(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text('Share your referral link'),
                                    ),
                                  ),
                                ),

                                Tab(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text('Rewards'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children:  <Widget> [
                                Container(
                                  child: SingleChildScrollView(
                                    // physics: NeverScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:const EdgeInsets.only(left: 15,right: 15,top: 20),
                                          child: Text("Refer a friend to $title App and Earn up to $SenderEarn% on their first-time subscription on services fee in your wallet ! Plus, your friend will also earn up to $ReceiverEarn% in $title App wallet.",textAlign: TextAlign.center,style:const TextStyle(fontSize: 12),),
                                        ),

                                        Container(
                                          margin:const EdgeInsets.only(left: 20,top: 15),
                                          child: Row(
                                            children: [
                                              Container(
                                                 height: 40,
                                                padding:const EdgeInsets.all(3),
                                                width: MediaQuery.of(context).size.width/1.55,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4)
                                                ),
                                                alignment: Alignment.center,
                                                child: Text("$Referral_token",style: TextStyle(fontSize: 16,color: ColorValues.Splash_bg_color1),),
                                              ),

                                              GestureDetector(
                                                onTap: () => copyToClipboard(context, "$Referral_token"),
                                                child: Container(
                                                  height: 40,
                                                  width: 50,
                                                  margin:const EdgeInsets.only(left: 20),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                      stops:const [
                                                        0.1,
                                                        0.5,
                                                      ],
                                                      colors: [
                                                        ColorValues.Splash_bg_color1,
                                                        ColorValues.Splash_bg_color1,
                                                      ],
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child:const Icon(Icons.copy,color: Colors.white,),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        Container(
                                            margin:const EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 30),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    // _shareContent();
                                                    DynamicLinkHandler.instance.shareProductLink("$Referral_token","$Refer_image","$Refer_desc");
                                                  },
                                                  child: Container(
                                                    height: 35,
                                                    width: 130,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight,
                                                        stops:const [
                                                          0.1,
                                                          0.7,
                                                        ],
                                                        colors: [
                                                          ColorValues.Splash_bg_color1,
                                                          ColorValues.Splash_bg_color3,
                                                        ],
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          child:const Icon(Icons.share,color: Colors.white,),
                                                        ),
                                                        Container(
                                                            margin:const EdgeInsets.only(left: 10),
                                                            child:const Text("Share",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),))
                                                      ],

                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  margin:const EdgeInsets.only(top: 20,left: 5,right: 5),
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                          columnSpacing: 5,
                                          headingRowHeight: 50,
                                          headingRowColor: MaterialStateColor.resolveWith(
                                                (Set<MaterialState> states) {
                                              if (states
                                                  .contains(MaterialState.hovered)) {
                                                return ColorValues.Splash_bg_color1.withOpacity(
                                                    0.5); // Color when hovered
                                              }

                                              return ColorValues.Splash_bg_color1; // Default color
                                            },
                                          ),

                                          columns:const <DataColumn>[
                                            DataColumn(
                                              label: Text('Name',
                                                  style: TextStyle(
                                                      fontSize: 11, color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text('Earning Amt.',
                                                  style: TextStyle(
                                                      fontSize: 11, color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text('Status',
                                                  style: TextStyle(
                                                      fontSize: 11, color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text('Date',
                                                  style: TextStyle(
                                                      fontSize: 11, color: Colors.white)),
                                            ),

                                          ],

                                          rows:
                                          List<DataRow>.generate(
                                              ReferEarnData.length, (index) {

                                            return DataRow(
                                                color: MaterialStateColor.resolveWith(
                                                        (Set<MaterialState> states) {
                                                      return Colors.white; // Default color
                                                    }),
                                                cells: <DataCell>[
                                                  DataCell(
                                                      Container(
                                                          child: Text(
                                                            '${ReferEarnData[index]['clientName']}',
                                                            style:const TextStyle(fontSize: 10),
                                                  ))),


                                                  DataCell(Container(
                                                      child:Text("${ReferEarnData[index]['amountType']['amount']}")
                                                  )),


                                                  DataCell(Container(
                                                    child:ReferEarnData[index]['status']==1?
                                                   const Text(
                                                      'Completed',
                                                      style: TextStyle(fontSize: 10,color: Colors.green),
                                                    ):
                                                   const Text(
                                                      'Pending',
                                                      style: TextStyle(fontSize: 10,color: Colors.red),
                                                    ),
                                                  )
                                                  ),


                                                  DataCell(Container(
                                                      child:
                                                      Text(
                                                        '${entryTime[index]}',
                                                        style:const TextStyle(fontSize: 10,color: Colors.black),
                                                      )

                                                  )),

                                                ]
                                            );

                                          }))),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 295,
                  child: Container(
                    height: 35,
                    width: 130,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorValues.Splash_bg_color2
                    ),
                    child:const Text("How its Work",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),),
                  ),
                ),


              ],
            ),
          ),
        ):
        Container(
          child:const Center(
           child: CircularProgressIndicator(color: Colors.black,),
          ),
        )
    );
  }
}
