import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Kyc/Kyc_formView.dart';
import 'package:stock_box/Screens/Main_screen/Thanku_Basket.dart';

class Basket_Payments extends StatefulWidget {
  var BaketDataa;
  Basket_Payments({Key? key, required this.BaketDataa}) : super(key: key);

  @override
  State<Basket_Payments> createState() => _Basket_PaymentsState(BaketDataa:BaketDataa);
}

class _Basket_PaymentsState extends State<Basket_Payments> with SingleTickerProviderStateMixin{
  var BaketDataa;
  _Basket_PaymentsState({
    required this.BaketDataa
  });
  late TabController _tabController;

  CallApi(){
    BasicSetting_Apii();
    Profile_Api();
  }

  late Razorpay _razorpay;

  String? Message_coupon;
  double? Discount=0.0;
  String? FinalPrice='';
  TextEditingController coupon =TextEditingController();
  String _appliedCoupon = '';

  ApplyCoupon_Api() async {

    print(coupon.text);
    var response = await http.post(Uri.parse(Util.ApplyCoupon_Api),
        body:{
          'code': '${coupon.text}',
          'purchaseValue': '${BaketDataa['basket_price']}',
          'planid': '${BaketDataa['_id']}',
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");

    Message_coupon=jsonString['message'];

    print("Message: $Message_coupon");

    if(Message_coupon=="Coupon applied successfully"){
      setState(() {});

      Discount=double.parse(jsonString['discount'].toString());
      FinalPrice=jsonString['finalPrice'].toString();

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

  String? Gst ='';
  String? Gst_status ='';
  double? gstPrice=0.0;
  double? priceAfterGst=0.0;
  String? razorpay_key ='';
  String? razorpay_secret ='';
  String? Kycc ='';
  BasicSetting_Apii() async {
    var data = await API.BesicSetting_Api();
    if(data['status']==true){
      setState(() {
        Gst = data['data']['gst'].toString();
        Gst_status = data['data']['gststatus'].toString();
        razorpay_key = data['data']['razorpay_key'];
        razorpay_secret = data['data']['razorpay_secret'];
        Kycc = data['data']['kyc'].toString();
      });
      Gsttt();
    }
    else{}
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

  Gsttt(){
    gstPrice= (double.parse(BaketDataa['basket_price'].toString()) * double.parse(Gst.toString()))/100;
    priceAfterGst= Gst_status=="1"?
    double.parse(BaketDataa['basket_price'].toString()) + double.parse(gstPrice!.toStringAsFixed(2)):
    double.parse(BaketDataa['basket_price'].toString());
  }

  addRequest_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_addRequest = prefs.getString('Login_id');
    var response = await http.post(Uri.parse(Util.AddRequest_Api),
        body: {
          "clientid":"$Id_addRequest",
          "type":"basket",
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    print("Status_Request : ${jsonString['status']}");
  }

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

    print("Statussss: $Status_coupon");

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
    }

    else{
      print("error");
    }

  }


  bool? Statuss;
  String? Messagee;
  String? Login_idd;
  String? Plans_id;

  // AddSubscription_Api(PaymentId) async {
  //   print("Plansssss: $Plans_id");
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   Login_idd= prefs.getString("Login_id");
  //
  //   var response = await http.post(Uri.parse("${Util.BASE_URL1}addbasketsubscription"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body:jsonEncode(
  //           {
  //             'basket_id': '${BaketDataa['_id']}',
  //             'client_id': '$Login_idd',
  //             'price': '${FinalPrice==""||FinalPrice==null? BaketDataa['basket_price'] : FinalPrice}',
  //             'discount': '$Discount',
  //             'orderid': '$PaymentId',
  //             'coupon': '${Discount==0.0||Discount==null?  "" : coupon.text}',
  //           }
  //       )
  //   );
  //
  //   var jsonString = jsonDecode(response.body);
  //   print("Jsnnnnnnpayment: $jsonString");
  //
  //   Statuss=jsonString['status'];
  //   Messagee=jsonString['message'];
  //
  //   if(Statuss==true){
  //     setState(() {
  //
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('$Messagee',style:const TextStyle(color: Colors.white)),
  //         duration:const Duration(seconds: 3),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //     Navigator.push(context, MaterialPageRoute(builder: (context)=> Thankyou_basket()));
  //     // Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_stocks(Basket_id: '${BaketDataa['_id']}', Investment_amount: '${BaketDataa['mininvamount']}',)));
  //   }
  //
  //   else {
  //
  //   }
  //
  // }

  AddSubscription_Api(PaymentId) async {
    // Show loader
    // showDialog(
    //   context: context,
    //   barrierDismissible: false, // Prevent dismissing loader by tapping outside
    //   builder: (BuildContext context) {
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );

    print("Plansssss: $Plans_id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Login_idd = prefs.getString("Login_id");

    try {
      var response = await http.post(Uri.parse("${Util.BASE_URL1}addbasketsubscription"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'basket_id': '${BaketDataa['_id']}',
            'client_id': '$Login_idd',
            'price': '${FinalPrice == "" || FinalPrice == null ? priceAfterGst!.toStringAsFixed(2) : FinalPrice}',
            'discount': '$Discount',
            'orderid': '$PaymentId',
            'coupon': '${Discount == 0.0 || Discount == null ? "" : coupon.text}',
          }));

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

        Navigator.push(context, MaterialPageRoute(builder: (context) => Thankyou_basket(Basket_id: '${BaketDataa['_id']}', Investment_amount: '${BaketDataa['mininvamount']}',)));
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
      // Hide loader in case of error
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


  double? full_price=0.0;
  double? basket_price=0.0;
  double? discount_price=0.0;
  Total_saving(){
    full_price=double.parse( BaketDataa['full_price'].toString());
    basket_price= double.parse(BaketDataa['basket_price'].toString());

    discount_price= full_price! - basket_price!;
    print("discount_price : $discount_price");
  }


  var Qrcodes_data=[];
  bool? Status;
  bool loader=false;

  Qrcodes_Api() async {
    var data = await API.Qrcodes_Api();
    setState(() {
      Status= data['status'];
    });

    print("Statussss: $Status");
    print("data: $data");

    if(Status==true){
      Qrcodes_data = data['data'];

      setState(() {
        loader=true;
      });

    }else{
      print("error");
    }
  }

  var Bank_data=[];
  bool? Status_bank;
  bool loadebank=false;

  BankDetails_Api() async {
    var data = await API.BankDetails_Api();
    setState(() {
      Status_bank= data['status'];
    });

    print("Statussss: $Status");
    print("data: $data");

    if(Status_bank==true){
      Bank_data = data['data'];

      setState(() {
        loadebank=true;
      });

    }
    else{
      print("error");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Coupons_Api();
    BasicSetting_Apii();
    Profile_Api();
    Total_saving();
    Qrcodes_Api();
    BankDetails_Api();
    _tabController = TabController(length: 2, vsync: this);
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
        title:const Text("Payments",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),

      body: Container(
        child: Column(
          children: [
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.2),
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
                    stops: [
                      0.1,
                      0.5,
                    ],
                    colors: [
                      ColorValues.Splash_bg_color3,
                      ColorValues.Splash_bg_color1,
                      // Color(0xff537895)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                tabs:  <Widget> [
                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Pay Online'),
                      ),
                    ),
                  ),

                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Pay Offline'),
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
                    child: Column(

                      children: [

                        Container(
                          // height: 200,
                          width: double.infinity,
                          padding:const EdgeInsets.only(top: 10,bottom: 20),
                          margin:const EdgeInsets.only(top: 45,left: 20,right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.2)
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Image.asset("images/whistle.png",height: 25,width: 25,)
                                  ),
                                  Container(
                                    margin:const EdgeInsets.only(top: 5,left: 10),
                                    child:BaketDataa['full_price']==0||BaketDataa['full_price']==null||BaketDataa['full_price']==""?
                                    const Text("Your total savings is off ₹0",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,letterSpacing: 0.6),):
                                    Text("Your total savings is off ₹${discount_price}",style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                                  ),
                                ],
                              ),

                              Container(
                                  margin:const EdgeInsets.only(top: 5),
                                  child: Divider(color: Colors.grey.shade500,thickness: 0.2,)),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    margin:const EdgeInsets.only(top: 5,left: 20),
                                    child: Text("${BaketDataa['title']} ( ${BaketDataa['themename']} )",style:const TextStyle(fontSize: 17,fontWeight: FontWeight.w600,letterSpacing: 0.6),),
                                  ),
                                  Container(
                                    margin:const EdgeInsets.only(top: 5,right: 20),
                                    child: Text("₹${BaketDataa['basket_price']}",style:const TextStyle(fontSize: 17,fontWeight: FontWeight.w600,letterSpacing: 0.6),),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:const EdgeInsets.only(top: 5,left: 20),
                                    child:const Text("Validity :",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                                  ),

                                  GestureDetector(
                                    child: Container(
                                        margin:const EdgeInsets.only(top: 5,right: 20),
                                        child:  Text("${BaketDataa['validity']}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),)
                                    ),
                                  ),
                                ],
                              ),
                              Gst_status=="1"?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin:const EdgeInsets.only(top: 10,left: 20),
                                    child: Text("GST($Gst%) :",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                                  ),

                                  GestureDetector(
                                    child: Container(
                                        margin:const EdgeInsets.only(top: 10,right: 20),
                                        child: Text("${gstPrice!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),)
                                    ),
                                  ),
                                ],
                              ):
                              const SizedBox(height: 0),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin:const EdgeInsets.only(top: 10,left: 20),
                                    child:const Text("Grand Total :",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                        margin:const EdgeInsets.only(top: 10,right: 20),
                                        child: Text("${priceAfterGst!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),)
                                    ),
                                  ),
                                ],
                              ),


                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                            int? amount= FinalPrice == null || FinalPrice!.isEmpty
                                ? (double.parse(priceAfterGst!.toStringAsFixed(2)) * 100).toInt()
                                : (double.parse(FinalPrice!) * 100).toInt();
                            String? planId ='${BaketDataa['_id']}';
                            String? clientid= '$Login_idd';
                            double? discount= Discount;
                            String? couponCode= '${Discount==0.0||Discount==null?  "" : coupon.text}';
                            String? type="basket";
                            String? Inv_amount="${BaketDataa['mininvamount']}";
                            addRequest_Api();
                            Kyc_verification=="1"||Kycc=="0"?
                            openCheckout():
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Kyc_formView(amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount:Inv_amount))).then((value) => CallApi());
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 42,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [
                                    0.1,
                                    0.5,
                                  ],
                                  colors: [
                                    ColorValues.Splash_bg_color3,
                                    ColorValues.Splash_bg_color1,
                                    // Color(0xff537895)
                                  ],
                                ),
                              ),
                              margin:const EdgeInsets.only(left: 25,right: 25,bottom: 20,top: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Subscribe Now  ",
                                    style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),
                                  BaketDataa['full_price']==0.0||BaketDataa['full_price']=="0.0"||BaketDataa['full_price']==0||BaketDataa['full_price']=="0"||BaketDataa['full_price']==null?
                                  SizedBox(width: 0):
                                  Text("₹${BaketDataa['full_price']}",
                                    style:const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough,decorationThickness: 3),),

                                  Text("  ₹${priceAfterGst!.toStringAsFixed(2)}",
                                    style:const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600,),),
                                ],
                              )
                          ),
                        ),

                      ],

                    ),
                  ),

                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          // Container(
                          //   height: 35,
                          //   width: double.infinity,
                          //   alignment: Alignment.center,
                          //   color: ColorValues.Splash_bg_color1,
                          //   margin:const EdgeInsets.only(top: 20,left: 20,right: 20),
                          //   child:const Text("Qr Codes",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),),
                          // ),
                          // Container(
                          //   child: ListView.builder(
                          //     physics:const NeverScrollableScrollPhysics(),
                          //     shrinkWrap: true,
                          //     itemCount: 1,
                          //     itemBuilder: (BuildContext context, int index) {
                          //       return Card(
                          //         elevation: 2,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(15),
                          //         ),
                          //         clipBehavior: Clip.antiAliasWithSaveLayer,
                          //         margin:const EdgeInsets.only(left: 25,right: 25,top: 12,bottom: 12),
                          //         child: Container(
                          //           // height: 200,
                          //           child: Image.network("https://pngimg.com/d/qr_code_PNG33.png",fit: BoxFit.contain,),
                          //         ),
                          //       );
                          //     },
                          //
                          //   ),
                          // ),

                          Qrcodes_data.length> 0?
                          Container(
                            height: 35,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: ColorValues.Splash_bg_color1,
                            margin:const EdgeInsets.only(top: 20,left: 25,right: 25),
                            child:const Text("QR Codes",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),),
                          ):
                          SizedBox(height: 0),

                          Qrcodes_data.length> 0?
                          Container(
                            child: ListView.builder(
                              physics:const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: Qrcodes_data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  margin:const EdgeInsets.only(left: 25,right: 25,top: 12,bottom: 12),
                                  child: Container(
                                    // height: 200,
                                    child: Image.network("${Qrcodes_data[index]['image']}",fit: BoxFit.fill,),
                                  ),
                                );
                              },

                            ),
                          ):
                          const SizedBox(height: 0,),

                          loadebank==false?
                          const SizedBox(height: 0,):
                          Container(
                            height: 35,
                            color: ColorValues.Splash_bg_color1,
                            alignment: Alignment.center,
                            margin:const EdgeInsets.only(top: 20,left: 25,right: 25),
                            child:const Text("Bank Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
                          ),

                          const SizedBox(height: 10),

                          loadebank==false?
                          const SizedBox(height: 0,):
                          Container(
                            child: ListView.builder(
                              physics:const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: Bank_data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  margin:const EdgeInsets.only(left: 25,right: 25,top: 12,bottom: 12),
                                  child: Container(
                                    // height: 250,
                                      margin:const EdgeInsets.only(bottom: 12),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            margin:const EdgeInsets.only(top: 10),
                                            child: Image.network("${Bank_data[index]['image']}",height: 50,width:MediaQuery.of(context).size.width-50,fit: BoxFit.contain,),
                                          ),
                                          Divider(color: Colors.grey.shade600,),


                                          Container(
                                            margin:const EdgeInsets.only(top: 5,left: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 120,
                                                  child:const Text('NAME : ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                                                ),

                                                Container(
                                                  width: MediaQuery.of(context).size.width/2.2,
                                                  child: Text('${Bank_data[index]['name']}',style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                )
                                              ],
                                            ),
                                          ),

                                          Container(
                                              margin:const EdgeInsets.only(top: 3),
                                              child: Divider(color: Colors.grey.shade300,)
                                          ),

                                          Container(
                                            margin:const EdgeInsets.only(top: 3,left: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 120,
                                                  child:const Text('BRANCH :  ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                                                ),

                                                Container(
                                                  width: MediaQuery.of(context).size.width/2.2,
                                                  child: Text('${Bank_data[index]['branch']}',style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                              margin:const EdgeInsets.only(top: 3),
                                              child: Divider(color: Colors.grey.shade300,)),

                                          Container(
                                            margin:const EdgeInsets.only(top: 3,left: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 120,
                                                  child:const Text('ACCOUNT NO :  ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                                                ),

                                                Container(
                                                  width: MediaQuery.of(context).size.width/2.2,
                                                  child: Text('${Bank_data[index]['accountno']}',style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                              margin:const EdgeInsets.only(top: 3),
                                              child: Divider(color: Colors.grey.shade300,)),

                                          Container(
                                            margin:const EdgeInsets.only(top: 3,left: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 120,
                                                  child:const Text('IFSC CODE :  ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                                                ),

                                                Container(
                                                  width: MediaQuery.of(context).size.width/2.2,
                                                  child: Text('${Bank_data[index]['ifsc']}',style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                )
                                              ],
                                            ),
                                          ),

                                        ],
                                      )
                                  ),
                                );
                              },

                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  void openCheckout() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Name= prefs.getString("FullName");
    String? Email= prefs.getString("Email");
    String? PhoneNo= prefs.getString("PhoneNo");
    try {
      var amount = FinalPrice == null || FinalPrice!.isEmpty
          ? (double.parse(priceAfterGst!.toStringAsFixed(2)) * 100).toInt()
          : (double.parse(FinalPrice!) * 100).toInt();

      var options = {
        'key': '$razorpay_key',
        'amount': amount,
        'name': '$Name',
        // 'description': 'Research Service Charges',
        'retry': {'enabled': true, 'max_count': 1},
        'prefill': {'contact': '$PhoneNo', 'email': '$Email'},
        'external': {
          'wallets': ['paytm']
        },
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   print("_handlePaymentSuccess paymentId == ${response.paymentId}");
  //
  //   print("_handlePaymentSuccess orderId == ${response.orderId}");
  //
  //   print("_handlePaymentSuccess signature== ${response.signature}");
  //
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
  // }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String? paymentId = response.paymentId;
    print("PaymentId: $paymentId");

    // ✅ Show loader immediately after Razorpay closes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openAlertBox();
    });

    try {
      var paymentStatusUrl = 'https://api.razorpay.com/v1/payments/$paymentId';
      var headers = {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$razorpay_key:$razorpay_secret')),
        'Content-Type': 'application/json',
      };

      var statusResponse = await http.get(Uri.parse(paymentStatusUrl), headers: headers);
      var paymentData = jsonDecode(statusResponse.body);

      if (paymentData['status'] == 'authorized') {
        double finalAmount = safeParse(FinalPrice) == 0.0
            ? safeParse(priceAfterGst?.toString())
            : safeParse(FinalPrice);

        var captureUrl = 'https://api.razorpay.com/v1/payments/$paymentId/capture';
        var body = jsonEncode({
          'amount': (finalAmount * 100).toInt(),
          'currency': 'INR',
        });

        var captureResponse = await http.post(Uri.parse(captureUrl), headers: headers, body: body);

        if (captureResponse.statusCode == 200) {
          print("Payment Captured Successfully: ${captureResponse.body}");
          await AddSubscription_Api(paymentId);
        } else {
          Navigator.pop(context); // hide loader
          var errorResponse = jsonDecode(captureResponse.body);
          Fluttertoast.showToast(
            msg: "Payment Capture Failed: ${errorResponse['error']['description'] ?? 'Unknown Error'}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Navigator.pop(context); // hide loader if unauthorized
        print("Payment is not authorized, cannot capture.");
      }
    } catch (e) {
      Navigator.pop(context); // hide loader on error
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
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName!,
    //     gravity: ToastGravity.CENTER,
    //     toastLength: Toast.LENGTH_SHORT);
  }


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
                                            color:const Color(0xcd354273),
                                            border: Border.all(color: Color(0xcd354273),),
                                            borderRadius:const BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child:const RotatedBox(
                                            quarterTurns: 3, // Rotates the text 90 degrees counterclockwise
                                            child: Text(
                                              "FLAT OFF",
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
                                                        // TextSpan(
                                                        //     text: "*${Coupons[index]['name']}",
                                                        //     style: TextStyle(fontSize: 10,letterSpacing: 0.01,fontWeight: FontWeight.bold,color: Colors.black)
                                                        // ),
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

}
