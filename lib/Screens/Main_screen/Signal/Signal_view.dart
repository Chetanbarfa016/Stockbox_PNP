import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Global_widgets/Broker_link.dart';
import 'package:stock_box/Global_widgets/Logout.dart';
import 'package:stock_box/Global_widgets/Pdf_view.dart';
import 'package:stock_box/Screens/Main_screen/Broker/Webview_broker.dart';
import 'package:stock_box/Screens/Main_screen/Kyc/Kyc_formView.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Broker Responce Detail.dart';

class SignalNew extends StatefulWidget {
  String? Samiti;
  SignalNew({super.key,required this.Samiti});

  @override
  State<SignalNew> createState() => _SignalNewState(Samiti:Samiti);
}

class _SignalNewState extends State<SignalNew> {

  String? Samiti;
  _SignalNewState({
    required this.Samiti
  });
  int selectedOption = 0;
  int selectedOptionn = 0;

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
    }else{

    }
  }

  var Data;
  bool? Status;
  String? Delete_status;
  String? Active_status;
  bool loader_profile=false;
  String? Email='';
  Profile_Api() async {
    var data = await API.Profile_Api();
    setState(() {
      Data = data['data'];
      Status = data['status'];
    });
    if(Status==true){
      setState(() {});
      Delete_status=Data['del'].toString();
      Active_status=Data['ActiveStatus'].toString();
      Kyc_verification= Data['kyc_verification'].toString();
      print("Kyccccccccc profile: $Kyc_verification");
      Email=Data['Email'];

      Delete_status=="1"||Active_status=="0"?
      handleLogout(context):
      print("Account not deleted");

      loader_profile=true;
    }

    else{
      print("");
    }

  }

  int? Future_quantity;


  TextEditingController api_key = TextEditingController();

  //Alice
  TextEditingController app_code = TextEditingController();
  TextEditingController user_id = TextEditingController();
  TextEditingController api_secret = TextEditingController();

  final TextEditingController searchController = TextEditingController();
  bool pdv_view= true;

  TextEditingController quantity_placeorder = TextEditingController();
  TextEditingController lot = TextEditingController();
  TextEditingController stoploss = TextEditingController();
  TextEditingController target = TextEditingController();
  TextEditingController exitQuantity = TextEditingController();
  bool? Status_placeorder;
  String? Message_placeorder;
  Place_order_Api(Signal_id,Signal_price,Url_placeorder,Future_quantity) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
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
        body:jsonEncode(
            {
              "id":"$Iddd",
              "signalid":"$Signal_id",
              "price":"$Signal_price",
              "quantity":"$Future_quantity",
              "tsprice":target.text==""||target.text==null?"0":"${target.text}",
              "slprice":stoploss.text==""||stoploss.text==null?"0":"${stoploss.text}",
              "exitquantity":exitQuantity.text==""||exitQuantity.text==null?"0":"${exitQuantity.text}",
              "tsstatus":"$selectedOptionn",
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("JsnnnnnnPlaceorder: $jsonString");

    Status_placeorder=jsonString['status'];
    Message_placeorder=jsonString['message'];

    if(Status_placeorder==true){
      setState(() {

      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order Placed Successfuly',style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Signal_Api();
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

  String? Kyc_verification;
  String? Dlink_Status;
  String? Trading_Status;
  String? Broker_id;
  String? Api_key;
  String? AliceUser_id;

  GetAllTradingStatus() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    // Kyc_verification= prefs.getString("Kyc_verification");
    // print("987654: $Kyc_verification");
    Dlink_Status=prefs.getString("Dlink_status");
    Trading_Status=prefs.getString("Trading_status");
    Broker_id=prefs.getString("Broker_id");
    Api_key=prefs.getString("Api_key");
    AliceUser_id = prefs.getString("AliceUser_id");
  }

  List<bool> show=[];

  // var Signal_data=[];
  String? Message;
  String? loader="false";

  List<dynamic> open_signal_Data = [];
  List<dynamic> filteredData = [];



  // Signal_Api() async {
  //   setState(() {
  //
  //     filteredData.clear();
  //     loader="false";
  //     GetAllTradingStatus();
  //     percentageDifference.clear();
  //   });
  //   print("Tab idddddd: $Samiti");
  //   var data = await API.Signal_Api(Samiti, searchController.text,"1");
  //
  //   if(data['status']==true){
  //     setState(() {
  //       open_signal_Data = data['data'];
  //       filteredData = List.from(open_signal_Data);
  //       Message = data['message'];
  //       NSE_All_Data_Api();
  //     });
  //
  //
  //     for(int i=0; i<open_signal_Data.length; i++){
  //       show.add(false);
  //       setState(() {
  //       });
  //     }
  //
  //     if(data['pagination']['page']<data['pagination']['totalPages']){
  //       max_page=false;
  //       page=2;
  //     }
  //     else{
  //       max_page=true;
  //     }
  //
  //
  //
  //     // filteredData.length>0?
  //     // loader="true":
  //     // loader="No_data";
  //
  //     print("Open Signal: ${filteredData.length}");
  //   }else{
  //     setState(() {
  //       // loader="No_data";
  //     });
  //   }
  //
  // }
  // var NSE_Data;
  // bool loader_nsedata=false;
  // NSE_All_Data_Api() async {
  //   var data = await API.NSE_AllData_Api();
  //   setState(() {
  //     NSE_Data = data['data'];
  //     matchSymbolWithStock();
  //   });
  // }
  // List<double> percentageDifference=[];
  // void matchSymbolWithStock() {
  //   if (NSE_Data != null && open_signal_Data != null) {
  //     // Create a map for faster lookup of SYMBOL and price from NSE_Data
  //     Map<String, dynamic> nseMap = {
  //       for (var item in NSE_Data) item['SYMBOL']: item['price']
  //     };
  //
  //     // Iterate through Signal_data to find matches
  //     for (var signalItem in open_signal_Data) {
  //       String stock = signalItem['stock'];
  //       if (nseMap.containsKey(stock)) {
  //         double price = nseMap[stock];
  //         // double tag1Value = double.tryParse(signalItem['tag1'].toString()) ?? 0.0;
  //
  //         double tag1Value =signalItem['tag3'] !=""?
  //         double.tryParse(signalItem['tag3'].toString()) ?? 0.0:
  //         signalItem['tag2'] !=""?
  //         double.tryParse(signalItem['tag2'].toString()) ?? 0.0:
  //         double.tryParse(signalItem['tag1'].toString()) ?? 0.0;
  //         // Calculate percentage difference
  //         if (tag1Value != 0) {
  //           if(signalItem['calltype']=="BUY"){
  //             double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
  //             percentageDifference.add(percentageDifferencee);
  //             print('Match Found: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
  //           }
  //           else{
  //             double percentageDifferencee  =((tag1Value - price).abs() / price) * 100;
  //             percentageDifference.add(percentageDifferencee);
  //             print('Match Found: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
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
  //     filteredData.length>0?
  //     loader="true":
  //     loader="No_data";
  //   });
  //   print(" percentageDifference==== ${percentageDifference}");
  // }

  Signal_Api() async {
    setState(() {

      filteredData.clear();
      loader="false";
      GetAllTradingStatus();
      Profile_Api();
      percentageDifference.clear();
    });
    print("Tab idddddd: $Samiti");
    var data = await API.Signal_Api(Samiti, searchController.text,"1");

    if(data['status']==true){
      setState(() {
        open_signal_Data = data['data'];
        filteredData = List.from(open_signal_Data);
        Message = data['message'];
        NSE_All_Data_Api();
      });


      for(int i=0; i<open_signal_Data.length; i++){
        show.add(false);
        setState(() {
        });
      }
      if(data['pagination']['page']<data['pagination']['totalPages']){
        max_page=false;
        page=2;
      }else{
        max_page=true;
      }

      // filteredData.length>0?
      // loader="true":
      // loader="No_data";

      print("Open Signal: ${filteredData.length}");
    }else{
      setState(() {
        loader="No_data";
      });
    }

  }
  var NSE_Data;
  bool loader_nsedata=false;
  NSE_All_Data_Api() async {
    var data = await API.NSE_AllData_Api();
    setState(() {
      NSE_Data = data['data'];
      matchSymbolWithStock();
    });
  }
  List<double> percentageDifference=[];
  List<bool> potentoalLeftLoader=[];
  void matchSymbolWithStock() {
    if (NSE_Data != null && open_signal_Data != null) {
      // Create a map for faster lookup of SYMBOL and price from NSE_Data
      Map<String, dynamic> nseMap = {
        for (var item in NSE_Data) item['SYMBOL']: item['price']
      };

      // Iterate through Signal_data to find matches
      for (var signalItem in open_signal_Data) {
        String stock = signalItem['stock'];
        if (nseMap.containsKey(stock)) {
          double price = nseMap[stock];
          // double tag1Value = double.tryParse(signalItem['tag1'].toString()) ?? 0.0;

          double tag1Value =signalItem['tag3'] !=""?
          double.tryParse(signalItem['tag3'].toString()) ?? 0.0:
          signalItem['tag2'] !=""?
          double.tryParse(signalItem['tag2'].toString()) ?? 0.0:
          double.tryParse(signalItem['tag1'].toString()) ?? 0.0;

          print("Priceeeeeeeeeeeeeee: $price");
          print("Targetttttttttttttt: $tag1Value");

          price > tag1Value ?
          potentoalLeftLoader.add(true):
          potentoalLeftLoader.add(false);

          // Calculate percentage difference
          if (tag1Value != 0) {
            if(signalItem['calltype']=="BUY"){
              // double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
              double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
              percentageDifference.add(percentageDifferencee);
              print('Match Found Buy: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
              price > tag1Value ?
              potentoalLeftLoader.add(true):
              potentoalLeftLoader.add(false);
            }
            else{
              double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
              percentageDifference.add(percentageDifferencee);
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
      filteredData.length>0?
      loader="true":
      loader="No_data";
    });
  }
  Future<void> fetchMoreItems() async {
    setState(() {
      isLoading = true;
    });
    var data = await API.Signal_Api(Samiti, searchController.text,"$page");

    if(data['status']==true){
      setState(() {
        var  open_signal_Data = data['data'];
        filteredData.addAll(List.from(open_signal_Data));
        Message = data['message'];
        NSE_All_Data_Api();
      });

      for(int i=0; i<open_signal_Data.length; i++){
        show.add(false);
        setState(() {
        });
      }

      if (NSE_Data != null && open_signal_Data != null) {
        // Create a map for faster lookup of SYMBOL and price from NSE_Data
        Map<String, dynamic> nseMap = {
          for (var item in NSE_Data) item['SYMBOL']: item['price']
        };

        // Iterate through Signal_data to find matches
        for (var signalItem in open_signal_Data) {
          String stock = signalItem['stock'];
          if (nseMap.containsKey(stock)) {
            double price = nseMap[stock]; // Get the matching price
            // double tag1Value = double.tryParse(signalItem['tag1'].toString()) ?? 0.0;

            double tag1Value =signalItem['tag3'] !=""?
            double.tryParse(signalItem['tag3'].toString()) ?? 0.0:
            signalItem['tag2'] !=""?
            double.tryParse(signalItem['tag2'].toString()) ?? 0.0:
            double.tryParse(signalItem['tag1'].toString()) ?? 0.0;
            // Calculate percentage difference
            if (tag1Value != 0) {
              double percentageDifferencee  =((price - tag1Value).abs() / tag1Value) * 100;
              percentageDifference.add(percentageDifferencee);
              print(
                  'Match Found: Stock = $stock, Price = $price, Tag1 = $tag1Value, Percentage Difference = ${percentageDifferencee.toStringAsFixed(2)}%');
            } else {
              print('Tag1 value is zero or invalid for Stock = $stock');
            }
          } else {
            print('No Match Found for Stock = $stock');
          }
        }
      } else {
        print('NSE_Data or Signal_data is null');
      }

      print("data['pagination'] === ${data['pagination']}");

      if(data['pagination']['page']<data['pagination']['totalPages']){

        setState(() {
          max_page=false;
          page++;
        });

      }else{
        setState(() {
          max_page=true;
        });
      }

      setState(() {
        page++;
        isLoading = false;
      });
      filteredData.length>0?
      loader="true":
      loader="No_data";
      print("Open Signal: ${filteredData.length}");
    }
    else{
      setState(() {
        loader="No_data";
      });
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

  // TextEditingController searchController = TextEditingController();
  bool _isSearchFieldVisible = false;  // To toggle visibility of search field
  void _toggleSearchField() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Signal_Api();
    BasicSetting_Apii();
    GetRedirectUrl();
    // Profile_Api();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  int page = 2;
  bool max_page = false;
  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchMoreItems();
    }
  }


  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: const EdgeInsets.only(top: 10),
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                    margin:const EdgeInsets.only(left: 10,right: 10),
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
                          onChanged: (query) => Signal_Api(),
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


              loader == "true" ?
              Container(
                height: MediaQuery.of(context).size.height-150,
                child:  RefreshIndicator(
                    onRefresh: () async{
                      setState(() {
                        Signal_Api();
                        BasicSetting_Apii();
                        Profile_Api();
                      });
                    },
                    child: ListView.builder(
                      physics:const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: filteredData.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {

                        String? Potential_left_price;
                        String? Potential_left_percent;
                        double? Potential_left_percent1;

                        String? target = filteredData[index]['tag3'] != ""?
                        filteredData[index]['tag3'].toString():
                        filteredData[index]['tag2'] != ""?
                        filteredData[index]['tag2'].toString():
                        filteredData[index]['tag1'].toString();
                        print('open_signal[indexx] ${filteredData[index]['segment']} == "O"');
                        print('open_signal[indexx]22 ${filteredData[index]['lotsize']}');
                        if(filteredData[index]['calltype'] == "BUY"){
                          Potential_left_price= ((double.parse(target)-double.parse(filteredData[index]['price'].toString()))*double.parse(filteredData[index]['lotsize'].toString())).toStringAsFixed(2);
                          Potential_left_percent1= ((double.parse(target)-double.parse(filteredData[index]['price'].toString()))/double.parse(filteredData[index]['price'].toString()))*100;
                          Potential_left_percent1==Potential_left_percent1.floor()?
                          Potential_left_percent = Potential_left_percent1.toInt().toString():
                          Potential_left_percent = Potential_left_percent1.toStringAsFixed(2);

                          // Potential_left_percent= (((double.parse(target)-double.parse(filteredData[index]['price'].toString()))/double.parse(filteredData[index]['price'].toString()))*100).toStringAsFixed(2);
                        }
                        else{
                          Potential_left_price= ((double.parse(filteredData[index]['price'].toString())- double.parse(target))*double.parse(filteredData[index]['lotsize'].toString())).toStringAsFixed(2);
                          Potential_left_percent1= ((double.parse(filteredData[index]['price'].toString())-double.parse(target))/double.parse(filteredData[index]['price'].toString()))*100;

                          Potential_left_percent1==Potential_left_percent1.floor()?
                          Potential_left_percent = Potential_left_percent1.toInt().toString():
                          Potential_left_percent = Potential_left_percent1.toStringAsFixed(2);
                        }

                        if (index == filteredData.length) {
                          return isLoading
                              ?const Center(child: CircularProgressIndicator())
                              : (max_page==true
                              ?const Center(child: Text("No more items to load"))
                              :const SizedBox.shrink());
                        }

                        DateTime dateTime = DateTime.parse(filteredData[index]['created_at']);
                        DateTime istTime = dateTime.add(const Duration(hours: 5, minutes: 30));
                        String entry_time = DateFormat('d MMM, HH:mm').format(istTime);

                        String? target_price= filteredData[index]['targethit1'] == "1" && filteredData[index]['targetprice3'] != "" ?
                        "${filteredData[index]['targetprice3']}":
                        filteredData[index]['targethit1'] == "1" && filteredData[index]['targetprice2'] != "" ?
                        "${filteredData[index]['targetprice2']}":
                        filteredData[index]['targethit1'] == "1" && filteredData[index]['targetprice1'] != "" ?
                        "${filteredData[index]['targetprice1']}":"- -";

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: filteredData.length==index+1?
                          const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 240):
                          const EdgeInsets.only(left: 20, right: 20, top: 12),
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
                                    margin: const EdgeInsets.only(top: 8, left: 8),
                                    height: 22,
                                    // width: 55,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.grey.shade300
                                    ),
                                    padding:const EdgeInsets.only(left: 10,right: 10),
                                    alignment: Alignment.center,
                                    child:  Text(
                                      "${filteredData[index]['callduration']}",
                                      style:
                                      const TextStyle(fontSize: 11, color: Colors.black),
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(top: 8, left: 8),
                                    height: 22,
                                    // width: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color:const Color(0xffAFE1AF),
                                    ),
                                    padding:const EdgeInsets.only(left: 10,right: 10),
                                    alignment: Alignment.center,
                                    child:  Text(
                                      "${filteredData[index]['calltype'][0].toUpperCase() + filteredData[index]['calltype'].substring(1).toLowerCase()} ${filteredData[index]['entrytype']}",
                                      style:
                                      TextStyle(fontSize: 11, color: Colors.grey.shade800),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 4, left: 8),
                                        child: Text(
                                          "Opened :",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 4, right: 8),
                                        child:  Text(
                                          "${entry_time}",
                                          style:const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
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
                                        margin: const EdgeInsets.only(top: 8, left: 10),
                                        child: Text(
                                          "${filteredData[index]['tradesymbol']}",
                                          style:const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(top: 8, right: 8),
                                    height: 22,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.green),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Open",
                                      style: TextStyle(fontSize: 11, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                margin:const EdgeInsets.only(top: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                          margin: const EdgeInsets.only(top: 6, left: 8),
                                          child:  Text(
                                            "₹${filteredData[index]['price']}",
                                            style:const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    filteredData[index]['lot']==""||filteredData[index]['lot']==null||filteredData[index]['lot']=="0"||filteredData[index]['lot']==0?
                                    const SizedBox(width: 0,):
                                    Container(
                                      height: 22,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.grey.shade300
                                      ),
                                      padding:const EdgeInsets.only(left: 10,right: 10),
                                      alignment: Alignment.center,
                                      margin:const EdgeInsets.only(right: 8,top: 2),
                                      child: filteredData[index]['segment']=="C"?
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
                                              "${filteredData[index]['lot']}",
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
                                              "${filteredData[index]['lot']}",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, left: 8),
                                        child: Text(
                                          "Entry time :",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, left: 8),
                                        child: Text(
                                          "${entry_time}",
                                          style:const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    margin:const EdgeInsets.only(right: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 6),
                                          child: Text(
                                            "Exit time :",
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.grey.shade700),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 6, left: 8),
                                          child: const Text(
                                            "- -",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6, left: 8),
                                        child: Text(
                                          "Stoploss :",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(top: 6, left: 8),
                                          child:filteredData[index]['stoploss']==""||filteredData[index]['stoploss']==null?
                                          const Text(
                                            "- -",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ):
                                          Text(
                                            "₹${filteredData[index]['stoploss']}",
                                            style:const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          )
                                      ),
                                    ],
                                  ),

                                  Container(
                                    margin:const EdgeInsets.only(right: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 6),
                                          child: Text(
                                            "Holding time :",
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.grey.shade700),
                                          ),
                                        ),

                                        filteredData[index]['segment']=="F"||filteredData[index]['segment']=="O"?
                                        Container(
                                          margin: const EdgeInsets.only(top: 6, left: 8),
                                          child: Text("${filteredData[index]['expirydate'].substring(0, 2)}-${filteredData[index]['expirydate'].substring(2, 4)}-${filteredData[index]['expirydate'].substring(4, 8)}",
                                            style:const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ):
                                        Container(
                                          margin: const EdgeInsets.only(top: 6, left: 8),
                                          child: Text(
                                            filteredData[index]['callduration']=="Intraday"?
                                            "Intraday":
                                            filteredData[index]['callduration']=="Short Term"?
                                            "(15-30 days)":
                                            filteredData[index]['callduration']=="Medium Term"?
                                            "(Above 3 month)":
                                            "(Above 1 year)" ,
                                            style:const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                ],
                              ),


                              GestureDetector(
                                onTap: (){
                                  print("Hello");
                                  setState(() {
                                    show[index]=!show[index];
                                  });
                                  print("Hello=== ${show[index]}");
                                },
                                child:Container(
                                  margin: const EdgeInsets.only(left: 8, right: 8, top: 12),
                                  height: 25,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade200),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 8,bottom: 2),
                                        child: Text(
                                          "Entry price :",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 2,right: 10),
                                            child: Text(
                                              "₹${filteredData[index]['price']}",
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.grey.shade700),
                                            ),
                                          ),

                                          Container(
                                              margin: const EdgeInsets.only(right: 8,bottom: 3),
                                              child:
                                              Icon(
                                                show==true?
                                                Icons.arrow_drop_up:
                                                Icons.arrow_drop_down,
                                                size: 25,color: Colors.black,)
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              show[index] == true && filteredData[index]['tag1'] != ""?
                              (filteredData[index]['targethit1'] == "1" && filteredData[index]['calltype'].toUpperCase()=="BUY" && double.parse(filteredData[index]['tag1']) <= double.parse(target_price)) ||
                                  (filteredData[index]['targethit1']  == "1" && filteredData[index]['calltype'].toUpperCase()=="SELL" && double.parse(filteredData[index]['tag1']) >= double.parse(target_price))?
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
                                        "₹${filteredData[index]['tag1']}",
                                        style:
                                        const TextStyle(
                                            fontSize:
                                            11,color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ):
                              filteredData[index]['tag1'] != ""?
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
                                        "₹${filteredData[index]['tag1']}",
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


                              show[index] == true && filteredData[index]['tag2'] != "" ?
                              (filteredData[index]['targethit1'] == "1"&& filteredData[index]['calltype'].toUpperCase()=="BUY" && double.parse(filteredData[index]['tag2']) <= double.parse(target_price)) ||
                                  (filteredData[index]['targethit1'] == "1"&& filteredData[index]['calltype'].toUpperCase()=="SELL" && double.parse(filteredData[index]['tag2']) >= double.parse(target_price))?
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
                                        "₹${filteredData[index]['tag2']}",
                                        style:
                                        const TextStyle(
                                            fontSize:
                                            11,color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ):
                              filteredData[index]['tag2'] != ""?
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
                                        "₹${filteredData[index]['tag2']}",
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


                              show[index] == true && filteredData[index]['tag3'] != "" ?
                              (filteredData[index]['targethit1'] == "1"&& filteredData[index]['calltype'].toUpperCase()=="BUY" && double.parse(filteredData[index]['tag3']) <= double.parse(target_price)) ||
                              (filteredData[index]['targethit1'] == "1"&& filteredData[index]['calltype'].toUpperCase()=="SELL" && double.parse(filteredData[index]['tag3']) >= double.parse(target_price))?
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
                                        "₹${filteredData[index]['tag3']}",
                                        style:
                                        const TextStyle(
                                            fontSize:
                                            11,color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ):
                              filteredData[index]['tag3'] != ""?
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
                                        "₹${filteredData[index]['tag3']}",
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


                              Container(
                                margin:const EdgeInsets.only(top: 5, bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Expanded(
                                      flex: 0,
                                      child: GestureDetector(
                                        onTap: (){
                                          String? Description = filteredData[index]['description'];
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
                                          padding:const EdgeInsets.only(left: 5, right: 5),
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

                                    filteredData[index]['purchased'] == true ?

                                    Expanded(
                                        flex: 0,
                                        child:GestureDetector(
                                          onTap: (){
                                            String? Single_id = filteredData[index]['_id'];
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Broker_Responce_Detail(Single_id:Single_id)));
                                          },
                                          child: Container(
                                            height: 25,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color:const Color(0xffE4EfE9),
                                            ),
                                            margin: const EdgeInsets.only(top: 6, left:0, right: 0),
                                            padding:const EdgeInsets.only(left: 5, right: 5),
                                            alignment: Alignment.center,
                                            child:const Text(
                                              "Broker Response",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        )
                                    )
                                        :
                                    const SizedBox(width: 0,),

                                    Expanded(
                                        flex: 0,
                                        child:GestureDetector(
                                          onTap: (){
                                            if(filteredData[index]['report_full_path']==null||filteredData[index]['report_full_path']==""){
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('No analysis available',style: TextStyle(color: Colors.white)),
                                                  duration:Duration(seconds: 3),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }

                                            else{
                                              setState(() {

                                              });
                                              String? pdf_path=filteredData[index]['report_full_path'];

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
                                            padding:const EdgeInsets.only(left: 5, right: 5),
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
                                                    ))
                                              ],
                                            ),
                                          ),
                                        )),

                                  ],
                                ),
                              ),
                              // filteredData[index]['segment']=="O"?
                              // const SizedBox(height: 0,):
                              // Container(
                              //   height: 28,
                              //   margin:const EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 8),
                              //   padding:const EdgeInsets.only(left: 15,right: 15),
                              //   decoration: BoxDecoration(
                              //       color:const Color(0xffAFE1AF),
                              //       borderRadius: BorderRadius.circular(8)
                              //   ),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              //           "${percentageDifference[index].toStringAsFixed(2)}%",
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


                              // filteredData[index]['purchased']==true?
                              // Container(
                              //   height: 30,
                              //   margin:const EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 10),
                              //   width: double.infinity,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(7),
                              //     color: Colors.grey,
                              //   ),
                              //   alignment: Alignment.center,
                              //   child: Text("${filteredData[index]['calltype']}",style: TextStyle(color: Colors.black),),
                              // ):

                              Container(
                                height: 28,
                                margin:const EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 8),
                                padding:const EdgeInsets.only(left: 15,right: 15),
                                decoration: BoxDecoration(
                                    color:const Color(0xffAFE1AF),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child:const Text(
                                        "Potential left: ",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .w500,
                                            color: Colors
                                                .black),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      child:Text(
                                        filteredData[index]['segment'] =="O"?
                                        "$Potential_left_price ($Potential_left_percent%)":
                                        filteredData[index]['segment'] == "F"?
                                        "$Potential_left_price ($Potential_left_percent%)":
                                        "${percentageDifference[index].toStringAsFixed(2)}%",
                                        style:const TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .w600,
                                            fontSize: 12,
                                            color:Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),



                              filteredData[index]['calltype']=="BUY"||filteredData[index]['calltype']=="buy"?
                              GestureDetector(
                                onTap: (){
                                  print("eeeeeeeeeeeeeee: $Kyc_verification");
                                  print("fffffffffffffff: $kyc_basicsetting");
                                  // if(Kyc_verification=="1" || kyc_basicsetting=="0"){
                                    if(Dlink_Status=="0"){
                                      // Broker_link_popup();
                                      Add_Broker.Broker_link(context);
                                    } else{
                                      if(Trading_Status=="0"){
                                        if(Broker_id=="1"){
                                          String? Url="https://smartapi.angelone.in/publisher-login?api_key=${Api_key}";
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url, Broker_idd:Broker_id, aliceuser_id:AliceUser_id,)));
                                        } else if(Broker_id=="2"){
                                          String? Url="https://ant.aliceblueonline.com/?appcode=${Api_key}";
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url,Broker_idd:Broker_id, aliceuser_id: AliceUser_id,)));
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
                                      } else{
                                        String? Signal_id= filteredData[index]['_id'];
                                        String? Signal_price= filteredData[index]['price'];
                                        String? Signal_name= filteredData[index]['stock'];
                                        String? Entry_type= filteredData[index]['calltype'];
                                        String? Segment= filteredData[index]['segment'];
                                        String? Expiry_date= filteredData[index]['expirydate'];
                                        String? Trade_symbol= filteredData[index]['tradesymbol'];
                                        String? Lot_size= filteredData[index]['lotsize'].toString();
                                        String? Target= filteredData[index]['tag3']!=""?
                                        filteredData[index]['tag3']:
                                        filteredData[index]['tag2']!=""?
                                        filteredData[index]['tag2']:
                                        filteredData[index]['tag1'];

                                        print("00000000: $Target");


                                        if(Broker_id=="1"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/angle/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else if(Broker_id=="2"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/aliceblue/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else if(Broker_id=="3"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/kotakneo/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else if(Broker_id=="4"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/markethub/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else if(Broker_id=="5"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/zerodha/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else if(Broker_id=="6"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/upstox/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else {
                                          String? Url_placeorder="${Util.Main_BasrUrl}/dhan/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                      }
                                    }
                                  // }
                                  //
                                  // else {
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=> Kyc_formView())).then((value) => CallApi());
                                  // }
                                },
                                child: Container(
                                  height: 30,
                                  margin:const EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.green
                                  ),
                                  alignment: Alignment.center,
                                  child: filteredData[index]['purchased']==true?
                                  Text("${filteredData[index]['calltype']} (Add More)",style:const TextStyle(color: Colors.white),):
                                  Text("${filteredData[index]['calltype']}",style:const TextStyle(color: Colors.white),),
                                ),
                              ):

                              GestureDetector(
                                onTap: (){
                                  print("ccccccccccc: $Kyc_verification");
                                  print("ddddddddddd: $kyc_basicsetting");
                                  // if(Kyc_verification=="1"|| kyc_basicsetting=="0"){
                                    if(Dlink_Status=="0"){
                                      // Broker_link_popup();
                                      Add_Broker.Broker_link(context);
                                    } else{
                                      if(Trading_Status=="0"){
                                        if(Broker_id=="1"){
                                          String? Url="https://smartapi.angelone.in/publisher-login?api_key=${Api_key}";
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url,Broker_idd:Broker_id, aliceuser_id:AliceUser_id,)));
                                        } else if(Broker_id=="2"){
                                          String? Url="https://ant.aliceblueonline.com/?appcode=${Api_key}";
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView_broker(Url:Url,Broker_idd:Broker_id, aliceuser_id:AliceUser_id,)));
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
                                      } else{

                                        String? Signal_id= filteredData[index]['_id'];
                                        String? Signal_price= filteredData[index]['price'];
                                        String? Signal_name= filteredData[index]['stock'];
                                        String? Entry_type= filteredData[index]['calltype'];
                                        String? Segment= filteredData[index]['segment'];
                                        String? Expiry_date= filteredData[index]['expirydate'];
                                        String? Trade_symbol= filteredData[index]['tradesymbol'];
                                        String? Lot_size= filteredData[index]['lotsize'].toString();
                                        String? Target= filteredData[index]['tag3']!=""?
                                        filteredData[index]['tag3']:
                                        filteredData[index]['tag2']!=""?
                                        filteredData[index]['tag2']:
                                        filteredData[index]['tag1'];

                                        print("00000000: $Target");

                                        if(Broker_id=="1"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/angle/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }
                                        else if(Broker_id=="2"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/aliceblue/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }
                                        else if(Broker_id=="3"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/kotakneo/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else if(Broker_id=="4"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/markethub/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else if(Broker_id=="5"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/zerodha/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else if(Broker_id=="6"){
                                          String? Url_placeorder="${Util.Main_BasrUrl}/upstox/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                        else {
                                          String? Url_placeorder="${Util.Main_BasrUrl}/dhan/placeorder";
                                          Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target);
                                        }

                                      }
                                    }
                                  // } else {
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=> Kyc_formView())).then((value) => CallApi());
                                  // }
                                },
                                child: Container(
                                  height: 30,
                                  margin:const EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.red
                                  ),
                                  alignment: Alignment.center,
                                  child:
                                  filteredData[index]['purchased']==true?
                                  Text("${filteredData[index]['calltype']} (Add More)",style:const TextStyle(color: Colors.white),):
                                  Text("${filteredData[index]['calltype']}",style:const TextStyle(color: Colors.white),),
                                ),
                              ),

                            ],
                          ),
                        );
                      },
                    )),
              ):
              loader == "false"?
              Container(
                  height: MediaQuery.of(context).size.height/1.7,
                  child: Center(child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,))):
              Container(
                height: MediaQuery.of(context).size.height/1.7,
                child: Center(
                    child: Image.asset("images/notrades.png",height: 100,)
                ),
              )
            ],
          ),
        ),
      );
  }

  String? localPath;
  Future<File> downloadFile(String url, String fileName) async {
    setState(() {

    });
    final response = await http.get(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  int? currentPage;
  Future<void> View_analysis_popup() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const SizedBox(height: 45),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.clear, color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: const Text(
                          "Analysis",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: localPath != null
                        ? PDFView(
                      filePath: localPath!,
                      fitEachPage: false, // Allows natural scrolling
                      fitPolicy: FitPolicy.BOTH, // Fits content proportionally
                      swipeHorizontal: true, // Enables vertical scrolling
                      enableSwipe: true,
                      pageFling: true,
                      pageSnap: true,
                      onPageChanged: (int? page, int? totalPages) {
                        setState(() {
                          currentPage = page; // Track the current page
                        });
                        print("Current page: $page of $totalPages");
                      },
                      onRender: (pages) {
                        print("Total Pages Rendered: $pages");
                      },
                      onError: (error) {
                        print("PDFView Error: $error");
                      },
                    )
                        : const Center(child: CircularProgressIndicator()),
                  ),

                ],
              ),
            );
          },
        );
      },
    );
  }


  // Description_popup(Description) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //               return Container(
  //                 margin: const EdgeInsets.only(left: 15, right: 15),
  //                 width: MediaQuery.of(context).size.width,
  //                 child: AlertDialog(
  //                   insetPadding: EdgeInsets.zero,
  //                   elevation: 0,
  //                   title: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Container(
  //                           child: const Text(
  //                             'Description',
  //                             style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
  //                           )
  //                       ),
  //                       GestureDetector(
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                         },
  //                         child: Container(
  //                           alignment: Alignment.topRight,
  //                           child: const Icon(
  //                             Icons.clear,
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   content: Container(
  //                     // height:300,
  //                     width: double.infinity,
  //                     child: SingleChildScrollView(
  //                       scrollDirection: Axis.vertical,
  //                       child: Column(
  //                         children: [
  //                           const Divider(
  //                             color: Colors.black,
  //                           ),
  //
  //                           Container(
  //                             child: Text("$Description"),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             });
  //       }) ??
  //       false;
  // }

  Description_popup(description) {
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
                          data: description,
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


  // Broker_connect_angel_popup() {
  //   return showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext ctx, StateSetter setState) {
  //           return Padding(
  //             padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom,  // Adjust for the keyboard
  //             ),
  //             child: SingleChildScrollView(
  //               child: Container(
  //                 padding: const EdgeInsets.all(16.0),
  //                 // Ensure container height is dynamic
  //                 constraints: BoxConstraints(
  //                   minHeight: MediaQuery.of(context).size.height / 3,
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         GestureDetector(
  //                           onTap: (){
  //                             AngelOne_Process_popup();
  //                           },
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             height: 25,
  //                             width: 100,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(8),
  //                                 color: Colors.grey.shade300
  //                             ),
  //                             child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Container(
  //                       alignment: Alignment.topLeft,
  //                       margin: const EdgeInsets.only(top: 20, left: 20),
  //                       child: const Text(
  //                         "Api Key",
  //                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
  //                       ),
  //                     ),
  //                     Container(
  //                       alignment: Alignment.topLeft,
  //                       margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
  //                       child: TextFormField(
  //                         cursorColor: Colors.black,
  //                         cursorWidth: 1.1,
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return 'Please Enter Api Key';
  //                           }
  //                           return null;
  //                         },
  //                         controller: api_key,
  //                         style: const TextStyle(fontSize: 13),
  //                         decoration: InputDecoration(
  //                           focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
  //                           ),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
  //                           ),
  //                           hintText: "Api Key",
  //                           contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
  //                           hintStyle: const TextStyle(fontSize: 13),
  //                           prefixIcon: const Icon(Icons.api),
  //                         ),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         api_secret.text = '';
  //                         user_id.text = '';
  //                         BrokerConnect_Api("1");
  //                       },
  //                       child: Card(
  //                         clipBehavior: Clip.antiAliasWithSaveLayer,
  //                         color: Colors.transparent,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         elevation: 0,
  //                         child: Container(
  //                           height: 45,
  //                           alignment: Alignment.topLeft,
  //                           margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
  //                           width: MediaQuery.of(context).size.width / 3,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(8),
  //                             color: Colors.grey.shade200,
  //                             gradient: const LinearGradient(
  //                               begin: Alignment.topRight,
  //                               end: Alignment.bottomLeft,
  //                               stops: [
  //                                 0.1,
  //                                 0.5,
  //                               ],
  //                               colors: [
  //                                 ColorValues.Splash_bg_color1,
  //                                 ColorValues.Splash_bg_color1,
  //                               ],
  //                             ),
  //                           ),
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             child: const Text(
  //                               "Submit",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 18,
  //                                   color: Colors.white),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  //
  // Broker_connect_aliceBlue_popup() {
  //   return showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext ctx, StateSetter setState) {
  //           return Padding(
  //             // Add padding at the bottom when the keyboard is open
  //             padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom,
  //             ),
  //             child: SingleChildScrollView(
  //               child: Container(
  //                 padding: const EdgeInsets.all(16.0),
  //                 constraints: BoxConstraints(
  //                   minHeight: MediaQuery.of(context).size.height / 1.8,
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         GestureDetector(
  //                           onTap: (){
  //                             Alice_Process_popup();
  //                           },
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             height: 25,
  //                             width: 100,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(8),
  //                                 color: Colors.grey.shade300
  //                             ),
  //                             child:const Text("View Process",style: TextStyle(color: Colors.black,fontSize: 12),),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Container(
  //                       alignment: Alignment.topLeft,
  //                       margin: const EdgeInsets.only(top: 20, left: 20),
  //                       child: const Text(
  //                         "App Code",
  //                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
  //                       ),
  //                     ),
  //                     Container(
  //                       alignment: Alignment.topLeft,
  //                       margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
  //                       child: TextFormField(
  //                         cursorColor: Colors.black,
  //                         cursorWidth: 1.1,
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return 'Please Enter App Code';
  //                           }
  //                           return null;
  //                         },
  //                         controller: api_key,
  //                         style: const TextStyle(fontSize: 13),
  //                         decoration: InputDecoration(
  //                           focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
  //                           ),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
  //                           ),
  //                           hintText: "Enter App Code",
  //                           contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
  //                           hintStyle: const TextStyle(fontSize: 13),
  //                           prefixIcon: const Icon(Icons.api),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       alignment: Alignment.topLeft,
  //                       margin: const EdgeInsets.only(top: 20, left: 20),
  //                       child: const Text(
  //                         "User Id",
  //                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
  //                       ),
  //                     ),
  //                     Container(
  //                       alignment: Alignment.topLeft,
  //                       margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
  //                       child: TextFormField(
  //                         cursorColor: Colors.black,
  //                         cursorWidth: 1.1,
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return 'Please Enter User Id';
  //                           }
  //                           return null;
  //                         },
  //                         controller: user_id,
  //                         style: const TextStyle(fontSize: 13),
  //                         decoration: InputDecoration(
  //                           focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
  //                           ),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
  //                           ),
  //                           hintText: "Enter User Id",
  //                           contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
  //                           hintStyle: const TextStyle(fontSize: 13),
  //                           prefixIcon: const Icon(Icons.api),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       alignment: Alignment.topLeft,
  //                       margin: const EdgeInsets.only(top: 20, left: 20),
  //                       child: const Text(
  //                         "Api Secret",
  //                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
  //                       ),
  //                     ),
  //                     Container(
  //                       alignment: Alignment.topLeft,
  //                       margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
  //                       child: TextFormField(
  //                         cursorColor: Colors.black,
  //                         cursorWidth: 1.1,
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return 'Please Enter Api Secret';
  //                           }
  //                           return null;
  //                         },
  //                         controller: api_secret,
  //                         style: const TextStyle(fontSize: 13),
  //                         decoration: InputDecoration(
  //                           focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
  //                           ),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
  //                           ),
  //                           hintText: "Enter Api Secret",
  //                           contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
  //                           hintStyle: const TextStyle(fontSize: 13),
  //                           prefixIcon: const Icon(Icons.api),
  //                         ),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         BrokerConnect_Api("2");
  //                       },
  //                       child: Card(
  //                         clipBehavior: Clip.antiAliasWithSaveLayer,
  //                         color: Colors.transparent,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         elevation: 0,
  //                         child: Container(
  //                           height: 45,
  //                           alignment: Alignment.topLeft,
  //                           margin: const EdgeInsets.only(top: 30, left: 15, right: 30),
  //                           width: MediaQuery.of(context).size.width / 3,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(8),
  //                             color: Colors.grey.shade200,
  //                             gradient: const LinearGradient(
  //                               begin: Alignment.topRight,
  //                               end: Alignment.bottomLeft,
  //                               stops: [0.1, 0.5],
  //                               colors: [
  //                                 ColorValues.Splash_bg_color1,
  //                                 ColorValues.Splash_bg_color1,
  //                               ],
  //                             ),
  //                           ),
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             child: const Text(
  //                               "Submit",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 18,
  //                                   color: Colors.white),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Place_order_popup(Signal_id,Signal_price,Url_placeorder,Signal_name,Entry_type,Segment,Expiry_date,Lot_size,Trade_symbol,Target){
    print("55565656: $Target");
    target.text="$Target";
    setState(() {
      selectedOption=0;
      selectedOptionn=0;
      stoploss.text="";
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

                          selectedOption == 1 ?
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
                          )
                              :
                          selectedOption == 2 ?
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

                                  print("selectedOptionn=== $selectedOptionn");
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

                                    else if(selectedOptionn==1 && target.text !=null && target.text!="" &&(double.parse(target.text.toString()) < double.parse(Signal_price.toString()))){
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
                                      Future_quantity =
                                      Segment=="C"?
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
                                          msg: "Enter Exit quantity",
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
