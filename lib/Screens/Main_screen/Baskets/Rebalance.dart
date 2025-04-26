import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Constants/Util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Rebalance extends StatefulWidget {
  String? Basket_id;
  String? Investment_amount;
  Rebalance({Key? key,required this.Basket_id,required this.Investment_amount}) : super(key: key);

  @override
  State<Rebalance> createState() => _RebalanceState(Basket_id:Basket_id,Investment_amount:Investment_amount);
}

class _RebalanceState extends State<Rebalance> {
  String? Basket_id;
  String? Investment_amount;
  _RebalanceState({
    required this.Basket_id,
    required this.Investment_amount
});

  String? Message_confirmOrder;
  Future<Map<String, dynamic>> Confirm_order_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_loginn = prefs.getString('Login_id');
    String? Broker_idd = prefs.getString('Broker_id');
    print("11112222: $Broker_idd");

    // print("111111111111111: $Basket_id");
    // print("222222222222222: $Id_loginn");
    // print("333333333333333: $Broker_idd");
    // print("444444444444444: ${MinInvAmt.text}");
    // print("555555555555555: 0");

    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/placeorder"),
      body: {
        "basket_id": "$Basket_id",
        "clientid": "$Id_loginn",
        "brokerid": "$Broker_idd",
        "investmentamount": "${MinInvAmt.text}",
        "type": "0",
      },
    );

    var jsonString = jsonDecode(response.body);
    print("Response JSON: $jsonString");

    // Return both message and list
    if (jsonString['status'] == 'success') {
      // Fluttertoast.showToast(
      //   msg: "${jsonString['message']}",
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white
      // );
      return {
        'message': jsonString['message'] ?? '',
        'data': jsonString['data'] ?? [],
      };

    }
    else{
      Fluttertoast.showToast(
          msg: "${jsonString['message']}",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }

    return {
      'message': jsonString['message'] ?? 'Failed to fetch message.',
      'data': jsonString['data'] ?? 'Failed to fetch data.',
    };
  }

  bool? status_placeOrder;
  String? Message_placeOrder;
  Place_order_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_login = prefs.getString('Login_id');
    String? Broker_id = prefs.getString('Broker_id');
    print("11112222: $Broker_id");
    var response = await http.post(
      Uri.parse("${Util.Main_BasrUrl}/api/placeorder"),
      body: {
        "basket_id": "$Basket_id",
        "clientid": "$Id_login",
        "brokerid": "$Broker_id",
        "investmentamount": "${MinInvAmt.text}",
        "type": "1",
      },
    );

    var jsonString = jsonDecode(response.body);
    print("Response JSON: $jsonString");

    status_placeOrder= jsonString['status'];
    Message_placeOrder= jsonString['message'];

    if(status_placeOrder==true){
      Fluttertoast.showToast(
          msg: "${Message_placeOrder}",
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
      Navigator.pop(context);
    }
    else{
      Fluttertoast.showToast(
          msg: "${Message_placeOrder}",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }
  }


  bool? status_exitplaceOrder;
  String? Message_exitplaceOrder;
  Exit_Place_order_Api(selectedId,version) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_loginn = prefs.getString('Login_id');
    String? Broker_iddd = prefs.getString('Broker_id');

    print("111: $Basket_id");
    print("222: $Id_loginn");
    print("333: $Broker_iddd");
    print("444: $version");
    print("555: $selectedId");
    var responseee = await http.post(
      Uri.parse("${Util.Main_BasrUrl}/api/exitplaceorder"),
        headers: {
          'Content-Type':'application/json'
        },
      body: jsonEncode({
        "basket_id":"$Basket_id",
        "clientid":"$Id_loginn",
        "brokerid":"$Broker_iddd",
        "version":version,
        "ids": selectedId
      })
    );

    var jsonString = jsonDecode(responseee.body);
    print("Response JSON: $jsonString");

    status_exitplaceOrder= jsonString['response']['status'];
    print("statussss: $status_exitplaceOrder");
    Message_exitplaceOrder= jsonString['response']['message'];

    if(status_exitplaceOrder==true){
      Fluttertoast.showToast(
          msg: "${Message_exitplaceOrder}",
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
      Navigator.pop(context);
    }
    else{
      Fluttertoast.showToast(
          msg: "${Message_exitplaceOrder}",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }
  }

  String? loader="false";
  var Dattta=[];
  // bool? Status;
  List<Map<String, dynamic>> data=[];
  List<int> sortedVersions=[];
  Map<int, List<Map<String, dynamic>>> groupedData={};
  double? Last_price;
  List<double> Liveprice_last=[];
  Future<void> postJsonData() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Iddddd_login = prefs.getString('Login_id');
    print("${Util.BASE_URL1}basketstockbalance/$Basket_id/$Iddddd_login");
    final url = Uri.parse('${Util.BASE_URL1}basketstockbalance/$Basket_id/$Iddddd_login');
    print(url);
    try {
      final response = await http.get(url);

      var jsonString = jsonDecode(response.body);
      print("Jsonnnnnnnnnnn: $jsonString");

      Dattta=jsonString['data'];
      print("Dattta : $Dattta");
      print("Dat : ${Dattta.length}");

      // NSE_All_Data_Api();

      for(int i=0; i<Dattta.length; i++){

        Map<String, dynamic> nseMap = {
          for (var item in NSE_Data) item['token']: item['lp']
        };

        // Iterate through Signal_data to find matches
        for (var signalItem in Dattta) {
          String stock = signalItem['instrument_token'].toString();
          if (nseMap.containsKey(stock)) {
            Last_price = nseMap[stock];
            print("1212121212: $Last_price");
            Liveprice_last.add(Last_price!);
            print('Match Found: Stock = $stock, Price = $Last_price,');

          } else {
            print('No Match Found for Stock = $stock');
          }
        }
      }
      setState(() {
        Dattta.length>0?
        loader="true":
        loader="No_data";
      });

      data= List<Map<String, dynamic>>.from(jsonString['data']);
      print("Dataaaaaa: ${data[0]}");

       groupedData = {};
      for (var item in data) {
        CurrentValuee.add(0.0);
        _symbols.add(item['instrument_token']);
        int version = item['version'];
        if (!groupedData.containsKey(version)) {
          groupedData[version] = [];
        }
        groupedData[version]!.add(item);
      }
      _symbols.sort();
      sortedVersions = groupedData.keys.toList()..sort();


    } catch (error) {
      print('Error occurred: $error');
    }
  }


  var NSE_Data;
  bool loader_nsedata=false;
  NSE_All_Data_Api() async {
    var data = await API.Live_AllData_Api(Basket_id);
    setState(() {
      NSE_Data = data['data'];
      postJsonData();
      // MyPortfolio_Api();
    });
  }


  bool? status_checkBasketsell;
  String? Message_checkBasketsell;
  var checkBasketsellData=[];

  CheckBasketsell_Api(version) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_logine = prefs.getString('Login_id');
    String? Broker_id = prefs.getString('Broker_id');
    print("11112222: $Broker_id");
    var response = await http.post(
      Uri.parse("${Util.Main_BasrUrl}/api/checkbasketsell"),
      headers: {
        'Content-Type':'application/json'
      },
      body: jsonEncode({
        "basket_id": "$Basket_id",
        "clientid": "$Id_logine",
        "brokerid": "$Broker_id",
        "version": version
      }),
    );

    var jsonString = jsonDecode(response.body);
    print("Response JSON: $jsonString");

    status_checkBasketsell= jsonString['status'];
    Message_checkBasketsell= jsonString['message'];

    if(status_checkBasketsell==true){
      setState(() {});
      checkBasketsellData=jsonString['data'];
      print("TTTTTTTTTTTTTTT: $checkBasketsellData");

      Exit_order_popup(checkBasketsellData,version);
      print("111111");
      // Fluttertoast.showToast(
      //     msg: "${Message_checkBasketsell}",
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white
      // );
    }
    else{
      Fluttertoast.showToast(
          msg: "${Message_checkBasketsell}",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }
  }

  var previousPrice;
  var currentPrice;
  List<double> CurrentValuee = [];
  double? CurrentValue=0.0;

    bool? Status_order;
  String? Message_order;
  var Orders=[];

  BasketVersionOrder_Api(version) async {
    print("777777");
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_loginnn = prefs.getString('Login_id');
    String? Broker_iddd = prefs.getString('Broker_id');
    print("11112222: $Broker_iddd");
    var response = await http.post(
      Uri.parse("${Util.BASE_URL1}getbasketversionorder"),
      headers: {
        'Content-Type':'application/json'
      },
      body: jsonEncode({
        "basket_id": "$Basket_id",
        "clientid": "$Id_loginnn",
        "version": version
      }),
    );

    var jsonString = jsonDecode(response.body);
    print("Response JSON: $jsonString");

    Status_order= jsonString['status'];
    Message_order= jsonString['message'];

    if(Status_order==true){
      setState(() {});
      Orders=jsonString['data'];
      Orders.length>0?
      VieeOrder_popup(Orders):
      Fluttertoast.showToast(
        msg: "No Orders Found",
        backgroundColor: Colors.red,
        textColor: Colors.white
      );
    }
    else{
      Fluttertoast.showToast(
          msg: "${Message_order}",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }
  }



  late IO.Socket socket;
  final List<String> _symbols = [];

  Map<String, double> _prices = {};
  Map<String, double> _previousPrices = {};

  // Future<void> _loadPreviousPrices() async {
  //   _previousPrices = await getPreviousPrices();
  //   setState(() {}); // Update UI after loading data
  // }
  //
  // Future<void> _updatePreviousPrices(String symbol, double price) async {
  //   _previousPrices[symbol] = price;
  //   await savePreviousPrices(_previousPrices);
  // }
  //
  // Future<void> savePreviousPrices(Map<String, double> previousPrices) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String jsonString = jsonEncode(previousPrices); // Convert Map to JSON String
  //   await prefs.setString('previous_prices', jsonString);
  // }
  //
  // Future<Map<String, double>> getPreviousPrices() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? jsonString = prefs.getString('previous_prices'); // Retrieve JSON String
  //   if (jsonString != null) {
  //     Map<String, dynamic> decodedMap = jsonDecode(jsonString);
  //     // Convert Map<String, dynamic> to Map<String, double>
  //     return decodedMap.map((key, value) => MapEntry(key, value.toDouble()));
  //   }
  //   return {}; // Return empty map if no data found
  // }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NSE_All_Data_Api();
    // _loadPreviousPrices();
    for (var symbol in _symbols) {
      _prices[symbol] = 0.0;

      _previousPrices[symbol] = 0.0;
    }

    socket = IO.io('http://217.145.69.150:5001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('Live_data', (data) {
      print("Socket Data Received: $data");

      final symbol = data['tk'];
      final price = double.tryParse(data['lp']?.toString() ?? '') ?? 0.0;

      if (_symbols.contains(symbol)) {
        setState(() {
          if (_prices[symbol] != null && _prices[symbol] != 0.0) {
            _previousPrices[symbol] = double.parse(_prices[symbol].toString());
          }

          if (price != 0.0) {
            _prices[symbol] = price;
          }
        });

        print("Symbol: $symbol");
        print("New Price: $price");
        print("Previous Prices: $_previousPrices");
      }
    });



    socket.on('disconnect', (_) {
      print('Disconnected from socket server');
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
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
        title:const Text("Rebalanced Stocks",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body: loader=="true"?
      SingleChildScrollView(
        child: Column(
          children: sortedVersions.map((version) {
            List<Map<String, dynamic>> versionData = groupedData[version]!;
            bool isSingleVersion = sortedVersions.length == 1;
            bool isLastVersion = version == sortedVersions.last;
            bool isSecondLastVersion = sortedVersions.length > 1 && version == sortedVersions[sortedVersions.length - 2];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:const EdgeInsets.only(right: 15,top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorValues.Splash_bg_color1, // Set the background color
                        ),
                        onPressed: () {
                          print("version for api: $version");
                          BasketVersionOrder_Api(version);
                          print("09090909");
                        },
                        child:const Text('View'),
                      ),
                      const SizedBox(width: 20,),

                      isSingleVersion
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          OrderConfirmation(context);
                          // Buy_popup(context);
                          // Buy logic here
                          print("Buy button clicked for single version $version");
                        },
                        child:const Text('Buy'),
                      )
                          : isLastVersion
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          OrderConfirmation(context);
                          // Buy_popup(context);
                          print("Buy button clicked for version $version");
                        },
                        child:const Text('Buy'),
                      )
                          : isSecondLastVersion
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Set the background color
                        ),
                        onPressed: () {
                          // Sell logic here
                          print("Sell button clicked for version $version");
                          CheckBasketsell_Api(version);

                        },
                        child:const Text('Sell'),
                      )
                          :const SizedBox.shrink(),
                    ],
                  ),
                ),

                Container(
                  margin:const EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:Container(
                      child: DataTable(
                        columnSpacing: 30,
                        headingRowHeight: 50,
                        headingRowColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states
                                .contains(MaterialState.hovered)) {
                              return ColorValues.Splash_bg_color1.withOpacity(
                                  0.5); // Color when hovered
                            }

                            return ColorValues.Splash_bg_color1;
                          },
                        ),
                        columns:const [
                          DataColumn(label: Text('Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                          DataColumn(label: Text('Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                          DataColumn(label: Text('CMP',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                          DataColumn(label: Text('Weightage',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                          DataColumn(label: Text('Qty.',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                        ],
                        // rows: versionData.map((item) {
                        //   final symbol =item['instrument_token'];
                        //    currentPrice = _prices[symbol] ?? 0.0;
                        //    previousPrice = _previousPrices[symbol] ?? 0.0;
                        //   // _updatePreviousPrices(symbol, previousPrice);
                        //   final priceColor = currentPrice > previousPrice
                        //       ? Colors.green
                        //       : currentPrice < previousPrice
                        //       ? Colors.red
                        //       : Colors.black;
                        //
                        //   double value =
                        //   currentPrice==0.0||currentPrice==0||currentPrice==null?
                        //   previousPrice * double.parse(item['quantity'].toString()):
                        //   currentPrice * double.parse(item['quantity'].toString());
                        //
                        //
                        //   CurrentValue=CurrentValuee.reduce((value, element) => value + element);
                        //
                        //   return DataRow(
                        //     cells: [
                        //       DataCell(Text(item['name'] ?? '',style:const TextStyle(fontSize: 12),)),
                        //       DataCell(Text('₹${item['price']}',style:const TextStyle(fontSize: 12),)),
                        //
                        //       DataCell(Container(width: 55, child:
                        //       currentPrice==0.0||currentPrice==0||currentPrice==null?
                        //       Text('₹$previousPrice', style:const TextStyle(fontSize: 12),):
                        //       Text('₹$currentPrice', style: TextStyle(fontSize: 12,color: priceColor),),
                        //       )
                        //       ),
                        //
                        //       DataCell(Text('${item['weightage']}%',style:const TextStyle(fontSize: 12),)),
                        //       DataCell(Text('${item['quantity']}',style:const TextStyle(fontSize: 12),)),
                        //       // DataCell(
                        //       //     GestureDetector(
                        //       //       onTap: (){
                        //       //         var Orders= item['order_details'];
                        //       //         print("Orders: ${Orders.length}");
                        //       //
                        //       //         Orders.length>0?
                        //       //         VieeOrder_popup(Orders):
                        //       //          Fluttertoast.showToast(
                        //       //            msg: "No record found",
                        //       //            backgroundColor: Colors.red,
                        //       //            textColor: Colors.white
                        //       //          );
                        //       //
                        //       //       },
                        //       //       child: Container(
                        //       //             height: 20,
                        //       //             width: 40,
                        //       //              alignment: Alignment.center,
                        //       //                decoration: BoxDecoration(
                        //       //                  borderRadius: BorderRadius.circular(7),
                        //       //                  color: ColorValues.Splash_bg_color1
                        //       //                ),
                        //       //       child:const Text('View',style: TextStyle(fontSize: 11,color: Colors.white),)),
                        //       //     )),
                        //     ],
                        //   );
                        // }).toList(),

                        rows: versionData.asMap().entries.map((entry) {
                          final index = entry.key; // Get the index
                          final item = entry.value; // Get the item
                          final symbol = item['instrument_token'];
                          currentPrice = _prices[symbol] ?? 0.0;
                          previousPrice = Liveprice_last[index];
                          // _updatePreviousPrices(symbol, previousPrice);

                          final priceColor = currentPrice > previousPrice
                              ? Colors.green
                              : currentPrice < previousPrice
                              ? Colors.red
                              : Colors.black;

                          double value = currentPrice == 0.0 || currentPrice == 0 || currentPrice == null
                              ? previousPrice * double.parse(item['quantity'].toString())
                              : currentPrice * double.parse(item['quantity'].toString());

                          CurrentValue = CurrentValuee.reduce((value, element) => value + element);

                          return DataRow(
                            cells: [
                              DataCell(Text(item['name'] ?? '', style: const TextStyle(fontSize: 12))),
                              DataCell(Text('₹${item['price']}', style: const TextStyle(fontSize: 12))),
                              DataCell(
                                Container(
                                  width: 55,
                                  child: currentPrice == 0.0 || currentPrice == 0 || currentPrice == null
                                      ? Text('₹$previousPrice', style: const TextStyle(fontSize: 12))
                                      : Text('₹$currentPrice',
                                      style: TextStyle(fontSize: 12, color: priceColor)),
                                ),
                              ),
                              DataCell(Text('${item['weightage']}%', style: const TextStyle(fontSize: 12))),
                              DataCell(Text('${item['quantity']}', style: const TextStyle(fontSize: 12))),
                            ],
                          );
                        }).toList(),

                      ),
                    ),
                  ),
                ),
                Container(
                    margin:const EdgeInsets.only(left: 10,right: 10),
                    child: Divider(color: Colors.grey.shade400,)
                ),
                // const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      ):
      loader=="false"?
      Container(
        child:const Center(child:CircularProgressIndicator(color: Colors.black,)),
      ):
      Container(
            child:const Center(child: Text("No Data Found..")),
          )
    );
  }


  TextEditingController MinInvAmt =TextEditingController();

  Buy_popup(BuildContext context) {
    List<dynamic> dataList = [];
    String message = "";
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setState) {
            return Wrap(
              children: [
                Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  // height: MediaQuery.of(context).size.height / 1.5,
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "Investment Amount :",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 35,
                                    width:
                                    MediaQuery.of(context).size.width / 1.7,
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, bottom: 4),
                                    margin:
                                    const EdgeInsets.only(left: 20, top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade600,
                                          width: 0.4),
                                    ),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: MinInvAmt,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter investment amount",
                                        hintStyle: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  message == "Order Confirm Successfully."?
                                  Container(
                                    height: 25,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 0.2)),
                                    margin:
                                    const EdgeInsets.only(left: 10, top: 7),
                                    child: const Text(
                                      "Confirm",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ):
                                  GestureDetector(
                                    onTap: () async {
                                      if(MinInvAmt.text==""||MinInvAmt.text==null){
                                        Fluttertoast.showToast(
                                            msg: "Please enter investment amount",
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white
                                        );
                                      }
                                      else{
                                          var response = await Confirm_order_Api();

                                          print("Responseeeeeeeeeeee: $response");
                                          setState(() {
                                            message = response['message'];
                                            dataList = response['data'];

                                            print("7777777777777777: $dataList");
                                            print("8888888888888888: $message");
                                          });


                                        // if (dataList.isEmpty && message.isEmpty) {
                                        //   // If data and message are not fetched yet, call API
                                        //   fetchData();
                                        // }
                                      }


                                    },
                                    child: Container(
                                      height: 25,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.green, width: 0.2)
                                      ),
                                      margin:
                                      const EdgeInsets.only(left: 10, top: 7),
                                      child: const Text(
                                        "Confirm",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                "Minimum Investment Amount :",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              alignment: Alignment.topLeft,
                              child:  Text(
                                "₹$Investment_amount",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),

                      message == "Order Confirm Successfully."?
                      Container(
                        height:MediaQuery.of(context).size.height/2.5,
                        width: MediaQuery.of(context).size.width,
                        margin:const EdgeInsets.only(top: 20,left: 20,right: 40),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child:  DataTable(
                              columnSpacing: 30,
                              headingRowHeight: 50,
                              headingRowColor: MaterialStateColor.resolveWith(
                                    (Set<MaterialState> states) {
                                  if (states
                                      .contains(MaterialState.hovered)) {
                                    return ColorValues.Splash_bg_color1.withOpacity(
                                        0.5); // Color when hovered
                                  }

                                  return ColorValues.Splash_bg_color1;
                                },
                              ),
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text('Stock Name',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white)),
                                ),
                                DataColumn(
                                  label: Text('CMP',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white)),
                                ),
                                DataColumn(
                                  label: Text('Quantity',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white)),
                                ),
                              ],

                              rows:
                              List<DataRow>.generate(
                                  dataList.length, (index) {

                                return DataRow(
                                  color: MaterialStateColor.resolveWith(
                                          (Set<MaterialState> states) {
                                        return Colors.white; // Default color
                                      }),
                                  cells: <DataCell>[
                                    DataCell(
                                        Container(
                                          // width: 100,
                                            child: Text(
                                              '${dataList[index]['symbol']}',
                                              style: TextStyle(fontSize: 12),
                                            ))),


                                    DataCell(Container(
                                        child: Text("₹${dataList[index]['lpPrice']}",style: TextStyle(fontSize: 12),)
                                    )),


                                    DataCell(Container(
                                      child: Text(
                                        '${dataList[index]['quantity']}',
                                        style: TextStyle(fontSize: 12,color: Colors.green),
                                      ),
                                    )
                                    ),
                                  ],
                                );

                              })),
                        ),
                      ):

                      const SizedBox(height: 0,),

                      message == "Order Confirm Successfully." ?
                      GestureDetector(
                        onTap: (){
                          Place_order_Api();
                        },
                        child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(left: 20, right: 40, top: 35,bottom: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green),
                            child: const Text(
                              "Place Order",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )),
                      )
                          : Container(
                          height: 40,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 20, right: 40, top: 35,bottom: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey),
                          child: const Text(
                            "Place Order",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )
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

  bool isChecked = false;
  List<int> selectedId=[];
  Exit_order_popup(checkBasketsellData,version){
    selectedId=[];
    return showModalBottomSheet(
      shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8)
        )
      ),
      isScrollControlled:true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return Container(
                margin:const EdgeInsets.only(top: 15),
                  // height: MediaQuery.of(context).size.height/2,
                  child:Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: checkBasketsellData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text("Order ${checkBasketsellData[index]['_id']}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                  ),

                                  Container(
                                    child: Checkbox(
                                      value: selectedId.contains(checkBasketsellData[index]['_id'])?true:false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selectedId.contains(checkBasketsellData[index]['_id'])?
                                          selectedId.remove(checkBasketsellData[index]['_id']):
                                          selectedId.add(checkBasketsellData[index]['_id']);
                                          // isChecked = value ?? false;
                                        });
                                        print("selectedId== ${selectedId}");
                                      },
                                    ),
                                  ),

                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Exit_Place_order_Api(selectedId,version);
                        },
                        child: Container(
                          margin:const EdgeInsets.only(bottom: 20,top: 20,right: 8),
                          height: 40,
                          width: MediaQuery.of(context).size.width/1.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red
                          ),
                          alignment: Alignment.center,
                          child:const Text("Exit Order",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),),
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
  VieeOrder_popup(Orders) {
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
                              'Order Detail',
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            )
                        ),
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
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          children: [
                            DataTable(
                              columnSpacing: 30,
                              headingRowHeight: 50,
                              headingRowColor: MaterialStateColor.resolveWith(
                                    (Set<MaterialState> states) {
                                  if (states
                                      .contains(MaterialState.hovered)) {
                                    return ColorValues.Splash_bg_color1.withOpacity(
                                        0.5); // Color when hovered
                                  }

                                  return ColorValues.Splash_bg_color1;
                                },
                              ),
                              columns:const [
                                DataColumn(label: Text('Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                                DataColumn(label: Text('Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                                DataColumn(label: Text('Qty.',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                                DataColumn(label: Text('Type',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                              ],
                              rows:List<DataRow>.generate(
                                  Orders.length, (index) {
                                return  DataRow(
                                  cells: [
                                    DataCell(Text("${Orders[index]['tradesymbol']}",style: TextStyle(fontSize: 12),)),
                                    DataCell(Text("${Orders[index]['price']}",style: TextStyle(fontSize: 12),)),
                                    DataCell(Text("${Orders[index]['quantity']}",style: TextStyle(fontSize: 12),)),
                                    DataCell(Text("${Orders[index]['ordertype']}",style: TextStyle(fontSize: 12),)),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                );
              });
        }) ??
        false;
  }

  OrderConfirmation(BuildContext context) {
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
                              'Do you want to buy this stock ?',
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            )
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: Container(
                        //     alignment: Alignment.topRight,
                        //     child: const Icon(
                        //       Icons.clear,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              margin:const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade500
                              ),
                              alignment: Alignment.center,
                              child:const Text("No",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              Buy_popup(context);
                            },
                            child: Container(
                              margin:const EdgeInsets.only(right: 20),
                              height: 30,
                              width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorValues.Splash_bg_color1
                              ),
                              child:const Text("Yes",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                );
              });
        }) ??
        false;
  }

}

