import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Global_widgets/Broker_link.dart';
import 'package:stock_box/Global_widgets/LocalNotificationService.dart';
import 'package:stock_box/Global_widgets/Logout.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Basket.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Basket_broker_response.dart';
import 'package:stock_box/Screens/Main_screen/Blogs.dart';
import 'package:stock_box/Screens/Main_screen/Broadcasts.dart';
import 'package:stock_box/Screens/Main_screen/Broker/Webview_broker.dart';
import 'package:stock_box/Screens/Main_screen/Coupons.dart';
import 'package:stock_box/Screens/Main_screen/Faq.dart';
import 'package:stock_box/Screens/Main_screen/Help_desk.dart';
import 'package:stock_box/Screens/Main_screen/My_subscription.dart';
import 'package:stock_box/Screens/Main_screen/News.dart';
import 'package:stock_box/Screens/Main_screen/Notification.dart';
import 'package:stock_box/Screens/Main_screen/Performance_listing.dart';
import 'package:stock_box/Screens/Main_screen/Plan_detail.dart';
import 'package:stock_box/Screens/Main_screen/Privacy_Policy.dart';
import 'package:stock_box/Screens/Main_screen/Profile.dart';
import 'dart:math' as math;
import 'package:stock_box/Screens/Main_screen/ReferEarn.dart';
import 'package:stock_box/Screens/Main_screen/Service_plan.dart';
import 'package:stock_box/Screens/Main_screen/Terms_condition.dart';
import 'package:stock_box/Screens/Main_screen/Trades/Trades.dart';
import 'package:stock_box/Screens/Main_screen/Wallet.dart';
import 'package:stock_box/Screens/Onboarding_screen/Splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Onboarding_screen/Login.dart';
import 'Broker_Response.dart';

class Homepage extends StatefulWidget {
   bool? showOnboarding;
   Homepage({Key? key,this.showOnboarding}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState(showOnboarding:showOnboarding);
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  bool? showOnboarding;
  _HomepageState({
    this.showOnboarding
});
  bool? Status_logout;
  String? Message_Logout='';

  Logoutt_Api() async {
    var data = await API.Logout_Api();
    setState(() {
      Status_logout = data['status'];
      Message_Logout = data['message'];
    });

    if(Status_logout==true){
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_Logout',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login_status', 'false');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false,
      );

    }

    else{
      print("Hello");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_Logout',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }

  }

  late FirebaseMessaging messaging;
  String? device_token;

