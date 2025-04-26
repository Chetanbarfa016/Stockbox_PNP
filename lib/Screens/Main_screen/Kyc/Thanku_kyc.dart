import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Dashboard.dart';
import 'package:stock_box/Screens/Main_screen/Thanku_Basket.dart';
import 'package:stock_box/Screens/Main_screen/Thankyou.dart';

class Thankyou_kyc extends StatefulWidget {
  int? amount;
  String? planId;
  String? clientid;
  double? discount;
  String? couponCode;
  String? digioDocId;
  String? type;
  String? Inv_amount;
  Thankyou_kyc({Key? key,required this.amount,required this.planId,required this.clientid,required this.discount,required this.couponCode,required this.digioDocId,required this.type,required this.Inv_amount}) : super(key: key);

  @override
  State<Thankyou_kyc> createState() => _Thankyou_kycState(amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,digioDocId:digioDocId,type:type,Inv_amount:Inv_amount);
}

class _Thankyou_kycState extends State<Thankyou_kyc> {
  int? amount;
  String? planId;
  String? clientid;
  double? discount;
  String? couponCode;
  String? digioDocId;
  String? type;
  String? Inv_amount;
  _Thankyou_kycState({
    required this.amount,
    required this.planId,
    required this.clientid,
    required this.discount,
    required this.couponCode,
    required this.digioDocId,
    required this.type,
    required this.Inv_amount
  });

  late Razorpay _razorpay;

  String? razorpay_key ='';
  String? razorpay_secret ='';

  BasicSetting_Apii() async {
    var data = await API.BesicSetting_Api();
    print("Data11111: $data");
    if(data['status']==true){
      razorpay_key = data['data']['razorpay_key'];
      razorpay_secret = data['data']['razorpay_secret'];

    }else{

    }
  }

  bool? Statuss;
  String? Messagee;
  String? Login_idd;

  bool? Status;
  String? Message;

  DownloadDocument_Api(digioDocId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Id_Login = prefs.getString('Login_id');
    print("Hello1");
    var response = await http.post(
      Uri.parse("${Util.Main_BasrUrl}/api/client/downloaddocument"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "id": "$Id_Login",
          "doc_id": "$digioDocId",
        },
      ),
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn11111: $jsonString");

    // Status = jsonString['status'];
    // Message = jsonString['message'];

    // if (Status == true) {
    //   // Navigator.push(context, MaterialPageRoute(builder: (context) => Thankyou_kyc(amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount:Inv_amount)));
    // } else {
    //   print("Error");
    // }
  }

  AddSubscription_Api(PaymentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Login_idd = prefs.getString("Login_id");

    print("1111: $planId");
    print("2222: $clientid");
    print("3333: $amount");
    print("4444: $discount");
    print("5555: $PaymentId");
    print("6666: $couponCode");

    try {
      openAlertBox();
      var response = await http.post(Uri.parse(Util.AddPlansSubscription_Api),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'plan_id': '$planId',
            'client_id': '$Login_idd',
            'price': '$amount',
            'discount': '$discount',
            'orderid': '$PaymentId',
            'coupon_code': '$couponCode',
          }));

      var jsonString = jsonDecode(response.body);
      print("Jsnnnnnnpayment: $jsonString");

      Statuss = jsonString['status'];
      Messagee = jsonString['message'];

