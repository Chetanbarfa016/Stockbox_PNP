import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Global_widgets/Logout.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Basket_detail.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Screens/Main_screen/Thankyou.dart';
import 'dart:math';

import 'package:stock_box/Screens/Onboarding_screen/Splash_screen.dart';

class Basket extends StatefulWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;


  var Basket_data;
  var BasketStock_data;
  bool? Status;
  String? Message;
  String? loader= "false";
  var Basket_value;


  bool? Status_token;
  checkToken_Api() async {
    var data = await API.checkToken();
    setState(() {
      Status_token = data['status'];

      print("Status_tokennnnnnnn: $Status_token");
    });

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

  double totalForThisIndex = 0.0;
  double totalForThisIndex_Admin = 0.0;
  List<double> indexWiseTotals = [];
  List<double> indexWiseTotals_Admin = [];

  // Basket_Apiii() async {
  //   print("Helloooooo1111111");
  //   var data = await API.Basket_Api();
  //   setState(() {
  //     Status = data['status'];
  //     Message = data['message'];
  //     print("Statusssss: $Status");
  //   });
  //
  //   if (Status == true) {
  //     setState(() {});
  //     Basket_data = data['data'];
  //     print("Basket data: $Basket_data");
  //
  //     // Initialize a list to store index-wise totals
  //
  //     for (int i = 0; i < Basket_data.length; i++) {
  //       print("11111111");
  //       Map<String, dynamic> nseMap = {
  //         for (var item in NSE_Data) item['SYMBOL']: item['prev_close']
  //       };
  //
  //       totalForThisIndex = 0.0; // To store total for the current index
  //
  //       // Iterate through Signal_data to find matches
  //       for (var signalItem in Basket_data[i]['stock_details']) {
  //         String stock = signalItem['name'];
  //         print("222222: $stock");
  //         if (nseMap.containsKey(stock)) {
  //           double price = nseMap[stock];
  //           double Qty = double.tryParse(signalItem['quantity'].toString()) ?? 0.0;
  //           double price_admin = double.tryParse(signalItem['price'].toString()) ?? 0.0;
  //
  //           if (Qty != 0 || Qty != 0.0) {
  //             double pricequantity_total = price * Qty;
  //             double Adminpricequantity_total = price_admin * Qty;
  //
  //
  //             // Add the total to the current index
  //             totalForThisIndex += pricequantity_total;
  //             totalForThisIndex_Admin += Adminpricequantity_total;
  //
  //
  //             print(
  //                 'Match Found: Stock = $stock, Price = $price, Quantity = $Qty, Price Quantity Total = ${pricequantity_total.toStringAsFixed(2)}');
  //           } else {
  //             print('Quantity value is zero or invalid for Stock = $stock');
  //           }
  //         } else {
  //           print('No Match Found for Stock = $stock');
  //         }
  //       }
  //
  //       Calculate_cagr(totalForThisIndex,totalForThisIndex_Admin);
  //
  //       print("Addddddddddddddddddddddddddddd: $totalForThisIndex_Admin");
  //       print("Not_____Addddddddddddddddddddddddddddd: $totalForThisIndex");
  //
  //       // Store the total for this index in the list
  //       indexWiseTotals.add(totalForThisIndex);
  //       indexWiseTotals_Admin.add(totalForThisIndex_Admin);
  //       print("Total for index $i: ${totalForThisIndex.toStringAsFixed(2)}");
  //     }
  //
  //     // Print the final list of totals
  //     print("Index-wise totals: $indexWiseTotals");
  //
  //     Basket_data.length > 0 ? loader = "true" : loader = "No_data";
  //   } else {
  //     print("error");
  //   }
  // }
  List<double> indexWiseCAGR = [];


  Basket_Apiii() async {
    var data = await API.Basket_Api();
    setState(() {
      Status = data['status'];
      Message = data['message'];
      print("Statusssss: $Status");
    });

    if (Status == true) {
      Basket_data = data['data'];
      print("Basket data: $Basket_data");

      // Initialize lists to store index-wise totals and CAGRs
      // List<double> indexWiseTotals = [];
      // List<double> indexWiseTotals_Admin = [];

      //   for (int i = 0; i < Basket_data.length; i++) {
      //     // print("11111111");
      //     // Map<String, dynamic> nseMap = {
      //     //   for (var item in NSE_Data) item['SYMBOL']: item['prev_close']
      //     // };
      //     //
      //     // double totalForThisIndex = 0.0; // To store total for the current index
      //     // double totalForThisIndex_Admin = 0.0;
      //
      //     // Iterate through Signal_data to find matches
      //   //   for (var signalItem in Basket_data[i]['stock_details']) {
      //   //     String stock = signalItem['name'];
      //   //     print("222222: $stock");
      //   //     if (nseMap.containsKey(stock)) {
      //   //       double price = nseMap[stock];
      //   //       double Qty = double.tryParse(signalItem['quantity'].toString()) ?? 0.0;
      //   //       double price_admin = double.tryParse(signalItem['price'].toString()) ?? 0.0;
      //   //
      //   //       if (Qty != 0 || Qty != 0.0) {
      //   //         double pricequantity_total = price * Qty;
      //   //         double Adminpricequantity_total = price_admin * Qty;
      //   //
      //   //         print("-------------- :$Adminpricequantity_total");
      //   //
      //   //         totalForThisIndex += pricequantity_total;
      //   //         totalForThisIndex_Admin += Adminpricequantity_total;
      //   //
      //   //         print(
      //   //             'Match Found: Stock = $stock, Price = $price, Quantity = $Qty, Price Quantity Total = ${pricequantity_total.toStringAsFixed(2)}');
      //   //       } else {
      //   //         print('Quantity value is zero or invalid for Stock = $stock');
      //   //       }
      //   //     } else {
      //   //       print('No Match Found for Stock = $stock');
      //   //     }
      //   //   }
      //   //    print("111111111111111: $totalForThisIndex");
      //   //    print("222222222222222: $totalForThisIndex_Admin");
      //   //   // Calculate CAGR for this index
      //   //   double cagr = Calculate_cagr(totalForThisIndex, totalForThisIndex_Admin);
      //   //   indexWiseCAGR.add(cagr);
      //   //
      //   //   print("CAGR for index $i: $cagr");
      //   //
      //   //   // Store totals in the respective lists
      //   //   indexWiseTotals.add(totalForThisIndex);
      //   //   indexWiseTotals_Admin.add(totalForThisIndex_Admin);
      //   // }
      //
      //   // setState(() {
      //   //   // Store the calculated values in state variables for UI rendering
      //   //   this.indexWiseTotals = indexWiseTotals;
      //   //   this.indexWiseTotals_Admin = indexWiseTotals_Admin;
      //   //   this.indexWiseCAGR = indexWiseCAGR;
      //   // });
      //
      //   print("Index-wise totals: $indexWiseTotals");
      //   print("Index-wise Admin totals: $indexWiseTotals_Admin");
      //   print("Index-wise CAGR: $indexWiseCAGR");
      //
      // }

      Basket_data.length > 0 ? loader = "true" : loader = "No_data";

    }
    else {
      print("error");
    }
  }


  var Data_profile;
  bool? Status_profile;
  String? Delete_status_profile;
  String? Active_status_profile;
  bool loader_profile=false;

  late TabController _tabController;


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

      Delete_status_profile=="1"||Active_status_profile=="0"?
      handleLogout(context):
      print("Account not deleted");

      loader_profile=true;
    }

    else{
      print("");
    }

  }

  String? Message_coupon;
  double? Discount=0.0;
  double? FinalPrice;
  double? price;

  Future<void> ApplyCoupon_Api(context,setState) async {
    var response = await http.post(Uri.parse(Util.ApplyCoupon_Api),
        body:{
          'code': '${coupon.text}',
          'purchaseValue': '$price',
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
      FinalPrice=double.parse(jsonString['finalPrice'].toString());

      print("FinalPrice: $FinalPrice");
      print("FinalDiscount: $Discount");

      Fluttertoast.showToast(
          msg: "$Message_coupon",
          backgroundColor: Colors.green,
          textColor: Colors.white
      );

      coupon.clear();
      couponfield_show=false;

      // Navigator.pop(context);
    }

    else{
      Fluttertoast.showToast(
          msg: "$Message_coupon",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }

  }

  String removeHtmlTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  int? _expandedIndex=0;

  bool? Status_Purchase;
  String? Message_Purchase;
  var BasketPurchase_data;
  String? loader_purchase="false";

  myBasketPurchase_Api() async {
    print("Helloooooo222222");
    var data = await API.MyBasketPurchase_Api();
    setState(() {
      Status_Purchase = data['status'];
      Message_Purchase = data['message'];
    });

    if (Status_Purchase == true) {
      BasketPurchase_data = data['data'];
      print("Basket purchase data: $BasketPurchase_data");
      BasketPurchase_data.length > 0 ? loader_purchase = "true" : loader_purchase = "No_data";

    }
    else {
      print("error");
    }
  }

  @override
  void initState() {
    super.initState();
    // Calculate_cagr();
    checkToken_Api();
    Basket_Apiii();
    Profile_Api();
    myBasketPurchase_Api();
    _tabController = TabController(length: 2, vsync: this);
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 0,
        backgroundColor: Colors.grey.shade200,
        elevation: 0.5,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child:const Icon(Icons.arrow_back,color: Colors.black,)),
        title:const Text("Portfolio Basket",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),

      body: Container(
        height: MediaQuery.of(context).size.height - 50,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 5, bottom: 10),
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
                        child: Text('All Baskets'),
                      ),
                    ),
                  ),

                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Subscribed'),
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
                  RefreshIndicator(
                      onRefresh: () async{
                        setState(() {
                          Profile_Api();
                        });
                      },
                      child: Container(
                        margin:const EdgeInsets.only(top: 10,bottom: 5),
                        child:ListView.builder(
                          itemCount: Basket_data.length,
                          itemBuilder: (BuildContext context, int index) {
                            String getSinceLaunchText(String startDate) {
                              DateTime createdDate = DateTime.parse(startDate);
                              DateTime oneYearLater = createdDate.add(Duration(days: 365));
                              DateTime now = DateTime.now();

                              print("createdDate = $createdDate");
                              print("oneYearLater = $oneYearLater");
                              return now.isBefore(oneYearLater) ? "Since launch" : "";
                            }
                            return GestureDetector(
                              onTap: (){
                                var BaketDataa=Basket_data[index];
                                var BaketDataa_Stocks=Basket_data[index]['stock_details'];
                                var cagrr=Basket_data[index]['cagr_live']==null?"0":Basket_data[index]['cagr_live'];
                                var cagrorSincelaunch=getSinceLaunchText(Basket_data[index]['created_at']);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Basket_detail(BaketDataa:BaketDataa,BaketDataa_Stocks:BaketDataa_Stocks,cagrr:cagrr,cagrorSincelaunch:cagrorSincelaunch))).then((val)=>Basket_Apiii());
                              },
                              child: Card(
                                elevation: 1,
                                margin:const EdgeInsets.only(top: 10,bottom: 5,left: 15,right: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Container(
                                  // height: 140,
                                  color: Color(0xff6be5e9ec),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Row(
                                        children: [
                                          Container(
                                            margin:const EdgeInsets.only(left: 4),
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.white,
                                              backgroundImage: NetworkImage("${Basket_data[index]['image']}"),
                                            ),
                                          ),
                                          Container(
                                            // height: 140,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width/1.5,
                                                  margin:const EdgeInsets.only(left: 15,top: 7),
                                                  alignment: Alignment.topLeft,
                                                  child: Text("${Basket_data[index]['title']} ( ${Basket_data[index]['themename']} )",style: TextStyle(fontSize: 18,color: ColorValues.Splash_bg_color2,fontWeight: FontWeight.bold),),
                                                ),

                                                Container(
                                                  margin:const EdgeInsets.only(top: 5,left: 15),
                                                  alignment: Alignment.topLeft,
                                                  width: MediaQuery.of(context).size.width/1.5,
                                                  child: Text("${removeHtmlTags(Basket_data[index]['description'])}",maxLines:2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Colors.grey.shade700),),
                                                ),

                                                Container(
                                                  margin:const EdgeInsets.only(top: 7,left: 15),
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text("Minimum Investment : ",style: TextStyle(fontSize: 14,color: Colors.grey.shade700),),
                                                      Text("₹${Basket_data[index]['mininvamount']}",style:const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                                                    ],
                                                  ),
                                                ),

                                                Container(
                                                  margin:const EdgeInsets.only(top: 7,left: 15),
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text("${getSinceLaunchText(Basket_data[index]['created_at'])} : ",style: TextStyle(fontSize: 14,color: Colors.grey.shade700),),

                                                      Basket_data[index]['cagr_live']==null?
                                                      Text("0%",style:const TextStyle(fontWeight: FontWeight.w600),):
                                                      Text("${Basket_data[index]['cagr_live']}%",style:const TextStyle(fontWeight: FontWeight.w600),),
                                                    ],
                                                  ),
                                                ),

                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin:const EdgeInsets.only(top: 10,bottom: 14,left: 15),
                                                        height: 30,
                                                        width: 100,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1)),
                                                        child: Text("${Basket_data[index]['validity']}",style: TextStyle(fontSize: 12,color: ColorValues.Splash_bg_color2,fontWeight: FontWeight.w600),),
                                                      ),
                                                      Container(
                                                        margin:const EdgeInsets.only(top: 10,right: 20,left: 15,bottom: 14),
                                                        height: 30,
                                                        width: 100,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1)),
                                                        child: Text("High Risk",style: TextStyle(fontSize: 12,color: ColorValues.Splash_bg_color2,fontWeight: FontWeight.w600),),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },

                        ),
                      )
                  ):
                  loader=="false"?
                  Container(
                    child: Center(
                      child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
                    ),
                  ):
                  Container(
                    child:const Center(
                        child:Text("No Record Found")
                    ),
                  ),

                  loader_purchase=="true"?
                  RefreshIndicator(
                      onRefresh: () async{
                        setState(() {
                          Profile_Api();
                        });
                      },
                      child: Container(
                        margin:const EdgeInsets.only(top: 10,bottom: 5),
                        child:ListView.builder(
                          itemCount: BasketPurchase_data.length,
                          itemBuilder: (BuildContext context, int index) {
                            String getSinceLaunchText(String startDate) {
                              DateTime createdDate = DateTime.parse(startDate);
                              DateTime oneYearLater = createdDate.add(Duration(days: 365));
                              DateTime now = DateTime.now();

                              print("createdDate = $createdDate");
                              print("oneYearLater = $oneYearLater");
                              return now.isBefore(oneYearLater) ? "Since launch" : "";
                            }
                            return GestureDetector(
                              onTap: (){
                                var BaketDataa_purchase=BasketPurchase_data[index];
                                var BaketDataa_Stocks_purchase=BasketPurchase_data[index]['stock_details'];
                                var cagrr=BasketPurchase_data[index]['cagr_live']==null?"0":BasketPurchase_data[index]['cagr_live'];
                                var cagrorSincelaunch=getSinceLaunchText(BasketPurchase_data[index]['created_at']);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Basket_detail(BaketDataa:BaketDataa_purchase,BaketDataa_Stocks:BaketDataa_Stocks_purchase,cagrr:cagrr,cagrorSincelaunch:cagrorSincelaunch))).then((val)=>myBasketPurchase_Api()());
                              },
                              child: Card(
                                elevation: 1,
                                margin:const EdgeInsets.only(top: 10,bottom: 5,left: 15,right: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Container(
                                  // height: 140,
                                  color: Color(0xfff5faf4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Row(
                                        children: [
                                          Container(
                                            margin:const EdgeInsets.only(left: 4),
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: ColorValues.Splash_bg_color1,
                                              child: Text("${BasketPurchase_data[index]['themename'].substring(0, 1)}",style: TextStyle(color: Colors.white,fontSize: 25),),
                                            ),
                                          ),
                                          Container(
                                            // height: 140,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width/1.5,
                                                  margin:const EdgeInsets.only(left: 15,top: 7),
                                                  alignment: Alignment.topLeft,
                                                  child: Text("${BasketPurchase_data[index]['title']} ( ${BasketPurchase_data[index]['themename']} )",style: TextStyle(fontSize: 18,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.bold),),
                                                ),

                                                Container(
                                                  margin:const EdgeInsets.only(top: 5,left: 15),
                                                  alignment: Alignment.topLeft,
                                                  width: MediaQuery.of(context).size.width/1.5,
                                                  child: Text("${removeHtmlTags(BasketPurchase_data[index]['description'])}",maxLines:2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Colors.grey.shade700),),
                                                ),

                                                Container(
                                                  margin:const EdgeInsets.only(top: 7,left: 15),
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text("Minimum Investment : ",style: TextStyle(fontSize: 14,color: Colors.grey.shade700),),
                                                      Text("₹${BasketPurchase_data[index]['mininvamount']}",style:const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                                                    ],
                                                  ),
                                                ),

                                                Container(
                                                  margin:const EdgeInsets.only(top: 7,left: 15),
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text("${getSinceLaunchText(BasketPurchase_data[index]['created_at'])} : ",style: TextStyle(fontSize: 14,color: Colors.grey.shade700),),

                                                      BasketPurchase_data[index]['cagr_live']==null?
                                                      Text("0%",style:const TextStyle(fontWeight: FontWeight.w600),):
                                                      Text("${BasketPurchase_data[index]['cagr_live']}%",style:const TextStyle(fontWeight: FontWeight.w600),),
                                                    ],
                                                  ),
                                                ),

                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin:const EdgeInsets.only(top: 10,bottom: 14,left: 15),
                                                        height: 30,
                                                        width: 100,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1)),
                                                        child: Text("${BasketPurchase_data[index]['validity']}",style: TextStyle(fontSize: 12,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600),),
                                                      ),
                                                      Container(
                                                        margin:const EdgeInsets.only(top: 10,right: 20,left: 15,bottom: 14),
                                                        height: 30,
                                                        width: 100,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1)),
                                                        child: Text("Low Risk",style: TextStyle(fontSize: 12,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600),),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },

                        ),
                      )
                  ):
                  loader_purchase=="false"?
                  Container(
                    child: Center(
                      child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
                    ),
                  ):
                  Container(
                    child:const Center(
                        child:Text("No Record Found")
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

  bool? couponfield_show=false;
  SubscribeDetail_popup(Basket_value,price,context,setState){
    print("Discount: $Discount");
    return showModalBottomSheet(
      isScrollControlled:true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return Container(
                  height: MediaQuery.of(context).size.height/2.5,
                  child:Column(
                    children: [
                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                child: Image.asset("images/whistle.png",height: 25,width: 25,)
                            ),
                            Container(
                                margin:const EdgeInsets.only(top: 5,left: 10),
                                child:const Text("Your total savings is of ₹0",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6),)
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin:const EdgeInsets.only(top: 5),
                          child: Divider(color: Colors.grey.shade500,thickness: 0.2,)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin:const EdgeInsets.only(top: 5,left: 20),
                            child:const Text("PR(1 month) :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),

                          ),
                          Container(
                            margin:const EdgeInsets.only(top: 5,right: 20),
                            child: Text("₹$price",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin:const EdgeInsets.only(top: 15,left: 20),
                            child:const Text("Coupon discount :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                          ),

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                couponfield_show=true;
                              });

                            },
                            child: Container(
                              margin:const EdgeInsets.only(top: 15,right: 20),
                              child: Discount==0.0||Discount==null?
                               Text("Apply Coupon",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color2),):
                              Text("$Discount",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color2),),
                            ),
                          ),

                        ],
                      ),

                      couponfield_show == true ?
                      Container(
                        margin:const EdgeInsets.only(top: 25,left: 10,right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width/2,
                              margin:const EdgeInsets.only(left: 15),
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
                                  ApplyCoupon_Api(context,setState);
                                }
                              },

                              child: Container(
                                height: 35,
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
                      ):
                      const SizedBox(height: 0,),

                      Container(
                          margin:const EdgeInsets.only(top: 5),
                          child: Divider(color: Colors.grey.shade500,thickness: 0.2,)
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin:const EdgeInsets.only(top: 4,left: 20),
                            child:const Text("Grand total :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6),),
                          ),

                          FinalPrice==null|| FinalPrice==0.0?
                          Container(
                              margin:const EdgeInsets.only(top: 4,right: 20),
                              child: Text("₹$price",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6,color: Colors.black),)
                          ):

                          Container(
                              margin:const EdgeInsets.only(top: 4,right: 20),
                              child: Text("₹$FinalPrice",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6,color: Colors.black),)
                          )
                        ],
                      ),

                      GestureDetector(
                        onTap: (){
                          // var Basket_valuee=Basket_value!;
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Thankyou()));
                        },
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: MediaQuery.of(context).size.width/1.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1),
                                gradient:const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [
                                    0.1,
                                    0.5,
                                  ],
                                  colors: [
                                    Color(0xff09203F),
                                    Color(0xff09203F),
                                    // Color(0xff537895)
                                  ],
                                ),
                              ),
                              margin:const EdgeInsets.only(top: 25),
                              child:const Text("Subscribe Now",style: TextStyle(fontSize: 11,color: Colors.white,fontWeight: FontWeight.w600),)
                          ),
                        ),
                      ),
                    ],
                  )
              );
            }
        );
      },
    );
  }

  TextEditingController coupon =TextEditingController();
  String _appliedCoupon = '';


}
