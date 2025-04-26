import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Rebalance.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stock_box/Screens/Main_screen/Baskets/Rebalance_history.dart';

class Basket_stocks extends StatefulWidget {
  String? Basket_id;
  String? Investment_amount;
   Basket_stocks({Key? key,required this.Basket_id,required this.Investment_amount}) : super(key: key);

  @override
  State<Basket_stocks> createState() => _Basket_stocksState(Basket_id:Basket_id,Investment_amount:Investment_amount);
}

class _Basket_stocksState extends State<Basket_stocks> with SingleTickerProviderStateMixin{
  String? Basket_id;
  String? Investment_amount;

  _Basket_stocksState({
    required this.Basket_id,
    required this.Investment_amount,
});

  late TabController _tabController;


  final ScrollController _scrollController = ScrollController();
  bool _showButton = false;
  bool show=false;

  var Stocks_data=[];
  bool? Status;
  String? Message;
  String? loader= "false";
  
  double? InvestmentAmount;
  double? CurrentValue=0.0;
  double? ProfitLoss=0.0;

  List<double> CurrentValuee = [];
  var previousPrice;
  var currentPrice;

  int version=0;
  double? Last_price;
  double? Last_price_Myportfolio;
  List<double> Liveprice_last=[];
  List<double> Liveprice_last_Myportfolio=[];
  BasketStocks_Api() async {
    var data = await API.BasketStocks_Api(Basket_id);
    setState(() {
      Status = data['status'];
      Message = data['message'];
    });

    if(Status==true){

      // setState(() {
      //   version= Stocks_data[0]['verion'];
      // });
      Stocks_data=data['data'];

      InvestmentAmount=0.0;
      NSE_All_Data_Api();
      for(int i=0; i<Stocks_data.length; i++){
        // InvestmentAmount = double.parse(Investment_amount.toString());
        InvestmentAmount = InvestmentAmount!+double.parse(Stocks_data[i]['price'].toString()) * double.parse(Stocks_data[i]['quantity'].toString());
         print("Investmenttttttttttttttt: $InvestmentAmount");
        CurrentValuee.add(0.0);
        _symbols.add(Stocks_data[i]['instrument_token']);

        Map<String, dynamic> nseMap = {
          for (var item in NSE_Data) item['token']: item['lp']
        };

        // Iterate through Signal_data to find matches
        for (var signalItem in Stocks_data) {
          String stock = signalItem['instrument_token'].toString();
          if (nseMap.containsKey(stock)) {
            Last_price = double.parse(nseMap[stock].toString());
            print("1212121212: $Last_price");
            Liveprice_last.add(Last_price!);
            // double tag1Value = double.tryParse(signalItem['tag1'].toString()) ?? 0.0;
            // Calculate percentage difference
            // if (tag1Value != 0) {
            //     double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
            //     percentageDifference.add(percentageDifferencee);
            print('Match Found: Stock = $stock, Price = $Last_price,');



            // } else {
            //   print('Tag1 value is zero or invalid for Stock = $stock');
            // }
          } else {
            Liveprice_last.add(0.0);
            print('No Match Found for Stock = $stock');
          }
        }


      }

      print("Pqqqqqqqqqqqqqqq: $InvestmentAmount");


      print("Stocks_data : $Stocks_data");
      Stocks_data.length>0?
      loader="true":
      loader="No_data";

    }

    else{
      print("error");
    }
  }


  var NSE_Data;
  bool loader_nsedata=false;
  NSE_All_Data_Api() async {
    var data = await API.Live_AllData_Api(Basket_id);
    setState(() {
      NSE_Data = data['data'];
      BasketStocks_Api();
      MyPortfolio_Api();
    });
  }

  // List<double> percentageDifference=[];