      // Hide loader
      // Navigator.of(context, rootNavigator: true).pop();

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
        SnackBar(
          content: Text('Something went wrong! Please try again.', style: const TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool? Statuss_basket;
  String? Messagee_basket;
  String? Login_idd_basket;

  AddSubscriptionBasket_Api(PaymentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Login_idd_basket = prefs.getString("Login_id");

    try {
      var response = await http.post(Uri.parse("${Util.BASE_URL1}addbasketsubscription"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'basket_id': '$planId',
            'client_id': '$Login_idd_basket',
            'price': '$amount',
            'discount': '$discount',
            'orderid': '$PaymentId',
            'coupon': '$couponCode',
          }));

      var jsonString = jsonDecode(response.body);
      print("Jsnnnnnnpayment: $jsonString");

      Statuss_basket = jsonString['status'];
      Messagee_basket = jsonString['message'];

      if (Statuss_basket == true) {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$Messagee_basket', style: const TextStyle(color: Colors.white)),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(context, MaterialPageRoute(builder: (context) => Thankyou_basket(Basket_id:planId, Investment_amount:Inv_amount,)));
      } else {
        // Show error message if API status is false
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$Messagee_basket', style: const TextStyle(color: Colors.white)),
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BasicSetting_Apii();
    DownloadDocument_Api(digioDocId);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        int count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 4;
        });
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:'false')));
              },
              child:const Icon(Icons.arrow_back,color: Colors.black,)
          ),
          title:const Text("Thank You",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
        ),

        body:isProcessing
            ? Center(
              child: Container(
                        height: 80, // Static height
                        width: 140,
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
                    fontSize: 10,
                  ),
                ),
              ],
                        ),
                      ),
            )
            :
           Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                child: Image.asset("images/thanku.png",height: 60,color: ColorValues.Splash_bg_color1,),
              ),

              Container(
                child: Text("Thank You",style: TextStyle(fontSize: 20,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600),),
              ),

              Container(
                margin:const EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                child:const Text("Thank You for choosing services your KYC AGREEMENT Completed.\nPlease check your email, Esign document was sent to your email.",textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500),),
              ),

              GestureDetector(
                onTap: (){
                  openCheckout();
                  // int count = 0;
                  // Navigator.popUntil(context, (route) {
                  //   return count++ == 4;
                  // });
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:'false')));
                },
                child: Container(
                  margin:const EdgeInsets.only(top: 15),
                  width: 170,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorValues.Splash_bg_color1
                  ),
                  alignment: Alignment.center,
                  child:const Text("Continue to payment",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }

  void openCheckout() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Name= prefs.getString("FullName");
    String? Email= prefs.getString("Email");
    String? PhoneNo= prefs.getString("PhoneNo");

    var options = {
      // 'key': 'rzp_test_22mEHcDzJbcUmz',
      'key': '$razorpay_key',
      'amount':amount,
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
  bool isProcessing = false;
  // declare in your state

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   String? paymentId = response.paymentId;
  //   print("PaymentId: $paymentId");
  //
  //   // ✅ Show blank screen + loader
  //   setState(() {
  //     isProcessing = true;
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
  //       int authorizedAmount = paymentData['amount'];
  //       print("Payment is authorized, capturing now...");
  //
  //       var captureUrl = 'https://api.razorpay.com/v1/payments/$paymentId/capture';
  //       var body = jsonEncode({
  //         'amount': authorizedAmount,
  //         'currency': 'INR',
  //       });
  //
  //       var captureResponse = await http.post(Uri.parse(captureUrl), headers: headers, body: body);
  //
  //       if (captureResponse.statusCode == 200) {
  //         print("Payment Captured Successfully");
  //
  //         type=="plan"?
  //         await AddSubscription_Api(paymentId):
  //         await AddSubscriptionBasket_Api(paymentId);
  //       } else {
  //         setState(() => isProcessing = false); // hide loader
  //         var errorResponse = jsonDecode(captureResponse.body);
  //         Fluttertoast.showToast(
  //           msg: "Payment Capture Failed: ${errorResponse['error']['description'] ?? 'Unknown Error'}",
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //         );
  //       }
  //     } else {
  //       setState(() => isProcessing = false); // hide loader
  //       print("Payment is not authorized");
  //     }
  //   } catch (e) {
  //     setState(() => isProcessing = false); // hide loader
  //     Fluttertoast.showToast(
  //       msg: "Capture Error: $e",
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   }
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
    type=="plan"?
     AddSubscription_Api(PaymentId):
     AddSubscriptionBasket_Api(PaymentId);
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
}
