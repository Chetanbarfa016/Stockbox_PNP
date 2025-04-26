import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Global_widgets/Logout.dart';
import 'package:stock_box/Screens/Main_screen/Kyc/Kyc_formView.dart';
import 'package:stock_box/Screens/Main_screen/Offline_payment.dart';
import 'package:stock_box/Screens/Main_screen/Profile.dart';
import 'package:stock_box/Screens/Main_screen/Thankyou.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stock_box/Screens/Onboarding_screen/Splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Subscribe extends StatefulWidget {
  const Subscribe({Key? key}) : super(key: key);

  @override
  State<Subscribe> createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {

  bool tap = false;
  int selectedIndex = -1;
  int selectedSubIndex = -1;

  int? _expandedIndex=0;

  var Plans=[];
  var SubscriptionPlans_rate;
  bool? Status;
  String loader="false";
  String? Price='';
  String? Validity='';
  String? CatTitle='';
  String? PlanTitle='';
  String category = '';

  List<List<bool>> Plansbycat=[];

  List<bool> initiallyExpanded =[];
  double? gstPrice;
  double? priceAfterGst;

  Subscription_Api() async {
    var data = await API.subscriptionPlans_Api();
    setState(() {
      Status = data['status'];
      Plans = data['data'];
      print("11111156789: $Plans");
      print("2222220000000: ${Plans.length}");
    });

    print("Dataaaaaa: $Plans");
    Price=Plans[0]['plans'][0]['price'].toStringAsFixed(2);

    gstPrice= (double.parse(Plans[0]['plans'][0]['price'].toStringAsFixed(2)) * double.parse(Gst.toString()))/100;

    priceAfterGst= GstStatus=="1"?
    double.parse(Price.toString()) + double.parse(gstPrice.toString()):
    double.parse(Price.toString());



    Validity=Plans[0]['plans'][0]['validity'].toString();

    CatTitle=Plans[0]['title'].toString();
    PlanTitle=Plans[0]['plans'][0]['title'].toString();

    category = '';
    for (int i = 0; i < Plans[0]['services'].length; i++) {
      category += "${Plans[0]['services'][i]['title']}+";
    }
    if (category.isNotEmpty && category.endsWith('+')) {
      category = category.substring(0, category.length - 1); // Remove the last character
    }

    if(Status==true){
      setState(() {});

      for(int i=0; i<Plans.length;i++){
        List<bool> sublist=[];

        for(int j=0; j<Plans[i]['plans'].length;j++){
          sublist.add(false);
        }

        Plansbycat.add(sublist);

      }

      Plansbycat[0][0]=true;

      print("Listtttttt: $Plansbycat");
      Plans.length>0?
      loader="true":
      loader="No_data";
    }

    else{
      print("error");
    }

  }

  addRequest_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_addRequest = prefs.getString('Login_id');
    var response = await http.post(Uri.parse(Util.AddRequest_Api),
        body: {
          "clientid":"$Id_addRequest",
          "type":"plan",
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    print("Status_Request : ${jsonString['status']}");
  }


  bool? Statuss;
  String? Messagee;
  String? Login_idd;
  String? Plans_id;

  AddSubscription_Api(PaymentId) async {
    try {
      // Show loader here
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (BuildContext context) {
      //     return const Center(child: CircularProgressIndicator());
      //   },
      // );
      openAlertBox();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      Login_idd = prefs.getString("Login_id");

      var response = await http.post(
        Uri.parse(Util.AddPlansSubscription_Api),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'plan_id': '${Plans_id == null ? Plans[0]['plans'][0]['_id'] : Plans_id}',
          'client_id': '$Login_idd',
          'price': '${FinalPrice == "" || FinalPrice == null ? priceAfterGst : FinalPrice}',
          'discount': '$Discount',
          'orderid': '$PaymentId',
          'coupon_code': '${Discount == 0.0 || Discount == null ? "" : coupon.text}',
        }),
      );

      var jsonString = jsonDecode(response.body);
      print("Jsnnnnnnpayment: $jsonString");

      // Hide loader
      // Navigator.of(context, rootNavigator: true).pop();

      Statuss = jsonString['status'];
      Messagee = jsonString['message'];

      if (Statuss == true) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$Messagee', style: const TextStyle(color: Colors.white)),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => Thankyou()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$Messagee', style: const TextStyle(color: Colors.white)),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {

      Navigator.of(context, rootNavigator: true).pop();

      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong! Please try again.', style: const TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  String? Message_coupon;
  double? Discount=0.0;
  String? FinalPrice='';
  String? gstaftercouponapply='';

  ApplyCoupon_Api() async {

    print(coupon.text);
    var response = await http.post(Uri.parse(Util.ApplyCoupon_Api),
        body:{
          'code': '${coupon.text}',
          'purchaseValue': '$Price',
          'planid': '${Plans_id==null?Plans[0]['plans'][0]['_id'] : Plans_id }',
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");

    Message_coupon=jsonString['message'];

    print("Message: $Message_coupon");

    if(Message_coupon=="Coupon applied successfully"){
      setState(() {

      });

      Discount=double.parse(jsonString['discount'].toString());
      FinalPrice=jsonString['finalPrice'].toStringAsFixed(2);
      gstaftercouponapply=jsonString['totalgst'].toStringAsFixed(2);

      print("FinalPrice: $FinalPrice");

      print("Discount: $Discount");

      Fluttertoast.showToast(
          msg: "$Message_coupon",
          backgroundColor: Colors.green,
          textColor: Colors.white
      );

      Navigator.pop(context);
    }

    else{
      Fluttertoast.showToast(
          msg: "$Message_coupon",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration:const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  late Razorpay _razorpay;


  var Coupons;
  bool? Status_coupon;
  bool loader_coupon=false;

  List<String> time=[];
  List expiryTime=[];

  Coupons_Api() async {
    var data = await API.Coupons_Api();
    setState(() {
      Status_coupon= data['status'];
    });


    if(Status_coupon==true){
      setState(() {});
      Coupons = data['data'];

      for(int i=0; i<Coupons.length; i++){
        time.add(Coupons[i]['enddate']);

        expiryTime = time.map((dateTimeString) {
          DateTime dateTime = DateTime.parse(dateTimeString);
          return DateFormat('dd MMM, yyyy HH:mm').format(dateTime);
        }).toList();
      }
      loader_coupon=true;
      // loader=true;
    }

    else{
      print("error");
    }

  }

  // String? Delete_status;
  // String? Active_status;
  // getAccountStatus() async {
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   Delete_status= prefs.getString("Delete_status");
  //   Active_status= prefs.getString("Active_status");
  //
  //   Delete_status=="1"||Active_status=="0"?
  //   handleLogout(context):
  //   print("Account not deleted");
  // }

  var Data_profile;
  bool? Status_profile;
  String? Delete_status_profile;
  String? Active_status_profile;
  bool loader_profile=false;
  String? Kyc_verification;
  Profile_Api() async {
    var data = await API.Profile_Api();
      Data_profile = data['data'];
      Status_profile = data['status'];

    if(Status_profile==true){
      setState(() {});
      Delete_status_profile=Data_profile['del'].toString();
      Active_status_profile=Data_profile['ActiveStatus'].toString();
      Kyc_verification= Data_profile['kyc_verification'].toString();
      print("Kyccccccccc profile: $Kyc_verification");

      Delete_status_profile=="1"||Active_status_profile=="0"?
      handleLogout(context):
      print("Account not deleted");

      loader_profile=true;
    }

    else{
      print("");
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken_Api();
    Coupons_Api();
    BasicSetting_Apii();
    Profile_Api();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);


  }

  String? razorpay_key ='';
  String? razorpay_secret ='';
  String? Online_payment_status ='';
  String? Offline_payment_status ='';
  var BasicSettingData;
  String? GstStatus='';
  String? Gst ='';
  String? Kycc ='';
  
  CallApi(){
    setState(() {
      api_call=false;
      BasicSetting_Apii();
      Profile_Api();
    });
  }
  

  bool api_call = true;
  BasicSetting_Apii() async {
    var data = await API.BesicSetting_Api();
    print("Data11111: $data");
    if(data['status']==true){
        razorpay_key = data['data']['razorpay_key'];
        razorpay_secret = data['data']['razorpay_secret'];
        Online_payment_status = data['data']['paymentstatus'].toString();
        Offline_payment_status = data['data']['officepaymenystatus'].toString();
        Kycc = data['data']['kyc'].toString();
        Gst = data['data']['gst'].toString();
        GstStatus = data['data']['gststatus'].toString();

      api_call == true?
      Subscription_Api():
          print("1");
    }else{}
  }

  bool? Status_token;
  checkToken_Api() async {
    var data = await API.checkToken();
      Status_token = data['status'];
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          titleSpacing: 0,
          backgroundColor: Colors.grey.shade200,
          elevation: 0.5,
          centerTitle: true,
          leading: GestureDetector(
              onTap: (){
                // ExtraOff_popup();
                Navigator.pop(context);
              },
              child:const Icon(Icons.arrow_back,color: Colors.black,)
          ),
          title:const Text("Plans for you",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
        ),

        bottomSheet:Price==null||Price==""?
        const SizedBox(height: 0,):

        Online_payment_status=="1"&& Offline_payment_status=="1" ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                int? amount= FinalPrice == "" || FinalPrice == null
                    ? (double.parse(priceAfterGst!.toString()) * 100).toInt()
                    : (double.parse(FinalPrice!) * 100).toInt();
                String? planId ='${Plans_id == null ? Plans[0]['plans'][0]['_id'] : Plans_id}';
                String? clientid= '$Login_idd';
                double? discount= Discount;
                String? couponCode= '${Discount == 0.0 || Discount == null ? "" : coupon.text}';
                String? type ="plan";
                String? Inv_amount="";

                addRequest_Api();
                Kyc_verification=="1"||Kycc=="0"?
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Offline_payment())):
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Kyc_formView(amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount: Inv_amount,))).then((value) => CallApi());
              },
              child: Container(
                width: MediaQuery.of(context).size.width/2.5,
                margin:const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: ColorValues.Splash_bg_color1
                ),
                alignment: Alignment.center,
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Pay offline",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16),),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                  int? amount= FinalPrice == "" || FinalPrice == null
                      ? (double.parse(priceAfterGst!.toString()) * 100).toInt()
                      : (double.parse(FinalPrice!) * 100).toInt();
                  String? planId ='${Plans_id == null ? Plans[0]['plans'][0]['_id'] : Plans_id}';
                  String? clientid= '$Login_idd';
                  double? discount= Discount;
                  String? couponCode= '${Discount == 0.0 || Discount == null ? "" : coupon.text}';
                  String? type="plan";
                  String? Inv_amount="";

                addRequest_Api();
                Kyc_verification=="1"||Kycc=="0"?
                openCheckout():
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Kyc_formView(amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount:Inv_amount,))).then((value) => CallApi());
              },
              child: Container(
                width: MediaQuery.of(context).size.width/2.5,
                margin:const EdgeInsets.only(left: 10,right: 20,bottom: 20),
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: ColorValues.Splash_bg_color1
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Pay ",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16),),
                    Container(
                      child:FinalPrice==""||FinalPrice==null?
                      Text("₹$priceAfterGst",style:const TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16),):
                      Text("₹$FinalPrice",style:const TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16),),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ):
        Online_payment_status=="1"&& Offline_payment_status=="0" ?
        GestureDetector(
          onTap: (){
            int? amount= FinalPrice == "" || FinalPrice == null
                ? (double.parse(priceAfterGst!.toString()) * 100).toInt()
                : (double.parse(FinalPrice!) * 100).toInt();
            String? planId ='${Plans_id == null ? Plans[0]['plans'][0]['_id'] : Plans_id}';
            String? clientid= '$Login_idd';
            double? discount= Discount;
            String? couponCode= '${Discount == 0.0 || Discount == null ? "" : coupon.text}';
            String? type="plan";
            String? Inv_amount="";
            addRequest_Api();

            Kyc_verification=="1"||Kycc=="0"?
            openCheckout():
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Kyc_formView(amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount:Inv_amount))).then((value) => CallApi());

          },
          child: Container(
            width: double.infinity,
            margin:const EdgeInsets.only(left: 20,right: 20,bottom: 20),
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: ColorValues.Splash_bg_color1
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Pay ",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16),),
                Container(
                  child:FinalPrice==""||FinalPrice==null?
                  Text("₹$priceAfterGst",style:const TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16),):
                  Text("₹$FinalPrice",style:const TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16),),
                ),
              ],
            ),
          ),
        ):
        Online_payment_status=="0"&& Offline_payment_status=="1" ?
        GestureDetector(
          onTap: (){
            int? amount= FinalPrice == "" || FinalPrice == null
                ? (double.parse(priceAfterGst!.toString()) * 100).toInt()
                : (double.parse(FinalPrice!) * 100).toInt();
            String? planId ='${Plans_id == null ? Plans[0]['plans'][0]['_id'] : Plans_id}';
            String? clientid= '$Login_idd';
            double? discount= Discount;
            String? couponCode= '${Discount == 0.0 || Discount == null ? "" : coupon.text}';
            String? type="plan";
            String? Inv_amount="";

            addRequest_Api();

            Kyc_verification=="1"||Kycc=="0"?
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Offline_payment())):
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Kyc_formView(amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount:Inv_amount))).then((value) => CallApi());

          },
          child: Container(
            width: double.infinity,
            margin:const EdgeInsets.only(left: 20,right: 20,bottom: 20),
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: ColorValues.Splash_bg_color1
            ),
            alignment: Alignment.center,
            child:const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Pay offline",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16),),
                // Container(
                //   child:FinalPrice==""||FinalPrice==null?
                //   Text("₹$Price",style:const TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 18),):
                //   Text("₹$FinalPrice",style:const TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 18),),
                // ),
              ],
            ),
          ),
        ):
        const SizedBox(),

        body: loader=="true" ?
        RefreshIndicator(
          onRefresh: () async{
            setState(() {
              Profile_Api();
            });
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              margin:const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Container(
                    child: ListView.builder(
                      key: Key('builder ${_expandedIndex.toString()}'),
                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
                      itemCount: Plans.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Plans[index]['plans'].length>0?
                        Card(
                          margin:const EdgeInsets.only(left: 15,right: 15,top: 20),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent, // Removes the underline
                            ),
                            child: ExpansionTile(
                              initiallyExpanded: index==_expandedIndex,

                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  if (expanded) {
                                    _expandedIndex = index; // Open the tapped tile
                                  } else {
                                    _expandedIndex = -1; // Close the tile if collapsed
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
                                          child: Text("${Plans[index]['title']}",style:const TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                                        ),

                                        Container(
                                          height: 25,
                                          width: 190,
                                          margin:const EdgeInsets.only(top: 2),
                                          child: ListView.builder(
                                            itemCount: Plans[index]['services'].length,
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int indexx) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    child: Text("${Plans[index]['services'][indexx]['title']}",style: TextStyle(fontSize: 13,color: Colors.grey.shade700),),
                                                  ),

                                                  Container(
                                                    padding:const EdgeInsets.only(left: 3,right: 3),
                                                    margin:const EdgeInsets.only(top: 2),
                                                    child: Text(
                                                        Plans[index]['services'].length==indexx+1?
                                                        "":"+",style: TextStyle(fontSize: 13,color: Colors.grey.shade700)),
                                                  ),

                                                ],
                                              );
                                            },
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                ],
                              ),

                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 20),
                                  height: 160,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Plans[index]['plans'].length,
                                    itemBuilder: (BuildContext context, int indexxx) {
                                      final isSelected = selectedIndex == index && selectedSubIndex == indexxx;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                            selectedSubIndex = indexxx;
                                          });

                                          Price = Plans[index]['plans'][indexxx]['price'].toString();
                                          gstPrice= (double.parse(Plans[index]['plans'][indexxx]['price'].toString()) * double.parse(Gst.toString()))/100;

                                          priceAfterGst= GstStatus=="1"?
                                          double.parse(Plans[index]['plans'][indexxx]['price'].toString()) + double.parse(gstPrice.toString()):
                                          double.parse(Plans[index]['plans'][indexxx]['price'].toString());

                                          Validity = Plans[index]['plans'][indexxx]['validity'].toString();
                                          CatTitle = Plans[index]['title'].toString();
                                          PlanTitle = Plans[index]['plans'][indexxx]['title'].toString();

                                          category = '';
                                          for (int i = 0; i < Plans[index]['services'].length; i++) {
                                            category += "${Plans[index]['services'][i]['title']}+";
                                          }
                                          if (category.isNotEmpty && category.endsWith('+')) {
                                            category = category.substring(0, category.length - 1);
                                          }

                                          print("CatTitle: $CatTitle");
                                          print("PlanTitle: $PlanTitle");
                                          print("cat: $category");

                                          Plans_id = Plans[index]['plans'][indexxx]['_id'];
                                          print("Plans_id: $Plans_id");

                                          Discount = 0.0;
                                          FinalPrice = "";
                                          coupon.clear();

                                          _scrollToBottom();
                                        },
                                        child: Card(
                                          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: isSelected ? ColorValues.Splash_bg_color1 : ColorValues.Splash_bg_color1,
                                              width: isSelected ? 1.5 : 0.2,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          child: Container(
                                            width: 100,
                                            height: 160,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 25,
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context).size.width / 3.3,
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),
                                                    ),
                                                    border: Border.all(color: ColorValues.Splash_bg_color1, width: 0.1),
                                                    color: isSelected ? ColorValues.Splash_bg_color1 : Color(0xffE4EfE9),
                                                  ),
                                                  child: Text(
                                                    "${Plans[index]['plans'][indexxx]['validity']}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: isSelected ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 15),
                                                  child: Text(
                                                    '₹${Plans[index]['plans'][indexxx]['price']}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                      color: isSelected ? Colors.black : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 22,
                                                  width: 80,
                                                  padding: const EdgeInsets.only(left: 4, right: 4),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: isSelected ? ColorValues.Splash_bg_color1 : ColorValues.Splash_bg_color1,
                                                  ),
                                                  margin: const EdgeInsets.only(top: 15),
                                                  child: Text(
                                                    '₹${Plans[index]['plans'][indexxx]['pricePerMonth'].toStringAsFixed(2)}/m',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style:const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap: (){
                                                    String? descriptionText=Plans[index]['plans'][indexxx]['description'];
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
                                                    margin: const EdgeInsets.only(top: 15),
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
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // Container(
                                //   margin:const EdgeInsets.only(left: 5,right: 5,top: 15,bottom: 20),
                                //    height: 140,
                                //   child: ListView.builder(
                                //     scrollDirection: Axis.horizontal,
                                //     // shrinkWrap: true,
                                //     itemCount: Plans[index]['plans'].length,
                                //     itemBuilder: (BuildContext context, int indexxx) {
                                //       return GestureDetector(
                                //         onTap: (){
                                //           Price=Plans[index]['plans'][indexxx]['price'].toString();
                                //           Validity=Plans[index]['plans'][indexxx]['validity'].toString();
                                //           CatTitle=Plans[index]['title'].toString();
                                //           PlanTitle=Plans[index]['plans'][indexxx]['title'].toString();
                                //           category = '';
                                //           for (int i = 0; i < Plans[index]['services'].length; i++) {
                                //             category += "${Plans[index]['services'][i]['title']}+";
                                //           }
                                //           if (category.isNotEmpty && category.endsWith('+')) {
                                //             category = category.substring(0, category.length - 1); // Remove the last character
                                //           }
                                //
                                //           print("CatTitle: $CatTitle");
                                //           print("PlanTitle: $PlanTitle");
                                //           print("cat: $category");
                                //
                                //           setState(() {
                                //             // Plansbycat.clear();
                                //             for(int i=0; i<Plans.length;i++){
                                //               List<bool> sublist=[];
                                //
                                //               for(int j=0; j<Plans[i]['plans'].length;j++){
                                //                 sublist.add(false);
                                //               }
                                //
                                //               Plansbycat.add(sublist);
                                //
                                //             }
                                //
                                //             Plansbycat[index][indexxx] =!Plansbycat[index][indexxx];
                                //
                                //             print(Plansbycat);
                                //             tap=!tap;
                                //             print("Tap: $tap");
                                //           });
                                //           Plans_id=Plans[index]['plans'][indexxx]['_id'];
                                //           print("Plans_id: $Plans_id");
                                //
                                //           Discount=0.0;
                                //           FinalPrice="";
                                //           coupon.clear();
                                //
                                //           _scrollToBottom();
                                //
                                //          },
                                //
                                //         child: Card(
                                //           margin:const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                //           elevation: 1,
                                //           shape: RoundedRectangleBorder(
                                //               borderRadius: BorderRadius.circular(10),
                                //               side:
                                //              //  Plansbycat[index][indexxx]==true?
                                //              // const BorderSide(
                                //              //    color: ColorValues.Splash_bg_color1,
                                //              //    width: 1.5,
                                //              //  ):
                                //              const BorderSide(
                                //                 color: ColorValues.Splash_bg_color1,
                                //                 width: 0.2,
                                //               )
                                //           ),
                                //           clipBehavior: Clip.antiAliasWithSaveLayer,
                                //           child: Container(
                                //             width: 100,
                                //             height: 140,
                                //             child: Column(
                                //               children: [
                                //                 Container(
                                //                     height: 25,
                                //                     alignment: Alignment.center,
                                //                     width: MediaQuery.of(context).size.width/3.3,
                                //                     decoration: BoxDecoration(
                                //                       borderRadius:const BorderRadius.only(
                                //                           topLeft: Radius.circular(10),
                                //                           topRight: Radius.circular(10)
                                //                       ),
                                //                       border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1),
                                //                       color:
                                //                       // Plansbycat[index][indexxx]==true?
                                //                       //     ColorValues.Splash_bg_color1:
                                //                       Color(0xffE4EfE9),
                                //                     ),
                                //                     child: Text("${Plans[index]['plans'][indexxx]['validity']}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,
                                //                         color:
                                //                         // Plansbycat[index][indexxx]==true?
                                //                         // Colors.white:
                                //                         Colors.black,
                                //                     ),)
                                //                 ),
                                //
                                //                 Container(
                                //                   margin:const EdgeInsets.only(top: 15),
                                //                   child: Text('₹${Plans[index]['plans'][indexxx]['price']}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,
                                //                   color:
                                //                   // Plansbycat[index][indexxx]==true?
                                //                   // Colors.black:
                                //                   Colors.grey,
                                //                   ),),
                                //                 ),
                                //
                                //                 // Container(
                                //                 //   alignment: Alignment.center,
                                //                 //   width: 80,
                                //                 //   margin:const EdgeInsets.only(top: 7),
                                //                 //   child: Text('${Plans[index]['plans'][indexxx]['title']}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,
                                //                 //     color:Plansbycat[index][indexxx]==true?
                                //                 //     Colors.black:
                                //                 //     Colors.grey,
                                //                 //   ),),
                                //                 // ),
                                //
                                //                 Container(
                                //                   height: 22,
                                //                   width: 80,
                                //                   padding:const EdgeInsets.only(left: 4,right: 4),
                                //                   alignment: Alignment.center,
                                //                   decoration: BoxDecoration(
                                //                       borderRadius: BorderRadius.circular(10),
                                //                       color: ColorValues.Splash_bg_color1
                                //                   ),
                                //                   margin:const EdgeInsets.only(top: 20),
                                //                   child: Text('₹${Plans[index]['plans'][indexxx]['pricePerMonth'].toStringAsFixed(2)}/m',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                //                 ),
                                //
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       );
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        )
                            :
                        const SizedBox(height: 0,);
                      },
                    ),
                  ),

                  Price==null||Price==""?
                  const SizedBox(height: 0,):
                  Container(
                    alignment: Alignment.topLeft,
                    margin:const EdgeInsets.only(top: 25,left: 15),
                    child:const Text("Plan Summary",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                  ),

                  Price==null||Price==""?
                  const SizedBox(height: 0,):
                  Container(
                    // height: 200,
                    width: double.infinity,
                    padding:const EdgeInsets.only(top: 10,bottom: 20),
                    margin:const EdgeInsets.only(top: 25,left: 20,right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorValues.Splash_bg_color1,)
                    ),
                    child: Column(
                      children: [
                        Discount==0.0||Discount==null?
                        const SizedBox(height: 0,):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                child: Image.asset("images/whistle.png",height: 25,width: 25,)
                            ),
                            Container(
                              margin:const EdgeInsets.only(top: 5,left: 10),
                              child:Discount==0.0||Discount==null?
                              const Text("Your total savings is off ₹0",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6),):
                              Text("Your total savings is off ₹${Discount!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6),),
                            ),
                          ],
                        ),

                        Discount==0.0||Discount==null?
                        const SizedBox(height: 0,):
                        Container(
                            margin:const EdgeInsets.only(top: 5),
                            child: Divider(color: Colors.grey.shade500,thickness: 0.2,)
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              margin:const EdgeInsets.only(top: 5,left: 20),
                              child: Text("$CatTitle ($category)",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),

                            ),
                            Container(
                              margin:const EdgeInsets.only(top: 5,right: 20),
                              child: Text("₹$Price",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:const EdgeInsets.only(top: 15,left: 20),
                              child:const Text("Validity :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                            ),

                            GestureDetector(
                              child: Container(
                                  margin:const EdgeInsets.only(top: 15,right: 20),
                                  child:  Text("$Validity",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),)
                              ),
                            ),
                          ],
                        ),

                        GstStatus=="1"?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:const EdgeInsets.only(top: 15,left: 20),
                              child: Text("GST ($Gst%) :",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                            ),

                            GestureDetector(
                              child: Container(
                                  margin:const EdgeInsets.only(top: 15,right: 20),
                                  child: gstaftercouponapply==null||gstaftercouponapply==""?
                                  Text("$gstPrice",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),):
                                  Text("${gstaftercouponapply}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),)
                              ),
                            ),
                          ],
                        ):
                        const SizedBox(height: 0,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:const EdgeInsets.only(top: 15,left: 20),
                              child:const Text("Coupon discount :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                            ),

                            GestureDetector(
                              onTap: (){
                                Apply_coupon();
                              },
                              child: Container(
                                margin:const EdgeInsets.only(top: 15,right: 20),
                                child:
                                Discount==0.0||Discount==null?
                                 Text("Apply Coupon",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color2),):

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("₹ -${Discount!.toStringAsFixed(2)}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: ColorValues.Splash_bg_color2),),

                                    GestureDetector(
                                      onTap: (){
                                        setState(() {

                                        });
                                        Discount=0.0;
                                        FinalPrice="";
                                        coupon.clear();
                                        gstaftercouponapply="";
                                      },
                                      child: Container(
                                          margin:const EdgeInsets.only(top: 2),
                                          child:const Text("Remove",style: TextStyle(color: Colors.red,fontSize: 10),)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        Container(
                            margin:const EdgeInsets.only(top: 5),
                            child: Divider(color: Colors.grey.shade500,thickness: 0.2,)
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:const EdgeInsets.only(top: 12,left: 20),
                              child:const Text("Grand total :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6),),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 12,right: 20),
                              child:FinalPrice==""||FinalPrice==null?
                              Text("₹${priceAfterGst!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6,color: Colors.black),):
                              Text("₹$FinalPrice",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6,color: Colors.black),),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ):

        loader=="false"?
        Container(
          child: Center(
              child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,)
          ),
        ):
        Container(
          child:const Center(
              child: Text("No Data Found...")
          ),
        )

    );
  }

  TextEditingController coupon =TextEditingController();
  String _appliedCoupon = '';
  Apply_coupon() async {
    final result = await showModalBottomSheet(
      isScrollControlled:true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin:const EdgeInsets.only(bottom: 20),
                    // height: MediaQuery.of(context).size.height/5,
                    child:Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin:const EdgeInsets.only(top: 15,left: 15),
                          child:const Text("Do you have coupon ?",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w500),),
                        ),

                        Container(
                          margin:const EdgeInsets.only(top: 25,left: 15,right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width/2,
                                // margin:const EdgeInsets.only(left: 15),
                                padding:const EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: ColorValues.Splash_bg_color2,
                                      width: 0.3
                                  ),
                                ),

                                child: TextFormField(
                                  controller: coupon,
                                  style:const TextStyle(fontSize: 14),
                                  textInputAction: TextInputAction.done,
                                  onSaved: (email) {},
                                  decoration: const InputDecoration(
                                    hintText: "Enter coupon code",
                                    enabledBorder:InputBorder.none,
                                    border: InputBorder.none,

                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: () async {
                                  if(coupon.text.trim()==""||coupon.text.trim()==null){
                                    Fluttertoast.showToast(
                                        msg: "Please enter coupon code",
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white
                                    );
                                  }
                                  else{
                                    ApplyCoupon_Api();
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width/3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.red,width: 0.4),
                                      color: ColorValues.Splash_bg_color1
                                  ),
                                  child:const Text("Apply",style: TextStyle(color: Colors.white),),
                                ),
                              ),

                            ],
                          ),
                        ),

                        Container(
                          alignment: Alignment.topLeft,
                          margin:const EdgeInsets.only(top: 25,left: 15),
                          child:const Text("Special Offer For You",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                        ),

                        Container(
                          height: 260,
                          margin:const EdgeInsets.only(top: 5),
                          child: ListView.builder(
                            itemCount: Coupons.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin:const EdgeInsets.only(left: 15,right: 15,bottom: 11,top: 11),
                                // height: 100,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.2)
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 124,
                                          decoration: BoxDecoration(
                                            // color: ColorValues.Splash_bg_color1,
                                            color: Color(0xcd354273),
                                            border: Border.all(color: Color(0xcd354273),),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: RotatedBox(
                                            quarterTurns: 3, // Rotates the text 90 degrees counterclockwise
                                            child: Text(
                                              "${Coupons[index]['serviceName']}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14, // Adjust the font size as needed
                                              ),
                                              textAlign: TextAlign.center, // Center align the text
                                              overflow: TextOverflow.ellipsis, // Add ellipsis if it overflows
                                              maxLines: 1, // Ensure it is a single line
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width/1.3,
                                          margin:const EdgeInsets.only(top: 5,left: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Image.asset("images/offer.png",height: 30,width: 30,),
                                                  ),
                                                  Container(
                                                    margin:const EdgeInsets.only(left: 5),
                                                    child:const Text("Limited Time Only",
                                                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),),
                                                  ),
                                                ],
                                              ),

                                              // Container(
                                              //   margin: EdgeInsets.only(left: 5),
                                              //   child: Text("Use code",style: TextStyle(fontSize: 12),),
                                              // ),
                                              Container(
                                                margin:const EdgeInsets.only(top: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(left: 10),
                                                      child: Text("Use Code :"),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 10),
                                                      height: 25,
                                                      width: 110,
                                                      alignment: Alignment.center,
                                                      padding:const EdgeInsets.only(left: 5,right: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          border: Border.all(color: ColorValues.Splash_bg_color2,width: 0.5)
                                                      ),

                                                      child: Text("${Coupons[index]['code']}",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                                    ),

                                                    // GestureDetector(
                                                    //   onTap: () => copyToClipboard(context, "${Coupons[index]['code']}"),
                                                    //   child: Container(
                                                    //     height: 25,
                                                    //     alignment: Alignment.center,
                                                    //     padding:const EdgeInsets.only(left: 10,right: 8),
                                                    //     margin:const EdgeInsets.only(left: 20),
                                                    //     decoration: BoxDecoration(
                                                    //         borderRadius: BorderRadius.circular(3),
                                                    //         color: ColorValues.Splash_bg_color2
                                                    //     ),
                                                    //     child: Icon(Icons.copy,color: Colors.white,size: 15,),
                                                    //   ),
                                                    // ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        coupon.text=Coupons[index]['code'];
                                                        ApplyCoupon_Api();
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        alignment: Alignment.center,
                                                        padding:const EdgeInsets.only(left: 12,right: 12),
                                                        margin:const EdgeInsets.only(left: 15),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(3),
                                                            color: ColorValues.Splash_bg_color1
                                                        ),

                                                        child:const Text("Apply",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600,color: Colors.white),),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Coupons[index]['type']=="percentage"?
                                              Container(
                                                margin: EdgeInsets.only(left: 10,top: 10),
                                                child: RichText(
                                                  text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "${Coupons[index]['value']}%",
                                                          style: TextStyle(fontSize:16,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                                        ),
                                                        TextSpan(
                                                          text: " Off",
                                                          style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                                        ),
                                                        TextSpan(
                                                            text: ",  ${Coupons[index]['name']} Offer",
                                                            style:const TextStyle(fontSize: 12,letterSpacing: 0.01,fontWeight: FontWeight.w500,color: Colors.black)
                                                        ),
                                                      ]),),
                                              ):
                                              Container(
                                                margin:const EdgeInsets.only(left: 10,top: 10),
                                                child: RichText(
                                                  text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "Save Upto ",
                                                          style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                                        ),
                                                        TextSpan(
                                                          text: "₹${Coupons[index]['value']}",
                                                          style: TextStyle(fontSize:14,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                                        ),
                                                        TextSpan(
                                                            text: ",  ${Coupons[index]['name']} Offer",
                                                            style: TextStyle(fontSize: 12,letterSpacing: 0.01,fontWeight: FontWeight.w500,color: Colors.black)
                                                        ),
                                                      ]),),
                                              ),


                                              Container(
                                                margin:const EdgeInsets.only(left: 10, top: 7,bottom: 10),
                                                child:  RichText(
                                                  text: TextSpan(
                                                      children: [
                                                        // TextSpan(
                                                        //     text: "*${Coupons[index]['name']}",
                                                        //     style: TextStyle(fontSize: 10,letterSpacing: 0.01,fontWeight: FontWeight.bold,color: Colors.black)
                                                        // ),
                                                        TextSpan(
                                                          text: "Minimum Purchase value ",
                                                          style: TextStyle(fontSize: 14,letterSpacing: 0.01, color: Colors.black87, fontWeight: FontWeight.w300),),
                                                        TextSpan(
                                                            text: "₹${Coupons[index]['minpurchasevalue']}",
                                                            style: TextStyle(fontSize: 14,letterSpacing: 0.01,fontWeight: FontWeight.w900,color: ColorValues.Splash_bg_color1)),
                                                      ]),),

                                                /*Text("*${Coupons[index]['name']} offer Minmum Purchase value ₹${Coupons[index]['minpurchasevalue']}",
                                style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black54),),*/
                                              ),


                                              // Container(
                                              //   // height: 99,
                                              //   // width: MediaQuery.of(context).size.width/3.5+30,
                                              //   // alignment: Alignment.center,
                                              //   child: Column(
                                              //     mainAxisAlignment: MainAxisAlignment.center,
                                              //     children: [
                                              //       Coupons[index]['type']=="percentage"?
                                              //       RichText(
                                              //         text: TextSpan(
                                              //             children: [
                                              //               TextSpan(
                                              //                 text: "${Coupons[index]['value']}%",
                                              //                 style: TextStyle(fontSize:16,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                              //               ),
                                              //               TextSpan(
                                              //                 text: " Off",
                                              //                 style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                              //               ),]),):
                                              //       RichText(
                                              //         text: TextSpan(
                                              //             children: [
                                              //               TextSpan(
                                              //                 text: "Upto ",
                                              //                 style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                              //               ),
                                              //               TextSpan(
                                              //                 text: "₹${Coupons[index]['value']}",
                                              //                 style: TextStyle(fontSize:16,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                              //               ),
                                              //             ]),),
                                              //       Container(
                                              //         margin:const EdgeInsets.only(left: 4, right: 5 , top: 5),
                                              //         child:  RichText(
                                              //           text: TextSpan(
                                              //               children: [
                                              //                 TextSpan(
                                              //                     text: "*${Coupons[index]['name']}",
                                              //                     style: TextStyle(fontSize: 10,letterSpacing: 0.01,fontWeight: FontWeight.bold,color: Colors.black)),
                                              //                 TextSpan(
                                              //                   text: " offer Minimum Purchase value ",
                                              //                   style: TextStyle(fontSize: 8,letterSpacing: 0.01, color: Colors.black87, fontWeight: FontWeight.w500),),
                                              //                 TextSpan(
                                              //                     text: "₹${Coupons[index]['minpurchasevalue']}",
                                              //                     style: TextStyle(fontSize: 12,letterSpacing: 0.01,fontWeight: FontWeight.w900,color: ColorValues.Splash_bg_color1)),
                                              //               ]),),
                                              //
                                              //         /*Text("*${Coupons[index]['name']} offer Minmum Purchase value ₹${Coupons[index]['minpurchasevalue']}",
                                              //     style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black54),),*/
                                              //       ),
                                              //
                                              //     ],
                                              //   ),
                                              // )

                                              // Container(
                                              //   alignment: Alignment.bottomLeft,
                                              //   margin:const EdgeInsets.only(top: 8,left: 5),
                                              //   width: MediaQuery.of(context).size.width/1.5,
                                              //   child: Text("Expires on ${expiryTime[index]}",
                                              //     style:const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.black),),
                                              // ),

                                            ],
                                          ),
                                        ),
                                        //  Container(
                                        //   height: 95,
                                        //   width: 0.2,
                                        //   margin: EdgeInsets.only(top: 2, bottom: 2),
                                        //   color: ColorValues.Splash_bg_color1
                                        // ),
                                        //  Container(
                                        //    height: 99,
                                        //    width: MediaQuery.of(context).size.width/3.5+30,
                                        //    alignment: Alignment.center,
                                        //    child: Column(
                                        //      mainAxisAlignment: MainAxisAlignment.center,
                                        //      children: [
                                        //        Coupons[index]['type']=="percentage"?
                                        //        RichText(
                                        //          text: TextSpan(
                                        //            children: [
                                        //               TextSpan(
                                        //                text: "${Coupons[index]['value']}%",
                                        //                style: TextStyle(fontSize:16,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                        //              ),
                                        //              TextSpan(
                                        //                text: " Off",
                                        //                style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                        //              ),]),):
                                        //        RichText(
                                        //          text: TextSpan(
                                        //            children: [
                                        //              TextSpan(
                                        //                text: "Upto ",
                                        //                style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                        //              ),
                                        //               TextSpan(
                                        //                text: "₹${Coupons[index]['value']}",
                                        //                style: TextStyle(fontSize:16,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                        //              ),
                                        //            ]),),
                                        //        Container(
                                        //          margin:const EdgeInsets.only(left: 4, right: 5 , top: 5),
                                        //          child:  RichText(
                                        //            text: TextSpan(
                                        //                children: [
                                        //                   TextSpan(
                                        //                    text: "*${Coupons[index]['name']}",
                                        //                      style: TextStyle(fontSize: 10,letterSpacing: 0.01,fontWeight: FontWeight.bold,color: Colors.black)),
                                        //                  TextSpan(
                                        //                    text: " offer Minimum Purchase value ",
                                        //                    style: TextStyle(fontSize: 8,letterSpacing: 0.01, color: Colors.black87, fontWeight: FontWeight.w500),),
                                        //                  TextSpan(
                                        //                      text: "₹${Coupons[index]['minpurchasevalue']}",
                                        //                      style: TextStyle(fontSize: 12,letterSpacing: 0.01,fontWeight: FontWeight.w900,color: ColorValues.Splash_bg_color1)),
                                        //                ]),),
                                        //
                                        //          /*Text("*${Coupons[index]['name']} offer Minmum Purchase value ₹${Coupons[index]['minpurchasevalue']}",
                                        //            style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black54),),*/
                                        //        ),
                                        //
                                        //      ],
                                        //    ),
                                        //  )
                                      ],
                                    ),
                                  ],
                                ),

                                //   Column(
                                //     children: [
                                //       Row(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           Container(
                                //             width: 40,
                                //             height: 99,
                                //             decoration: BoxDecoration(
                                //               color: ColorValues.Splash_bg_color1,
                                //               border: Border.all(color: ColorValues.Splash_bg_color1),
                                //               borderRadius: BorderRadius.only(
                                //                 topLeft: Radius.circular(6),
                                //                 bottomLeft: Radius.circular(6),
                                //               ),
                                //             ),
                                //             alignment: Alignment.center,
                                //             child: RotatedBox(
                                //               quarterTurns: 3, // Rotates the text 90 degrees counterclockwise
                                //               child: Text(
                                //                 "FLAT OFF",
                                //                 style: TextStyle(
                                //                   color: Colors.white,
                                //                   fontWeight: FontWeight.w600,
                                //                   fontSize: 14, // Adjust the font size as needed
                                //                 ),
                                //                 textAlign: TextAlign.center, // Center align the text
                                //                 overflow: TextOverflow.ellipsis, // Add ellipsis if it overflows
                                //                 maxLines: 1, // Ensure it is a single line
                                //               ),
                                //             ),
                                //           ),
                                //           Container(
                                //             width: MediaQuery.of(context).size.width/2,
                                //             margin:const EdgeInsets.only(top: 5,left: 0),
                                //             child: Column(
                                //               mainAxisAlignment: MainAxisAlignment.start,
                                //               crossAxisAlignment: CrossAxisAlignment.start,
                                //               children: [
                                //                 Row(
                                //                   children: [
                                //                     Container(
                                //                       child: Image.asset("images/offer.png",height: 30,width: 30,),
                                //                     ),
                                //                     Container(
                                //                       margin:const EdgeInsets.only(left: 4),
                                //                       child:const Text("Limited Time Only",
                                //                         style: TextStyle(fontSize: 14,letterSpacing: 0.01,fontWeight: FontWeight.bold,color: Colors.black),),
                                //                     ),
                                //                   ],
                                //                 ),
                                //
                                //                 Container(
                                //                   margin: EdgeInsets.only(left: 5),
                                //                   child: Text("Use code"),
                                //                 ),
                                //                 Container(
                                //                   margin:const EdgeInsets.only(top: 5),
                                //                   child: Row(
                                //                     mainAxisAlignment: MainAxisAlignment.start,
                                //                     children: [
                                //                       Container(
                                //                         margin: EdgeInsets.only(left: 5),
                                //                         height: 25,
                                //                         width: 110,
                                //                         alignment: Alignment.center,
                                //                         padding:const EdgeInsets.only(left: 5,right: 5),
                                //                         decoration: BoxDecoration(
                                //                             borderRadius: BorderRadius.circular(3),
                                //                             border: Border.all(color: ColorValues.Splash_bg_color2,width: 0.5)
                                //                         ),
                                //
                                //                         child: Text("${Coupons[index]['code']}",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                //                       ),
                                //
                                //                       GestureDetector(
                                //                         onTap: (){
                                //                           coupon.text=Coupons[index]['code'];
                                //                           ApplyCoupon_Api();
                                //                         },
                                //                         child: Container(
                                //                           height: 25,
                                //                           alignment: Alignment.center,
                                //                           padding:const EdgeInsets.only(left: 12,right: 12),
                                //                           margin:const EdgeInsets.only(left: 25),
                                //                           decoration: BoxDecoration(
                                //                               borderRadius: BorderRadius.circular(3),
                                //                               color: ColorValues.Splash_bg_color1
                                //                           ),
                                //
                                //                           child:const Text("Apply",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600,color: Colors.white),),
                                //                         ),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //
                                //                 // Container(
                                //                 //   alignment: Alignment.bottomLeft,
                                //                 //   margin:const EdgeInsets.only(top: 8,left: 5),
                                //                 //   width: MediaQuery.of(context).size.width/1.5,
                                //                 //   child: Text("Expires on ${expiryTime[index]}",
                                //                 //     style:const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.black),),
                                //                 // ),
                                //
                                //               ],
                                //             ),
                                //           ),
                                //
                                //           /*Container(
                                //             margin:const EdgeInsets.only(top: 13,left: 10),
                                //             width: MediaQuery.of(context).size.width/2,
                                //             child: Column(
                                //               mainAxisAlignment: MainAxisAlignment.start,
                                //               crossAxisAlignment: CrossAxisAlignment.start,
                                //               children: [
                                //                 Row(
                                //                   children: [
                                //                     Container(
                                //                       child: Image.asset("images/offer.png",height: 30,width: 30,),
                                //                     ),
                                //                     Container(
                                //                       margin:const EdgeInsets.only(left: 4),
                                //                       width: MediaQuery.of(context).size.width/1.5,
                                //                       child:const Text("Limited Time Only",
                                //                         style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),),
                                //                     ),
                                //                   ],
                                //                 ),
                                //                 Container(
                                //                   margin: EdgeInsets.only(left: 5),
                                //                   child: Text("Use code : "),
                                //                 ),
                                //
                                //                 Container(
                                //                   margin:const EdgeInsets.only(top: 12),
                                //                   child: Row(
                                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                     children: [
                                //                       Row(
                                //                         mainAxisAlignment: MainAxisAlignment.start,
                                //                         children: [
                                //                           Container(
                                //                             margin: EdgeInsets.only(left: 5),
                                //                             height: 25,
                                //                             width: 100,
                                //                             alignment: Alignment.center,
                                //                             padding:const EdgeInsets.only(left: 5,right: 5),
                                //                             decoration: BoxDecoration(
                                //                                 borderRadius: BorderRadius.circular(3),
                                //                                 border: Border.all(color: ColorValues.Splash_bg_color2,width: 0.5)
                                //                             ),
                                //
                                //                             child: Text("${Coupons[index]['code']}",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                //                           ),
                                //                         ],
                                //                       ),
                                //
                                //                       GestureDetector(
                                //                         onTap: (){
                                //                           coupon.text=Coupons[index]['code'];
                                //                           ApplyCoupon_Api();
                                //                         },
                                //                         child: Container(
                                //                           height: 25,
                                //                           alignment: Alignment.center,
                                //                           padding:const EdgeInsets.only(left: 12,right: 12),
                                //                           margin:const EdgeInsets.only(left: 25),
                                //                           decoration: BoxDecoration(
                                //                               borderRadius: BorderRadius.circular(3),
                                //                               color: ColorValues.Splash_bg_color1
                                //                           ),
                                //
                                //                           child:const Text("Apply",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600,color: Colors.white),),
                                //                         ),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //
                                //               ],
                                //             ),
                                //           ),*/
                                //           Container(
                                //               height: 95,
                                //               width: 0.2,
                                //               margin: EdgeInsets.only(top: 2, bottom: 2),
                                //               color: ColorValues.Splash_bg_color1
                                //           ),
                                //           Container(
                                //             height: 99,
                                //             width: MediaQuery.of(context).size.width/3.5+20,
                                //             alignment: Alignment.center,
                                //             child: Column(
                                //               mainAxisAlignment: MainAxisAlignment.center,
                                //               children: [
                                //                 Coupons[index]['type']=="percentage"?
                                //                 RichText(
                                //                   text: TextSpan(
                                //                       children: [
                                //                         TextSpan(
                                //                           text: "${Coupons[index]['value']}%",
                                //                           style: TextStyle(fontSize:16,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                //                         ),
                                //                         TextSpan(
                                //                           text: " Off",
                                //                           style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                //                         ),]),):
                                //                 RichText(
                                //                   text: TextSpan(
                                //                       children: [
                                //                         TextSpan(
                                //                           text: "Upto ",
                                //                           style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                //                         ),
                                //                         TextSpan(
                                //                           text: "₹${Coupons[index]['value']}",
                                //                           style: TextStyle(fontSize:16,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                //                         ),
                                //                       ]),),
                                //                 Container(
                                //                   margin:const EdgeInsets.only(left: 4, right: 5),
                                //                   child:  RichText(
                                //                     text: TextSpan(
                                //                         children: [
                                //                           TextSpan(
                                //                               text: "*${Coupons[index]['name']}",
                                //                               style: TextStyle(fontSize: 10,letterSpacing: 0.01,fontWeight: FontWeight.bold,color: Colors.black)),
                                //                           TextSpan(
                                //                             text: " offer Minimum Purchase value ",
                                //                             style: TextStyle(fontSize: 8,letterSpacing: 0.01, color: Colors.grey, fontWeight: FontWeight.w500),),
                                //                           TextSpan(
                                //                               text: "₹${Coupons[index]['minpurchasevalue']}",
                                //                               style: TextStyle(fontSize: 12,letterSpacing: 0.01,fontWeight: FontWeight.w900,color: ColorValues.Splash_bg_color1)),
                                //                         ]),),
                                //
                                //                   /*Text("*${Coupons[index]['name']} offer Minmum Purchase value ₹${Coupons[index]['minpurchasevalue']}",
                                // style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black54),),*/
                                //                 ),
                                //
                                //               ],
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                              );
                            },

                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            }
        );
      },
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _appliedCoupon = result;
      });
    }
  }


  void openCheckout() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Name= prefs.getString("FullName");
    String? Email= prefs.getString("Email");
    String? PhoneNo= prefs.getString("PhoneNo");
    print("11111: $FinalPrice");
    print("22222: $Price");
    var options = {
      // 'key': 'rzp_test_22mEHcDzJbcUmz',
      'key': '$razorpay_key',
      'amount': FinalPrice == "" || FinalPrice == null
          ? (double.parse(priceAfterGst!.toString()) * 100).toInt()
          : (double.parse(FinalPrice!) * 100).toInt(),
      'name': '$Name',
      // 'description': 'Research Service Charges',
      'retry': {'enabled': true, 'max_count': 1},
      'prefill': {'contact': '$PhoneNo', 'email': '$Email'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   String? paymentId = response.paymentId;
  //   print("PaymentId: $paymentId");
  //
  //   // ✅ Show loader immediately after Razorpay closes
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     openAlertBox();
  //   });
  //
  //   try {
  //     var paymentStatusUrl = 'https://api.razorpay.com/v1/payments/$paymentId';
  //     var headers = {
  //       'Authorization': 'Basic ' + base64Encode(utf8.encode('$razorpay_key:$razorpay_secret')),
  //       'Content-Type': 'application/json',
  //     };
  //
  //     var statusResponse = await http.get(Uri.parse(paymentStatusUrl), headers: headers);
  //     var paymentData = jsonDecode(statusResponse.body);
  //
  //     if (paymentData['status'] == 'authorized') {
  //       double finalAmount = safeParse(FinalPrice) == 0.0
  //           ? safeParse(priceAfterGst?.toString())
  //           : safeParse(FinalPrice);
  //
  //       var captureUrl = 'https://api.razorpay.com/v1/payments/$paymentId/capture';
  //       var body = jsonEncode({
  //         'amount': (finalAmount * 100).toInt(),
  //         'currency': 'INR',
  //       });
  //
  //       var captureResponse = await http.post(Uri.parse(captureUrl), headers: headers, body: body);
  //
  //       if (captureResponse.statusCode == 200) {
  //         print("Payment Captured Successfully: ${captureResponse.body}");
  //         await AddSubscription_Api(paymentId); // This will auto pop the loader
  //       } else {
  //         Navigator.pop(context); // hide loader
  //         var errorResponse = jsonDecode(captureResponse.body);
  //         Fluttertoast.showToast(
  //           msg: "Payment Capture Failed: ${errorResponse['error']['description'] ?? 'Unknown Error'}",
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //         );
  //       }
  //     } else {
  //       Navigator.pop(context); // hide loader if unauthorized
  //       print("Payment is not authorized, cannot capture.");
  //     }
  //   } catch (e) {
  //     Navigator.pop(context); // hide loader on error
  //     Fluttertoast.showToast(
  //       msg: "Capture Error: $e",
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   }
  // }
  // openAlertBox() async {
  //   setState(() {});
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return GestureDetector(
  //         onTap: () {},
  //         child: AlertDialog(
  //           insetPadding:const EdgeInsets.all(10),
  //           contentPadding: EdgeInsets.zero,
  //           content: SizedBox(
  //             height: 120, // Static height
  //             width: 50,  // Static width
  //             child: Container(
  //               color: Colors.white,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   const CircularProgressIndicator(color: Colors.black),
  //                   const SizedBox(height: 10),
  //                   Text(
  //                     "Please hold on..",
  //                     style: TextStyle(
  //                       color: Colors.grey.shade600,
  //                       fontSize: 11,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("_handlePaymentSuccess paymentId == ${response.paymentId}");
    print("_handlePaymentSuccess orderId == ${response.orderId}");
    print("_handlePaymentSuccess signature== ${response.signature}");
    print("_handlePaymentSuccess data== ${response.data}");
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!,
    //     gravity: ToastGravity.CENTER,
    //     toastLength: Toast.LENGTH_SHORT);
    String? PaymentId=response.paymentId;
    print("PaymentId: $PaymentId");
    AddSubscription_Api(PaymentId);
  }

  openAlertBox() async {
    setState(() {});
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {},
          child: AlertDialog(
            insetPadding:const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              height: 120, // Static height
              width: 50,  // Static width
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.black),
                    const SizedBox(height: 10),
                    Text(
                      "Please hold on..",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  double safeParse(String? value, {double defaultValue = 0.0}) {
    if (value == null || value.isEmpty) {
      return defaultValue;
    }
    try {
      return double.parse(value);
    } catch (e) {
      print("Error parsing double: $e");
      return defaultValue;
    }
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment cancelled by user",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT);
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   String? paymentId = response.paymentId;
  //   print("PaymentId: $paymentId");
  //
  //   // Capture Payment API Call
  //   try {
  //     var url = 'https://api.razorpay.com/v1/payments/$paymentId/capture';
  //     var headers = {
  //       'Authorization': 'Basic ' + base64Encode(utf8.encode('$razorpay_key:$razorpay_secret')),
  //       'Content-Type': 'application/json',
  //     };
  //     var body = jsonEncode({
  //       'amount': (double.parse(FinalPrice ?? priceAfterGst!.toString()) * 100).toInt(),
  //     });
  //
  //     var captureResponse = await http.post(Uri.parse(url), headers: headers, body: body);
  //     if (captureResponse.statusCode == 200) {
  //       print("Payment Captured Successfully: ${captureResponse.body}");
  //       AddSubscription_Api(paymentId);
  //     } else {
  //       print("Capture Failed: ${captureResponse.body}");
  //     }
  //   } catch (e) {
  //     print("Capture Error: $e");
  //   }
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   print("_handlePaymentSuccess paymentId == ${response.paymentId}");
  //   print("_handlePaymentSuccess orderId == ${response.orderId}");
  //   print("_handlePaymentSuccess signature== ${response.signature}");
  //   print("_handlePaymentSuccess data== ${response.data}");
  //
  //   // Fluttertoast.showToast(
  //   //     msg: "SUCCESS: " + response.paymentId!,
  //   //     gravity: ToastGravity.CENTER,
  //   //     toastLength: Toast.LENGTH_SHORT);
  //
  //   String? PaymentId=response.paymentId;
  //   print("PaymentId: $PaymentId");
  //
  //   AddSubscription_Api(PaymentId);
  //
  //   // String? paymentId = response.paymentId;
  //   //
  //   // String? orderId = response.orderId;
  //   //
  //   // String? signature = response.signature;
  //
  //   // payment_Api(paymentId, orderId, signature, Price_final);
  // }

  ExtraOff_popup() async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration:const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin:const EdgeInsets.only(left: 25,right: 25,bottom: 11,top: 30),
                      height: 110,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.9)
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 108,
                                decoration: BoxDecoration(
                                  color:const Color(0xffE4EfE9),
                                  border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1),
                                  borderRadius:const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child:const RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    "Just For You",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),

                              Container(
                                margin:const EdgeInsets.only(top: 20,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:const EdgeInsets.only(left: 65),
                                      child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'EXTRA ',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                      fontSize: 16
                                                  ),
                                                ),

                                                TextSpan(
                                                  text: '₹75 ',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorValues.Splash_bg_color1,
                                                      fontSize: 25
                                                  ),
                                                ),

                                                TextSpan(
                                                  text: 'OFF',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                      fontSize: 16
                                                  ),
                                                ),
                                              ])),
                                    ),
                                    Container(
                                        margin:const EdgeInsets.only(top: 8,left: 40),
                                        child: Row(
                                          children: [
                                            Container(
                                              child:const Text("Offer ends in "),
                                            ),

                                            Container(
                                              height: 20,
                                              width: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: ColorValues.Splash_bg_color1
                                              ),
                                              child:const Text("20 m",style: TextStyle(color: Colors.white,fontSize: 10),),
                                            ),
                                            Container(
                                              margin:const EdgeInsets.only(left: 5),
                                              child:const Text(":"),
                                            ),
                                            Container(
                                              margin:const EdgeInsets.only(left: 5),
                                              height: 20,
                                              width: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: ColorValues.Splash_bg_color1
                                              ),
                                              child:const Text("52 s",style: TextStyle(color: Colors.white,fontSize: 10),),
                                            ),

                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin:const EdgeInsets.only(top: 40,left: 20,right: 20),
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: ColorValues.Splash_bg_color1
                      ),
                      alignment: Alignment.center,
                      child:const Text("Claim Extra Discount",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 15),),
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        margin:const EdgeInsets.only(top: 15,left: 20,right: 20,bottom: 20),
                        alignment: Alignment.center,
                        child:const Text("No, thanks. I will pay full price later!",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 13),),

                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        );
      },
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
                    margin: const EdgeInsets.only(top: 5),
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
