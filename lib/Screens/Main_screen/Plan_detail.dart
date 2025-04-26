import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Kyc/Kyc_formView.dart';
import 'package:stock_box/Screens/Main_screen/Offline_payment.dart';
import 'package:stock_box/Screens/Main_screen/Thankyou.dart';
import '../../Constants/Util.dart';
import 'package:http/http.dart' as http;

class Plan_detail extends StatefulWidget {
  var PlanDetail;
  String? Services;
  Plan_detail({Key? key,required this.PlanDetail,required this.Services}) : super(key: key);

  @override
  State<Plan_detail> createState() => _Plan_detailState(PlanDetail:PlanDetail,Services:Services);
}

class _Plan_detailState extends State<Plan_detail> {
  var PlanDetail;
  String? Services;
  late Razorpay _razorpay;

  _Plan_detailState({
    required this.PlanDetail,
    required this.Services
  });

  String? Message_coupon;

  double? Discount=0.0;
  String? FinalPrice='';
  String? gstaftercouponapply='';

  ApplyCoupon_Api() async {
    var response = await http.post(Uri.parse(Util.ApplyCoupon_Api),
        body:{
          'code': '${coupon.text}',
          'purchaseValue': '${PlanDetail['price']}',
          'planid': '${PlanDetail['_id']}',
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


  var Coupons;
  bool? Status_coupon;
  bool loader_coupon=false;
  bool loader=false;

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
      loader=true;
    }

    else{
      print("error");
    }

  }

  bool? Statuss;
  String? Messagee;
  String? Login_idd;
  String? Plans_id;

  AddSubscription_Api(PaymentId) async {
    // Show loader
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );

    print("Plansssss: $Plans_id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Login_idd = prefs.getString("Login_id");

    try {
      var response = await http.post(Uri.parse(Util.AddPlansSubscription_Api),
          headers: {
            'Content-Type': 'application/json',
          },
          body:jsonEncode(
              {
                'plan_id': '${PlanDetail['_id']}',
                'client_id': '$Login_idd',
                'price': '${FinalPrice==""||FinalPrice==null? priceAfterGst : FinalPrice}',
                'discount': '$Discount',
                'orderid': '$PaymentId',
                'coupon_code': '${Discount==0.0||Discount==null?  "" : coupon.text}',
              }
          )
      );

      var jsonString = jsonDecode(response.body);
      print("Jsnnnnnnpayment: $jsonString");

      Statuss = jsonString['status'];
      Messagee = jsonString['message'];

      // Hide loader
      Navigator.of(context, rootNavigator: true).pop();

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
        // Show error message if API status is false
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$Messagee', style: const TextStyle(color: Colors.white)),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Hide loader in case of error
      Navigator.of(context, rootNavigator: true).pop();

      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong! Please try again.', style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? razorpay_key ='';
  String? razorpay_secret ='';
  String? Online_payment_status ='';
  String? Offline_payment_status ='';
  var BasicSettingData;
  String? Gst ='';
  String? Gst_status ='';
  double? gstPrice=0.0;
  double? priceAfterGst=0.0;
  String? Kycc ='';
  BasicSetting_Apii() async {
    var data = await API.BesicSetting_Api();
    if(data['status']==true){
      setState(() {
        razorpay_key = data['data']['razorpay_key'];
        razorpay_secret = data['data']['razorpay_secret'];
        Online_payment_status = data['data']['paymentstatus'].toString();
        Offline_payment_status = data['data']['officepaymenystatus'].toString();
        Kycc = data['data']['kyc'].toString();
        Gst = data['data']['gst'].toString();
        Gst_status = data['data']['gststatus'].toString();
      });
      Gsttt();
    }else{

    }
  }
  Gsttt(){
    gstPrice= (double.parse(PlanDetail['price'].toString()) * double.parse(Gst.toString()))/100;

    priceAfterGst= Gst_status=="1"?
    double.parse(PlanDetail['price'].toString()) + double.parse(gstPrice.toString()):
    double.parse(PlanDetail['price'].toString());
  }

  var Data_profile;
  bool? Status_profile;
  bool loader_profile=false;
  String? Kyc_verification;
  Profile_Api() async {
    var data = await API.Profile_Api();
    setState(() {
      Data_profile = data['data'];
      Status_profile = data['status'];
    });
    if(Status_profile==true){
      setState(() {});
      Kyc_verification= Data_profile['kyc_verification'].toString();


      loader_profile=true;
    }

    else{
      print("");
    }

  }

  // String? Kyc_verification;
  // GetKycVerificationStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Kyc_verification = prefs.getString("Kyc_verification");
  // }

  CallApi(){
    BasicSetting_Apii();
    Profile_Api();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("123456: $PlanDetail");
    Coupons_Api();
    // GetKycVerificationStatus();
    Profile_Api();
    BasicSetting_Apii();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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
              child:const Icon(Icons.arrow_back,color: Colors.black,)
          ),
          title:const Text("Plan Details",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
        ),

        bottomSheet:PlanDetail['price']==null||PlanDetail['price']==""?
        const SizedBox(height: 0,):

        Online_payment_status=="1"&& Offline_payment_status=="1" ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Offline_payment()));
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
                String? planId ='${PlanDetail['_id']}';
                String? clientid= '$Login_idd';
                double? discount= Discount;
                String? couponCode= '${Discount==0.0||Discount==null?  "" : coupon.text}';
                String? type="plan";
                String? Inv_amount="";

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
            String? planId ='${PlanDetail['_id']}';
            String? clientid= '$Login_idd';
            double? discount= Discount;
            String? couponCode= '${Discount==0.0||Discount==null?  "" : coupon.text}';
            String? type="plan";
            String? Inv_amount="";
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Offline_payment()));
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
              ],
            ),
          ),
        ):
        SizedBox(),


        body: Container(
          child: Column(
            children: [
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
                        child: Divider(color: Colors.grey.shade500,thickness: 0.2,)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:const EdgeInsets.only(top: 5,left: 20),
                          child: Text("PR(${PlanDetail['validity']}) :",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),

                        ),
                        Container(
                          margin:const EdgeInsets.only(top: 5,right: 20),
                          child: Text("₹${PlanDetail['price']}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                        ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:const EdgeInsets.only(top: 15,left: 20),
                          child:const Text("Category :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),

                        ),
                        Container(
                          // width: MediaQuery.of(context).size.width/1.8,
                          margin:const EdgeInsets.only(top: 15,right: 15),
                          child: Text("${PlanDetail['category']['title']}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:const EdgeInsets.only(top: 15,left: 20),
                          child:const Text("Segment :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),

                        ),
                        Container(
                          margin:const EdgeInsets.only(top: 15,right: 20),
                          child: Text("${Services}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                        ),
                      ],
                    ),

                    Gst_status=="1"?
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
                              Text("$gstaftercouponapply",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),)
                          ),
                        ),
                      ],
                    ):
                    const SizedBox(height: 0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [

                                Container(
                                  // margin: EdgeInsets.only(top: 15),
                                    child: Text("₹ -${Discount!.toStringAsFixed(2)}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color2),)),

                                GestureDetector(
                                  onTap: (){
                                    setState(() {

                                    });
                                    Discount=0.0;
                                    FinalPrice="";
                                    gstaftercouponapply="";
                                  },
                                  child: Container(
                                      margin:const EdgeInsets.only(top: 2),
                                      child:const Text("Remove",style: TextStyle(color: Colors.red,fontSize: 10),)
                                  ),
                                ),

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
                          Text("₹$priceAfterGst",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6,color: Colors.black),):
                          Text("₹$FinalPrice",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6,color: Colors.black),),
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ],
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
                                            color:const Color(0xcd354273),
                                            border: Border.all(color:const Color(0xcd354273),),
                                            borderRadius:const BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              "${Coupons[index]['serviceName']}",
                                              style:const TextStyle(
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

                                              Container(
                                                margin:const EdgeInsets.only(top: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(left: 10),
                                                      child:const Text("Use Code :"),
                                                    ),
                                                    Container(
                                                      margin:const EdgeInsets.only(left: 10),
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
                                                margin:const EdgeInsets.only(left: 10,top: 10),
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
                                                            style:const TextStyle(fontSize: 12,letterSpacing: 0.01,fontWeight: FontWeight.w500,color: Colors.black)
                                                        ),
                                                      ]),),
                                              ),


                                              Container(
                                                margin:const EdgeInsets.only(left: 10, top: 7,bottom: 10),
                                                child:  RichText(
                                                  text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text: "Minimum Purchase value ",
                                                          style: TextStyle(fontSize: 14,letterSpacing: 0.01, color: Colors.black87, fontWeight: FontWeight.w300),),
                                                        TextSpan(
                                                            text: "₹${Coupons[index]['minpurchasevalue']}",
                                                            style: TextStyle(fontSize: 14,letterSpacing: 0.01,fontWeight: FontWeight.w900,color: ColorValues.Splash_bg_color1)),
                                                      ]),),

                                              ),


                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
    var options = {
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
      },
      // 'capture': false
    };
    print("Hello1");
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
  //   try {
  //     var paymentStatusUrl = 'https://api.razorpay.com/v1/payments/$paymentId';
  //     var headers = {
  //       'Authorization': 'Basic ' + base64Encode(utf8.encode('$razorpay_key:$razorpay_secret')),
  //       'Content-Type': 'application/json',
  //     };
  //
  //     // Check payment status before capturing
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
  //       });
  //
  //       var captureResponse = await http.post(Uri.parse(captureUrl), headers: headers, body: body);
  //       if (captureResponse.statusCode == 200) {
  //         print("Payment Captured Successfully: ${captureResponse.body}");
  //         AddSubscription_Api(paymentId);
  //       } else {
  //         print("Capture Failed: ${captureResponse.body}");
  //       }
  //     } else {
  //       print("Payment is not authorized, cannot capture!");
  //     }
  //   } catch (e) {
  //     print("Capture Error: $e");
  //   }
  // }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String? paymentId = response.paymentId;
    print("PaymentId: $paymentId");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      openAlertBox();
    });

    try {
      var paymentStatusUrl = 'https://api.razorpay.com/v1/payments/$paymentId';
      var headers = {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$razorpay_key:$razorpay_secret')),
        'Content-Type': 'application/json',
      };

      // Check payment status before capturing
      var statusResponse = await http.get(Uri.parse(paymentStatusUrl), headers: headers);
      var paymentData = jsonDecode(statusResponse.body);

      if (paymentData['status'] == 'authorized') {
        double finalAmount = safeParse(FinalPrice) == 0.0
            ? safeParse(priceAfterGst?.toString())
            : safeParse(FinalPrice);
        print("Payment is authorized, capturing now...");

        var captureUrl = 'https://api.razorpay.com/v1/payments/$paymentId/capture';
        var body = jsonEncode({
          'amount': (finalAmount * 100).toInt(),
          'currency': 'INR',
        });

        var captureResponse = await http.post(Uri.parse(captureUrl), headers: headers, body: body);

        if (captureResponse.statusCode == 200) {
          print("Payment Captured Successfully: ${captureResponse.body}");
          AddSubscription_Api(paymentId);
        } else {
          var errorResponse = jsonDecode(captureResponse.body);
          print("Capture Failed: ${errorResponse['error']['description']}");

          Fluttertoast.showToast(
            msg: "Payment Capture Failed: ${errorResponse['error']['description'] ?? 'Unknown Error'}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else if (paymentData['status'] == 'captured') {
        print("Payment already captured, no need to capture again.");
      } else {
        print("Payment is not authorized, cannot capture.");
      }

    } catch (e) {
      print("Capture Error: $e");

      // Show FlutterToast message for exception
      Fluttertoast.showToast(
        msg: "Capture Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
                      "Payment in progress..",
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


}
