import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Constants/Util.dart';

class API  {

  static Future register_Api(username,password,name,email,referral,_selectedState,_selectedCity) async {
      var response = await http.post(Uri.parse(Util.Register_Api),
          body:{
            'FullName': '$name',
            'Email': '$email',
            'PhoneNo': '$username',
            'password': '$password',
            'token': '$referral',
            'state': '$_selectedState',
            'city': '$_selectedCity',
          }
      );
      var jsonString = jsonDecode(response.body);
      print("Jsnnnnnn: $jsonString");
      return jsonString;
  }

  static Future login_Api(username,password,device_token) async {
      var response = await http.post(Uri.parse(Util.Login_Api),
          body:{
            'UserName': '$username',
            'password': '$password',
            'devicetoken': '$device_token',
          }
      );
      var jsonString = jsonDecode(response.body);
      print("login_Api Jsnnnnnn: $jsonString");
      return jsonString;
  }

  static Future forgot_Api(username) async {
      var response = await http.post(Uri.parse(Util.Forgotpassword_Api),
          body:{
            'Email': '$username',
          }
      );
      var jsonString = jsonDecode(response.body);
      print("Jsnnnnnn: $jsonString");
      return jsonString;
  }

  static Future resetPassword_Api(token,newpassword) async {
    print("Tokennnnnnn: $token");
    var response = await http.post(Uri.parse(Util.resetPassword_Api),
        body:{
          'newPassword': '$newpassword',
          'resetToken': '$token',
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Profile_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_profile = prefs.getString('Login_id');
    print("Idddd1212: $Id_profile");
    var response = await http.get(Uri.parse("${Util.Profile_Api}/$Id_profile"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future getState_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_profile = prefs.getString('Login_id');
    print("Idddd1212: $Id_profile");
    var response = await http.get(Uri.parse("${Util.State_Api}"));
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future getCity_Api(_selectedState) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_profile = prefs.getString('Login_id');
    print("Idddd1212: $Id_profile");
    var response = await http.get(Uri.parse("${Util.City_Api}/$_selectedState"));
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Slider_Api() async {
    var response = await http.get(Uri.parse(Util.Slider_Api),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future subscriptionPlans_Api() async {
    var response = await http.get(Uri.parse(Util.SubscriptionsPlan_Api),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Logout_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_Logout = prefs.getString('Login_id');
    var response = await http.get(Uri.parse("${Util.BASE_URL1}logout/$Id_Logout"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }


  static Future Mysubscription_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_MySubscription = prefs.getString('Login_id');
    print("${Util.MySubscriptions_Api}/$Id_MySubscription");
    var response = await http.get(Uri.parse("${Util.MySubscriptions_Api}/$Id_MySubscription"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future MyBasketPurchase_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_MyBasketPurchase = prefs.getString('Login_id');
    print("11111111: ${Util.BASE_URL1}mybasketpurchaselist");
    var response = await http.post(Uri.parse("${Util.BASE_URL1}mybasketpurchaselist"),
        body: {
          "clientid":"$Id_MyBasketPurchase",
        }
    );
    print("JsnnnnnnPurchase: ${response.body}");
    var jsonString = jsonDecode(response.body);
    print("JsnnnnnnPurchase11111: $jsonString");
    return jsonString;
  }

  static Future MyBasketsubscription_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_MyBasketSubscription = prefs.getString('Login_id');
    var response = await http.get(Uri.parse("${Util.BASE_URL1}mybasketplan/$Id_MyBasketSubscription"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }


  static Future Blogs_Api(_page) async {
    var response = await http.get(Uri.parse("${Util.Blogs_Api}?page=$_page"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future News_Api(_page) async {
    var response = await http.get(Uri.parse("${Util.News_Api}?page=$_page"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Faq_Api() async {
    var response = await http.get(Uri.parse(Util.Faq_Api),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future PrivacyPolicy_Api() async {
    print("${Util.PrivacyPolicy_Api}/content/66dbef118b3cf3e8cf23a988");
    var response = await http.get(Uri.parse("${Util.PrivacyPolicy_Api}content/66dbef118b3cf3e8cf23a988"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future TermsCondition_Api() async {
    var response = await http.get(Uri.parse("${Util.TermsCondition_Api}content/66dbec0a9f7a0365f1f4527d"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future DeleteAccount_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_Delete = prefs.getString('Login_id');
    var response = await http.get(Uri.parse("${Util.DeleteAccount_Api}/$Id_Delete"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Signal_Api(Samiti, search, page_no) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_Signal = prefs.getString('Login_id');
    print('"client_id":"$Id_Signal","service_id":"$Samiti", "search":"$search",  "page":"$page_no"');
    print("Util.Signal_Api == ${Util.Signal_Api}");
    var response = await http.post(Uri.parse(Util.Signal_Api),
    body: {
      "client_id":"$Id_Signal",
      "service_id":"$Samiti",
      "search":"$search",
      "page":"$page_no",
    }
   );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future NSE_AllData_Api() async {
    var response = await http.get(Uri.parse("http://stockboxapis.cmots.com/api/BseNseDelayedData/NSE"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  // static Future Live_AllData_Api() async {
  //   var response = await http.get(Uri.parse("https://stockboxpnp.pnpuniverse.com/backend/api/getliveprice"),);
  //   var jsonString = jsonDecode(response.body);
  //   print("Jsnnnnnn: $jsonString");
  //   return jsonString;
  // }

  static Future Live_AllData_Api(Basket_id) async {
    print("https://stockbox.pnpuniverse.com/backend/api/getliveprices/$Basket_id");
    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/getliveprices/$Basket_id"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }


  static Future Close_Signal_Api(Samiti, search, page_no) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_Signal = prefs.getString('Login_id');
     print("11111: ${Util.Close_Signal_Api}");
     print("22222: ${Id_Signal}");
     print("33333: ${Samiti}");
     print("44444: ${search}");
     print("55555: ${page_no}");
    var response = await http.post(Uri.parse(Util.Close_Signal_Api),
        body: {
          "client_id":"$Id_Signal",
          "service_id":"$Samiti",
          "search":"$search",
          "page":"$page_no",
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Coupons_Api() async {
    var response = await http.get(Uri.parse(Util.AllCoupons_Api),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Notification_Api(_page) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_notification = prefs.getString('Login_id');
    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/list/notification/$Id_notification?page=$_page"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future  Basket_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_Basket = prefs.getString('Login_id');
    print("${Util.BASE_URL1}baskets");
    print("11111111: $Id_Basket");
    var response = await http.post(Uri.parse("${Util.BASE_URL1}baskets"),
        body: {
          "clientid":"$Id_Basket",
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future  BasketStocks_Api(Basket_id) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_Basketstocks = prefs.getString('Login_id');
    print("${Util.BASE_URL1}basketstock/$Basket_id");
    var response = await http.get(Uri.parse("${Util.BASE_URL1}basketstock/$Basket_id"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future  MyPortfolio_Api(Basket_id) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_Basketstocks = prefs.getString('Login_id');
    print("${Util.BASE_URL1}myportfolio/$Basket_id/$Id_Basketstocks");
    var response = await http.get(Uri.parse("${Util.BASE_URL1}myportfolio/$Basket_id/$Id_Basketstocks"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }


  static Future Request_payout_Api(amount) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_payout = prefs.getString('Login_id');

    print("2222: $Id_payout");
    print("3333: $amount");
    print(Util.RequestPayout_Api);
    var response = await http.post(Uri.parse(Util.RequestPayout_Api),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'clientId': '$Id_payout',
              'amount': '$amount',
            }
        )

    );
    var jsonString = jsonDecode(response.body);
    print("JsnnnnnnPayout: $jsonString");
    return jsonString;
  }

  static Future ReferandEarn_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_refer = prefs.getString('Login_id');
        print("${Util.ReferEarn_Api}");
    var response = await http.post(Uri.parse(Util.ReferEarn_Api),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'id': '$Id_refer',
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Service_Expiry_Apii() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_serviceExpiry = prefs.getString('Login_id');
    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/list/myservice/$Id_serviceExpiry"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn111111: $jsonString");
    return jsonString;
  }

  static Future PayoutHistory_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_payout = prefs.getString('Login_id');

    var response = await http.post(Uri.parse(Util.PayoutHistory_Api),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'id': '$Id_payout',
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("JsnnnnnnPayout: $jsonString");
    return jsonString;
  }

  static Future GetAllPlans() async {
    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/list/getallplan"),);

    print("Jsnnnnnnyyyy5555: ${response.body}");
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnnyyyy: $jsonString");
    return jsonString;
  }

  static Future Broadcast_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_broadcast = prefs.getString('Login_id');
    print(Id_broadcast);

    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/list/broadcast"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'id': '$Id_broadcast',
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future AddHelpDesk_Api(subject,message) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_helpdesk = prefs.getString('Login_id');

    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/addhelpdesk"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'client_id': '$Id_helpdesk',
              'subject': '$subject',
              'message': '$message',
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future HelpDesk_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_helpdesk = prefs.getString('Login_id');
    print(Id_helpdesk);

    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/client/helpdesk/$Id_helpdesk"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future FreeTrial_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_freetrial = prefs.getString('Login_id');
    print(Id_freetrial);

    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/list/freetrial"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'client_id': '$Id_freetrial',
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future BesicSetting_Api() async {
    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/list/basicsetting"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Qrcodes_Api() async {
    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/list/qrcode"),);
    // var response = await http.get(Uri.parse("https://stockboxpnp.pnpuniverse.com/backend/api/list/basicsetting"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future BankDetails_Api() async {
    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/list/bank"),);
    // var response = await http.get(Uri.parse("https://stockboxpnp.pnpuniverse.com/backend/api/list/basicsetting"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future MyFreeTrial() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_myfreetrial = prefs.getString('Login_id');
    print(Id_myfreetrial);

    var response = await http.get(Uri.parse("${Util.Main_BasrUrl}/api/list/myfreetrial/$Id_myfreetrial"),);
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future BrokerResponse_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? clientid = prefs.getString('Login_id');

    print("clientid== $clientid");

    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/orderlist"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'clientid': '$clientid',
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Basket_BrokerResponse_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? clientid = prefs.getString('Login_id');

    print("clientid== $clientid");

    var response = await http.post(Uri.parse("${Util.BASE_URL}basketorderlist"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'clientid': '$clientid',
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future BrokerResponse_Detail_Api(orderid, borkerid) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? clientid = prefs.getString('Login_id');

    print('{"clientid" :"$clientid", "orderid": "$orderid"}');
    print("borkerid== ${borkerid}");

    borkerid.toString()=="1"?
    print("${Util.Main_BasrUrl}/angle/checkorder"):
    print("${Util.Main_BasrUrl}/aliceblue/checkorder");

    var response = await http.post(Uri.parse(
        borkerid.toString()=="1"?
        "${Util.Main_BasrUrl}/angle/checkorder":
        borkerid.toString()=="2"?
        "${Util.Main_BasrUrl}/aliceblue/checkorder":
        borkerid.toString()=="3"?
        "${Util.Main_BasrUrl}/kotakneo/checkorder":
        borkerid.toString()=="4"?
        "${Util.Main_BasrUrl}/markethub/checkorder":
        borkerid.toString()=="5"?
        "${Util.Main_BasrUrl}/zerodha/checkorder":
         borkerid.toString()=="6"?
        "${Util.Main_BasrUrl}/upstox/checkorder":
        "${Util.Main_BasrUrl}/dhan/checkorder",
    ),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'clientid': '$clientid',
              'orderid': '$orderid',
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future Basket_BrokerResponse_Detail_Api(orderid, borkerid) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? clientid = prefs.getString('Login_id');

    print('{"clientid" :"$clientid", "orderid": "$orderid"}');
    print("borkerid== ${borkerid}");

    // borkerid.toString()=="1"?
    // print("${Util.Main_BasrUrl}/angle/checkorderbasket"):
    // print("${Util.Main_BasrUrl}/aliceblue/checkorderbasket");

    var response = await http.post(Uri.parse(
      borkerid.toString()=="1"?
      "${Util.Main_BasrUrl}/angle/checkorderbasket":
      borkerid.toString()=="2"?
      "${Util.Main_BasrUrl}/aliceblue/checkorderbasket":
      borkerid.toString()=="3"?
      "${Util.Main_BasrUrl}/kotakneo/checkorderbasket":
      "${Util.Main_BasrUrl}/markethub/checkorderbasket",

    ),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'clientid': '$clientid',
              'orderid': '$orderid',
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future BrokerResponse_all_Detail_Api(Single_id) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? clientid = prefs.getString('Login_id');

    print('{"clientid" :"$clientid", "signalid": "$Single_id"}');
    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/orderlistdetail"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'clientid': '$clientid',
              'signalid': '$Single_id'
            }
        )
    );
    print("response.body: ${response.body}");
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    return jsonString;
  }

  static Future checkToken() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_checkToken = prefs.getString('Login_id');
    String? Token = prefs.getString('Token');
    var response = await http.post(Uri.parse("${Util.BASE_URL1}checkclienttoken"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'client_id':'$Id_checkToken',
              'token':'$Token'
            }
        )

    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnntokennnnnnnnnnnnnn: $jsonString");
    return jsonString;
  }

}


class Check_internet {
  static Future check() async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: "No Internet Connection!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('not connected');
    }
  }
}