  Firebase_Notification(){
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print("11111111 test:${event.data}");
      print("22222222 test: ${event.notification!.body}");
      print("33333333 test: ${event.data.toString()}");
      print("44444444 test: ${event.data['type'].toString()}");

      // NotificationService().showNotification(body: '${event.notification!.body}');\
      NotificationService().showNotification(context,body: '${event.notification!.body}',payload:'["${event.data['type']}","${event.data['segment']}"]' );


    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      print("Testing1111111: ${message.data.toString()}");
      print("Testing2222222: ${message.data['type'].toString()}");
      String? Segment =message.data['segment'].toString();


      message.data['type'].toString()=="open signal"?
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Trades(indexchange: 0,Segment:Segment=="Cash"? 0:Segment=="Future"? 1: 2))):

      message.data['type'].toString()=="close signal"?
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Trades(indexchange: 1,Segment:Segment=="Cash"? 0:Segment=="Future"? 1: 2))):

      message.data['type'].toString()=="add coupon"?
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Coupons())):

      message.data['type'].toString()=="add broadcast"?
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Broadcasts())):

      message.data['type'].toString()=="add news"?
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Newss())):

      message.data['type'].toString()=="payout"?
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Wallet(index_tab: 1,))):

      message.data['type'].toString()=="add blog"?
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Blogs())):

      message.data['type'].toString()=="add news"?
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Newss())):

      print("No other routes");


      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Notificationn()),
      // );

     }
    );

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
            if(message != null){
              String? Segment =message.data['segment'].toString();
              message.data['type'].toString()=="open signal"?
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Trades(indexchange: 0,Segment:Segment=="Cash"? 0:Segment=="Future"? 1: 2))):
              message.data['type'].toString()=="close signal"?
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Trades(indexchange: 1,Segment:Segment=="Cash"? 0:Segment=="Future"? 1: 2))):

              message.data['type'].toString()=="add coupon"?
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Coupons())):

              message.data['type'].toString()=="add broadcast"?
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Broadcasts())):

              message.data['type'].toString()=="add news"?
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Newss())):

              message.data['type'].toString()=="payout"?
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Wallet(index_tab: 1,))):

              message.data['type'].toString()=="add blog"?
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Blogs())):

              message.data['type'].toString()=="add news"?
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Newss())):

              print("No other routes");
            }

      },
    );

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print('device_tokennnnnnnnnnnnnn =  $value');
      device_token = value;
      // postToken();
      // setToken();
    }
  );
 }

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    Fluttertoast.showToast(
        backgroundColor: Colors.black,
        msg: "Copied to clipboard!",
        textColor: Colors.white
    );
  }

  String? AngelRedirectUrl;
  String? AliceRedirectUrl;

  GetRedirectUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    AngelRedirectUrl=prefs.getString("AngelRedirectUrl");
    AliceRedirectUrl=prefs.getString("AliceRedirectUrl");
  }


  bool? Status_freetrial;
  String? Message_freetrial;
  // String? loader_freetrial="false";
  bool isButtonDisabled = false;
  FreeTrial_Apii() async {
    var data = await API.FreeTrial_Api();
    print("Data: $data");
    setState(() {
      Status_freetrial = data['status'];
      Message_freetrial = data['message'];
    });

    print("Free Trial Status: $Status_freetrial");
    print("Free Trial Message: $Message_freetrial");

    if(Status_freetrial==true){
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_freetrial',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
      // loader_freetrial="true";

    }

    else{
      print("Error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_freetrial',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }

  }

   String? Url;
   bool? Status_broker;

   //Angel
   TextEditingController api_key = TextEditingController();

   //Alice
   TextEditingController app_code = TextEditingController();
   TextEditingController user_id = TextEditingController();
   TextEditingController api_secret = TextEditingController();

   bool? Status_Dbroker;
   String? Message_Dbroker;

   DeleteBrokerLink_Api() async {
     SharedPreferences prefs= await SharedPreferences.getInstance();
     String? Id_brokerr = prefs.getString('Login_id');

     var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/deletebrokerlink"),
         headers: {
           'Content-Type': 'application/json',
         },
         body:jsonEncode(
             {
               'id': '$Id_brokerr',
             }
         )
     );

     var jsonString = jsonDecode(response.body);
     print("JsnnnnnnPayout: $jsonString");
     Status_Dbroker=jsonString['status'];
     if(Status_Dbroker==true){
       setState(() {});
     Message_Dbroker=jsonString['message'];

       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('$Message_Dbroker',style:const TextStyle(color: Colors.white)),
           duration:const Duration(seconds: 3),
           backgroundColor: Colors.red,
         ),
       );

       Navigator.pop(context);
       Profile_Api();

     }

     else{
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('$Message_Dbroker',style:const TextStyle(color: Colors.white)),
           duration:const Duration(seconds: 3),
           backgroundColor: Colors.red,
         ),
       );
     }
   }



  // int key = 0;
  // final dataMap = <String, double>{
  //   'iy':30.5,
  //   'iy':35.5,
  // };

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();


  List _data=[
    "images/slider.png",
    "images/slider2.jpg",
    "images/slider3.jpg",
    "images/slider4.jpg",
    "images/slider5.jpg",
  ];

  int _currentCarouselIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Widget buildIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin:const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: ShapeDecoration(
        shape:const CircleBorder(),
        color: index == _currentCarouselIndex  ? const Color(0xfffbdebf) : Colors.grey,
      ),
    );
  }

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  var Slider_Data=[];
  bool? Status;
  bool loader=false;
  List Slider_image=[];

  Slider_Api() async {
    var data = await API.Slider_Api();
    setState(() {
      Slider_Data = data['data'];
      print("Dataaaaa: $Slider_Data");
      Status = data['status'];
    });

    print("Dataaaaaa: $Slider_Data");

    if(Status==true){
      setState(() {});
      
      for(int i=0; i<=Slider_Data.length; i++ ){
        Slider_image.add('${Slider_Data[i]['image']}');

        print("SliderImage: $Slider_image");
      }

      loader=true;
    }

    else{
      print("error");
    }
  }

  var Data;
  String? Name='';
  String? Email='';
  String? Phone_no='';
  String? firstLetter='';
  String? Wallet_amount='';
  String? FullName='';
  String? Dlink_Status='';
  String? Trading_Status='';
  String? Broker_id='';
  String? Api_key='';
  String? Kyc_verification='';
  String CapitalLetter = '';
  String? Freetrial = '';
  String? Refer_token = '';

  SetAllTradingStatus() async {
    setState(() {});
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString("Kyc_verification",Kyc_verification!);
    prefs.setString("Dlink_status",Dlink_Status!);
    prefs.setString("Trading_status",Trading_Status!);
    prefs.setString("Broker_id",Broker_id!);
    prefs.setString("Api_key",Api_key!);
    prefs.setString("Refer_token",Refer_token!);
    prefs.setString("Name",Name!);
    prefs.setString("Email",Email!);
    prefs.setString("Phone",Phone_no!);
    prefs.setString("Delete_status",Delete_status!);
    prefs.setString("Active_status",Active_status!);

    setState(() {});
  }

  String? Demat_Api_key;
  String? Demat_Api_secret;
  String? Demat_userId;
  String? authtoken;
  String? AliceUser_id;

  String? Delete_status;
  String? Active_status;

  Profile_Api() async {

    setState(() {
      CapitalLetter = '';
    });

    var data = await API.Profile_Api();
    setState(() {
      Data = data['data'];
      Status = data['status'];
    });

    print("Dataaaaaa: $Data");

    if(Status==true){
      setState(() {});
      Name=Data['FullName'];
      Email=Data['Email'];
      Phone_no=Data['PhoneNo'];

      if (Name != null && Name!.isNotEmpty) {
        List<String> nameParts = Name!.split(" ");
        for (var part in nameParts) {
          if (part.isNotEmpty) {
            CapitalLetter += part[0].toUpperCase();
          }
        }
        print("CapitalLetter: $CapitalLetter");
      }

      Wallet_amount=Data['wamount'].toStringAsFixed(2);
      FullName=Data['FullName'];
      Dlink_Status=Data['dlinkstatus'].toString();
      Trading_Status=Data['tradingstatus'].toString();
      Broker_id=Data['brokerid'].toString();
      Api_key=Data['apikey']==null?"":Data['apikey'];
      Kyc_verification=Data['kyc_verification'].toString();
      Freetrial=Data['freetrial'].toString();
      Refer_token=Data['refer_token'];
      Delete_status=Data['del'].toString();
       print("Delete_status: $Delete_status");
      Demat_Api_key=Data['apikey'].toString();
      Demat_Api_secret=Data['apisecret'].toString();
      Demat_userId=Data['alice_userid'].toString();
      authtoken=Data['authtoken'].toString();
      AliceUser_id=Data['alice_userid'].toString();
      Active_status=Data['ActiveStatus'].toString();

      Delete_status=="1"||Active_status=="0"?
      handleLogout(context):
      print("Account not deleted");

      SetAllTradingStatus();

      Freetrial=="1"?
      print("Hello"):

      Future.delayed(const Duration(seconds: 2), () {
        FreeTrial_popup();
      });

      print("BBBBBBBB: ${Freetrial}");
      Sow_popup_first_time== true && Freetrial=="1" && Delete_status=="0"?
      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          Sow_popup_first_time= false;
          Offer_popup();
        });

      }):
      print("Hello");

      if(Trading_Status=="1"){
        _isSwitched=true;
      }
      else{
        _isSwitched=false;
      }
      SharedPreferences prefs= await SharedPreferences.getInstance();
      prefs.setString("Wallet_amount",Wallet_amount!);
      prefs.setString("FullName",FullName!);
      prefs.setString("Email",Email!);
      prefs.setString("PhoneNo",Phone_no!);
      prefs.setString("authtoken",authtoken!);
      prefs.setString("AliceUser_id",AliceUser_id!);
      loader=true;
    }

    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login_status', 'false');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false,
      );
    }

  }

  List<bool> color= [];
  bool loader_service=false;
  bool? Status_service;
  var Data_service;

  String? Avgreturnpertrade='',Avgreturnpermonth='',Ideasclosed='',Hit='',Miss='',Accuracy='';
  String? Service_id="66d2c3bebf7e6dc53ed07626";
  String? Segment_name="Cash";

  Service() async {
    var response = await http.get(Uri.parse(Util.SignalTabs_Api),);
    print(response.body);
    var jsonString = jsonDecode(response.body);
    print("Jsonnnnn: $jsonString");

    Status_service=jsonString['status'];

    if(Status_service==true){
      setState(() {});
      Data_service=jsonString['data'];
      PastPerformance_Api(Data_service[0]['_id']);

      for(int i=0; i<Data_service.length; i++){
        color.add(true);
      }
      color[0]=false;

      loader_service = true;
    }
    else{
      print("Error");
    }
  }


  var Prformance_data;
  bool? Prformance_status;
  bool? loader_data=false;

  PastPerformance_Api(Service_id) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_profile = prefs.getString('Login_id');
    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/list/past-performance/$Service_id"),);
    var jsonString = jsonDecode(response.body);
    Prformance_status=jsonString['status'];
    if(Prformance_status==true){
      setState(() {

      });
      Prformance_data=jsonString['data'];
      Avgreturnpertrade=Prformance_data['avgreturnpertrade'].toStringAsFixed(2);
      Avgreturnpermonth=Prformance_data['avgreturnpermonth'].toStringAsFixed(2);
      Ideasclosed=Prformance_data['count'].toString();
      Hit=Prformance_data['profitCount'].toString();
      Miss=Prformance_data['lossCount'].toString();
      Accuracy=Prformance_data['accuracy'].toStringAsFixed(2);
      loader_data=true;
    }

    else{
      Avgreturnpertrade="0";
      Avgreturnpermonth="0";
      Ideasclosed="0";
      Hit="0";
      Miss="0";
      Accuracy="0";
    }
    print("Jsnnnnnn: $jsonString");
  }


  var Prformancepopup_data;
  bool? Prformancepopup_status;

  String? Cash_return;
  String? Future_return;
  String? Option_return;

  int? ClosedTrades;
  int? Cashcount;
  int? Futurecount;
  int? Optioncount;

  PastPerformancePopup_Api() async {
    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/list/past-performances"),);
    var jsonString = jsonDecode(response.body);
    Prformancepopup_status=jsonString['status'];
    if(Prformancepopup_status==true){
      setState(() {});
      Prformancepopup_data=jsonString['results'];

      Cash_return=Prformancepopup_data['66d2c3bebf7e6dc53ed07626']['status']==false?"0.0":
          Prformancepopup_data['66d2c3bebf7e6dc53ed07626']['data']['avgreturnpermonth'].toStringAsFixed(2);

      Option_return=Prformancepopup_data['66dfeef84a88602fbbca9b79']['status']==false?"0.0":
          Prformancepopup_data['66dfeef84a88602fbbca9b79']['data']['avgreturnpermonth'].toStringAsFixed(2);

      Future_return= Prformancepopup_data['66dfede64a88602fbbca9b72']['status']==false?"0.0":
      Prformancepopup_data['66dfede64a88602fbbca9b72']['data']['avgreturnpermonth'].toStringAsFixed(2);



      print("Option Returnnnnn: $Option_return");
      Cashcount=Prformancepopup_data['66d2c3bebf7e6dc53ed07626']['status']==false?0:
          int.parse(Prformancepopup_data['66d2c3bebf7e6dc53ed07626']['data']['count'].toString());

      Futurecount=Prformancepopup_data['66dfede64a88602fbbca9b72']['status']==false?0:
          int.parse(Prformancepopup_data['66dfede64a88602fbbca9b72']['data']['count'].toString());

      Optioncount=Prformancepopup_data['66dfeef84a88602fbbca9b79']['status']==false?0:
          int.parse(Prformancepopup_data['66dfeef84a88602fbbca9b79']['data']['count'].toString());

      ClosedTrades=Cashcount! + Futurecount! + Optioncount!;

      print("Cashcount: $Cashcount");
      print("ClosedTrades: $ClosedTrades");
    }

    else{

    }
  }


  var Basket_data;
  bool? Status_basket;
  String? Message_basket;
  bool loader_basket= false;

  Basket_Api() async {
    var data = await API.Basket_Api();
    setState(() {
      Status_basket = data['status'];
      Message_basket = data['message'];
    });

    if(Status_basket==true){
      setState(() {});
      Basket_data=data['data'];

      loader_basket=true;
    }

    else{
      print("error");
    }
  }


  var AllPlans=[];
  bool? Status_allplans;
  bool loader_allplans=false;

  GetAllPlans_Api() async {

    var data = await API.GetAllPlans();
    setState(() {
      Status_allplans = data['status'];
    });
    print("Statussss: $Status_allplans");

    if(Status_allplans==true){
      setState(() {});
      AllPlans = data['data'];

      print("Alllllllllllllllllllllllll: $AllPlans");

      AllPlans.length>0?
      loader_allplans=true:
      loader_allplans=false;
    }

    else{
      print("error");
    }

  }

  bool? Status_token;
  checkToken_Api() async {
    var data = await API.checkToken();
    setState(() {
      Status_token = data['status'];

      print("Status_tokennnnnnnn: $Status_token");
    });

    if(Status_token==true){
      print("66666666666666666");
    }
    else{
      setState(() {});
      print("7777777777777777777");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login_status', 'false');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }


  bool? Status_setting;
  String? loader_setting="false";
  String? FreetrialDays;
  String? SenderEarn='';
  String? ReceiverEarn='';
  String? Refer_title='';
  String? refer_image='';
  String? Refer_description='';

  String? Facebook_link='';
  String? Instagram_link='';
  String? Twitter_link='';
  String? Youtube_link='';
  String? razorpay_key='';
  String? OfferImage='';
  String? popupstatus='';
  String? popupcontent='';
  String? Whatsapp_number='';

  BasicSetting_Apii() async {
    var data = await API.BesicSetting_Api();
    print("Data: $data");
    setState(() {
      Status_setting = data['status'];
    });

    if(Status_setting==true){
      setState(() {});
      OfferImage=data['data']['offer_image'];
      print("OfferImage: $OfferImage");
      FreetrialDays=data['data']['freetrial'].toString();

      SenderEarn=data['data']['sender_earn'];
      ReceiverEarn=data['data']['receiver_earn'];
      Refer_title=data['data']['refer_title'];
      Refer_description=data['data']['refer_description'];
      refer_image=data['data']['refer_image'];

      Facebook_link=data['data']['facebook'];
      Instagram_link=data['data']['instagram'];
      Twitter_link=data['data']['twitter'];
      Youtube_link=data['data']['youtube'];
      razorpay_key=data['data']['razorpay_key'];
      popupstatus=data['data']['popupstatus'].toString();
      popupcontent=data['data']['popupcontent'].toString();
      Whatsapp_number=data['data']['wh_number'].toString();

       SharedPreferences prefs= await SharedPreferences.getInstance();
       prefs.setString('Razorpay_key', razorpay_key!);


      data['data'].length>0?
      loader_setting="true":
      loader_setting="No_data";

    }

    else{

    }
  }

  int _page = 1;
  String? loader_noti = "false";
  var Notification_data;
  List<String> time1=[];
  List entryTime1=[];
  Set<String> readNotifications = {};

  int? Unread_count=0;
  void _firstLoad() async {
    setState(() {
      loader_noti = "false";
      _page = 1;
    });

    try {
      var data = await API.Notification_Api(_page);
      setState(() {
        // _posts = data["productdata"]["allEquipment"]['data'];
        Notification_data = data['data'];

        for(int i=0; i<Notification_data.length; i++){
          time1.add(Notification_data[i]['createdAt']);
          entryTime1 = time1.map((dateTimeString1) {
            DateTime dateTime1 = DateTime.parse(dateTimeString1);
            DateTime istTime = dateTime1.add(Duration(hours: 5, minutes: 30));
            return DateFormat('d MMM, yyyy HH:mm').format(istTime);
          }).toList();
        }

          int totalNotificationCount= data["pagination"]['total'];
          print("asdsgdgh :$totalNotificationCount");

        Unread_count= totalNotificationCount - readNotifications.length;
        // Notification_data.length>0?
        // loader = "true":
        // loader = "No_data";

        loader_noti = Notification_data.isNotEmpty ? "true" : "No_data";
      });
    }
    catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
        setState(() {
          loader_noti = "No_data";
        });
      }
    }
  }

  bool _isLoadMoreRunning = false;
  var Product=[];
  bool _hasNextPage = false;
  bool data_loder = true;

  void _loadMore(_page) async {

    setState(() {
      _isLoadMoreRunning = true;
    });

    try {
      var data = await API.Notification_Api(_page);
      Product = data['data'];

      if (Product.isNotEmpty) {
        setState(() {
          Notification_data.addAll(Product);

          for(int i=0; i<Notification_data.length; i++){
            time1.add(Notification_data[i]['createdAt']);
            entryTime1 = time1.map((dateTimeString1) {
              DateTime dateTime1 = DateTime.parse(dateTimeString1);
              return DateFormat('d MMM, yyyy HH:mm').format(dateTime1);
            }).toList();
          }
          int TotalNotificationCount= data["pagination"]['total'];
          Unread_count= TotalNotificationCount - readNotifications.length;

          loader_noti = "true";
        });
      } else {

        setState(() {
          data_loder =false;
          _hasNextPage = false;
        });
        var snackBar = SnackBar(
            backgroundColor: ColorValues.Splash_bg_color1,
            content: Text("You have seen all notifications.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),)
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong!');
      }
    }


    setState(() {
      _isLoadMoreRunning = false;
    });
  }


  void _markAsRead(String _id) {
    setState(() {
      readNotifications.add(_id);
    });
    _saveReadNotifications();
  }

  Future<void> _loadReadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final readList = prefs.getStringList('readNotifications') ?? [];
    setState(() {
      readNotifications = readList.toSet();
    });
  }
  Future<void> _saveReadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('readNotifications', readNotifications.toList());
  }

  final onboardingKey = GlobalKey<OnboardingState>();

  final FocusNode fabFocusNode = FocusNode();
  final FocusNode iconFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();

  testtt() async {
    final prefs = await SharedPreferences.getInstance();
    final showOnboarding = prefs.getBool('showOnboarding') ?? true;

    if(showOnboarding==true){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (widget.showOnboarding!) {
          onboardingKey.currentState?.show();
        }
      });
    }

  }


  @override
  void initState() {
    super.initState();
    getReminders();
    testtt();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: 5), () {
        Status_reminder==true?
        showRightSideFlushbar(context):
        print("Hello");
      });
    });
    checkToken_Api();
    Slider_Api();
    Profile_Api();
    Basket_Api();
    Service();
    GetAllPlans_Api();
    BasicSetting_Apii();
    PastPerformancePopup_Api();
    GetRedirectUrl();
    _firstLoad();
    _loadReadNotifications();
    _controller = AnimationController(
      duration:const Duration(seconds: 8),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
    Firebase_Notification();

  }
  @override
  void dispose() {
    fabFocusNode.dispose();
    iconFocusNode.dispose();
    textFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }


  notification_count_update(){
    _firstLoad();
    _loadReadNotifications();
  }

  bool _isSwitched = false;

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Onboarding(
      key: onboardingKey,
      steps: [
        OnboardingStep(
          focusNode: iconFocusNode,
          stepBuilder: (context, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Your Profile',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Click here to view your profile.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      decoration: TextDecoration.none, // Remove underline
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: controller.close,
                        child: const Text("Skip", style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: controller.nextStep,
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          titleText: '',
        ),
        OnboardingStep(
          focusNode: fabFocusNode,
          stepBuilder: (context, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Your Profile',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Click here to view your profile.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      decoration: TextDecoration.none, // Remove underline
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: controller.close,
                        child: const Text("Skip", style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: controller.nextStep,
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          titleText: '', // Empty to avoid default title styling
        ),
        OnboardingStep(
          focusNode: textFocusNode,
          stepBuilder: (context, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Your Profile',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Click here to view your profile.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      decoration: TextDecoration.none, // Remove underline
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed:(){
                          controller.close;
                          setState(() {
                            showOnboarding=false;
                          });
                          // controller.nextStep();
                        },
                        child: const Text("Skip", style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed:() async {
                          controller.close();
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('showOnboarding', false);
                          // controller.nextStep;
                        },
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          titleText: '', // Empty to avoid default title styling
        ),

        // OnboardingStep(
        //   focusNode: iconFocusNode,
        //   titleText: 'Tap to Add',
        //   bodyText: 'Tap this button to add a new item.',
        //   shape: const CircleBorder(),
        // ),
        // OnboardingStep(
        //   focusNode: fabFocusNode,
        //   titleText: 'Tap to Add',
        //   bodyText: 'Tap this button to add a new item.',
        //   shape: const CircleBorder(),
        // ),
        // OnboardingStep(
        //   focusNode: textFocusNode,
        //   titleText: 'Welcome!',
        //   bodyText: 'This is your homepage.',
        // ),

      ],
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: true,
          backgroundColor: Colors.grey.shade200,
          elevation: 0,
          leading: Padding(
              padding:const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: (){
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: CircleAvatar(
                    backgroundColor: ColorValues.Splash_bg_color1,
                    radius: 15,
                    child: Text(
                      "$CapitalLetter",
                      style:const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    )),
              )
          ),

          title: Container(
            // color: Colors.red,
            width: MediaQuery.of(context).size.width/2.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  child:const Text("Login With Api :",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                ),

                Container(
                  child: Switch(
                    value: _isSwitched,
                    onChanged: (value) {
                      if (!_isSwitched) {
                        setState(() {
                          _isSwitched = value;
                          print("Is switch : $_isSwitched");
                          if(Dlink_Status=="0"&& Trading_Status=="0"){
                            // Broker_link_popup();
                            Add_Broker.Broker_link(context);
                          }

                          else if(Dlink_Status=="1"&& Trading_Status=="0"){
                            String? Url= Broker_id=="1"?
                            "https://smartapi.angelone.in/publisher-login?api_key=${Api_key}":
                            Broker_id=="2"?
                            "https://ant.aliceblueonline.com/?appcode=${Api_key}":
                            Broker_id=="5"?
                            "https://kite.zerodha.com/connect/login?v=3&api_key=${Api_key}":
                            Broker_id=="6"?
                            "https://api-v2.upstox.com/login/authorization/dialog?response_type=code&client_id=${Api_key}&redirect_uri=${Util.Url}/backend/upstox/getaccesstoken&state=${Email}":
                            "" ;
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url, Broker_idd:Broker_id, aliceuser_id: AliceUser_id,)));
                          }

                          else{
                            print("Hello");
                          }

                        });
                      } else {
                        print("Switch is already on, cannot be turned off.");
                      }
                    },
                    activeColor: ColorValues.Splash_bg_color1,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),

          actions: <Widget>[

            GestureDetector(
              onTap: (){
                openWhatsApp(
                  phone: "$Whatsapp_number",
                  message: "Hello",
                );
              },
              child: Container(
                height: 25,width: 25,
                margin:const EdgeInsets.only(right: 7,bottom: 5),
                child: Image.asset("images/whatsapp.png"),
              ),
            ),


            popupstatus=="1"?
            GestureDetector(
              onTap: (){
                DisclaimerPopup();
              },
              child: Container(
                  margin:const EdgeInsets.only(right: 7,bottom: 5),
                  child: Icon(Icons.info_outline,size: 25,color: ColorValues.Splash_bg_color1,)
              ),
            ):
            const SizedBox(),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Notificationn())).then((value) =>  notification_count_update());
              },
              child: Focus(
                focusNode: iconFocusNode,
                child: Container(
                  margin:const EdgeInsets.only(top: 22,right: 15),
                  child: Stack(
                    children: [
                      Container(
                          margin:const EdgeInsets.only(top:3),
                          child: Icon(
                            Icons.notifications,
                            color: ColorValues.Splash_bg_color1,
                            size: 30,
                          )),
                      Stack(
                        children: [
                          Unread_count! > 0 ?
                          Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.topRight,
                            // margin: EdgeInsets.only(top: 5),
                            child: Container(
                                width: 18,
                                height: 18,
                                decoration:const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffc32c37),
                                ),
                                child:Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(
                                    child: Text(
                                      "$Unread_count",
                                      style:const TextStyle(fontSize: 10,color: Colors.white),
                                    ),
                                  ),
                                )
                            ),
                          ):
                          const SizedBox()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

        ),

        drawer: Drawer(
          width: 220,
          child: Column(
            children: [
              const SizedBox(height: 40,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
                },
                child: Container(
                  margin:const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                       CircleAvatar(
                          backgroundColor: ColorValues.Splash_bg_color1,
                          radius: 25,
                          child: Text(
                            "$CapitalLetter",
                            style:const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white),
                          )
                      ),

                      Container(
                        margin:const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text("$Name",style:const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                            ),
                            Container(
                              margin:const EdgeInsets.only(top: 4),
                              child: Text("$Phone_no",),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              Facebook_link=="" && Instagram_link==""&&Twitter_link==""&&Youtube_link==""?
              const SizedBox(height: 0,):
              Container(
                margin:const EdgeInsets.only(top: 10),
                child: Divider(
                  color: Colors.grey.shade500,
                  thickness: 0.1,
                ),
              ),

              Container(
                margin:const EdgeInsets.only(bottom: 10,top: 5),
                child: Row(
                  children: [
                    Facebook_link==""?
                    SizedBox():
                    GestureDetector(
                      onTap: (){
                        _launchUrl(Facebook_link!);
                      },
                      child: Container(
                        margin:const EdgeInsets.only(left: 15),
                        child: Image.asset("images/facebook.png",height: 30,width: 30,),
                      ),
                    ),

                    Instagram_link==""?
                    SizedBox():
                    GestureDetector(
                      onTap: (){
                        _launchUrl(Instagram_link!);
                      },
                      child: Container(
                        margin:const EdgeInsets.only(left: 15),
                        child: Image.asset("images/instagram.png",height: 30,width: 30,),
                      ),
                    ),

                    Twitter_link==""?
                    SizedBox():
                    GestureDetector(
                      onTap: (){
                        _launchUrl(Twitter_link!);
                      },
                      child: Container(
                        margin:const EdgeInsets.only(left: 15),
                        child: Image.asset("images/twitter.png",height: 30,width: 30,),
                      ),
                    ),

                    Youtube_link==""?
                    SizedBox():
                    GestureDetector(
                      onTap: (){
                        _launchUrl(Youtube_link!);
                      },
                      child: Container(
                        margin:const EdgeInsets.only(left: 15),
                        child: Image.asset("images/youtube.png",height: 30,width: 30,),
                      ),
                    )
                  ],
                ),
              ),

              Container(
                child: Divider(
                  color: Colors.grey.shade500,
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.home,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Home",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),

                      GestureDetector(
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.add_card,color: ColorValues.Splash_bg_color1,),
                              ),
                              GestureDetector(
                                onTap: (){
                                  // Dlink_Status=="1"?
                                  // DematcredentialData_popup();
                                  //     :
                                  // print("No data");
                                },
                                child: Container(
                                  margin:const EdgeInsets.only(left: 10),
                                  child:const Text("Demat",style: TextStyle(fontSize: 15),),
                                ),
                              ),
                              const SizedBox(width: 40,),

                              Dlink_Status=="1"?
                              GestureDetector(
                                onTap: (){
                                  Broker_dlink();
                                },
                                child: Container(
                                  height: 22,
                                  width: 50,
                                  margin:const EdgeInsets.only(top: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.red),
                                  ),
                                  alignment: Alignment.center,
                                  child:const Text("Delete",style: TextStyle(color: Colors.red,fontSize: 12),),
                                ),
                              ):
                              GestureDetector(
                                onTap: (){
                                  // Broker_link_popup();
                                  Add_Broker.Broker_link(context);
                                },
                                child: Container(
                                  height: 22,
                                  width: 45,
                                  margin:const EdgeInsets.only(top: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.blue)
                                  ),
                                  alignment: Alignment.center,
                                  child:const Text("Link",style: TextStyle(color: Colors.blue,fontSize: 12),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> My_subscription(go_home: false)));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.subscriptions,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Subscriptions",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Coupons()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.local_offer,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Coupons",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Referral()));
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> Referral()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              // Container(
                              //   child:const Icon(Icons.change_circle_outlined,color: ColorValues.Splash_bg_color1,),
                              // ),
                              Container(
                                margin:const EdgeInsets.only(left: 3),
                                child: Image.asset("images/referearn.png",height: 18,width: 18,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Refer and Earn",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Faq()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.question_answer,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("FAQ's",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Privacy_policy()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.privacy_tip_outlined,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Privacy Policy",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Terms_condition()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.rule,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Terms & Conditions",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Help_desk()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.help_center,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Help Desk",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Broadcasts()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.message,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Broadcast",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> BrokerResponse()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Image.asset("images/broker.png",height: 20,width: 20,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Broker Response",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_BrokerResponse()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Image.asset("images/broker.png",height: 20,width: 20,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Basket Broker Response",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Notificationn()));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.notifications_outlined,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Notifications",style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Logout();
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.logout,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("Logout",style: TextStyle(fontSize: 15),),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.1,
                        ),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        body: RefreshIndicator(
          onRefresh: () async{
            setState(() {
              Profile_Api();
            });
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            onPageChanged: (index, reason) => setState(() => _currentCarouselIndex = index),
                            autoPlay: true,
                            height: 203,
                            viewportFraction: 1,
                            autoPlayInterval: const Duration(seconds: 2),
                          ),
                          items: Slider_Data.map<Widget>((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () => _launchUrl(item['hyperlink']!),  // Open URL on image tap
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: const EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(
                                        item['image']!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        // CarouselSlider(
                        //   options: CarouselOptions(
                        //     onPageChanged: (index, reason) => setState(() => _currentCarouselIndex = index),
                        //     autoPlay: true,
                        //     height: 203,
                        //     viewportFraction: 1,
                        //     autoPlayInterval:const Duration(seconds: 2),
                        //   ),
                        //
                        //   items: Slider_image.map<Widget>((item) {
                        //     return Builder(
                        //       builder: (BuildContext context) {
                        //         return Card(
                        //           elevation: 1,
                        //           color: Colors.white,
                        //           clipBehavior: Clip.antiAliasWithSaveLayer,
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(8),
                        //           ),
                        //           margin:const EdgeInsets.only( top: 20, bottom: 10,left: 15,right: 15),
                        //           child: Container(
                        //             // height: 170,
                        //               width: MediaQuery.of(context).size.width,
                        //               child: Container(
                        //                 child: Image.network("${item}",fit: BoxFit.fill,),
                        //               )
                        //           ),
                        //         );
                        //       },
                        //     );
                        //   }).toList(),
                        // )
                    ),

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center indicators
                        children: List.generate(Slider_Data.length, (index) => buildIndicator(index)),
                      ),
                    ),
                  ],
                ),

                Container(
                  margin:const EdgeInsets.only(top: 25,left: 25 ,right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscribe()));
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: RadialGradient(
                                    center: Alignment.center,
                                    radius: 0.5,
                                    colors: [
                                      ColorValues.Splash_bg_color1.withOpacity(0.3),
                                      Colors.grey.shade300,
                                    ],
                                    stops: [0.001, 1.0],
                                  ),
                                ),
                                child: Container(
                                    padding:const EdgeInsets.all(15),
                                    child: Image.asset("images/service1.png",)
                                ),
                              ),
                              Container(
                                margin:const EdgeInsets.only(top:8),
                                child: Text("Service",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.grey.shade600),),
                              ),
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Trades(indexchange: 0,Segment:0)));
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: RadialGradient(
                                    center: Alignment.center,
                                    radius: 0.5,
                                    colors: [
                                      ColorValues.Splash_bg_color2.withOpacity(0.3),
                                      Colors.grey.shade300,
                                    ],

                                    stops: [0.001, 1.0],
                                  ),
                                ),
                                child: Container(
                                    padding:const EdgeInsets.all(18),
                                    child: Image.asset("images/trade1.png",)
                                ),
                              ),

                              Container(
                                margin:const EdgeInsets.only(top:8),
                                child: Text("Trades",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.grey.shade600),),
                              ),

                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Basket()));
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: RadialGradient(
                                  center: Alignment.center,
                                  radius: 0.5,
                                  colors: [
                                    Colors.deepPurpleAccent.withOpacity(0.3),
                                    Colors.grey.shade300,
                                  ],

                                  stops: [0.001, 1.0],
                                ),
                              ),
                              child: Container(
                                  padding:const EdgeInsets.all(18),
                                  child: Image.asset("images/basket1.png",)),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top:8),
                              child: Text("Basket",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.grey.shade600),),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Referral()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> ShareLinkPage()));
                  },
                  child: Container(
                    padding:const EdgeInsets.only(top: 12,bottom: 12),
                    // height: 85,~
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          // Color(0xffE4EfE9),
                          // Color(0xffE4EfE9),
                          ColorValues.Splash_bg_color1,
                          ColorValues.Splash_bg_color4,
                        ],
                        stops: [0.0, 3.0],
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 25, left: 15, right: 15,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              margin:const EdgeInsets.only(left: 15,top: 10,bottom: 3),
                              child: Text(
                                "$Refer_title",
                                textAlign: TextAlign.start,
                                style:const TextStyle(fontSize: 22 , color: Colors.white,fontWeight: FontWeight.w700),),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width/1.75,
                              margin:const EdgeInsets.only(left: 15,bottom: 10,top: 2),
                              child:RichText(
                                text: TextSpan(
                                  text: 'Invite a friend to enjoy ',
                                  style:const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '$ReceiverEarn% ',
                                      style:const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                          color: Colors.white
                                      ),
                                    ),

                                    const TextSpan(
                                      text: 'of their plan price as credit in their wallet, and you will receive',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color:Colors.white,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),

                                    TextSpan(
                                      text: ' $SenderEarn%',
                                      style:const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white
                                      ),
                                    ),

                                    const TextSpan(
                                      text: ' credit for yourself!',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),

                        Container(
                            margin:const EdgeInsets.only(right: 10),
                            height: 70,width: 70,
                            child:refer_image==''?
                                Container(
                                   height: 30,width: 30,
                                  alignment: Alignment.center,
                                  child:const CircularProgressIndicator(),
                                ):

                            Image.network("$refer_image",height: 70,width: 70,)
                        ),
                        /*Container(
                            margin:const EdgeInsets.only(right: 10),
                            child:Image.asset("images/gift_refer.png",height: 70,width: 70,)
                        ),*/

                      ],
                    ),
                  ),
                ),


                loader_allplans==true?
                Container(
                  margin:const EdgeInsets.only(top: 20,left: 15 ,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin:const EdgeInsets.only(top:8),
                        child:const Text("Plans",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscribe()));
                        },
                        child: Row(
                          children: [
                            Container(
                              margin:const EdgeInsets.only(top:8),
                              child:const Text("View all",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black),),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top:8,left: 4),
                              child: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade600,size: 12,),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ):
                const SizedBox(height: 0,),

                loader_allplans==true?
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 15,),
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: AllPlans.length,
                      itemBuilder: (BuildContext context, int indexxx) {
                        String? ttt ='';
                        for(int i=0; i<AllPlans[indexxx]['services'].length; i++){
                          ttt = i==0?
                          (ttt!+"${AllPlans[indexxx]['services'][i]['title']}"):
                          (ttt!+" + ${AllPlans[indexxx]['services'][i]['title']}");
                        }

                        return GestureDetector(
                          onTap: () {
                            // Your tap logic here
                          },
                          child: Card(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: ColorValues.Splash_bg_color1,
                                width: 0.2,
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              width: 130,
                              child: Column(
                                children: [
                                  // Services Title
                                  // Container(
                                  //   height: 25,
                                  //   alignment: Alignment.center,
                                  //   width: 130,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: const BorderRadius.only(
                                  //       topLeft: Radius.circular(10),
                                  //       topRight: Radius.circular(10),
                                  //     ),
                                  //     border: Border.all(color: ColorValues.Splash_bg_color1, width: 0.1),
                                  //     color: ColorValues.Splash_bg_color1,
                                  //   ),
                                  //   child: ListView.builder(
                                  //     scrollDirection: Axis.horizontal,
                                  //     itemCount: AllPlans[indexxx]['services'].length,
                                  //     itemBuilder: (BuildContext context, int index) {
                                  //       return Container(
                                  //         alignment: Alignment.center,  // Ensure it centers
                                  //         child: Row(
                                  //           mainAxisAlignment: MainAxisAlignment.center,  // Center content horizontally
                                  //           children: [
                                  //             Text(
                                  //               "${AllPlans[indexxx]['services'][index]['title']}",
                                  //               style: const TextStyle(
                                  //                 fontWeight: FontWeight.w600,
                                  //                 fontSize: 10,
                                  //                 color: Colors.white,
                                  //               ),
                                  //             ),
                                  //             Container(
                                  //               margin: const EdgeInsets.only(left: 2),
                                  //               child: const Icon(
                                  //                 Icons.add,
                                  //                 color: Colors.white,
                                  //                 size: 15,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                  Container(
                                    height: 25,
                                    alignment: Alignment.center,
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      border: Border.all(color: ColorValues.Splash_bg_color1, width: 0.1),
                                      color: ColorValues.Splash_bg_color1,
                                    ),
                                    child:Text(
                                      "$ttt",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      '₹${AllPlans[indexxx]['price']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: 80,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 7),
                                    child: Text(
                                      '${AllPlans[indexxx]['validity']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),


                                  GestureDetector(
                                    onTap: (){
                                      var PlanDetail=AllPlans[indexxx];
                                      String Services = ttt!;

                                      print("1111: $Services");

                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Plan_detail(PlanDetail:PlanDetail,Services:Services)));
                                    },

                                    child: Container(
                                      height: 22,
                                      width: 100,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: [
                                            0.1,
                                            0.7,
                                          ],
                                          colors: [
                                            ColorValues.Splash_bg_color1,
                                            ColorValues.Splash_bg_color3,
                                          ],
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: const Text(
                                        'Subscribe Now',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ):
                const SizedBox(height: 0,),

                loader_data==true?
                Container(
                  alignment: Alignment.topLeft,
                  margin:const EdgeInsets.only(top: 25,left: 15 ,right: 15),
                  child:const Text("Performance Status",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,color: Colors.black),),
                ):
                const SizedBox(height: 0,),

                loader_data==true?
                Container(
                  margin:const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [
                        0.1,
                        0.9,
                      ],
                      colors: [
                        ColorValues.Splash_bg_color1,
                        ColorValues.Splash_bg_color4,
                      ],
                    ),
                  ),

                  child: Column(
                    children: [
                      Container(
                        margin:const EdgeInsets.only(top: 10,left: 15),
                        alignment: Alignment.topLeft,
                        child:const Text("Past Performance",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                      ),
                      loader_service==true?
                      Container(
                        alignment: Alignment.topLeft,
                        height: 30,
                        margin:const EdgeInsets.only(left: 15,top: 10,right: 15),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: Data_service.length,
                          itemBuilder: (BuildContext context, int index) {
                            return color[index]==true?
                             GestureDetector(
                               onTap: (){
                                 setState(() {

                                 });
                                 for(int i=0; i<Data_service.length; i++){
                                   color[i]=true;
                                 }
                                 color[index]=false;
                                 Service_id=Data_service[index]['_id'];
                                 print("111111111 : $Service_id");
                                 Segment_name=Data_service[index]['title'];
                                 PastPerformance_Api(Service_id);
                               },
                               child: Container(
                                margin:const EdgeInsets.only(left: 8,right: 8),
                                height: 25,
                                width: 55,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white)
                                ),
                                alignment: Alignment.center,
                                child: Text("${Data_service[index]['title']}",style:const TextStyle(fontSize: 11,color: Colors.black,fontWeight: FontWeight.w500),),
                             ),
                           ):
                             Container(
                              margin:const EdgeInsets.only(left: 8,right: 8),
                              height: 25,
                              width: 58,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ColorValues.Splash_bg_color2,
                                  border: Border.all(color: Colors.black,width: 0.2)
                              ),
                              alignment: Alignment.center,
                              child: Text("${Data_service[index]['title']}",style:const TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w600),),
                            );
                          },
                        ),
                      ):
                      const CircularProgressIndicator(color: Colors.black,),

                      Container(
                        margin:const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text("Avg. return / trade",style: TextStyle(color: Colors.grey.shade300,fontWeight: FontWeight.bold),),
                                  ),

                                  Container(
                                    margin:const EdgeInsets.only(top: 10),
                                    child: Text("₹$Avgreturnpertrade",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 16),),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                                height: 45,
                                child:const VerticalDivider(color: Colors.white)
                            ),

                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text("Avg. return / month",style: TextStyle(color: Colors.grey.shade300,fontWeight: FontWeight.bold),),
                                  ),
                                  Container(
                                    margin:const EdgeInsets.only(top: 10),
                                    child: Text("₹${Avgreturnpermonth}",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 16),),
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          print("2222222222: $Service_id");

                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> Performance_listing(Service_id:Service_id,Segment_name:Segment_name)));
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PerformanceListing(serviceId:Service_id,segmentName:Segment_name)));
                        },
                        child: Container(
                          margin:const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 12),
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width/2.2,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin:const EdgeInsets.only(left: 10,top: 14),
                                      child:const Text("Ideal Hit Accuracy",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin:const EdgeInsets.only(left: 10,top: 7),
                                      child: Text("Ideal hit closed: $Ideasclosed",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                    ),

                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin:const EdgeInsets.only(left: 10,top: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 12,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.green
                                                  ),
                                                ),
                                                Container(
                                                  margin:const EdgeInsets.only(left: 8),
                                                  child: Text("Hit: $Hit",style:const TextStyle(fontSize: 12),),
                                                )
                                              ],
                                            ),
                                          ),

                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 12,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.red
                                                  ),
                                                ),
                                                Container(
                                                  margin:const EdgeInsets.only(left: 8),
                                                  child: Text("Miss: $Miss",style:const TextStyle(fontSize: 12),),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                height: 90,
                                margin:const EdgeInsets.only(right: 10),
                                child: PieChart(
                                  key: ValueKey(Accuracy),
                                  centerWidget: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Text(
                                            "$Accuracy%",
                                            style:const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          child: const Text(
                                            "Accuracy",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  dataMap: <String, double>{
                                    'Accuracy': double.parse(Accuracy==""?"0.0":Accuracy!),
                                    'Remaining': 100 - double.parse(Accuracy==""?"0.0":Accuracy!),
                                  },
                                  animationDuration: const Duration(milliseconds: 800),
                                  chartLegendSpacing: 20,
                                  chartRadius: math.min(
                                    MediaQuery.of(context).size.width / 4.2, 250,
                                  ),
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.ring,
                                  legendOptions: const LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.right,
                                    showLegends: false,
                                    legendShape: BoxShape.circle,
                                    legendTextStyle: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValueBackground: true,
                                    showChartValues: false,
                                    showChartValuesInPercentage: false,
                                    showChartValuesOutside: false,
                                  ),
                                  ringStrokeWidth: 10,
                                  colorList:const [Colors.green, Colors.red],
                                  baseChartColor: Colors.transparent,
                                ),

                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ):
                const SizedBox(height: 10,)

              ],
            ),
          ),
        ),

      ),
    );
  }

  Logout(){
    return showModalBottomSheet(
      isScrollControlled:true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return Container(
                  height: MediaQuery.of(context).size.height/5,
                  child:Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin:const EdgeInsets.only(top: 15,left: 15),
                        child:const Text("Do you want to logout ?",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w500),),
                      ),

                      Container(
                        margin:const EdgeInsets.only(top: 25,left: 15,right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width/2.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
                                    color: Colors.white
                                ),
                                alignment: Alignment.center,
                                child:const Text("Cancel",style: TextStyle(color: Colors.black),),
                              ),
                            ),

                            GestureDetector(
                              onTap: () async {
                                Logoutt_Api();
                                // SharedPreferences prefs = await SharedPreferences.getInstance();
                                // prefs.setString('login_status', 'false');
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => SplashScreen()),
                                //       (Route<dynamic> route) => false,
                                // );
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width/2.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color:ColorValues.Splash_bg_color1,width: 0.4),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: [
                                      0.1,
                                      0.7,
                                    ],
                                    colors: [
                                      ColorValues.Splash_bg_color1,
                                      ColorValues.Splash_bg_color3,
                                    ],
                                  ),
                                ),
                                child:const Text("Logout",style: TextStyle(color: Colors.white),),
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  )
              );
            }
        );
      },
    );
  }

  Offer_popup(){
    return showModalBottomSheet(
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
          )
      ),
      isScrollControlled:true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return Container(
                  height:550,
                  width: MediaQuery.of(context).size.width,
                  decoration:const BoxDecoration(
                    image:DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("images/offernew_background.jpg",)
                    )
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:const EdgeInsets.only(left: 0,top: 2),
                      alignment: Alignment.center,
                      child: Image.network("$OfferImage",height: 150,),
                    ),

                    Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 140,
                          width: 100,
                          margin:const EdgeInsets.only(top: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.1,
                                0.7,
                              ],
                              colors: [
                                ColorValues.Splash_bg_color1,
                                ColorValues.Splash_bg_color4,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin:const EdgeInsets.only(top: 10),
                                child:const Text("CASH",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),),
                              ),

                              Container(
                                margin:const EdgeInsets.only(top: 10),
                                child:Image.asset("images/cash1.png",height: 40,color: Colors.white,)
                              ),

                              Container(
                                padding:const EdgeInsets.only(left: 4,right: 4),
                                margin:const EdgeInsets.only(top: 12),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("₹$Cash_return",
                                    maxLines: 1,style:const TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
                                ),
                              ),
                              Container(
                                child: Text("(Monthly Returns)",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500,color: Colors.grey.shade400),),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin:const EdgeInsets.only(top: 0,left: 10),
                          height: 140,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.1,
                                0.7,
                              ],
                              colors: [
                                ColorValues.Splash_bg_color1,
                                ColorValues.Splash_bg_color4,
                              ],
                            ),
                          ),
                           child: Column(
                          children: [
                            Container(
                              margin:const EdgeInsets.only(top: 10),
                              child:const Text(
                                "FUTURE",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                            Container(
                                margin:const EdgeInsets.only(top: 10),
                                child: Image.asset(
                                  "images/future.png",
                                  height: 40,
                                  color: Colors.white,
                                )),
                            Container(
                              padding:const EdgeInsets.only(left: 4,right: 4),
                              margin:const EdgeInsets.only(top: 12),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "₹$Future_return",maxLines: 1,
                                  style:const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "(Monthly Returns)",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400),
                              ),
                            )
                          ],
                        ),
                      ),
                        Container(
                          height: 140,
                          width: 100,
                          margin:const EdgeInsets.only(top: 50,left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.1,
                                0.7,
                              ],
                              colors: [
                                ColorValues.Splash_bg_color1,
                                ColorValues.Splash_bg_color4,
                              ],
                            ),
                          ),
                          child:  Column(
                            children: [
                              Container(
                                margin:const EdgeInsets.only(top: 10),
                                child:const Text(
                                  "OPTION",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),

                              Container(
                                  margin:const EdgeInsets.only(top: 10),
                                  child: Image.asset(
                                    "images/option.png",
                                    height: 40,
                                    color: Colors.white,
                                  )
                              ),

                              Container(
                                padding:const EdgeInsets.only(left: 4,right: 4),
                                margin:const EdgeInsets.only(top: 12),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "₹$Option_return",maxLines: 1,
                                    style:const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),

                              Container(
                                child: Text(
                                  "(Monthly Returns)",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade400),
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                    ),

                    Container(
                      margin:const EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      child: Text("$ClosedTrades+ Trades Closed",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600,letterSpacing: 0.9,color: Colors.black,),),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: Text("-----------------  Till Date  -----------------",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.grey.shade500),),
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscribe()));
                      },
                      child: Container(
                        width: double.infinity,
                        margin:const EdgeInsets.only(left: 20,right: 20,top: 28),
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                              0.1,
                              0.7,
                            ],
                            colors: [
                              ColorValues.Splash_bg_color1,
                              ColorValues.Splash_bg_color3,
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child:const Text("Subscribe Now",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 18),),

                      ),
                    ),

                  ],
                ),
              );
            }
        );
      },
    );
  }

   Broker_dlink(){
     return showModalBottomSheet(
       isScrollControlled:true,
       context: context,
       builder: (BuildContext context) {
         return StatefulBuilder(
             builder: (BuildContext ctx, StateSetter setState) {
               return Container(
                   height: MediaQuery.of(context).size.height/5,
                   child:Column(
                     children: [
                       Container(
                         alignment: Alignment.topLeft,
                         margin:const EdgeInsets.only(top: 15,left: 15),
                         child:const Text("Do you want to delete Broker ?",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w500),),
                       ),

                       Container(
                         margin:const EdgeInsets.only(top: 25,left: 15,right: 15),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [

                             GestureDetector(
                               onTap: (){
                                 Navigator.pop(context);
                               },
                               child: Container(
                                 height: 40,
                                 width: MediaQuery.of(context).size.width/2.4,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4)
                                 ),
                                 alignment: Alignment.center,
                                 child: Text("No",style: TextStyle(color: ColorValues.Splash_bg_color1),),
                               ),
                             ),

                             GestureDetector(
                               onTap: () async {
                                 DeleteBrokerLink_Api();
                               },
                               child: Container(
                                 height: 40,
                                 alignment: Alignment.center,
                                 width: MediaQuery.of(context).size.width/2.4,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     border: Border.all(color: Colors.red,width: 0.4),
                                     color: Colors.red
                                 ),
                                 child:const Text("Yes",style: TextStyle(color: Colors.white),),
                               ),
                             ),

                           ],
                         ),
                       )
                     ],
                   )
               );
             }
         );
       },
     );
   }

   FreeTrial_popup(){
     return showModalBottomSheet(
       shape:const RoundedRectangleBorder(
           borderRadius: BorderRadius.only(
               topLeft: Radius.circular(15),
               topRight: Radius.circular(15)
           ),
       ),
       isScrollControlled:true,
       context: context,
       builder: (BuildContext context) {
         return StatefulBuilder(
             builder: (BuildContext ctx, StateSetter setState) {
               return Container(
                 height: 400,
                 // height: MediaQuery.of(context).size.height/2,
                 width: MediaQuery.of(context).size.width,
                 decoration:const BoxDecoration(
                     borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(15),
                         topRight: Radius.circular(15)
                     ),
                     image:DecorationImage(
                         fit: BoxFit.cover,
                         image: AssetImage("images/offernew_background.jpg",)
                     )
                 ),

                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     FreetrialDays==""||FreetrialDays==null?
                     Container(
                         margin:const EdgeInsets.only(left: 20,top: 20),
                         alignment: Alignment.topLeft,
                         child:const CircularProgressIndicator(color: Colors.black,)
                     )
                         :

                     Container(
                       margin:const EdgeInsets.only(left: 20,top: 20),
                       alignment: Alignment.topLeft,
                       child: Text("Get a Free Trial For $FreetrialDays Days",style:const TextStyle(fontSize: 22,fontWeight: FontWeight.w600),)
                     ),

                     Container(
                         margin:const EdgeInsets.only(left: 20,top: 7),
                         alignment: Alignment.topLeft,
                         child: Text("Try First & Decide Later",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,color: Colors.grey.shade600),)
                     ),

                     Container(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Container(
                             height: 100,
                             width: 100,
                             margin:const EdgeInsets.only(top: 60),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(7),
                                 color: ColorValues.Splash_bg_color1,
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [

                                 Container(
                                   child:const Text("CASH",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),),
                                 ),

                                 Container(
                                     margin:const EdgeInsets.only(top: 10),
                                     child:Image.asset("images/cash1.png",height: 40,color: Colors.white,)
                                 ),


                               ],
                             ),
                           ),

                           Container(
                             margin:const EdgeInsets.only(top: 10,left: 10),
                             height: 100,
                             width: 100,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(7),
                               color: ColorValues.Splash_bg_color1,
                             ),

                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Container(
                                   child:const Text(
                                     "FUTURE",
                                     style: TextStyle(
                                         fontSize: 15,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.white),
                                   ),
                                 ),

                                 Container(
                                     margin:const EdgeInsets.only(top: 10),
                                     child: Image.asset(
                                       "images/future.png",
                                       height: 40,
                                       color: Colors.white,
                                     )
                                 ),

                                 // Container(
                                 //   margin:const EdgeInsets.only(top: 12),
                                 //   child:const Text(
                                 //     "₹20,500",
                                 //     style: TextStyle(
                                 //         fontSize: 18,
                                 //         fontWeight: FontWeight.w600,
                                 //         color: Colors.white),
                                 //   ),
                                 // ),
                                 // Container(
                                 //   child: Text(
                                 //     "(Intraday Returns)",
                                 //     style: TextStyle(
                                 //         fontSize: 10,
                                 //         fontWeight: FontWeight.w500,
                                 //         color: Colors.grey.shade400),
                                 //   ),
                                 // )

                               ],
                             ),
                           ),

                           Container(
                             height: 100,
                             width: 100,
                             margin:const EdgeInsets.only(top: 60,left: 10),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(7),
                               color: ColorValues.Splash_bg_color1,
                             ),
                             child:  Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Container(
                                   margin:const EdgeInsets.only(top: 10),
                                   child:const Text(
                                     "OPTION",
                                     style: TextStyle(
                                         fontSize: 15,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.white),
                                   ),
                                 ),

                                 Container(
                                     margin:const EdgeInsets.only(top: 10),
                                     child: Image.asset(
                                       "images/option.png",
                                       height: 40,
                                       color: Colors.white,
                                     )
                                 ),

                                 // Container(
                                 //   margin:const EdgeInsets.only(top: 12),
                                 //   child:const Text(
                                 //     "₹30,500",
                                 //     style: TextStyle(
                                 //         fontSize: 18,
                                 //         fontWeight: FontWeight.w600,
                                 //         color: Colors.white),
                                 //   ),
                                 // ),
                                 //
                                 // Container(
                                 //   child: Text(
                                 //     "(Intraday Returns)",
                                 //     style: TextStyle(
                                 //         fontSize: 10,
                                 //         fontWeight: FontWeight.w500,
                                 //         color: Colors.grey.shade400),
                                 //   ),
                                 // ),

                               ],
                             ),
                           )
                         ],
                       ),
                     ),

                     GestureDetector(
                       onTap: isButtonDisabled
                           ? null
                           : () async {
                         setState(() {
                           isButtonDisabled = true;
                         });
                         await FreeTrial_Apii();
                       },
                       child: Container(
                         width: double.infinity,
                         margin:const EdgeInsets.only(left: 20,right: 20,top: 45),
                         height: 45,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(7),
                           gradient: isButtonDisabled ?
                          const LinearGradient(
                             begin: Alignment.centerLeft,
                             end: Alignment.centerRight,
                             stops: [
                               0.1,
                               0.7,
                             ],
                             colors: [
                               Colors.grey,
                               Colors.grey,
                             ],
                           ):
                           LinearGradient(
                             begin: Alignment.centerLeft,
                             end: Alignment.centerRight,
                             stops: [
                               0.1,
                               0.7,
                             ],
                             colors: [
                               ColorValues.Splash_bg_color1,
                               ColorValues.Splash_bg_color3,
                             ],
                           )
                         ),
                         alignment: Alignment.center,
                         child:const Text("Subscribe Now",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 18),),
                       ),
                     ),

                   ],
                 ),
               );
             }
         );
       },
     );
   }

  DematcredentialData_popup() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    elevation: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: const Text(
                              'Demat Data',
                              style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: const Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    content: Container(
                      // height:300,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Form(
                          child: Column(
                            children: [
                              const Divider(
                                color: Colors.black,
                              ),
                              Demat_Api_key==""||Demat_Api_key=="null"?
                              const SizedBox(height: 0,):
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 10, left: 10),
                                child: const Text(
                                  "Api Key",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),

                              Demat_Api_key==""||Demat_Api_key=="null"?
                              const SizedBox(height: 0,):
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width/1.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black,width: 0.4)
                                ),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 10, left: 10,right: 10),
                                child:  Text(
                                  "$Demat_Api_key",
                                  style:const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),

                              Demat_Api_secret==""||Demat_Api_secret=="null"?
                              const SizedBox(height: 0,):
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 20, left: 10),
                                child: const Text(
                                  "Api Secret",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),

                              Demat_Api_secret==""||Demat_Api_secret=="null"?
                              const SizedBox(height: 0,):
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width/1.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black,width: 0.4)
                                ),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 10, left: 10,right: 10),
                                child: Text(
                                  "$Demat_Api_secret",
                                  style:const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),

                              Demat_userId==""||Demat_userId=="null"?
                              const SizedBox(height: 0,):
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 20, left: 10),
                                child: const Text(
                                  "User Id",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),

                              Demat_userId==""||Demat_userId=="null"?
                              const SizedBox(height: 0,):
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width/1.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black,width: 0.4)
                                ),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 10, left: 10,right: 10),
                                child: Text(
                                  "$Demat_userId",
                                  style:const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }) ??
        false;
  }

  DisclaimerPopup(){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  width: MediaQuery.of(context).size.width,
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    elevation: 0,
                    // title: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //         child:const Text(
                    //           'Disclaimer',
                    //           style: TextStyle(color:Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
                    //         )),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.pop(context);
                    //       },
                    //       child: Container(
                    //         alignment: Alignment.topRight,
                    //         child: const Icon(
                    //           Icons.clear,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    content: IntrinsicHeight(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Container(
                                  child: Html(
                                    data:"$popupcontent",
                                    style: {
                                      "p": Style(fontSize: FontSize.medium),
                                    },
                                    onLinkTap: (url, _, __) {
                                      if (url != null) {
                                        _launchURL(url);
                                      }
                                    },
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 35,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: ColorValues.Splash_bg_color1
                                    ),
                                    child:const Text("I Agree",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                );
              });
        }) ??
        false;
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openWhatsApp({required String phone, String? message}) async {
    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$phone${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}",
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      // fallback or error
      print("Could not launch WhatsApp");
    }
  }


  List<String> reminders = [];
  bool? Status_reminder;

  Future<void> getReminders() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_broadcast = prefs.getString('Login_id');
    final response = await http.post(Uri.parse('${Util.BASE_URL1}planexpire'),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'client_id': '$Id_broadcast',
            }
        )
    );

    var jsonString = jsonDecode(response.body);
    Status_reminder=jsonString['status'];
    print("Status_reminder: $Status_reminder");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Extract the reminders list
      if (data.containsKey('reminders')) {
        reminders = List<String>.from(data['reminders']);
        print("Reminders: $reminders");

        // Optional: show popup for each reminder
        /*for (String reminder in reminders) {
          Future.delayed(Duration.zero, () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Reminder'),
                content: Text(reminder),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          });
        }*/

        // Set state if you're displaying them in UI
        setState(() {});
      }
    } else {
      print("Failed to load reminders");
    }
  }

  void showRightSideFlushbar(BuildContext context) {
    final flushbar = Flushbar(
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.black.withOpacity(0.75),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOut,
      messageText: Container(
        margin:const EdgeInsets.only(right: 30),
        child: Column(
          children: [
            ListView.builder(
              itemCount: reminders.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // Split the reminder text at comma
                List<String> parts = reminders[index].split('",');

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: ListTile(
                      leading:const Icon(Icons.notifications_active, color: Colors.orange),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parts[0],
                            style:const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          if (parts.length > 1)
                            Text(
                              parts.sublist(1).join(','),
                              style:const TextStyle(fontSize: 13),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscribe()));
                  },
                  child: Container(
                    margin:const EdgeInsets.only(left: 35),
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorValues.Splash_bg_color1
                    ),
                    alignment: Alignment.center,
                    child:const Text("Subscribe Now",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w600),),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin:const EdgeInsets.only(left: 20),
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red
                    ),
                    alignment: Alignment.center,
                    child:const Text("Skip",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w600),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Container(
      //       margin:const EdgeInsets.only(right: 30),
      //       child:const Text(
      //         'Hurry Up, Items added in your cart',
      //         style: TextStyle(color: Colors.white, fontSize: 16),),
      //     ),
      //     const SizedBox(height: 15),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Container(
      //           margin:const EdgeInsets.only(left: 35),
      //           height: 24,
      //           width: 80,
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(10),
      //               color: ColorValues.Splash_bg_color1
      //           ),
      //           alignment: Alignment.center,
      //           child:const Text("Subscribe Now",style: TextStyle(color: Colors.black,fontSize: 12),),
      //         ),
      //         Container(
      //           margin:const EdgeInsets.only(left: 20),
      //           height: 24,
      //           width: 80,
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(10),
      //               color: Colors.red
      //           ),
      //           alignment: Alignment.center,
      //           child:const Text("Skip",style: TextStyle(color: Colors.white,fontSize: 12),),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );

    Navigator.of(context).push(_createFlushbarRoute(flushbar));
  }

  Route _createFlushbarRoute(Flushbar flushbar) {
    return PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => flushbar,
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(1.0, 0.0);  // Slide in from the right
        const end = Offset(0.1, 0.0);    // Slight offset to the left
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

}