  // void matchSymbolWithStock() {
  //   if (NSE_Data != null && Stocks_data != null) {
  //     // Create a map for faster lookup of SYMBOL and price from NSE_Data
  //     Map<String, dynamic> nseMap = {
  //       for (var item in NSE_Data) item['token']: item['lp']
  //     };
  //
  //     // Iterate through Signal_data to find matches
  //     for (var signalItem in Stocks_data) {
  //       String stock = signalItem['ordertoken'];
  //       if (nseMap.containsKey(stock)) {
  //         double price = nseMap[stock];
  //
  //         // double tag1Value = double.tryParse(signalItem['tag1'].toString()) ?? 0.0;
  //         // Calculate percentage difference
  //         // if (tag1Value != 0) {
  //         //     double percentageDifferencee  =((price - tag1Value).abs() / price) * 100;
  //         //     percentageDifference.add(percentageDifferencee);
  //             print('Match Found: Stock = $stock, Price = $price,');
  //
  //
  //
  //         // } else {
  //         //   print('Tag1 value is zero or invalid for Stock = $stock');
  //         // }
  //       } else {
  //         print('No Match Found for Stock = $stock');
  //       }
  //     }
  //   } else {
  //     print('NSE_Data or Signal_data is null');
  //   }
  //   setState(() {
  //     loader="true";
  //   });
  //   print(" percentageDifference==== ${percentageDifference}");
  // }


  var MyPortfolio_data=[];
  bool? Status_MyPortfolio;
  String? Message_MyPortfolio;
  String? loader_MyPortfolio= "false";
  double? InvestmentAmount_MyPortfolio;
  double? CurrentValue_MyPortfolio=0.0;
  double? ProfitLoss_MyPortfolio=0.0;

  List<double> CurrentValuee_MyPortfolio = [];
  var previousPrice_MyPortfolio;
  var currentPrice_MyPortfolio;
  // final List<String> _symbols_MyPortfolio = [];

  MyPortfolio_Api() async {
    print("1111111aaaaa");
    var data = await API.MyPortfolio_Api(Basket_id);
    setState(() {
      Status_MyPortfolio = data['status'];
      Message_MyPortfolio = data['message'];
    });

    if(Status_MyPortfolio==true){

      setState(() {});
      MyPortfolio_data=data['data'];
      print("MyPortfolio_data: $MyPortfolio_data");

      InvestmentAmount_MyPortfolio=0.0;
      for(int i=0; i<MyPortfolio_data.length; i++){
        InvestmentAmount_MyPortfolio = InvestmentAmount_MyPortfolio!+double.parse(MyPortfolio_data[i]['price'].toString()) * double.parse(MyPortfolio_data[i]['totalQuantity'].toString());
        CurrentValuee_MyPortfolio.add(0.0);
        _symbols.add(MyPortfolio_data[i]['ordertoken']);


        Map<String, dynamic> nseMap = {
          for (var item in NSE_Data) item['token']: item['lp']
        };

        // Iterate through Signal_data to find matches
        for (var signalItem in Stocks_data) {
          String stock = signalItem['ordertoken'].toString();
          if (nseMap.containsKey(stock)) {
            Last_price_Myportfolio = nseMap[stock];
            print("1212121212: $Last_price_Myportfolio");

            Liveprice_last_Myportfolio.add(Last_price_Myportfolio!);

            print('Match Found: Stock = $stock, Price = $Last_price_Myportfolio,');



            // } else {
            //   print('Tag1 value is zero or invalid for Stock = $stock');
            // }
          } else {
            Liveprice_last_Myportfolio.add(0.0);
            print('No Match Found for Stock = $stock');
          }
        }


      }

      print("Pqqqqqqqqqqqqqqq: $InvestmentAmount_MyPortfolio");


      print("Stocks_data5667788888 : $MyPortfolio_data");
      MyPortfolio_data.length>0?
      loader_MyPortfolio="true":
      loader_MyPortfolio="No_data";

    }

    else{
      print("error");
    }
  }



