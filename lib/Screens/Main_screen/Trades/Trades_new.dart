import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Global_widgets/Broker_link.dart';
import 'package:stock_box/Global_widgets/Logout.dart';
import 'package:stock_box/Global_widgets/Pdf_view.dart';
import 'package:stock_box/Screens/Main_screen/Broker/Webview_broker.dart';
import 'package:stock_box/Screens/Main_screen/Kyc/Kyc_formView.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Broker Responce Detail.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class TradesNew extends StatefulWidget {
  String? Samiti, Tab_name;
  int? indexchange;

  TradesNew({super.key, required this.Samiti, required this.Tab_name,required this.indexchange});

  @override
  State<TradesNew> createState() => _TradesNewState(Samiti: Samiti, Tab_name:Tab_name,indexchange:indexchange);
}

class _TradesNewState extends State<TradesNew> with SingleTickerProviderStateMixin {
  int? indexchange;
  int? selectedOption=0;
  int? selectedOptionn=0;
  //Angel
  TextEditingController api_key = TextEditingController();

  //Alice
  TextEditingController app_code = TextEditingController();
  TextEditingController user_id = TextEditingController();
  TextEditingController api_secret = TextEditingController();

  CallApi(){
    BasicSetting_Apii();
    Profile_Api();
  }

  var BasicSettingData;
  String? kyc_basicsetting;
  BasicSetting_Apii() async {
    var data = await API.BesicSetting_Api();
    print("Data11111: $data");
    if(data['status']==true){
      setState(() {
        kyc_basicsetting = data['data']['kyc'].toString();

      });
    }else{}
  }
  bool pdv_view= true;

  TextEditingController lot = TextEditingController();
  int? Future_quantity;