   String? Message_confirmOrder;
  Future<Map<String, dynamic>> Confirm_order_Api() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_loginn = prefs.getString('Login_id');
    String? Broker_idd = prefs.getString('Broker_id');

    // print("111111111111111: $Basket_id");
    // print("222222222222222: $Id_loginn");
    // print("333333333333333: $Broker_idd");
    // print("444444444444444: ${MinInvAmt.text}");
    // print("555555555555555: 0");

    var response = await http.post(
      Uri.parse("${Util.Main_BasrUrl}/api/placeorder"),
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

  late IO.Socket socket;
  final List<String> _symbols = [];

  Map<String, double> _prices = {};
  Map<String, double> _previousPrices = {};

  // Future<void> _loadPreviousPrices() async {
  //   _previousPrices = await getPreviousPrices();
  //   setState(() {}); // Update UI after loading data
  // }
  // Future<void> _updatePreviousPrices(String symbol, double price) async {
  //   _previousPrices[symbol] = price;
  //   await savePreviousPrices(_previousPrices);
  // }
  // Future<void> savePreviousPrices(Map<String, double> previousPrices) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String jsonString = jsonEncode(previousPrices); // Convert Map to JSON String
  //   await prefs.setString('previous_prices', jsonString);
  // }
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

  // Map<String, double> _prices = {};
  // Map<String, double> _previousPrices = {};

  // Future<void> _loadPreviousPrices_MyPortfolio() async {
  //   _previousPrices_MyPortfolio = await getPreviousPrices_MyPortfolio();
  //   setState(() {}); // Update UI after loading data
  // }
  // Future<void> _updatePreviousPrices_MyPortfolio(String symbol, double price) async {
  //   _previousPrices_MyPortfolio[symbol] = price;
  //   await savePreviousPrices_MyPortfolio(_previousPrices_MyPortfolio);
  // }
  // Future<void> savePreviousPrices_MyPortfolio(Map<String, double> previousPrices_MyPortfolio) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String jsonString = jsonEncode(previousPrices_MyPortfolio); // Convert Map to JSON String
  //   await prefs.setString('previous_prices_MyPortfolio', jsonString);
  // }
  // Future<Map<String, double>> getPreviousPrices_MyPortfolio() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? jsonString = prefs.getString('previous_pricesprevious_prices_MyPortfolio'); // Retrieve JSON String
  //   if (jsonString != null) {
  //     Map<String, dynamic> decodedMapp = jsonDecode(jsonString);
  //     // Convert Map<String, dynamic> to Map<String, double>
  //     return decodedMapp.map((key, value) => MapEntry(key, value.toDouble()));
  //   }
  //   return {}; // Return empty map if no data found
  // }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loader_MyPortfolio=="true"?
    // _tabController = TabController(length: 2, vsync: this):
    _tabController = loader_MyPortfolio=="true"?
        TabController(length: 2, vsync: this):
        TabController(length: 1, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        print("Current Tab Index: ${_tabController.index}");
      }
    });

    // BasketStocks_Api();
    NSE_All_Data_Api();
    // MyPortfolio_Api();
    // _loadPreviousPrices();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 100) {
        // Show button if scrolled down more than 200 pixels
        if (!_showButton) {
          setState(() {
            _showButton = true;
          });
        }
      } else {
        // Hide button if scrolled back to the top
        if (_showButton) {
          setState(() {
            _showButton = false;
          });
        }
      }
    });


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
    // Dispose the scroll controller
    _scrollController.dispose();
    socket.dispose();
    _tabController.dispose();
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
        title:const Text("Stock List",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
          actions: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Rebalance_history(Basket_id:Basket_id, Investment_amount:Investment_amount,)));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20,bottom: 10, right: 15),
                height: 22,
                width: 110,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: ColorValues.Splash_bg_color1
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Rebalance History",
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
            ),

            loader_MyPortfolio=="true"?
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Rebalance(Basket_id:Basket_id, Investment_amount:Investment_amount,)));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20,bottom: 10, right: 15),
                height: 22,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: ColorValues.Splash_bg_color1
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Rebalance",
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
            )
            : const SizedBox(width: 0,)
          ],
         ),

        bottomSheet: Stocks_data.length<=3 && Stocks_data.length>0?
        GestureDetector(
          onTap: (){
            Buy_popup(context);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 20,bottom: 10, right: 25,left: 25),
            height: 35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.green
            ),
            alignment: Alignment.center,
            child: const Text(
              "Buy Now",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ):
        _showButton?
        GestureDetector(
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_stocksnew()));
            Buy_popup(context);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 20,bottom: 10, right: 25,left: 25),
            height: 35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.green
            ),
            alignment: Alignment.center,
            child: const Text(
              "Buy Now",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ):null,



        body: loader_MyPortfolio=="true"?
        Column(
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
                    colors: [ColorValues.Splash_bg_color3, ColorValues.Splash_bg_color1],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                tabs:  <Widget>  [
                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Baskets'),
                      ),
                    ),
                  ),

                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('My Portfolio'),
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
                  loader=="true"?
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20,bottom: 50),
                        child: Column(
                          children: [

                            Container(
                              margin:const EdgeInsets.only(top: 5,left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Investment Amount :",style: TextStyle(fontSize: 13),),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("₹${InvestmentAmount!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                      )
                                    ],
                                  ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Current Value :",style: TextStyle(fontSize: 13),),
                                      ),

                                      CurrentValue==0.0?
                                      SizedBox(height: 25):
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("₹${CurrentValue!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(left: 20,right: 20),
                              child: Divider(color: Colors.grey.shade300,),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 3,left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Profit / Loss :",style: TextStyle(fontSize: 13),),
                                      ),
                                      CurrentValue==0.0?
                                      SizedBox(height: 25):
                                      // Container(
                                      //   margin:const EdgeInsets.only(top: 2),
                                      //   child: Text("0.0",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color:
                                      //   Colors.black
                                      //   ),),
                                      // ):
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("${ProfitLoss!.toStringAsFixed(2)}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color:
                                        ProfitLoss==0?
                                        Colors.black:
                                        ProfitLoss! > 0?
                                        Colors.green:
                                        Colors.red,
                                        ),),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 10,left: 20,right: 20),
                              child: Divider(color: Colors.grey.shade700,),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 5,bottom: 10),
                              child: ListView.builder(
                                itemCount:Stocks_data.length,
                                shrinkWrap: true,
                                physics:const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index)  {
                                  // final symbol = _symbols[index];
                                  final symbol = Stocks_data[index]['instrument_token'];
                                  print("Simmmmmmmmmmmmmmmm: $symbol");
                                  currentPrice = _prices[symbol] ?? 0.0;
                                  // previousPrice = _previousPrices[symbol] ?? 0.0;
                                  previousPrice = Liveprice_last[index];

                                  // _updatePreviousPrices(symbol, previousPrice);

                                  print("Current: $currentPrice");
                                  print("Previous: $previousPrice");

                                  final priceColor = currentPrice > previousPrice
                                      ? Colors.green
                                      : currentPrice < previousPrice
                                      ? Colors.red
                                      : Colors.black;
                                  print("111111");
                                  // CurrentValue= currentPrice * double.parse(Stocks_data[index]['quantity'].toString());
                                  print("2222222");
                                  double value =
                                  currentPrice==0.0||currentPrice==0||currentPrice==null?
                                      previousPrice * double.parse(Stocks_data[index]['quantity'].toString()):
                                      currentPrice * double.parse(Stocks_data[index]['quantity'].toString());

                                  CurrentValuee[index]= value;

                                  CurrentValue=CurrentValuee.reduce((value, element) => value + element);

                                  print("CurrentValueeeeeeeeeee: $CurrentValue");
                                  ProfitLoss= CurrentValue! - InvestmentAmount!;

                                  print("Profitloss: $ProfitLoss");

                                  return Container(
                                    // height: 130,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(left: 20, right: 20, top: 12,bottom: 8),
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
                                              margin: const EdgeInsets.only(top: 8, left: 15),
                                              child: Text(
                                                "${Stocks_data[index]['name']}",
                                                style:const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Container(
                                              margin:const EdgeInsets.only(right: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 15),
                                                    child:const Text("Qty : ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.grey),),
                                                  ),
                                                  Container(
                                                    child: Text("${Stocks_data[index]['quantity']}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),

                                        Container(
                                          margin:const EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 20),
                                          height: 105,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey,width: 0.01),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                  margin:const EdgeInsets.only(top: 7),
                                                  child: Row(
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [

                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          child: Text("Suggested Price: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                        ),
                                                      ),

                                                      Expanded(
                                                        flex: 2,
                                                        child:Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin:const EdgeInsets.only(left: 8),
                                                          child: Text("${Stocks_data[index]['price']}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: ColorValues.Splash_bg_color1),),

                                                        ) ,
                                                      )

                                                    ],
                                                  )
                                              ),

                                              Container(
                                                  margin:const EdgeInsets.only(left: 40,right: 40),
                                                  child: Divider(color: Colors.grey.shade300,)
                                              ),

                                              Container(
                                                  child: Row(
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          child: Text("Stock Weightage: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin:const EdgeInsets.only(left: 8),
                                                          child: Text("${Stocks_data[index]['weightage']} %",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: ColorValues.Splash_bg_color1),),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),

                                              Container(
                                                  margin:const EdgeInsets.only(left: 40,right: 40),
                                                  child: Divider(color: Colors.grey.shade300,)
                                              ),

                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 150,
                                                      child: Text("Current Market Price : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                    ),
                                                    Container(
                                                      width: 50,
                                                      alignment: Alignment.topLeft,
                                                      margin:const EdgeInsets.only(left: 8),
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child:currentPrice=="0.0"||currentPrice=="0"||currentPrice==null||currentPrice==0||currentPrice==0.0?
                                                        Text("₹${previousPrice}", style: TextStyle(fontWeight: FontWeight.w600,color:priceColor,fontSize: 12),):
                                                        Text("₹${currentPrice}", style: TextStyle(fontWeight: FontWeight.w600,color:priceColor,fontSize: 12),),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Container(
                                        //   margin:const EdgeInsets.only(left: 15,bottom: 12,top: 10),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.start,
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       Container(
                                        //         child:const Text("Comment : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                        //       ),
                                        //       Container(
                                        //         width: MediaQuery.of(context).size.width/1.58,
                                        //         child: Text("${Stocks_data[index]['comment']}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),


                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
                  ):
                  loader=="false"?
                  Container(
                    child: Center(child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,)),
                  ) :
                  Container(
                    child:const Center(
                      child: Text("No Record Found.."),
                    ),
                  ),



                  loader_MyPortfolio=="true"?
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20,bottom: 50),
                        child: Column(
                          children: [

                            Container(
                              margin:const EdgeInsets.only(top: 5,left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Investment Amount :",style: TextStyle(fontSize: 13),),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("₹${InvestmentAmount_MyPortfolio!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                      )
                                    ],
                                  ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Current Value :",style: TextStyle(fontSize: 13),),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("₹${CurrentValue_MyPortfolio!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(left: 20,right: 20),
                              child: Divider(color: Colors.grey.shade300,),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 3,left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Profit / Loss :",style: TextStyle(fontSize: 13),),
                                      ),
                                      CurrentValue_MyPortfolio!.toStringAsFixed(2)==0.00?
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("0.0",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color:
                                        Colors.black
                                        ),),
                                      ):
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("${ProfitLoss_MyPortfolio!.toStringAsFixed(2)}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color:
                                        ProfitLoss_MyPortfolio==0?
                                        Colors.black:
                                        ProfitLoss_MyPortfolio! > 0?
                                        Colors.green:
                                        Colors.red,
                                        ),),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 10,left: 20,right: 20),
                              child: Divider(color: Colors.grey.shade700,),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 5,bottom: 10),
                              child: ListView.builder(
                                itemCount:MyPortfolio_data.length,
                                shrinkWrap: true,
                                physics:const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index)  {
                                  // final symbol = _symbols[index];
                                  final symbol = MyPortfolio_data[index]['ordertoken'];
                                  final currentPrice_MyPortfolio = _prices[symbol] ?? 0.0;
                                  // previousPrice_MyPortfolio = _previousPrices[symbol] ?? 0.0;
                                  previousPrice_MyPortfolio = Liveprice_last_Myportfolio[index];

                                  // _updatePreviousPrices(symbol, currentPrice_MyPortfolio);

                                  print("Current: $currentPrice_MyPortfolio");
                                  print("Previous: $previousPrice_MyPortfolio");

                                  final priceColor = currentPrice_MyPortfolio > previousPrice_MyPortfolio
                                      ? Colors.green
                                      : currentPrice_MyPortfolio < previousPrice_MyPortfolio
                                      ? Colors.red
                                      : Colors.black;
                                  print("111111");
                                  // CurrentValue= currentPrice * double.parse(Stocks_data[index]['quantity'].toString());
                                  print("2222222");

                                  double valu =
                                  currentPrice_MyPortfolio==0.0||currentPrice_MyPortfolio==0||currentPrice_MyPortfolio==null?
                                  previousPrice_MyPortfolio * double.parse(MyPortfolio_data[index]['totalQuantity'].toString()):
                                  currentPrice_MyPortfolio * double.parse(MyPortfolio_data[index]['totalQuantity'].toString());

                                  CurrentValuee_MyPortfolio[index]= valu;

                                  CurrentValue_MyPortfolio=CurrentValuee_MyPortfolio.reduce((value, element) => value + element);

                                  print("CurrentValueeeeeeeeeee: $CurrentValue_MyPortfolio");
                                  ProfitLoss_MyPortfolio= CurrentValue_MyPortfolio! - InvestmentAmount_MyPortfolio!;
                                  print("Profitloss: $ProfitLoss_MyPortfolio");

                                  return Container(
                                    // height: 130,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(left: 20, right: 20, top: 12,bottom: 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade400, width: 0.3),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.shade50
                                    ),
                                    child: Column(
                                      children: [

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 8, left: 15),
                                              child: Text(
                                                "${MyPortfolio_data[index]['tradesymbol']}",
                                                style:const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Container(
                                              margin:const EdgeInsets.only(right: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 15),
                                                    child:const Text("Qty : ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.grey),),
                                                  ),
                                                  Container(
                                                    child: Text("${MyPortfolio_data[index]['totalQuantity']}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),

                                        Container(
                                          margin:const EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 20),
                                          height: 105,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey,width: 0.01),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                  margin:const EdgeInsets.only(top: 7),
                                                  child: Row(
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [

                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          child: Text("Suggested Price: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                        ),
                                                      ),

                                                      Expanded(
                                                        flex: 2,
                                                        child:Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin:const EdgeInsets.only(left: 8),
                                                          child: Text("${MyPortfolio_data[index]['price']}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: ColorValues.Splash_bg_color1),),

                                                        ) ,
                                                      )

                                                    ],
                                                  )
                                              ),

                                              Container(
                                                  margin:const EdgeInsets.only(left: 40,right: 40),
                                                  child: Divider(color: Colors.grey.shade300,)
                                              ),

                                              Container(
                                                  child: Row(
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          child: Text("Stock Weightage: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin:const EdgeInsets.only(left: 8),
                                                          child: Text("96 %",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: ColorValues.Splash_bg_color1),),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),

                                              Container(
                                                  margin:const EdgeInsets.only(left: 40,right: 40),
                                                  child: Divider(color: Colors.grey.shade300,)
                                              ),

                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 150,
                                                      child: Text("Current Market Price : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                    ),
                                                    Container(
                                                      width: 50,
                                                      alignment: Alignment.topLeft,
                                                      margin:const EdgeInsets.only(left: 8),
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child:currentPrice=="0.0"||currentPrice=="0"||currentPrice==null||currentPrice==0||currentPrice==0.0?
                                                        Text("₹${previousPrice_MyPortfolio}", style: TextStyle(fontWeight: FontWeight.w600,color:priceColor,fontSize: 12),):
                                                        Text("₹${currentPrice_MyPortfolio}", style: TextStyle(fontWeight: FontWeight.w600,color:priceColor,fontSize: 12),),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Container(
                                        //   margin:const EdgeInsets.only(left: 15,bottom: 12,top: 10),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.start,
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       Container(
                                        //         child:const Text("Comment : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                        //       ),
                                        //       Container(
                                        //         width: MediaQuery.of(context).size.width/1.58,
                                        //         child: Text("${Stocks_data[index]['comment']}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade600),),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),


                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
                  ):
                  loader_MyPortfolio=="false"?
                  Container(
                    child: Center(child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,)),
                  ) :
                  Container(
                    child:const Center(
                      child: Text("No Record Found.."),
                    ),
                  )
                ],
              ),
            ),

          ],
        ):

        Column(
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
                    colors: [ColorValues.Splash_bg_color3, ColorValues.Splash_bg_color1],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                tabs:  <Widget>  [
                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Baskets'),
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
                  loader=="true"?
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20,bottom: 50),
                        child: Column(
                          children: [

                            Container(
                              margin:const EdgeInsets.only(top: 5,left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Investment Amount :",style: TextStyle(fontSize: 13),),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("₹${InvestmentAmount!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                      )
                                    ],
                                  ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Current Value :",style: TextStyle(fontSize: 13),),
                                      ),

                                      CurrentValue==0.0?
                                      SizedBox(height: 25):
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("₹${CurrentValue!.toStringAsFixed(2)}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(left: 20,right: 20),
                              child: Divider(color: Colors.grey.shade300,),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 3,left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:const Text("Profit / Loss :",style: TextStyle(fontSize: 13),),
                                      ),
                                      CurrentValue==0.0?
                                      SizedBox(height: 25):
                                      // Container(
                                      //   margin:const EdgeInsets.only(top: 2),
                                      //   child:const Text("0.0",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color:
                                      //   Colors.black
                                      //   ),),
                                      // ):
                                      Container(
                                        margin:const EdgeInsets.only(top: 2),
                                        child: Text("${ProfitLoss!.toStringAsFixed(2)}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color:
                                        ProfitLoss==0?
                                        Colors.black:
                                        ProfitLoss! > 0?
                                        Colors.green:
                                        Colors.red,
                                        ),),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 10,left: 20,right: 20),
                              child: Divider(color: Colors.grey.shade700,),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 5,bottom: 10),
                              child: ListView.builder(
                                itemCount:Stocks_data.length,
                                shrinkWrap: true,
                                physics:const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index)  {
                                  final symbol = _symbols[index];
                                  currentPrice = _prices[symbol] ?? 0.0;
                                  // previousPrice = _previousPrices[symbol] ?? 0.0;
                                  previousPrice = Liveprice_last[index];

                                  // _updatePreviousPrices(symbol, previousPrice);

                                  print("Current: $currentPrice");
                                  print("Previous: $previousPrice");

                                  final priceColor = currentPrice > previousPrice
                                      ? Colors.green
                                      : currentPrice < previousPrice
                                      ? Colors.red
                                      : Colors.black;
                                  print("111111");
                                  // CurrentValue= currentPrice * double.parse(Stocks_data[index]['quantity'].toString());
                                  print("2222222");

                                  double value =
                                  currentPrice==0.0||currentPrice==0||currentPrice==null?
                                  previousPrice * double.parse(Stocks_data[index]['quantity'].toString()):
                                  currentPrice * double.parse(Stocks_data[index]['quantity'].toString());

                                  CurrentValuee[index]= value;

                                  print("value ==== $value");
                                  print("value ==== $CurrentValuee");


                                    CurrentValue=CurrentValuee.reduce((value, element) => value + element);
                                    print("CurrentValueeeeeeeeeee: $CurrentValue");
                                    ProfitLoss= CurrentValue! - InvestmentAmount!;

                                    print("Profitloss: $ProfitLoss");




                                  return Container(
                                    // height: 130,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(left: 20, right: 20, top: 12,bottom: 8),
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
                                              margin: const EdgeInsets.only(top: 8, left: 15),
                                              child: Text(
                                                "${Stocks_data[index]['name']}",
                                                style:const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Container(
                                              margin:const EdgeInsets.only(right: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 15),
                                                    child:const Text("Qty : ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.grey),),
                                                  ),
                                                  Container(
                                                    child: Text("${Stocks_data[index]['quantity']}",style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),

                                        Container(
                                          margin:const EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 20),
                                          height: 105,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey,width: 0.01),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                  margin:const EdgeInsets.only(top: 7),
                                                  child: Row(
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [

                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          child: Text("Suggested Price: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                        ),
                                                      ),

                                                      Expanded(
                                                        flex: 2,
                                                        child:Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin:const EdgeInsets.only(left: 8),
                                                          child: Text("${Stocks_data[index]['price']}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: ColorValues.Splash_bg_color1),),

                                                        ) ,
                                                      )

                                                    ],
                                                  )
                                              ),

                                              Container(
                                                  margin:const EdgeInsets.only(left: 40,right: 40),
                                                  child: Divider(color: Colors.grey.shade300,)
                                              ),

                                              Container(
                                                  child: Row(
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          child: Text("Stock Weightage: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin:const EdgeInsets.only(left: 8),
                                                          child: Text("${Stocks_data[index]['weightage']} %",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: ColorValues.Splash_bg_color1),),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),

                                              Container(
                                                  margin:const EdgeInsets.only(left: 40,right: 40),
                                                  child: Divider(color: Colors.grey.shade300,)
                                              ),

                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 150,
                                                      child: Text("Current Market Price : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                    ),
                                                    Container(
                                                      width: 50,
                                                      alignment: Alignment.topLeft,
                                                      margin:const EdgeInsets.only(left: 8),
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: currentPrice==0.0||currentPrice==0||currentPrice==null?
                                                        Text("₹${previousPrice}",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1,fontSize: 12),):
                                                        Text("₹${currentPrice}", style: TextStyle(fontWeight: FontWeight.w600,color:priceColor,fontSize: 12),),
                                                      ),
                                                    )
                                                  ],
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
                          ],
                        )),
                  ):
                  loader=="false"?
                  Container(
                    child: Center(child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,)),
                  ) :
                  Container(
                    child:const Center(
                      child: Text("No Record Found.."),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),

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
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
                                    margin: const EdgeInsets.only(left: 20, top: 10),
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
                                        }
                                    },
                                    child: Container(
                                      height: 25,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.green, width: 0.2)),
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
                                _tabController.index==1?
                                "₹$Investment_amount":
                                "₹$Investment_amount",
                                // "₹$Investment_amount",
                                style:const TextStyle(
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
                              columns:const <DataColumn> [
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
                                              style:const TextStyle(fontSize: 12),
                                            ))),


                                    DataCell(Container(
                                        child: Text("₹${dataList[index]['lpPrice']}",style:const TextStyle(fontSize: 12),)
                                    )),


                                    DataCell(Container(
                                      child: Text(
                                        '${dataList[index]['quantity']}',
                                        style:const TextStyle(fontSize: 12,color: Colors.green),
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
                         :
                       Container(
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

}