  // String? Url_webview;
  // bool? Status_broker;
  //
  // BrokerConnect_Api(brokerid) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? Id_brokerconnect = prefs.getString('Login_id');
  //
  //   var response = await http.post(
  //       Uri.parse(
  //           "${Util.Main_BasrUrl}/api/client/brokerlink"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         "id": "$Id_brokerconnect",
  //         "apikey": "${api_key.text}",
  //         "apisecret": "${api_secret.text}",
  //         "alice_userid": "${user_id.text}",
  //         "brokerid": "$brokerid"
  //       }));
  //   var jsonString = jsonDecode(response.body);
  //   print("JsnnnnnnPayout: $jsonString");
  //
  //   Status_broker = jsonString['status'];
  //
  //   if (Status_broker == true) {
  //     setState(() {});
  //     Url_webview = jsonString['url'];
  //
  //     print("Urllllll22222: $Url_webview");
  //
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => WebView_broker(Url: Url_webview)));
  //     api_key.clear();
  //   } else {
  //     print("Hello");
  //   }
  // }

  String? Samiti, Tab_name;

  _TradesNewState({required this.Samiti, required this.Tab_name, required this.indexchange});

  String? Kyc_verification;
  String? Dlink_Status;
  String? Trading_Status;
  String? Broker_id;
  String? Api_key;
  String? AliceUser_id;

  GetAllTradingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Kyc_verification = prefs.getString("Kyc_verification");
    // print("987654: $Kyc_verification");
    Dlink_Status = prefs.getString("Dlink_status");
    Trading_Status = prefs.getString("Trading_status");
    Broker_id = prefs.getString("Broker_id");
    Api_key = prefs.getString("Api_key");
    AliceUser_id = prefs.getString("AliceUser_id");
  }

  late final TabController _tabController;

  var Signal_data;
  var Signal_data_close;
  String? Message;
  String? loader = "false";
  // List<String> time = [];
  // List<String> time1 = [];
  // List entryTime_live = [];
  // List entryTime_close = [];

  var open_signal = [];
  var close_signal = [];

  List<double> result = [];

  List<bool> show = [];
  List<bool> show2 = [];

  double percentage = 0.0;

  // Signal_Api() async {
  //
  //   setState(() {
  //     show =[];
  //     Signal_data = [];
  //     open_signal.clear();
  //     GetAllTradingStatus();
  //     loader = "false";
  //     percentageDifference.clear();
  //   });
  //
  //   print("Tab idddddd: $Samiti");
  //   var data = await API.Signal_Api(Samiti, searchController.text, "1");
  //   setState(() {
  //     Signal_data = data['data'];
  //     print("Signal dataaa: $Signal_data");
  //     Message = data['message'];
  //     // loader = true;
  //     NSE_All_Data_Api();
  //   });
  //
  //   for (int i = 0; i < Signal_data.length; i++) {
  //     show.add(false);
  //     open_signal.add(Signal_data[i]);
  //   }
  //   page_get = data['pagination']['page'];
  //   totalPages = data['pagination']['totalPages'];
  //   if(data['pagination']['page']<data['pagination']['totalPages']){
  //     max_page=false;
  //     page=2;
  //   }else{
  //     max_page=true;
  //   }
  // }
  // var NSE_Data;
  // bool loader_nsedata=false;
  // NSE_All_Data_Api() async {
  //   var data = await API.NSE_AllData_Api();
  //   setState(() {
  //     NSE_Data = data['data'];
  //     print("NSE dataaa: $Signal_data");
  //     matchSymbolWithStock();
  //   });
  // }
  // List<double> percentageDifference=[];
  // void matchSymbolWithStock() {
  //   if (NSE_Data != null && Signal_data != null) {
  //     // Create a map for faster lookup of SYMBOL and price from NSE_Data
  //     Map<String, dynamic> nseMap = {
  //       for (var item in NSE_Data) item['SYMBOL']: item['price']
  //     };
  //
  //     for (var signalItem in Signal_data) {
  //       String stock = signalItem['stock'];
  //       if (nseMap.containsKey(stock)) {
  //         double price = nseMap[stock]; //Get the matching price
  //         double tag1Value =
  //         signalItem['tag3'] !=""?
  //         double.tryParse(signalItem['tag3'].toString()) ?? 0.0:
  //         signalItem['tag2'] !=""?
  //         double.tryParse(signalItem['tag2'].toString()) ?? 0.0:
  //         double.tryParse(signalItem['tag1'].toString()) ?? 0.0;
  //
  //         // Calculate percentage difference
  //         if (tag1Value != 0) {
  //           if(signalItem['calltype']=="BUY"){
  //             double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
  //             percentageDifference.add(percentageDifferencee);
  //             print('Match Found Buy: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
  //           }
  //           else{
  //             double percentageDifferencee  =((tag1Value - price).abs() / price) * 100;
  //             percentageDifference.add(percentageDifferencee);
  //             print('Match Found Sell: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
  //           }
  //
  //         } else {
  //           print('Tag1 value is zero or invalid for Stock = $stock');
  //         }
  //       } else {
  //         print('No Match Found for Stock = $stock');
  //       }
  //     }
  //   } else {
  //     print('NSE_Data or Signal_data is null');
  //   }
  //   setState(() {
  //     Signal_data.length>0?
  //     loader="true":
  //     loader="No_data";
  //   });
  // }
  // Future<void> fetchMoreItems() async {
  //
  //   print("qqqqqqqqqqqqqqqq");
  //   if(page_get2<totalPages2){
  //     setState(() {
  //       isLoading2 = true;
  //     });
  //
  //
  //     var data = await API.Signal_Api(Samiti, searchController.text, "$page");
  //     for (int i = 0; i < data['data'].length; i++) {
  //       show.add(false);
  //       open_signal.add(data['data'][i]);
  //     }
  //
  //     if (NSE_Data != null && open_signal != null) {
  //       // Create a map for faster lookup of SYMBOL and price from NSE_Data
  //       Map<String, dynamic> nseMap = {
  //         for (var item in NSE_Data) item['SYMBOL']: item['price']
  //       };
  //
  //       // Iterate through Signal_data to find matches
  //       for (var signalItem in open_signal) {
  //         String stock = signalItem['stock'];
  //         if (nseMap.containsKey(stock)) {
  //           double price = nseMap[stock]; // Get the matching price
  //           // double tag1Value = double.tryParse(signalItem['tag1'].toString()) ?? 0.0;
  //
  //           double tag1Value =signalItem['tag3'] !=""?
  //           double.tryParse(signalItem['tag3'].toString()) ?? 0.0:
  //           signalItem['tag2'] !=""?
  //           double.tryParse(signalItem['tag2'].toString()) ?? 0.0:
  //           double.tryParse(signalItem['tag1'].toString()) ?? 0.0;
  //           // Calculate percentage difference
  //           if (tag1Value != 0) {
  //             double percentageDifferencee  =((price - tag1Value).abs() / tag1Value) * 100;
  //             percentageDifference.add(percentageDifferencee);
  //             print(
  //                 'Match Found: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
  //           } else {
  //             print('Tag1 value is zero or invalid for Stock = $stock');
  //           }
  //         } else {
  //           print('No Match Found for Stock = $stock');
  //         }
  //       }
  //     } else {
  //       print('NSE_Data or Signal_data is null');
  //     }
  //
  //     page_get = data['pagination']['page'];
  //     totalPages = data['pagination']['totalPages'];
  //
  //     if(page_get<totalPages){
  //       setState(() {
  //         max_page=false;
  //         page++;
  //       });
  //
  //     }else{
  //       setState(() {
  //         max_page=true;
  //       });
  //     }
  //
  //     setState(() {
  //       page++;
  //       isLoading = false;
  //     });
  //   }
  // }

  Signal_Api() async {
    setState(() {
      show =[];
      Signal_data = [];
      open_signal.clear();
      GetAllTradingStatus();
      Profile_Api();
      loader = "false";
      percentageDifference.clear();
      percentageDifference1.clear();
    });

    print("Tab idddddd: $Samiti");
    var data = await API.Signal_Api(Samiti, searchController.text, "1");

    print("data['data'] == ${data['data']}");
    print("data['data'] == ${data['data'].length}");
    data['data'].length>0?
    Signal_data = data['data']:
    loader="No_data";
    setState(() {
      print("Signal dataaa: $Signal_data");
      Message = data['message'];
      print("Messageeeeeeeeeeeeeeeeeeeeeeeeee1111: $Message");

      NSE_All_Data_Api();
    });

    for (int i = 0; i < Signal_data.length; i++) {
      show.add(true);
      open_signal.add(Signal_data[i]);
    }
    page_get = data['pagination']['page'];
    totalPages = data['pagination']['totalPages'];
    if(data['pagination']['page']<data['pagination']['totalPages']){
      max_page=false;
      page=2;
    }else{
      max_page=true;
    }
  }
  Future<void> fetchMoreItems() async {
    if(page_get2<totalPages2){
      setState(() {
        isLoading2 = true;
      });


      var data = await API.Signal_Api(Samiti, searchController.text, "$page");
      for (int i = 0; i < data['data'].length; i++) {
        show.add(true);
        open_signal.add(data['data'][i]);
      }

      if (NSE_Data != null && open_signal != null) {
        // Create a map for faster lookup of SYMBOL and price from NSE_Data
        Map<String, dynamic> nseMap = {
          for (var item in NSE_Data) item['SYMBOL']: item['price']
        };

        // Iterate through Signal_data to find matches
        for (var signalItem in open_signal) {
          String stock = signalItem['stock'];
          if (nseMap.containsKey(stock)) {
            double price = nseMap[stock]; // Get the matching price
            // double tag1Value = double.tryParse(signalItem['tag1'].toString()) ?? 0.0;

            double tag1Value =signalItem['tag3'] !=""?
            double.tryParse(signalItem['tag3'].toString()) ?? 0.0:
            signalItem['tag2'] !=""?
            double.tryParse(signalItem['tag2'].toString()) ?? 0.0:
            double.tryParse(signalItem['tag1'].toString()) ?? 0.0;


            if (tag1Value != 0) {
              if(signalItem['calltype']=="BUY"){
                // double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
                double percentageDifferencee  =((tag1Value - price).abs() / price) * 100;
                percentageDifference.add(percentageDifferencee);
                percentageDifference1.add((tag1Value-price).abs());
                print('Match Found Buy: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
                price > tag1Value ?
                potentoalLeftLoader.add(true):
                potentoalLeftLoader.add(false);
              }
              else{
                double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
                percentageDifference.add(percentageDifferencee);
                percentageDifference1.add((price - tag1Value).abs());
                print('Match Found Sell: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
                tag1Value > price ?
                potentoalLeftLoader.add(true):
                potentoalLeftLoader.add(false);
              }
              // double percentageDifferencee  =((price - tag1Value).abs() / tag1Value) * 100;
              // percentageDifference.add(percentageDifferencee);
              // print(
              //     'Match Found: Stock = $stock, '
              //         'Price = $price, Tag1 = $tag1Value, '
              //         'Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
            }

            else {
              print('Tag1 value is zero or invalid for Stock = $stock');
            }
          } else {
            print('No Match Found for Stock = $stock');
          }
        }
      }
      else {
        print('NSE_Data or Signal_data is null');
      }

      page_get = data['pagination']['page'];
      totalPages = data['pagination']['totalPages'];

      if(page_get<totalPages){
        setState(() {
          max_page=false;
          // page++;
        });

      }
      else{
        setState(() {
          max_page=true;
        });
      }

      setState(() {
        page++;
        isLoading = false;
      });
    }
  }
  var NSE_Data;
  bool loader_nsedata=false;
  NSE_All_Data_Api() async {
    var data = await API.NSE_AllData_Api();
    setState(() {
      NSE_Data = data['data'];
      print("NSE dataaa: $Signal_data");
      matchSymbolWithStock();
    });
  }
  List<double> percentageDifference=[];
  List<double> percentageDifference1=[];
  List<bool> potentoalLeftLoader=[];
  void matchSymbolWithStock() {
    if (NSE_Data != null && Signal_data != null) {
      Map<String, dynamic> nseMap = {
        for (var item in NSE_Data) item['SYMBOL']: item['price']
      };

      for (var signalItem in Signal_data) {
        String stock = signalItem['stock'];
        if (nseMap.containsKey(stock)) {
          double price = nseMap[stock]; //Get the matching price
          double tag1Value = signalItem['tag3'] !=""?
          double.tryParse(signalItem['tag3'].toString()) ?? 0.0:
          signalItem['tag2'] !=""?
          double.tryParse(signalItem['tag2'].toString()) ?? 0.0:
          double.tryParse(signalItem['tag1'].toString()) ?? 0.0;

          print("price: $price");
          print("Target: $tag1Value");

          // if (close_signal[i]['calltype'] == "BUY") {
          //   percentage = ((num1 - num2) / num2) * 100;
          // } else {
          //   percentage = ((num2 - num1) / num1) * 100;
          // }

          if (tag1Value != 0) {
            if(signalItem['calltype']=="BUY"){
              // double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
              double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
              percentageDifference.add(percentageDifferencee);
              percentageDifference1.add((price - tag1Value).abs());
              print('Match Found Buy: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
              price > tag1Value ?
              potentoalLeftLoader.add(true):
              potentoalLeftLoader.add(false);
            }
            else{
              double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
              percentageDifference.add(percentageDifferencee);
              percentageDifference1.add((price - tag1Value).abs());
              print('Match Found Sell: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
              tag1Value > price ?
              potentoalLeftLoader.add(true):
              potentoalLeftLoader.add(false);
            }

          } else {
            print('Tag1 value is zero or invalid for Stock = $stock');
          }
        } else {
          print('No Match Found for Stock = $stock');
        }
      }
    }
    else {
      print('NSE_Data or Signal_data is null');
    }
    setState(() {
      Signal_data.length>0?
      loader="true":
      loader="No_data";
    });

  }



  String? loader_closesignal="false";
  List<bool> isApiDateBeforeToday=[];
  Close_Signal_Api() async {
    setState(() {
      show2.clear();
      Signal_data_close = [];
      close_signal.clear();
      GetAllTradingStatus();
      loader_closesignal = "false";
      isApiDateBeforeToday=[];
      result.clear();
    });

    print("Tab idddddd: $Samiti");
    var data = await API.Close_Signal_Api(Samiti, searchController.text, '1');
    page_get2 = data['pagination']['page'];
    totalPages2 = data['pagination']['totalPages'];
    if(data['pagination']['page']<data['pagination']['totalPages']){
      max_page2=false;
      page2=2;
    }else{
      max_page2=true;
    }

    setState(() {
      Signal_data_close = data['data'];
      print("Signal dataaa: $Signal_data_close");
      Message = data['message'];
      Signal_data_close.length>0?
      loader_closesignal="true":
      loader_closesignal="No_data";
    });

    for (int i = 0; i < Signal_data_close.length; i++) {
      show2.add(false);
      close_signal.add(Signal_data_close[i]);
    }

    for (int i = 0; i < close_signal.length; i++) {
      double num1 = double.parse(close_signal[i]['closeprice'] == null ||
          close_signal[i]['closeprice'] == ""
          ? "0.0"
          : close_signal[i]['closeprice']);
      double num2 = double.parse(
          close_signal[i]['price'] == null || close_signal[i]['price'] == ""
              ? "0.0"
              : close_signal[i]['price']);

      if (close_signal[i]['calltype'] == "BUY") {
        percentage = ((num1 - num2) / num2) * 100;
      } else {
        percentage = ((num2 - num1) / num2) * 100;
      }

      String formattedPercentage = percentage.toStringAsFixed(2);

      result.add(double.parse(formattedPercentage));

      if( close_signal[i]['callduration']=='Intraday'){
        // DateTime dateTime = DateTime.parse(close_signal[i]['created_at'].toString());
        // DateTime istTime1 = dateTime.add(const Duration(hours: 5, minutes: 30));
        // String? entryTime_live=  DateFormat('yyyy-mm-dd').format(istTime1);
        //
        // print("Formated Date: $entryTime_live");
        // DateTime parsedApiDate = DateTime.parse(entryTime_live);
        //
        // // Get today's date without time
        // DateTime today = DateTime.now();
        // DateTime todayDateOnly = DateTime(today.year, today.month, today.day);
        // isApiDateBeforeToday.add(parsedApiDate.isBefore(todayDateOnly));


        DateTime dateTime = DateTime.parse(close_signal[i]['created_at'].toString());

        // Convert to IST
        DateTime istTime1 = dateTime.add(const Duration(hours: 5, minutes: 30));

        // Format the date correctly
        String entryTimeLive = DateFormat('yyyy-MM-dd').format(istTime1);

        print("Formatted Date: $entryTimeLive");

        // Parse the formatted date back to DateTime (at midnight)
        DateTime parsedApiDate = DateTime.parse(entryTimeLive);

        // Get today's date without time
        DateTime today = DateTime.now();
        DateTime todayDateOnly = DateTime(today.year, today.month, today.day);

        // Compare the dates
        bool isBeforeToday = parsedApiDate.isBefore(todayDateOnly);
        print("isBeforeToday=== $isBeforeToday");
        isApiDateBeforeToday.add(isBeforeToday);

      }

      else if(close_signal[i]['segment'] == "F" || close_signal[i]['segment'] == "O"){
        String formattedApiDate = "${close_signal[i]['expirydate'].substring(4, 8)}-${close_signal[i]['expirydate'].substring(2, 4)}-${close_signal[i]['expirydate'].substring(0, 2)}";

        print("Formated Date: $formattedApiDate");
        DateTime parsedApiDate = DateTime.parse(formattedApiDate);

        // Get today's date without time
        DateTime today = DateTime.now();
        DateTime todayDateOnly = DateTime(today.year, today.month, today.day);
        isApiDateBeforeToday.add(parsedApiDate.isBefore(todayDateOnly));
      }

      else{
        isApiDateBeforeToday.add(false);
      }

      print(isApiDateBeforeToday);

    }

  }

  var Data_profile;
  bool? Status_profile;
  String? Delete_status_profile;
  String? Active_status_profile;
  bool loader_profile=false;
  String? Email='';

  Profile_Api() async {
    var data = await API.Profile_Api();
    setState(() {
      Data_profile = data['data'];
      Status_profile = data['status'];
    });
    if(Status_profile==true){
      setState(() {});
      Delete_status_profile=Data_profile['del'].toString();
      Active_status_profile=Data_profile['ActiveStatus'].toString();
      Kyc_verification= Data_profile['kyc_verification'].toString();
      Email=Data_profile['Email'];

      Delete_status_profile=="1"||Active_status_profile=="0"?
      handleLogout(context):
      print("Account not deleted");

      loader_profile=true;
    }

    else{
      print("");
    }

  }

  TextEditingController quantity_placeorder = TextEditingController();
  TextEditingController stoplossorTargetPrice = TextEditingController();
  TextEditingController quantity_placeorder_exit = TextEditingController();
  TextEditingController stoploss = TextEditingController();
  TextEditingController target = TextEditingController();
  TextEditingController exitQuantity = TextEditingController();
  bool? Status_placeorder;
  String? Message_placeorder;

  Place_order_Api(Signal_id, Signal_price, Url_placeorder,Future_quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Iddd = prefs.getString('Login_id');
    print("Url_placeorder: $Url_placeorder");
    print("Iddd: $Iddd");
    print("signalid: $Signal_id");
    print("price: $Signal_price");
    print("quantity: ${quantity_placeorder.text}");
    var response = await http.post(Uri.parse("$Url_placeorder"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": "$Iddd",
          "signalid": "$Signal_id",
          "price": Signal_price,
          "quantity": "$Future_quantity",
          "tsprice":target.text==""||target.text==null?"0":"${target.text}",
          "slprice":stoploss.text==""||stoploss.text==null?"0":"${stoploss.text}",
          "exitquantity":exitQuantity.text==""||exitQuantity.text==null?"0":"${exitQuantity.text}",
          "tsstatus":"$selectedOptionn",
        }));
    var jsonString = jsonDecode(response.body);
    print("JsnnnnnnPlaceorder: $jsonString");

    Status_placeorder = jsonString['status'];
    Message_placeorder = jsonString['message'];

    if (Status_placeorder == true) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order Placed Successfuly',
              style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      quantity_placeorder.clear();

      Signal_Api();
      Close_Signal_Api();

      Navigator.pop(context);
    }

    else{
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: "$Message_placeorder"
      );
    }
  }

  bool? Status_placeorder_exit;
  String? Message_exit;

  Exit_order_Api(SignalId_exit, SignalPrice_exit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Id_exit = prefs.getString('Login_id');

    print("111111: $Id_exit");
    print("222222: $SignalId_exit");
    print("333333: $SignalPrice_exit");
    print("444444: ${quantity_placeorder_exit.text}");

    var response = await http.post(
        Broker_id=="1"?
        Uri.parse("${Util.Main_BasrUrl}/angle/exitplaceorder"):
        Broker_id=="2"?
        Uri.parse("${Util.Main_BasrUrl}/aliceblue/exitplaceorder"):
        Broker_id=="3"?
        Uri.parse("${Util.Main_BasrUrl}/kotakneo/exitplaceorder"):
        Broker_id=="4"?
        Uri.parse("${Util.Main_BasrUrl}/markethub/exitplaceorder"):
        Broker_id=="5"?
        Uri.parse("${Util.Main_BasrUrl}/zerodha/exitplaceorder"):
        Broker_id=="6"?
        Uri.parse("${Util.Main_BasrUrl}/upstox/exitplaceorder"):
        Uri.parse("${Util.Main_BasrUrl}/dhan/exitplaceorder"),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          "id": "$Id_exit",
          "signalid": "$SignalId_exit",
          "price": "$SignalPrice_exit",
          "quantity": "${quantity_placeorder_exit.text}"
        }));

    var jsonString = jsonDecode(response.body);
    print("JsnnnnnnExitorder: $jsonString");

    Status_placeorder_exit = jsonString['status'];
    Message_exit = jsonString['message'];

    if (Status_placeorder_exit == true) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_exit',
              style: const TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      quantity_placeorder_exit.clear();

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "$Message_exit",
          textColor: Colors.white);
    }
  }

  String? AngelRedirectUrl;
  String? AliceRedirectUrl;

  GetRedirectUrl() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    AngelRedirectUrl=prefs.getString("AngelRedirectUrl");
    AliceRedirectUrl=prefs.getString("AliceRedirectUrl");
  }

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    Fluttertoast.showToast(
        backgroundColor: Colors.black,
        msg: "Copied to clipboard!",
        textColor: Colors.white
    );
  }


  TextEditingController searchController =  TextEditingController(text: '');
  Search(){
    Signal_Api();
    Close_Signal_Api();
  }

  // TextEditingController searchController = TextEditingController();
  bool _isSearchFieldVisible = false;  // To toggle visibility of search field

  // Function to trigger when the user taps the search icon
  void _toggleSearchField() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this,initialIndex: indexchange!);
    Signal_Api();
    // NSE_All_Data_Api();

    // Future.delayed(Duration(seconds: 15), () {
    //   matchSymbolWithStock();
    // });

    BasicSetting_Apii();
    Close_Signal_Api();
    GetRedirectUrl();
    _scrollController.addListener(_scrollListener);
    _scrollController2.addListener(_scrollListener2);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  bool isLoading2 = false;
  int page = 2;
  int page2 = 2;
  bool max_page = false;
  bool max_page2 = false;
  int page_get=0;
  int page_get2=0;
  int totalPages=1;
  int totalPages2=1;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      fetchMoreItems();
    }
  }
  void _scrollListener2() {
    if (_scrollController2.position.pixels == _scrollController2.position.maxScrollExtent) {
      fetchMoreItems2();
    }
  }

  Future<void> fetchMoreItems2() async {
    if(page_get2<totalPages2){
      setState(() {
        isLoading2 = true;
      });

      var data = await API.Close_Signal_Api(Samiti, searchController.text, page2);
      setState(() {
        Message = data['message'];
        loader_closesignal = "true";
      });
      close_signal.addAll(data['data']);

      for (int i = 0; i < data['data'].length; i++) {
        show2.add(false);

        close_signal.add(Signal_data_close[i]);
      }

      for (int i = 0; i < close_signal.length; i++) {
        double num1 = double.parse(close_signal[i]['closeprice'] == null ||
            close_signal[i]['closeprice'] == ""
            ? "0.0"
            : close_signal[i]['closeprice']);
        double num2 = double.parse(
            close_signal[i]['price'] == null || close_signal[i]['price'] == ""
                ? "0.0"
                : close_signal[i]['price']);

        if (close_signal[i]['calltype'] == "BUY") {
          percentage = ((num1 - num2) / num2) * 100;
        } else {
          percentage = ((num2 - num1) / num1) * 100;
        }

        String formattedPercentage = percentage.toStringAsFixed(2);

        result.add(double.parse(formattedPercentage));
      }

      page_get2 = data['pagination']['page'];
      totalPages2 = data['pagination']['totalPages'];

      if(page_get2<totalPages2){
        setState(() {
          max_page2=false;
          page2++;
        });

      }else{
        setState(() {
          max_page2=true;
        });
      }

      setState(() {
        page++;
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return  Container(
        child: Column(
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 0.3)),
              child: TabBar(
                dividerColor: Colors.transparent,
                // padding: EdgeInsets.only(left: 25,right: 25),
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                indicatorWeight: 0.0,
                isScrollable: false,
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    // stops: [
                    //   0.1,
                    //   0.5,
                    // ],
                    colors: [
                      // Color(0xff93A5CF),
                      // Color(0xffE4EfE9)
                      ColorValues.Splash_bg_color3,
                      ColorValues.Splash_bg_color1,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                tabs: const <Widget>[
                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Live Trades'),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Closed Trades'),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Container(
            //     margin:const EdgeInsets.only(top: 10, left: 35, right: 35, bottom: 0),
            //     child: TextFormField(
            //       cursorColor: Colors.black,
            //       cursorWidth: 1.1,
            //       controller: searchController,
            //       style:const TextStyle(fontSize: 13),
            //       decoration: InputDecoration(
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide:const BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
            //           ),
            //           border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(10),
            //               borderSide:const BorderSide(color: ColorValues.Splash_bg_color1,width:1.1)
            //           ),
            //           hintText: "Search by Stock Name or Entry Type",
            //           contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
            //           hintStyle:const TextStyle(
            //               fontSize: 13
            //           ),
            //           prefixIcon:const Icon(Icons.search)
            //       ),
            //       onChanged: (query) => Search(),
            //     )
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedContainer(
                  alignment: Alignment.topLeft,
                  duration:const Duration(milliseconds: 300), // Duration of the animation
                  width:_isSearchFieldVisible?
                  MediaQuery.of(context).size.width/1.1:60, // Container will take up the full width
                  height: _isSearchFieldVisible ? 40 : 40, // Height expands when the field is visible

                  // decoration: BoxDecoration(
                  //   color: Colors.grey[200],
                  //   borderRadius: BorderRadius.circular(10),
                  // ),

                  margin:const EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: GestureDetector(
                    onTap: _toggleSearchField, // Toggle the visibility of the search field
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: _isSearchFieldVisible
                          ? TextFormField(
                        controller: searchController,
                        cursorColor: Colors.black,
                        cursorWidth: 1.1,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.1),
                            ),
                            hintText: "Search by Stock Name or Entry Type",
                            contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
                            hintStyle: const TextStyle(fontSize: 13),
                            prefixIcon:const Icon(Icons.search)
                        ),
                        onChanged: (query) => Search(),
                      )
                          : Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade500)
                        ),
                        child:const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  loader=="true"?
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: RefreshIndicator(
                      onRefresh: () async{
                        setState(() {
                          Signal_Api();
                          Profile_Api();
                        });
                      },
                      child: ListView.builder(
                        physics:const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: open_signal.length,
                        itemBuilder: (BuildContext context, int indexx) {

                          String? Potential_left_price;
                          double? Potential_left_price1;
                          String? Potential_left_percent;
                          double? Potential_left_percent1;

                          String? target = open_signal[indexx]['tag3'] != ""?
                          open_signal[indexx]['tag3'].toString():
                          open_signal[indexx]['tag2'] != ""?
                          open_signal[indexx]['tag2'].toString():
                          open_signal[indexx]['tag1'].toString();
                          print('open_signal[indexx] ${open_signal[indexx]['segment']} == "O"');
                          print('open_signal[indexx]22 ${open_signal[indexx]['lotsize']}');

                          if(open_signal[indexx]['calltype'] == "BUY"){
                            Potential_left_price1= (double.parse(target)-double.parse(open_signal[indexx]['price'].toString()))*double.parse(open_signal[indexx]['lotsize'].toString());
                            Potential_left_percent1= ((double.parse(target)-double.parse(open_signal[indexx]['price'].toString()))/double.parse(open_signal[indexx]['price'].toString()))*100;
                          }else{
                            Potential_left_price1= (double.parse(open_signal[indexx]['price'].toString())- double.parse(target))*double.parse(open_signal[indexx]['lotsize'].toString());
                            Potential_left_percent1= ((double.parse(open_signal[indexx]['price'].toString())-double.parse(target))/double.parse(open_signal[indexx]['price'].toString()))*100;
                          }

                          Potential_left_price1==Potential_left_price1.floor()?
                          Potential_left_price = Potential_left_price1.toInt().toString():
                          Potential_left_price = Potential_left_price1.toStringAsFixed(2);


                          Potential_left_percent1==Potential_left_percent1.floor()?
                          Potential_left_percent = Potential_left_percent1.toInt().toString():
                          Potential_left_percent = Potential_left_percent1.toStringAsFixed(2);

                          if (indexx == open_signal.length) {
                            return isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : (max_page==true
                                ? const Center(child: Text("No more items to load"))
                                : const SizedBox.shrink());
                          }

                          DateTime dateTime = DateTime.parse(open_signal[indexx]['created_at']);
                          DateTime istTime1 = dateTime.add(const Duration(hours: 5, minutes: 30));
                          String? entryTime_live=  DateFormat('d MMM, HH:mm').format(istTime1);

                          String? target_price= open_signal[indexx]['targethit1'] == "1" && open_signal[indexx]['targetprice3'] != "" ?
                          "${open_signal[indexx]['targetprice3']}":
                          open_signal[indexx]['targethit1'] == "1" && open_signal[indexx]['targetprice2'] != "" ?
                          "${open_signal[indexx]['targetprice2']}":
                          open_signal[indexx]['targethit1'] == "1" && open_signal[indexx]['targetprice1'] != "" ?
                          "${open_signal[indexx]['targetprice1']}":"- -";

                          return Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                            // height: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: const Color(0x7193a5cf),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Container(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.lock_clock,
                                              size: 18,
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                "${entryTime_live}",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      open_signal[indexx]['lot']==""||open_signal[indexx]['lot']==null||open_signal[indexx]['lot']=="0"||open_signal[indexx]['lot']==0?
                                      const SizedBox(width: 0,):
                                      Container(
                                        height: 20,
                                        padding:const EdgeInsets.only(left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.black,
                                              width: 0.3),
                                          color: Colors.white,
                                        ),
                                        alignment: Alignment.center,
                                        child:open_signal[indexx]['segment']=="C"?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                "Sugg. Qty :",
                                                style: TextStyle(
                                                    fontSize: 11, color: Colors.grey.shade700),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only( left: 8),
                                              child: Text(
                                                "${open_signal[indexx]['lot']}",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ):
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                "Lot :",
                                                style: TextStyle(
                                                    fontSize: 11, color: Colors.grey.shade700),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 8),
                                              child: Text(
                                                "${open_signal[indexx]['lot']}",
                                                style:const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                      Container(
                                        height: 20,
                                        // width: 80,
                                        padding:const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.black,
                                              width: 0.3),
                                          color: Colors.white,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${open_signal[indexx]['callduration']}",
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  // height: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 15, top: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width/1.28,
                                              child: Row(
                                                children: [
                                                  open_signal[indexx]['tradesymbol'] == "" || open_signal[indexx]['tradesymbol'] == null
                                                      ? const SizedBox()
                                                      : Container(
                                                    width: MediaQuery.of(context).size.width/1.28-110,
                                                    child: Text("${open_signal[indexx]['tradesymbol']}",
                                                      style: const TextStyle(
                                                          fontSize:
                                                          13,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                  ),

                                                  open_signal[indexx]['purchased']==true?
                                                  GestureDetector(
                                                    onTap: (){
                                                      String? Single_id = open_signal[indexx]['_id'];
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Broker_Responce_Detail(Single_id:Single_id)));
                                                    },
                                                    child: Container(
                                                      height: 20,
                                                      width: 110,
                                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15),
                                                        // border: Border.all(
                                                        //     color: Colors.black,
                                                        //     width: 0.3),
                                                        color: ColorValues.Splash_bg_color1,
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: const Text(
                                                        "Broker Responce",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11),
                                                      ),
                                                    ),
                                                  ):
                                                  const SizedBox(width: 0,),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              margin:const EdgeInsets.only(top: 3),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(
                                                        top: 2),
                                                    child: Text(
                                                      "₹${open_signal[indexx]['price']}",
                                                      style: const TextStyle(
                                                          fontSize:
                                                          11),
                                                    ),
                                                  ),

                                                  // Container(
                                                  //   child: open_signal[indexx]['segment']=="C"?
                                                  //   Row(
                                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                                  //     children: [
                                                  //       Container(
                                                  //         margin: const EdgeInsets.only( left: 10),
                                                  //         child: Text(
                                                  //           "Qty :",
                                                  //           style: TextStyle(
                                                  //               fontSize: 12, color: Colors.grey.shade700),
                                                  //         ),
                                                  //       ),
                                                  //       Container(
                                                  //         margin: const EdgeInsets.only( left: 8),
                                                  //         child: Text(
                                                  //           "${open_signal[indexx]['lot']}",
                                                  //           style: TextStyle(
                                                  //               fontSize: 11,
                                                  //               color: Colors.black,
                                                  //               fontWeight: FontWeight.w600),
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ):
                                                  //   Row(
                                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                                  //     children: [
                                                  //       Container(
                                                  //         margin: const EdgeInsets.only( left: 10),
                                                  //         child: Text(
                                                  //           "Lot :",
                                                  //           style: TextStyle(
                                                  //               fontSize: 12, color: Colors.grey.shade700),
                                                  //         ),
                                                  //       ),
                                                  //       Container(
                                                  //         margin: const EdgeInsets.only(left: 8),
                                                  //         child: Text(
                                                  //           "${open_signal[indexx]['lot']}",
                                                  //           style: TextStyle(
                                                  //               fontSize: 11,
                                                  //               color: Colors.black,
                                                  //               fontWeight: FontWeight.w600),
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                  Spacer(),
                                                  open_signal[indexx]['report_full_path']==null||open_signal[indexx]['report_full_path']==""?
                                                  const SizedBox(width: 0,):
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {

                                                      });
                                                      String? pdf_path=open_signal[indexx]['report_full_path'];

                                                      if(pdv_view==true){
                                                        pdv_view=false;
                                                        downloadFile(pdf_path!, 'sample.pdf').then((file) {
                                                          setState(() {
                                                            localPath = file.path;
                                                            pdv_view=true;
                                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewAnalysisPdf(localPath: localPath,)));
                                                            // View_analysis_popup();

                                                          });
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(right: 15),
                                                      child: Text(
                                                        "View Analysis",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            color: ColorValues
                                                                .Splash_bg_color2),
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorValues
                                                    .Splash_bg_color1,
                                                width: 0.5),
                                            borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              // margin:const EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 6),
                                                        child: Text(
                                                          "Entry price: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              color: Colors
                                                                  .grey
                                                                  .shade700),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8),
                                                        child: Text(
                                                          "( ₹${open_signal[indexx]['price']} )",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              fontSize: 12,
                                                              color: ColorValues
                                                                  .Splash_bg_color1),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  Container(
                                                    height: 20,
                                                    margin:const EdgeInsets.only(right: 5),
                                                    padding:const EdgeInsets.only(left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.1),
                                                      color:const Color(0xffAFE1AF),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child:  Text(
                                                      "${open_signal[indexx]['calltype'][0].toUpperCase() + open_signal[indexx]['calltype'].substring(1).toLowerCase()} ${open_signal[indexx]['entrytype']}",
                                                      style:
                                                      const TextStyle(fontSize: 11, color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 12, left: 10, right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    child: const Text(
                                                      "Stoploss:",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(top: 5),
                                                    child: open_signal[
                                                    indexx]
                                                    [
                                                    'stoploss'] ==
                                                        ""
                                                        ? const Text(
                                                      "- -",
                                                      style: TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    )
                                                        : Text(
                                                      "₹${open_signal[indexx]['stoploss']}",
                                                      style: const TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    child: const Text(
                                                      "Target:",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(top: 5),
                                                    child:Text(
                                                        "$target_price",
                                                        style:const TextStyle( fontSize: 12,
                                                            fontWeight: FontWeight.w600)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    child: const Text(
                                                      "Hold duration:",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  open_signal[indexx]['segment'] == "F" || open_signal[indexx]['segment'] == "O"
                                                      ? Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(
                                                        top: 5),
                                                    child: Text(
                                                      "${open_signal[indexx]['expirydate'].substring(0, 2)}-${open_signal[indexx]['expirydate'].substring(2, 4)}-${open_signal[indexx]['expirydate'].substring(4, 8)}",
                                                      style: const TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  )
                                                      : Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(
                                                        top: 5),
                                                    child: Text(
                                                      open_signal[indexx]
                                                      [
                                                      'callduration'] ==
                                                          "Intraday"
                                                          ? "Intraday"
                                                          : open_signal[indexx]['callduration'] ==
                                                          "Short Term"
                                                          ? "(15-30 days)"
                                                          : open_signal[indexx]['callduration'] == "Medium Term"
                                                          ? "(Above 3 month)"
                                                          : "(Above 1 year)",
                                                      style: const TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print("Hello");
                                          setState(() {
                                            show[indexx] = !show[indexx];
                                          });
                                          print(
                                              "Hello=== ${show[indexx]}");
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 12,
                                              bottom: 12),
                                          height: 25,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              color:
                                              Colors.grey.shade200),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                const EdgeInsets.only(
                                                    left: 8,
                                                    bottom: 2),
                                                child: Text(
                                                  "Entry price :",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors
                                                          .grey.shade700),
                                                ),
                                              ),


                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    margin:
                                                    const EdgeInsets.only(
                                                        right: 15,
                                                        bottom: 2),
                                                    child: Text(
                                                      "₹${open_signal[indexx]['price']}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey.shade700),
                                                    ),
                                                  ),
                                                  Container(
                                                      margin: const EdgeInsets
                                                          .only(
                                                          right: 8,
                                                          bottom: 3),
                                                      child: Icon(
                                                        show[indexx] == true
                                                            ? Icons
                                                            .arrow_drop_up
                                                            : Icons
                                                            .arrow_drop_down,
                                                        size: 25,
                                                        color: Colors.black,
                                                      )),

                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),


                                      show[indexx] == true && open_signal[indexx]['tag1'] != ""?
                                      (open_signal[indexx]['targethit1'] == "1" && open_signal[indexx]['calltype'].toUpperCase()=="BUY" && double.parse(open_signal[indexx]['tag1']) <= double.parse(target_price)) ||
                                          (open_signal[indexx]['targethit1']  == "1" && open_signal[indexx]['calltype'].toUpperCase()=="SELL" && double.parse(open_signal[indexx]['tag1']) >= double.parse(target_price))?
                                      Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(8),
                                            color: Colors
                                                .green),
                                        margin:
                                        const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 1",
                                                style: TextStyle(
                                                    fontSize: 11,color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right: 10),
                                              child: Text(
                                                "₹${open_signal[indexx]['tag1']}",
                                                style:
                                                const TextStyle(
                                                    fontSize:
                                                    11,color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ):
                                      open_signal[indexx]['tag1'] != ""?
                                      Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(8),
                                            color: Colors
                                                .grey.shade200),
                                        margin:
                                        const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 1",
                                                style: TextStyle(
                                                    fontSize: 11),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right: 10),
                                              child: Text(
                                                "₹${open_signal[indexx]['tag1']}",
                                                style:
                                                const TextStyle(
                                                    fontSize:
                                                    11),
                                              ),
                                            )
                                          ],
                                        ),
                                      ) :
                                      const SizedBox(height: 0):
                                      const SizedBox(height: 0),


                                      show[indexx] == true && open_signal[indexx]['tag2'] != "" ?
                                      (open_signal[indexx]['targethit1'] == "1"&& open_signal[indexx]['calltype'].toUpperCase()=="BUY" && double.parse(open_signal[indexx]['tag2']) <= double.parse(target_price)) ||
                                          (open_signal[indexx]['targethit1'] == "1"&& open_signal[indexx]['calltype'].toUpperCase()=="SELL" && double.parse(open_signal[indexx]['tag2']) >= double.parse(target_price))?
                                      Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(8),
                                            color: Colors
                                                .green),
                                        margin:
                                        const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 2",
                                                style: TextStyle(
                                                    fontSize: 11,color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right: 10),
                                              child: Text(
                                                "₹${open_signal[indexx]['tag2']}",
                                                style:
                                                const TextStyle(
                                                    fontSize:
                                                    11,color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ):
                                      open_signal[indexx]['tag2'] != ""?
                                      Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(8),
                                            color: Colors
                                                .grey.shade200),
                                        margin:
                                        const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 2",
                                                style: TextStyle(
                                                    fontSize: 11),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right: 10),
                                              child: Text(
                                                "₹${open_signal[indexx]['tag2']}",
                                                style:
                                                const TextStyle(
                                                    fontSize:
                                                    11),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                          : const SizedBox(height: 0):
                                      const SizedBox(height: 0),


                                      show[indexx] == true && open_signal[indexx]['tag3'] != "" ?
                                      (open_signal[indexx]['targethit1'] == "1"&& open_signal[indexx]['calltype'].toUpperCase()=="BUY" && double.parse(open_signal[indexx]['tag3']) <= double.parse(target_price)) ||
                                          (open_signal[indexx]['targethit1'] == "1"&& open_signal[indexx]['calltype'].toUpperCase()=="SELL" && double.parse(open_signal[indexx]['tag3']) >= double.parse(target_price))?
                                      Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(8),
                                            color: Colors
                                                .green),
                                        margin:
                                        const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 3",
                                                style: TextStyle(
                                                    fontSize: 11,color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right: 10),
                                              child: Text(
                                                "₹${open_signal[indexx]['tag3']}",
                                                style:
                                                const TextStyle(
                                                    fontSize:
                                                    11,color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ):
                                      open_signal[indexx]['tag3'] != ""?
                                      Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(8),
                                            color: Colors
                                                .grey.shade200),
                                        margin:
                                        const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 3",
                                                style: TextStyle(
                                                    fontSize: 11),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right: 10),
                                              child: Text(
                                                "₹${open_signal[indexx]['tag3']}",
                                                style:
                                                const TextStyle(
                                                    fontSize:
                                                    11),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                          : const SizedBox(height: 0):
                                      const SizedBox(height: 0),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                                  height: 40,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // open_signal[indexx]['segment']=="O"?
                                      //     :
                                      // Container(
                                      //   height: 30,
                                      //   margin:const EdgeInsets.only(left: 10),
                                      //   padding:const EdgeInsets.only(left: 10,right: 10),
                                      //   decoration: BoxDecoration(
                                      //       color:const Color(0xffAFE1AF),
                                      //       borderRadius: BorderRadius.circular(8)
                                      //   ),
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.start,
                                      //     children: [
                                      //       Container(
                                      //         child:const Text(
                                      //           "Potential left: ",
                                      //           style: TextStyle(
                                      //               fontWeight:
                                      //               FontWeight
                                      //                   .w500,
                                      //               color: Colors
                                      //                   .black),
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         margin: const EdgeInsets.only(left: 8),
                                      //         child:Text(
                                      //           "${percentageDifference[indexx].toStringAsFixed(2)}%",
                                      //           style:const TextStyle(
                                      //               fontWeight:
                                      //               FontWeight
                                      //                   .w600,
                                      //               fontSize: 12,
                                      //               color:Colors.black),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      // open_signal[indexx]['report_full_path']==null||open_signal[indexx]['report_full_path']==""?
                                      // const SizedBox(width: 0,):
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     setState(() {
                                      //
                                      //     });
                                      //     String? pdf_path=open_signal[indexx]['report_full_path'];
                                      //
                                      //     if(pdv_view==true){
                                      //       pdv_view=false;
                                      //       downloadFile(pdf_path!, 'sample.pdf').then((file) {
                                      //         setState(() {
                                      //           localPath = file.path;
                                      //           pdv_view=true;
                                      //           Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewAnalysisPdf(localPath: localPath,)));
                                      //           // View_analysis_popup();
                                      //
                                      //         });
                                      //       });
                                      //     }
                                      //   },
                                      //   child: Container(
                                      //     child: const Text(
                                      //       "View Analysis",
                                      //       style: TextStyle(
                                      //           fontSize: 13,
                                      //           fontWeight:
                                      //           FontWeight.w600,
                                      //           color: ColorValues
                                      //               .Splash_bg_color2),
                                      //     ),
                                      //   ),
                                      // ),

                                      // GestureDetector(
                                      //   onTap: () {
                                      //     String? Description = open_signal[indexx]['description'];
                                      //     Description_popup(Description);
                                      //   },
                                      //   child: Container(
                                      //     margin: const EdgeInsets.only(left: 20),
                                      //     child: const Text(
                                      //       "View Detail",
                                      //       style: TextStyle(
                                      //           fontSize: 13,
                                      //           fontWeight:
                                      //           FontWeight.w600,
                                      //           color: ColorValues
                                      //               .Splash_bg_color2),
                                      //     ),
                                      //   ),
                                      // ),

                                      Container(
                                        height: 30,
                                        margin:const EdgeInsets.only(left: 10),
                                        padding:const EdgeInsets.only(left: 10,right: 10),
                                        decoration: BoxDecoration(
                                            color:const Color(0xffAFE1AF),
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:const Text(
                                                "Potential left: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 8),
                                              child:Text(
                                                open_signal[indexx]['segment'] =="O"?
                                                "$Potential_left_price ($Potential_left_percent%)":
                                                open_signal[indexx]['segment'] == "F"?
                                                "$Potential_left_price ($Potential_left_percent%)":
                                                "${percentageDifference[indexx].toStringAsFixed(2)}%",

                                                style:const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color:Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                      open_signal[indexx]['calltype'] == "BUY" || open_signal[indexx]['calltype'] == "buy"
                                          ? GestureDetector(
                                        onTap: () {
                                          // if (Kyc_verification == "1" || kyc_basicsetting=="0") {
                                            if (Dlink_Status == "0") {
                                              // Broker_link_popup();
                                              Add_Broker.Broker_link(context);
                                            } else {
                                              if (Trading_Status == "0") {
                                                if (Broker_id == "1") {
                                                  String? Url = "https://smartapi.angelone.in/publisher-login?api_key=${Api_key}";
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebView_broker(Url: Url, Broker_idd:Broker_id, aliceuser_id:AliceUser_id,)));
                                                } else if (Broker_id == "2"){
                                                  String? Url = "https://ant.aliceblueonline.com/?appcode=${Api_key}";
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebView_broker(Url: Url,Broker_idd:Broker_id, aliceuser_id:AliceUser_id,)));
                                                }
                                                else if(Broker_id=="5"){
                                                  String? Url="https://kite.zerodha.com/connect/login?v=3&api_key=${Api_key}";
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url,Broker_idd:Broker_id, aliceuser_id: AliceUser_id,)));
                                                }
                                                else if(Broker_id=="6"){
                                                  String? Url="https://api-v2.upstox.com/login/authorization/dialog?response_type=code&client_id=${Api_key}&redirect_uri=${Util.Url}/backend/upstox/getaccesstoken&state=${Email}";
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url,Broker_idd:Broker_id, aliceuser_id: AliceUser_id,)));
                                                }
                                                else{
                                                  print("error");
                                                }
                                              } else {
                                                String?Signal_id = open_signal[indexx]['_id'];
                                                String?Signal_price = open_signal[indexx]['price'];
                                                String?Signal_name = open_signal[indexx]['stock'];
                                                String?Entry_type = open_signal[indexx]['calltype'];
                                                String?Segment = open_signal[indexx]['segment'];

                                                String?
                                                Expiry_date =
                                                open_signal[
                                                indexx]
                                                [
                                                'expirydate'];
                                                String?Trade_Symbol = open_signal[indexx]['tradesymbol'];
                                                print("Trade symbol : $Trade_Symbol");

                                                String?Lot_size = open_signal[indexx]['lotsize'].toString();
                                                String? Target= open_signal[indexx]['tag3']!=""?
                                                open_signal[indexx]['tag3']:
                                                open_signal[indexx]['tag2']!=""?
                                                open_signal[indexx]['tag2']:
                                                open_signal[indexx]['tag1'];


                                                print('''''
                                                        Signal_id = $Signal_id,
                                                        Signal_price - $Signal_price,
                                                        Signal_name== $Signal_name,
                                                        Entry_type == $Entry_type,
                                                        Lot_size == $Lot_size,
                                                        Trade_Symbol == $Trade_Symbol,
                                                        Segment == $Segment
                                                        ''''');

                                                if (Broker_id == "1") {
                                                  String?Url_placeorder = "${Util.Main_BasrUrl}/angle/placeorder";
                                                  Place_order_popup(
                                                      Signal_id,
                                                      Signal_price,
                                                      Url_placeorder,
                                                      Signal_name,
                                                      Entry_type,
                                                      Lot_size,
                                                      Trade_Symbol,
                                                      Segment,
                                                      Target
                                                  );
                                                }
                                                else if (Broker_id == "2"){
                                                  String?Url_placeorder = "${Util.Main_BasrUrl}/aliceblue/placeorder";
                                                  Place_order_popup(
                                                      Signal_id,
                                                      Signal_price,
                                                      Url_placeorder,
                                                      Signal_name,
                                                      Entry_type,
                                                      Lot_size,
                                                      Trade_Symbol,
                                                      Segment,
                                                      Target
                                                  );
                                                }

                                                else if (Broker_id == "3"){
                                                  String?Url_placeorder = "${Util.Main_BasrUrl}/kotakneo/placeorder";
                                                  Place_order_popup(
                                                      Signal_id,
                                                      Signal_price,
                                                      Url_placeorder,
                                                      Signal_name,
                                                      Entry_type,
                                                      Lot_size,
                                                      Trade_Symbol,
                                                      Segment,
                                                      Target
                                                  );
                                                }

                                                else if (Broker_id == "4"){
                                                  String?Url_placeorder = "${Util.Main_BasrUrl}/markethub/placeorder";
                                                  Place_order_popup(Signal_id, Signal_price, Url_placeorder, Signal_name, Entry_type, Lot_size, Trade_Symbol, Segment, Target);
                                                }

                                                else if (Broker_id == "5"){
                                                  String?Url_placeorder = "${Util.Main_BasrUrl}/zerodha/placeorder";
                                                  Place_order_popup(Signal_id, Signal_price, Url_placeorder, Signal_name, Entry_type, Lot_size, Trade_Symbol, Segment, Target);
                                                }
                                                else if (Broker_id == "6"){
                                                  String?Url_placeorder = "${Util.Main_BasrUrl}/upstox/placeorder";
                                                  Place_order_popup(Signal_id, Signal_price, Url_placeorder, Signal_name, Entry_type, Lot_size, Trade_Symbol, Segment, Target);
                                                }

                                                else{
                                                  String?Url_placeorder = "${Util.Main_BasrUrl}/dhan/placeorder";
                                                  Place_order_popup(Signal_id, Signal_price, Url_placeorder, Signal_name, Entry_type, Lot_size, Trade_Symbol, Segment, Target);
                                                }

                                              }
                                            }
                                          // } else {
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder:
                                          //               (context) =>
                                          //           const Kyc_formView())).then((value) => CallApi());
                                          // }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          height: 25,
                                          padding:const EdgeInsets.only(left: 14,right: 14),
                                          alignment:
                                          Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: Colors.green),
                                          child:open_signal[indexx]['purchased']==true?
                                          Text(
                                            "${open_signal[indexx]['calltype']} (Add More)",
                                            style:
                                            const TextStyle(
                                                fontSize:
                                                12,
                                                color: Colors
                                                    .white),
                                          ):
                                          Text(
                                            "${open_signal[indexx]['calltype']}",
                                            style:
                                            const TextStyle(
                                                fontSize:
                                                12,
                                                color: Colors
                                                    .white),
                                          ),
                                        ),
                                      )
                                        : GestureDetector(
                                        onTap: () {
                                          // if (Kyc_verification == "1" || kyc_basicsetting=="0") {
                                            if (Dlink_Status ==
                                                "0") {
                                              // Broker_link_popup();
                                              Add_Broker.Broker_link(context);
                                            } else {
                                              if (Trading_Status ==
                                                  "0") {
                                                if (Broker_id == "1") {
                                                  String? Url = "https://smartapi.angelone.in/publisher-login?api_key=${Api_key}";
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebView_broker(Url: Url,Broker_idd:Broker_id, aliceuser_id:AliceUser_id,)));
                                                } else if (Broker_id == "2"){
                                                  String? Url = "https://ant.aliceblueonline.com/?appcode=${Api_key}";
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebView_broker(Url: Url,Broker_idd:Broker_id, aliceuser_id:AliceUser_id,)));
                                                }
                                                else if(Broker_id=="5"){
                                                  String? Url="https://kite.zerodha.com/connect/login?v=3&api_key=${Api_key}";
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url,Broker_idd:Broker_id, aliceuser_id: AliceUser_id,)));
                                                }
                                                else if(Broker_id=="6"){
                                                  String? Url="https://api-v2.upstox.com/login/authorization/dialog?response_type=code&client_id=${Api_key}&redirect_uri=${Util.Url}/backend/upstox/getaccesstoken&state=${Email}";
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url,Broker_idd:Broker_id, aliceuser_id: AliceUser_id,)));
                                                }
                                                else{
                                                  print("error");
                                                }
                                              } else {
                                                String?
                                                Signal_id =
                                                open_signal[
                                                indexx]
                                                ['_id'];
                                                String?
                                                Signal_price =
                                                open_signal[
                                                indexx]
                                                [
                                                'price'];
                                                String?
                                                Signal_name =
                                                open_signal[
                                                indexx]
                                                [
                                                'stock'];
                                                String?
                                                Entry_type =
                                                open_signal[
                                                indexx]
                                                [
                                                'calltype'];
                                                String?
                                                Segment =
                                                open_signal[
                                                indexx]
                                                [
                                                'segment'];
                                                String?
                                                Expiry_date =
                                                open_signal[
                                                indexx]
                                                [
                                                'expirydate'];
                                                String?Lot_size = open_signal[indexx]['lotsize'].toString();
                                                String?Trade_Symbol = open_signal[indexx]['tradesymbol'];
                                                String? Target= open_signal[indexx]['tag3']!=""?
                                                open_signal[indexx]['tag3']:
                                                open_signal[indexx]['tag2']!=""?
                                                open_signal[indexx]['tag2']:
                                                open_signal[indexx]['tag1'];

                                                print('''''
                                                        Signal_id = $Signal_id,
                                                        Signal_price - $Signal_price,
                                                        Signal_name== $Signal_name,
                                                        Entry_type == $Entry_type,
                                                        Lot_size == $Lot_size,
                                                        Trade_Symbol == $Trade_Symbol,
                                                        Segment == $Segment
                                                        ''''');

                                                if (Broker_id == "1") {
                                                  String? Url_placeorder = "${Util.Main_BasrUrl}/angle/placeorder";
                                                  Place_order_popup(
                                                      Signal_id,
                                                      Signal_price,
                                                      Url_placeorder,
                                                      Signal_name,
                                                      Entry_type,
                                                      Lot_size,
                                                      Trade_Symbol,
                                                      Segment,
                                                      Target
                                                  );
                                                }
                                                else if(Broker_id == "2"){
                                                  String? Url_placeorder = "${Util.Main_BasrUrl}/aliceblue/placeorder";
                                                  Place_order_popup(
                                                      Signal_id,
                                                      Signal_price,
                                                      Url_placeorder,
                                                      Signal_name,
                                                      Entry_type,
                                                      Lot_size,
                                                      Trade_Symbol,
                                                      Segment,
                                                      Target
                                                  );
                                                }

                                                else if(Broker_id == "3"){
                                                  String? Url_placeorder = "${Util.Main_BasrUrl}/kotakneo/placeorder";
                                                  Place_order_popup(
                                                      Signal_id,
                                                      Signal_price,
                                                      Url_placeorder,
                                                      Signal_name,
                                                      Entry_type,
                                                      Lot_size,
                                                      Trade_Symbol,
                                                      Segment,
                                                      Target
                                                  );
                                                }

                                                else if(Broker_id == "4"){
                                                  String? Url_placeorder = "${Util.Main_BasrUrl}/markethub/placeorder";
                                                  Place_order_popup(Signal_id, Signal_price, Url_placeorder, Signal_name, Entry_type, Lot_size, Trade_Symbol, Segment, Target);
                                                }

                                                else if(Broker_id == "5"){
                                                  String? Url_placeorder = "${Util.Main_BasrUrl}/zerodha/placeorder";
                                                  Place_order_popup(Signal_id, Signal_price, Url_placeorder, Signal_name, Entry_type, Lot_size, Trade_Symbol, Segment, Target);
                                                }
                                                else if(Broker_id == "6"){
                                                  String? Url_placeorder = "${Util.Main_BasrUrl}/upstox/placeorder";
                                                  Place_order_popup(Signal_id, Signal_price, Url_placeorder, Signal_name, Entry_type, Lot_size, Trade_Symbol, Segment, Target);
                                                }
                                                else{
                                                  String? Url_placeorder = "${Util.Main_BasrUrl}/dhan/placeorder";
                                                  Place_order_popup(Signal_id, Signal_price, Url_placeorder, Signal_name, Entry_type, Lot_size, Trade_Symbol, Segment, Target);
                                                }
                                              }
                                            }
                                          // } else {
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder:
                                          //               (context) =>
                                          //           const Kyc_formView())).then((value) => CallApi());
                                          // }
                                        },
                                        child: Container(
                                          margin:
                                          const EdgeInsets.only(right: 10),
                                          padding:const EdgeInsets.only(left: 14,right: 14),
                                          height: 25,
                                          alignment:
                                          Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  4),
                                              color:
                                              Colors.red),
                                          child: Text(
                                            open_signal[indexx]['purchased']==true?
                                            "${open_signal[indexx]['calltype']} (Add More)":
                                            "${open_signal[indexx]['calltype']}",
                                            style: const TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ):
                  loader=="No_data"?
                  Container(
                    child: Center(
                        child: Image.asset(
                          "images/notrades.png",
                          height: 100,
                        )),
                  ):
                  Container(
                    child: Center(
                        child:CircularProgressIndicator(color: ColorValues.Splash_bg_color1,)
                    ),
                  ),


                  loader_closesignal == "true" ?
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: RefreshIndicator(
                      onRefresh: () async{
                        setState(() {
                          Close_Signal_Api();
                        });
                      },
                      child: ListView.builder(
                        physics:const AlwaysScrollableScrollPhysics(),
                        itemCount: close_signal.length,
                        itemBuilder: (BuildContext context, int index) {


                          if (index == close_signal.length) {
                            return isLoading2
                                ? const Center(child: CircularProgressIndicator())
                                : (max_page2==true
                                ? const Center(child: Text("No more items to load"))
                                : const SizedBox.shrink());
                          }


                          DateTime dateTime1 = DateTime.parse(Signal_data_close[index]['closedate']);
                          DateTime istTime = dateTime1.add(const Duration(hours: 5, minutes: 30));
                          String? entryTime_close=  DateFormat('d MMM, HH:mm').format(istTime);

                          return Container(
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 15, right: 15),
                            // height: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: const Color(0x7193a5cf),
                            ),
                            child: close_signal[index]['closeprice']=="0.0"||close_signal[index]['closeprice']=="0"||close_signal[index]['closeprice']==0.0||close_signal[index]['closeprice']==0?
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.lock_clock,
                                              size: 18,
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                "${entryTime_close}",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        // width: 80,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.black,
                                              width: 0.3),
                                          color: Colors.white,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${close_signal[index]['callduration']}",
                                          style: const TextStyle(
                                              fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  height: show2[index] == true && close_signal[index]['tag1'] != "" && close_signal[index]['tag2'] != "" && close_signal[index]['tag3'] != ""
                                      ? 380
                                      : show2[index] == true && close_signal[index]['tag1'] != "" && close_signal[index]['tag2'] != "" && close_signal[index]['tag3'] == ""
                                      ? 350
                                      : show2[index] == true && close_signal[index]['tag1'] != "" && close_signal[index]['tag2'] == "" && close_signal[index]['tag3'] == ""
                                      ? 310 :
                                  close_signal[index]['closeprice']=="0.0"||close_signal[index]['closeprice']=="0"||close_signal[index]['closeprice']==0.0||close_signal[index]['closeprice']==0?
                                  200:
                                  283,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                        const EdgeInsets.only(top: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [

                                            Container(
                                              margin:
                                              const EdgeInsets.only(
                                                  left: 15, top: 5),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width/1.28,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        close_signal[index]['tradesymbol'] == "" || close_signal[index]['tradesymbol'] == null
                                                            ? const SizedBox()
                                                            : Container(
                                                          width: MediaQuery.of(context).size.width/1.28-10,
                                                          child: Text("${close_signal[index]['tradesymbol']}",
                                                            style: const TextStyle(
                                                                fontSize: 13, fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                  Container(
                                                      width: MediaQuery.of(context).size.width/1.28,
                                                      margin: const EdgeInsets.only(top: 3),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              "₹${close_signal[index]['price']}",
                                                              style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                  11),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      right: 5),
                                                                  child: const Text(
                                                                    "Entry Type :",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                        color:
                                                                        Colors.grey),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                    right: 15,),
                                                                  child: Text(
                                                                    "${close_signal[index]['calltype']}",
                                                                    style: const TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, left: 15, right: 15),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorValues
                                                    .Splash_bg_color1,
                                                width: 0.5),
                                            borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Suggested Entry: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          color: Colors
                                                              .grey
                                                              .shade700),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                     EdgeInsets
                                                        .only(
                                                        left: 8),
                                                    child: Text(
                                                      "₹${close_signal[index]['price']}",
                                                      style:  TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          color: ColorValues
                                                              .Splash_bg_color1),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        height: 80,
                                        alignment: Alignment.topLeft,
                                        // color: Colors.red,
                                        margin:const EdgeInsets.only(left: 15,right: 15,top: 12),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: RichText(
                                            text: TextSpan(
                                                children: [
                                                   TextSpan(
                                                    text: "Avoid Description :",
                                                    style: TextStyle(fontSize:15, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w600),
                                                  ),
                                                  TextSpan(
                                                    text: " ${close_signal[index]['close_description']}",
                                                    style:const TextStyle(fontSize: 14,letterSpacing: 0.7, color: Colors.black, fontWeight: FontWeight.w400),
                                                  ),
                                                ]),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 10,
                                        left: 15,
                                        right: 15,
                                        bottom: 15
                                    ),
                                    height: 35,
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Avoid Trade",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 8),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ):
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.lock_clock,
                                              size: 18,
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                "${entryTime_close}",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        // width: 80,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.black,
                                              width: 0.3),
                                          color: Colors.white,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${close_signal[index]['callduration']}",
                                          style: const TextStyle(
                                              fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 15, left: 15, right: 15),
                                  height: show2[index] == true && close_signal[index]['tag1'] != "" && close_signal[index]['tag2'] != "" && close_signal[index]['tag3'] != ""
                                      ? 380
                                      : show2[index] == true && close_signal[index]['tag1'] != "" && close_signal[index]['tag2'] != "" && close_signal[index]['tag3'] == ""
                                      ? 350
                                      : show2[index] == true && close_signal[index]['tag1'] != "" && close_signal[index]['tag2'] == "" && close_signal[index]['tag3'] == ""
                                      ? 310 : 283,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                        const EdgeInsets.only(top: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [

                                            Container(
                                              margin:
                                              const EdgeInsets.only(
                                                  left: 15, top: 5),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width/1.28,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        close_signal[index]['tradesymbol'] == "" || close_signal[index]['tradesymbol'] == null
                                                            ? const SizedBox()
                                                            : Container(
                                                          width: MediaQuery.of(context).size.width/1.28-10,
                                                          child: Text("${close_signal[index]['tradesymbol']}",
                                                            style: const TextStyle(
                                                                fontSize: 13, fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                  Container(
                                                      width: MediaQuery.of(context).size.width/1.28,
                                                      margin: const EdgeInsets.only(top: 3),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              "₹${close_signal[index]['price']}",
                                                              style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                  11),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      right: 5),
                                                                  child: const Text(
                                                                    "Entry Type :",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                        color:
                                                                        Colors.grey),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                    right: 15,),
                                                                  child: Text(
                                                                    "${close_signal[index]['calltype']}",
                                                                    style: const TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, left: 15, right: 15),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorValues
                                                    .Splash_bg_color1,
                                                width: 0.5),
                                            borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Suggested Entry: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          color: Colors
                                                              .grey
                                                              .shade700),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 8),
                                                    child: Text(
                                                      "₹${close_signal[index]['price']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          color: ColorValues
                                                              .Splash_bg_color1),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                      Container(
                                        margin: const EdgeInsets.only(top: 17, left: 10, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    child: const Text(
                                                      "Stoploss:",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  close_signal[index][
                                                  'stoploss'] ==
                                                      "" ||
                                                      close_signal[
                                                      index]
                                                      [
                                                      'stoploss'] ==
                                                          null
                                                      ? Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(
                                                        top: 5),
                                                    child:
                                                    const Text(
                                                      "- -",
                                                      style: TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  )
                                                      : Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(
                                                        top: 5),
                                                    child: Text(
                                                      "₹${close_signal[index]['stoploss']}",
                                                      style: const TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    child: const Text(
                                                      "Exit Price:",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(top: 5),
                                                    child:Text("₹${close_signal[index]['closeprice']}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                    // Text(
                                                    //   close_signal[index][
                                                    //               'tag3'] !=
                                                    //           ""
                                                    //       ? "₹${close_signal[index]['tag3']}"
                                                    //       : close_signal[index]
                                                    //                   [
                                                    //                   'tag2'] !=
                                                    //               ""
                                                    //           ? "₹${close_signal[index]['tag2']}"
                                                    //           : "₹${close_signal[index]['tag1']}",
                                                    //   style: const TextStyle(
                                                    //       fontSize: 12,
                                                    //       fontWeight:
                                                    //           FontWeight
                                                    //               .w600),
                                                    // ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    child: const Text(
                                                      "Hold duration:",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  close_signal[index]['segment'] == "F" || close_signal[index]['segment'] == "O"
                                                      ? Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(
                                                        top: 5),
                                                    child: Text(
                                                      "${close_signal[index]['expirydate'].substring(0, 2)}-${close_signal[index]['expirydate'].substring(2, 4)}-${close_signal[index]['expirydate'].substring(4, 8)}",
                                                      style: const TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  )
                                                      : Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .only(
                                                        top: 5),
                                                    child: Text(
                                                      close_signal[index]
                                                      [
                                                      'callduration'] ==
                                                          "Intraday"
                                                          ? "- -"
                                                          : close_signal[index]['callduration'] ==
                                                          "Short Term"
                                                          ? "(15-30 days)"
                                                          : close_signal[index]['callduration'] == "Medium Term"
                                                          ? "(Above 3 month)"
                                                          : "(Above 1 year)",
                                                      style: const TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          print("Hello");
                                          setState(() {
                                            show2[index] = !show2[index];
                                          });
                                          print(
                                              "Hello=== ${show2[index]}");
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 15),
                                          height: 25,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              color:
                                              Colors.grey.shade200),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                const EdgeInsets.only(
                                                    left: 12),
                                                child: Text(
                                                  "See Targets :",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors
                                                          .grey.shade700),
                                                ),
                                              ),
                                              Container(
                                                  margin: const EdgeInsets
                                                      .only(
                                                      right: 8,
                                                      bottom: 3),
                                                  child: Icon(
                                                    show2 == true
                                                        ? Icons
                                                        .arrow_drop_up
                                                        : Icons
                                                        .arrow_drop_down,
                                                    size: 25,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),

                                      show2[index] == true && close_signal[index]['tag1'] != "" ?
                                      (close_signal[index]['calltype'].toUpperCase()=="BUY" && double.parse(close_signal[index]['tag1']) <= double.parse(close_signal[index]['closeprice'])) ||
                                          (close_signal[index]['calltype'].toUpperCase()=="SELL" && double.parse(close_signal[index]['tag1']) >= double.parse(close_signal[index]['closeprice']))
                                          ? Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.green),
                                        margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(left: 10),
                                              child: const Text(
                                                "Target 1",
                                                style: TextStyle(fontSize: 11, color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets.only(right: 10),
                                              child: Text(
                                                "₹${close_signal[index]['tag1']}",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                          : Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8),
                                            color: Colors
                                                .grey.shade200),
                                        margin: const EdgeInsets
                                            .only(
                                            left: 15,
                                            right: 15,
                                            top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 1",
                                                style: TextStyle(
                                                    fontSize:
                                                    11),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right:
                                                  10),
                                              child: Text(
                                                "₹${close_signal[index]['tag1']}",
                                                style:
                                                const TextStyle(
                                                    fontSize:
                                                    11),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                          : const SizedBox(
                                        height: 0,
                                      ),

                                      show2[index] == true && close_signal[index]['tag2'] != "" ?
                                      (close_signal[index]['calltype'].toUpperCase()=="BUY" && double.parse(close_signal[index]['tag2']) <= double.parse(close_signal[index]['closeprice'])) ||
                                          (close_signal[index]['calltype'].toUpperCase()=="SELL" && double.parse(close_signal[index]['tag2']) >= double.parse(close_signal[index]['closeprice']))
                                          ? Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8),
                                            color:
                                            Colors.green),
                                        margin: const EdgeInsets
                                            .only(
                                            left: 15,
                                            right: 15,
                                            top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 2",
                                                style: TextStyle(
                                                    fontSize:
                                                    11,
                                                    color: Colors
                                                        .white),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right:
                                                  10),
                                              child: Text(
                                                "₹${close_signal[index]['tag2']}",
                                                style: const TextStyle(
                                                    fontSize:
                                                    11,
                                                    color: Colors
                                                        .white),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                          : Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8),
                                            color: Colors
                                                .grey.shade200),
                                        margin: const EdgeInsets
                                            .only(
                                            left: 15,
                                            right: 15,
                                            top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 2",
                                                style: TextStyle(
                                                    fontSize:
                                                    11),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right:
                                                  10),
                                              child: Text(
                                                "₹${close_signal[index]['tag2']}",
                                                style:
                                                const TextStyle(
                                                    fontSize:
                                                    11),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                          : const SizedBox(
                                        height: 0,
                                      ),

                                      show2[index] == true && close_signal[index]['tag3'] != "" ?
                                      (close_signal[index]['calltype'].toUpperCase()=="BUY" && double.parse(close_signal[index]['tag3']) <= double.parse(close_signal[index]['closeprice'])) ||
                                          (close_signal[index]['calltype'].toUpperCase()=="SELL" && double.parse(close_signal[index]['tag3']) >= double.parse(close_signal[index]['closeprice']))
                                          ? Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8),
                                            color:
                                            Colors.green),
                                        margin: const EdgeInsets
                                            .only(
                                            left: 15,
                                            right: 15,
                                            top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 3",
                                                style: TextStyle(
                                                    fontSize:
                                                    11,
                                                    color: Colors
                                                        .white),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right:
                                                  10),
                                              child: Text(
                                                "₹${close_signal[index]['tag3']}",
                                                style: const TextStyle(
                                                    fontSize:
                                                    11,
                                                    color: Colors
                                                        .white),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                          : Container(
                                        height: 25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8),
                                            color: Colors
                                                .grey.shade200),
                                        margin: const EdgeInsets
                                            .only(
                                            left: 15,
                                            right: 15,
                                            top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  left: 10),
                                              child: const Text(
                                                "Target 3",
                                                style: TextStyle(
                                                    fontSize:
                                                    11),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right:
                                                  10),
                                              child: Text(
                                                "₹${close_signal[index]['tag3']}",
                                                style:
                                                const TextStyle(
                                                    fontSize:
                                                    11),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          : const SizedBox(
                                        height: 0,
                                      ),

                                      Container(
                                        margin:const EdgeInsets.only(top: 5, bottom: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            Expanded(
                                              flex: 0,
                                              child: GestureDetector(
                                                onTap: (){
                                                  String? Description = close_signal[index]['description'];
                                                  Description_popup(Description);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 25,
                                                  // width: 140,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color:const Color(0xffE4EfE9),
                                                  ),
                                                  margin: const EdgeInsets.only(top: 6, left: 8),
                                                  padding: const EdgeInsets.only(left: 5, right: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Text(
                                                        "View Detail",
                                                        style: TextStyle(fontSize: 10),
                                                      ),
                                                      Icon(
                                                        Icons.candlestick_chart,
                                                        size: 12,
                                                        color: Colors.grey.shade600,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                                flex: 0,
                                                child:
                                                close_signal[index]['purchased'] == true?
                                                GestureDetector(
                                                  onTap: (){
                                                    String? Single_id = close_signal[index]['_id'];
                                                    print("Signal_id : $Single_id");
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Broker_Responce_Detail(Single_id:Single_id)));
                                                  },
                                                  child: Container(
                                                      height: 25,
                                                      // padding: EdgeInsets.symmetric(horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color:const Color(0xffE4EfE9),
                                                      ),
                                                      margin: const EdgeInsets.only(top: 6, left:0, right: 0),
                                                      padding: const EdgeInsets.only(left: 5, right: 5),
                                                      alignment: Alignment.center,
                                                      child:const Text(
                                                        "Broker Response",
                                                        style: TextStyle(fontSize: 10),
                                                      )
                                                  ),
                                                ):
                                                const SizedBox(width: 0,)
                                            ),

                                            Expanded(
                                                flex: 0,
                                                child:GestureDetector(
                                                  onTap: (){
                                                    if(close_signal[index]['report_full_path']==null||close_signal[index]['report_full_path']==""){
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('No analysis available',style: TextStyle(color: Colors.white)),
                                                          duration:Duration(seconds: 3),
                                                          backgroundColor: Colors.red,
                                                        ),
                                                      );
                                                    }

                                                    else{
                                                      String? pdf_path=close_signal[index]['report_full_path'];

                                                      if(pdv_view==true){
                                                        pdv_view=false;
                                                        downloadFile(pdf_path!, 'sample.pdf').then((file) {
                                                          setState(() {
                                                            localPath = file.path;
                                                            pdv_view=true;
                                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewAnalysisPdf(localPath: localPath,)));
                                                            // View_analysis_popup2(pdf_path!);
                                                          });
                                                        });
                                                      }

                                                    }

                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    // width: 140,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color:const Color(0xffE4EfE9),
                                                    ),
                                                    margin: const EdgeInsets.only(top: 6, right: 8),
                                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        const Text(
                                                          "View Analysis",
                                                          style: TextStyle(fontSize: 10),
                                                        ),

                                                        Container(
                                                            margin:const EdgeInsets.only(left: 3),
                                                            child: Icon(
                                                              Icons.computer,
                                                              size: 10,
                                                              color: Colors.grey.shade600,
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),

                                      const Spacer(),

                                      close_signal[index]['calltype'] == 'BUY'
                                          ? (double.parse(close_signal[index]['closeprice'] == null ?
                                      "0.0" :
                                      close_signal[index]['closeprice']) > double.parse(close_signal[index]['price'])
                                          ? Container(
                                        height: 25,
                                        color: Colors.green,
                                        alignment:
                                        Alignment.center,
                                        child:  Text(
                                            "P&L : ${result[index]}%",
                                            // "P&L : %",
                                            style:
                                            const TextStyle(
                                                fontSize:
                                                11,
                                                color: Colors
                                                    .white)),
                                      )
                                          : Container(
                                        height: 25,
                                        color: Colors.red,
                                        alignment:
                                        Alignment.center,
                                        child: Text(
                                            "P&L : ${result[index]}%",
                                            style:
                                            const TextStyle(
                                                fontSize:
                                                11,
                                                color: Colors
                                                    .white)),
                                      )
                                      )
                                          : (double.parse(close_signal[index]['price'] == null
                                          ? "0.0"
                                          : close_signal[index]['price']) >double.parse(close_signal[index]['closeprice'] == null ? "0.0" : close_signal[index]['closeprice'])
                                          ? Container(
                                        height: 25,
                                        color: Colors.green,
                                        alignment:
                                        Alignment.center,
                                        child: Text("P&L : ${result[index]}%",
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.white)),
                                      )
                                          : Container(
                                        height: 25,
                                        color: Colors.red,
                                        alignment:
                                        Alignment.center,
                                        child: Text(
                                            "P&L : ${result[index]}%",
                                            style:
                                            const TextStyle(
                                                fontSize:
                                                11,
                                                color: Colors
                                                    .white)),
                                      ))
                                    ],
                                  ),
                                ),




                                close_signal[index]['purchased'] == false
                                    ? Container(
                                    margin: const EdgeInsets.only(
                                        top: 10,
                                        left: 15,
                                        right: 15,
                                        bottom: 15
                                    ),
                                    height: 35,
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Trade Closed",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 8),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                        )
                                      ],
                                    )) :

                                isApiDateBeforeToday[index]==false?
                                GestureDetector(
                                  onTap: () {
                                    String? SignalId_exit =
                                    close_signal[index]['_id'];
                                    String? SignalPrice_exit = close_signal[index]['price'];
                                    String? Trade_symbol = close_signal[index]['tradesymbol'];
                                    String? Lot_Size = close_signal[index]['lotsize'];

                                    String? SignalName_exit = close_signal[index]['stock'];
                                    String? Entrytype_exit = close_signal[index]['calltype'];
                                    String? Order_quantity = close_signal[index]['order_quantity'] == null
                                        ? ""
                                        : close_signal[index]['order_quantity'].toString();
                                    print("Order: $Order_quantity");
                                    Exit_order_popup(
                                        SignalId_exit,
                                        SignalPrice_exit,
                                        SignalName_exit,
                                        Entrytype_exit,
                                        Order_quantity,
                                        Trade_symbol,
                                        Lot_Size
                                    );
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          left: 15,
                                          right: 15,
                                          bottom: 15),
                                      height: 35,
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: ColorValues
                                            .Splash_bg_color1,
                                        borderRadius:
                                        BorderRadius.circular(
                                            8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        children: [
                                          const Text(
                                            "Exit Trade",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w600,
                                                color:
                                                Colors.white),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 8),
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          )
                                        ],
                                      )),
                                ):
                                GestureDetector(
                                  // onTap: () {
                                  //   String? SignalId_exit =
                                  //   close_signal[index]['_id'];
                                  //   String? SignalPrice_exit = close_signal[index]['price'];
                                  //   String? Trade_symbol = close_signal[index]['tradesymbol'];
                                  //   String? Lot_Size = close_signal[index]['lotsize'];
                                  //
                                  //   String? SignalName_exit = close_signal[index]['stock'];
                                  //   String? Entrytype_exit = close_signal[index]['calltype'];
                                  //   String? Order_quantity = close_signal[index]['order_quantity'] == null
                                  //       ? ""
                                  //       : close_signal[index]['order_quantity'].toString();
                                  //   print("Order: $Order_quantity");
                                  //   Exit_order_popup(
                                  //       SignalId_exit,
                                  //       SignalPrice_exit,
                                  //       SignalName_exit,
                                  //       Entrytype_exit,
                                  //       Order_quantity,
                                  //       Trade_symbol,
                                  //       Lot_Size
                                  //   );
                                  // },
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          left: 15,
                                          right: 15,
                                          bottom: 15),
                                      height: 35,
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                        BorderRadius.circular(
                                            8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        children: [
                                          const Text(
                                            "Exit Trade",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w600,
                                                color:
                                                Colors.black),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 8),
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ):
                  loader_closesignal=="No_data"?
                  Container(
                    child: Center(
                        child: Image.asset(
                          "images/notrades.png",
                          height: 100,
                        )),
                  ):
                  Container(
                    child: Center(
                        child:CircularProgressIndicator(color: ColorValues.Splash_bg_color1,)
                    ),
                  ),
                ],
              ),
            )


          ],
        ));
  }

  String? localPath;
  Future<File> downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  View_analysis_popup2(pdf_path){
    return showModalBottomSheet(
      isScrollControlled:true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  child:Column(
                    children: [
                      const SizedBox(height: 45,),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin:const EdgeInsets.only(left: 20),
                              child:const Icon(Icons.clear,color: Colors.black,),
                            ),
                          ),
                          Container(
                            margin:const EdgeInsets.only(left: 12),
                            child:const Text("Analysis",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),

                      Container(
                        height:MediaQuery.of(context).size.height-100,
                        child:localPath != null

                            ? PDFView(

                          filePath: localPath!,

                          fitEachPage: true,

                          fitPolicy: FitPolicy.WIDTH,

                          pageFling: false,

                        )

                            : const Center(child: CircularProgressIndicator()),
                      )


                    ],
                  )
              );
            }
        );
      },
    );
  }

  Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Lot_size,Trade_symbol,Segment,Target){
    setState(() {
      selectedOption=0;
      selectedOptionn=0;
      stoploss.text="";
      target.text="$Target";
      exitQuantity.text="";
    });
    print("selectedOption: $selectedOption");
    return showModalBottomSheet(
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
                    // height: MediaQuery.of(context).size.height/2.2,
                      child:Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin:const EdgeInsets.only(left: 10,top: 15),
                                  child: Icon(Icons.clear,color: Colors.grey.shade600,size: 25),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    // Container(
                                    //     margin:const EdgeInsets.only(left: 10,top: 15),
                                    //     child: Text("$Signal_name",style:const TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)
                                    // ),

                                    Container(
                                        margin:const EdgeInsets.only(left: 10,top: 15),
                                        child: Trade_symbol==null||Trade_symbol==""?
                                        SizedBox():
                                        Text("$Trade_symbol",style:const TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)
                                    ),


                                    // Container(
                                    //     margin:const EdgeInsets.only(left: 3),
                                    //     child: Text("(Lot Size : 10)",style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),)
                                    // ),

                                  ],
                                ),
                              ),

                            ],

                          ),

                          Container(
                            margin:const EdgeInsets.only(top: 5,left: 30,right: 45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 90,
                                    alignment: Alignment.topLeft,
                                    margin:const EdgeInsets.only(left: 15,top: 15),
                                    child:const Text("Price : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),)
                                ),
                                Container(
                                    height: 27,
                                    width: 100,
                                    alignment: Alignment.center,
                                    padding:const EdgeInsets.only(left: 12,right: 12),
                                    margin:const EdgeInsets.only(left: 15,top: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade600,width: 0.4)
                                    ),
                                    child:Text("₹ $Signal_price",style:const TextStyle(fontWeight: FontWeight.w600,fontSize: 12),)
                                ),
                              ],

                            ),
                          ),

                          Container(
                            margin:const EdgeInsets.only(top: 8,left: 30,right: 45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 90,
                                    alignment: Alignment.topLeft,
                                    margin:const EdgeInsets.only(left: 15,top: 10),
                                    child:const Text("Entry Type : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),)
                                ),
                                Container(
                                    height: 27,
                                    width: 100,
                                    alignment: Alignment.center,
                                    padding:const EdgeInsets.only(left: 12,right: 12),
                                    margin:const EdgeInsets.only(left: 15,top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade600,width: 0.4)
                                    ),
                                    child: Text("$Entry_type",style:const TextStyle(fontWeight: FontWeight.w600,fontSize: 12),)
                                ),
                              ],

                            ),
                          ),


                          Segment=="C"?
                          Container(
                            margin:const EdgeInsets.only(top: 8,left: 30,right: 45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    alignment: Alignment.topLeft,
                                    margin:const EdgeInsets.only(left: 15,top: 10),
                                    child:const Text("Quantity : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),)
                                ),
                                Container(
                                    height: 35,
                                    width: 100,
                                    alignment: Alignment.center,
                                    padding:const EdgeInsets.only(left: 12,right: 12,bottom: 4),
                                    margin:const EdgeInsets.only(left: 15,top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade600,width: 0.4)
                                    ),
                                    child:TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: quantity_placeorder,
                                      onChanged: (_){
                                        exitQuantity.text=quantity_placeorder.text;
                                      },
                                      decoration:const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter Quantity",
                                          hintStyle: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w500)
                                      ),
                                    )
                                ),
                              ],

                            ),
                          ):
                          Container(
                            width: double.infinity,
                            margin:const EdgeInsets.only(top: 8,left: 30,right: 45),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        margin:const EdgeInsets.only(left: 15,top: 10),
                                        child:const Text("Quantity : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),)
                                    ),
                                    Segment=="C"?
                                    const SizedBox():
                                    Container(
                                      margin:const EdgeInsets.only(top: 10),
                                      child: Text("( Lot Size : $Lot_size )",style:const TextStyle(fontSize: 11,color: Colors.grey),),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Segment=="C"?
                                        Container(
                                            height: 35,
                                            width: 100,
                                            alignment: Alignment.center,
                                            padding:const EdgeInsets.only(left: 12,right: 12,bottom: 4),
                                            margin:const EdgeInsets.only(left: 15,top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.grey.shade600,width: 0.4)
                                            ),
                                            child:TextFormField(
                                              keyboardType: TextInputType.number,
                                              controller: quantity_placeorder,
                                              onChanged: (_){
                                                exitQuantity.text=quantity_placeorder.text;
                                              },
                                              decoration:const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Enter Quantity",
                                                  hintStyle: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w500)
                                              ),
                                            )
                                        ):
                                        Container(
                                          margin:const EdgeInsets.only(left: 15,top: 10),
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color:Colors.grey.shade400,width: 0.6)
                                          ),
                                          alignment: Alignment.center,
                                          child: Text("$Lot_size"),
                                        )
                                      ],
                                    ),
                                    Segment!="C"?
                                    Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      margin:const EdgeInsets.only(left: 15,top: 5),
                                      child:const Text("*"),
                                    ):
                                    SizedBox(width: 0,),

                                    Segment!="C"?
                                    Container(
                                        height: 35,
                                        width: 100,
                                        alignment: Alignment.center,
                                        padding:const EdgeInsets.only(left: 12,right: 12,bottom: 4),
                                        margin:const EdgeInsets.only(left: 15,top: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.shade600,width: 0.4)
                                        ),
                                        child:TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: lot,
                                          onChanged: (_){
                                            exitQuantity.text=lot.text;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                            CustomZeroInputFormatter(), // Custom input formatter to disallow 0
                                          ],
                                          decoration:const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Enter Lot",
                                              hintStyle: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w500)
                                          ),
                                        )
                                    ):
                                    SizedBox(width: 0,)
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin:const EdgeInsets.only(top: 20,left: 35,right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 10,
                                      child: Radio<int>(
                                        value: 1,
                                        groupValue: selectedOption,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedOption = value!;
                                            print(selectedOption);
                                            if(selectedOption==1){
                                              selectedOptionn=1;
                                            }
                                            else{
                                              selectedOptionn=1;
                                            }

                                          });
                                        },
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.all(0),
                                      child: const Text(
                                        "Target",
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                    ),

                                    Container(
                                      margin:const EdgeInsets.only(left: 25),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 10,
                                            child: Radio<int>(
                                              activeColor: Colors.red,
                                              fillColor:MaterialStateProperty.all(Colors.red),
                                              value: 2,
                                              groupValue: selectedOption,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedOption = value!;
                                                  print(selectedOption);

                                                  if(selectedOption==2){
                                                    selectedOptionn=2;
                                                  }
                                                  else{
                                                    selectedOptionn=2;
                                                  }

                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(0),
                                            child: const Text(
                                              "StopLoss",
                                              style: TextStyle(fontSize: 14, color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),

                          selectedOption==1?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width/2.7,
                                  alignment: Alignment.topLeft,
                                  padding:const EdgeInsets.only(left: 12,right: 12,bottom: 4),
                                  margin:const EdgeInsets.only(left: 45,top: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade600,width: 0.4)
                                  ),
                                  child:TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: target,
                                    enabled: false,
                                    decoration:const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter target",
                                      hintStyle: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w500),
                                    ),
                                  )
                              ),
                              Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width/2.7,
                                  alignment: Alignment.topLeft,
                                  padding:const EdgeInsets.only(left: 12,right: 12,bottom: 4),
                                  margin:const EdgeInsets.only(left: 20,top: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade600,width: 0.4)
                                  ),
                                  child:TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: exitQuantity,
                                    enabled: false,
                                    decoration:const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Exit quantity",
                                      hintStyle: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w500),
                                    ),
                                  )
                              ),
                            ],
                          ):
                          selectedOption==2?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width/2.7,
                                  alignment: Alignment.topLeft,
                                  padding:const EdgeInsets.only(left: 12,right: 12,bottom: 4),
                                  margin:const EdgeInsets.only(left: 45,top: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade600,width: 0.4)
                                  ),
                                  child:TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: stoploss,
                                    decoration:const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter stoploss",
                                      hintStyle: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w500),
                                    ),
                                  )
                              ),
                              Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width/2.7,
                                  alignment: Alignment.topLeft,
                                  padding:const EdgeInsets.only(left: 12,right: 12,bottom: 4),
                                  margin:const EdgeInsets.only(left: 20,top: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade600,width: 0.4)
                                  ),
                                  child:TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: exitQuantity,
                                    enabled: false,
                                    decoration:const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Exit quantity",
                                      hintStyle: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w500),
                                    ),
                                  )
                              ),
                            ],
                          )
                              :

                          const SizedBox(height: 0,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              GestureDetector(
                                onTap: (){
                                  if(Entry_type=="BUY"){
                                    if(Segment!="C" && (lot.text==null||lot.text=="")){

                                      Fluttertoast.showToast(
                                          msg: "Enter lot",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }
                                    else if(Segment=="C" && (quantity_placeorder.text==null||quantity_placeorder.text=="")){

                                      Fluttertoast.showToast(
                                          msg: "Enter quantity",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn ==1 && (target.text ==null ||  target.text=="") ){
                                      Fluttertoast.showToast(
                                          msg: "Enter Target",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn ==2 && (stoploss.text ==null ||  stoploss.text=="") ){
                                      Fluttertoast.showToast(
                                          msg: "Enter Stoploss",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn !=0 && (exitQuantity.text ==null ||  exitQuantity.text=="") ){
                                      Fluttertoast.showToast(
                                          msg: "Enter Exit quantity",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn==1&&target.text !=null && target.text!="" &&(double.parse(target.text.toString()) < double.parse(Signal_price.toString()))){

                                      Fluttertoast.showToast(
                                          msg: "Target price should be greater than price",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn==2&&stoploss.text !=null && stoploss.text!="" && (double.parse(stoploss.text.toString()) > double.parse(Signal_price.toString()))){

                                      Fluttertoast.showToast(
                                          msg: "Stoploss should be less than price",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }
                                    else{
                                      Future_quantity =Segment=="C"?
                                      int.parse(quantity_placeorder.text):
                                      int.parse(Lot_size.toString()) * int.parse(lot.text.toString());

                                      if(Segment!="C"&& exitQuantity.text !=null &&exitQuantity.text !="" && (Future_quantity! < int.parse(exitQuantity.text))){
                                        Fluttertoast.showToast(
                                            msg: "Exit Quantity should be less than Quantity.",
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white
                                        );
                                      }
                                      else{
                                        Place_order_Api(Signal_id,Signal_price,Url_placeorder,Future_quantity);
                                      }

                                    }
                                  }
                                  else{
                                    if(Segment!="C" && (lot.text==null||lot.text=="")){

                                      Fluttertoast.showToast(
                                          msg: "Enter lot",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }
                                    else if(Segment=="C" && (quantity_placeorder.text==null||quantity_placeorder.text=="")){

                                      Fluttertoast.showToast(
                                          msg: "Enter quantity",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn ==1 && (target.text ==null ||  target.text=="") ){
                                      Fluttertoast.showToast(
                                          msg: "Enter Target",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn ==2 && (stoploss.text ==null ||  stoploss.text=="") ){
                                      Fluttertoast.showToast(
                                          msg: "Enter Stoploss",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn !=0 && (exitQuantity.text ==null ||  exitQuantity.text=="") ){
                                      Fluttertoast.showToast(
                                          msg: "Enter exit quantity",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn==1&&target.text !=null && target.text!="" &&(double.parse(target.text.toString()) > double.parse(Signal_price.toString()))){

                                      Fluttertoast.showToast(
                                          msg: "Target price should be less than price",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }

                                    else if(selectedOptionn==2&&stoploss.text !=null && stoploss.text!="" && (double.parse(stoploss.text.toString()) < double.parse(Signal_price.toString()))){
                                      Fluttertoast.showToast(
                                          msg: "Stoploss should be greater than price",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                      );
                                    }
                                    else{
                                      Future_quantity =Segment=="C"?
                                      int.parse(quantity_placeorder.text):
                                      int.parse(Lot_size.toString()) * int.parse(lot.text.toString());

                                      if(Segment!="C"&& exitQuantity.text !=null &&exitQuantity.text !="" && (Future_quantity! < int.parse(exitQuantity.text))){
                                        Fluttertoast.showToast(
                                            msg: "Exit quantity should be less than Quantity.",
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white
                                        );
                                      }
                                      else{
                                        Place_order_Api(Signal_id,Signal_price,Url_placeorder,Future_quantity);
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                    height: 35,
                                    width: MediaQuery.of(context).size.width/1.3,
                                    alignment: Alignment.center,
                                    padding:const EdgeInsets.only(left: 12,right: 12),
                                    margin:const EdgeInsets.only(top: 25,bottom: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: ColorValues.Splash_bg_color1
                                    ),
                                    child:const Text("Submit",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: Colors.white),)
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                ),
              );
            }
        );
      },
    );
  }

  Exit_order_popup(SignalId_exit, SignalPrice_exit, SignalName_exit, Entrytype_exit, Order_quantity,Trade_symbol,Lot_Size) {
    quantity_placeorder_exit.text = Order_quantity;
    return showModalBottomSheet(
      isScrollControlled: true,
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
                    height: MediaQuery.of(context).size.height / 2.6,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(left: 15, top: 15),
                                child: Icon(Icons.clear,
                                    color: Colors.grey.shade600, size: 25),
                              ),
                            ),
                            /* Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 15, top: 15),
                            child: Text(
                              "$SignalName_exit",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            )),*/

                            Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(left: 15, top: 15),
                                child:Trade_symbol==null||Trade_symbol==""?
                                const SizedBox():
                                Text(
                                  "$Trade_symbol",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                )
                            ),

                          ],
                        ),

                        Container(
                          margin:
                          const EdgeInsets.only(top: 5, left: 30, right: 45),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 90,
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 15, top: 15),
                                  child: const Text(
                                    "Price : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500, fontSize: 14),
                                  )),
                              Container(
                                  height: 27,
                                  width: 100,
                                  alignment: Alignment.center,
                                  padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                                  margin: const EdgeInsets.only(left: 15, top: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade600, width: 0.4)),
                                  child: Text(
                                    "₹ $SignalPrice_exit",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 12),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                          const EdgeInsets.only(left: 30, right: 45, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 90,
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 15, top: 10),
                                  child: const Text(
                                    "Entry Type : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500, fontSize: 14),
                                  )),
                              Container(
                                  height: 27,
                                  width: 100,
                                  alignment: Alignment.center,
                                  padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                                  margin: const EdgeInsets.only(left: 15, top: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade600, width: 0.4)),
                                  child: Text(
                                    "$Entrytype_exit",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 12),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                          const EdgeInsets.only(left: 30, right: 45, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 90,
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 15, top: 10),
                                  child: const Text(
                                    "Quantity : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500, fontSize: 14),
                                  )),
                              Column(
                                children: [
                                  Container(
                                      height: 35,
                                      width: 100,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12, bottom: 4),
                                      margin: const EdgeInsets.only(left: 15, top: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey.shade600, width: 0.4)),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: quantity_placeorder_exit,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter Quantity",
                                            hintStyle: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                      )),

                                  Lot_Size=="null"||Lot_Size=="" || Tab_name!.toUpperCase()=="CASH"?
                                  const SizedBox():
                                  Container(
                                    margin:const EdgeInsets.only(top: 10),
                                    height: 25,
                                    padding:const EdgeInsets.only(left: 12,right: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.2)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("Lot Size : $Lot_Size",style:const TextStyle(fontSize: 11,color: Colors.grey),),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Exit_order_Api(SignalId_exit, SignalPrice_exit);
                              },
                              child: Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  alignment: Alignment.center,
                                  padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                                  margin: const EdgeInsets.only(top: 25),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: ColorValues.Splash_bg_color1),
                                  child: const Text(
                                    "Exit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  Description_popup(Description) {
    return showModalBottomSheet(
      shape:const RoundedRectangleBorder(
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
            return Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Minimum size ke hisaab se adjust karega
                    children: [
                      Row(
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
                      const Divider(color: Colors.black),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Html(
                          data: Description,
                          style: {
                            "p": Style(fontSize: FontSize.medium,),
                            "h1": Style(fontSize: FontSize.large, fontWeight: FontWeight.bold),
                          },
                          onLinkTap: (url, _, __) {
                            if (url != null) {
                              _launchURL(url);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
class CustomZeroInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '0') {
      return oldValue;
    }
    return newValue;
  }
}







