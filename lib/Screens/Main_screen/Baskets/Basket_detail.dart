import 'dart:convert';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Basket_payments.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Basket_stocks.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Rebalance.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Constants/Util.dart';
import 'package:http/http.dart' as http;

class Basket_detail extends StatefulWidget {
  var BaketDataa;
  var BaketDataa_Stocks;
  var cagrr;
  var cagrorSincelaunch;
  Basket_detail({Key? key, required this.BaketDataa, required this.BaketDataa_Stocks,required this.cagrr,required this.cagrorSincelaunch}) : super(key: key);

  @override
  State<Basket_detail> createState() => _Basket_detailState(BaketDataa:BaketDataa,BaketDataa_Stocks:BaketDataa_Stocks,cagrr:cagrr,cagrorSincelaunch:cagrorSincelaunch);
}

class _Basket_detailState extends State<Basket_detail> with SingleTickerProviderStateMixin {
  var BaketDataa;
  var BaketDataa_Stocks;
  var cagrr;
  var cagrorSincelaunch;
  _Basket_detailState({
    required this.BaketDataa,
    required this.BaketDataa_Stocks,
    required this.cagrr,
    required this.cagrorSincelaunch
  });
  // late Razorpay _razorpay;

  String? Message_coupon;
  double? Discount=0.0;
  String? FinalPrice='';
  TextEditingController coupon =TextEditingController();
  String _appliedCoupon = '';

  late TabController _tabController;


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

  AddSubscription_Api(PaymentId) async {
    print("Plansssss: $Plans_id");
    SharedPreferences prefs= await SharedPreferences.getInstance();
    Login_idd= prefs.getString("Login_id");

    var response = await http.post(Uri.parse("${Util.BASE_URL1}addbasketsubscription"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              'basket_id': '${BaketDataa['_id']}',
              'client_id': '$Login_idd',
              'price': '${FinalPrice==""||FinalPrice==null? BaketDataa['basket_price'] : FinalPrice}',
              'discount': '$Discount',
              'orderid': '$PaymentId',
              'coupon': '${Discount==0.0||Discount==null?  "" : coupon.text}',
            }
        )
    );

    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnnpayment: $jsonString");

    Statuss=jsonString['status'];
    Messagee=jsonString['message'];

    if(Statuss==true){
      setState(() {

      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Messagee',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_stocks(Basket_id: '${BaketDataa['_id']}',Investment_amount: '${BaketDataa['mininvamount']}',)));
    }

    else {

    }

  }

  var Stocks_data=[];
  bool? Status;
  String? Message;
  String? loader= "false";

  BasketStocks_Api() async {
    var data = await API.BasketStocks_Api(BaketDataa['_id']);
    setState(() {
      Status = data['status'];
      Message = data['message'];
    });

    if(Status==true){
      setState(() {});
      Stocks_data=data['data'];

      print("Stocks_data : $Stocks_data");
      print("Stocks_data length: ${Stocks_data.length}");
      Stocks_data.length>0?
      loader="true":
      loader="No_data";
    }
    else{
      print("error");
    }
  }

  Map<String, double> aggregatedMap = {};
  Map<String, double> resultList = {};

  List<Color> colour_list =[];
  bool loder_graph = true;
  Test(){
    setState(() {});
    List<dynamic> stockDetails = BaketDataa_Stocks;
    for (var stock in stockDetails) {
      String type = stock['type'];
      double weightage = double.parse(stock['weightage'].toString());
      if (aggregatedMap.containsKey(type)) {
        aggregatedMap[type] = aggregatedMap[type]! + weightage;
      } else {
        aggregatedMap[type] = weightage;
      }
    }
    print("Mappppppppppppp: ${aggregatedMap}");
    aggregatedMap.forEach((type, weightage) {
      resultList['$type (${weightage.toStringAsFixed(1)}%)'] = weightage;
    });


    List<String> key_list =aggregatedMap.keys.toList();
    for(int i=0; i<key_list.length; i++){
      colour_list.add(
          key_list[i].toUpperCase()=="LARGE CAP"?Colors.green:
          key_list[i].toUpperCase()=="MID CAP"?Colors.orange:Colors.red
      );
    }

    setState(() {
      loder_graph= false;
    });

    print("Resultttttttttttttttt: $resultList");

  }


  String removeHtmlTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  void initState() {
    Test();

    // TODO: implement initState
    super.initState();
    BasketStocks_Api();
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 1,
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child:const Icon(Icons.arrow_back,color: Colors.black,)
        ),
        title: Text("Basket Detail",style: TextStyle(color: ColorValues.Splash_bg_color2),),
      ),

      bottomSheet: BaketDataa['isSubscribed']==true && BaketDataa['isActive'] == true ?
      Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_stocks(Basket_id: '${BaketDataa['_id']}', Investment_amount: '${BaketDataa['mininvamount']}',)));
          },
          child: Container(
            alignment: Alignment.center,
            height: 42,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.1,
                  0.9,
                ],
                colors: [
                  ColorValues.Splash_bg_color3,
                  ColorValues.Splash_bg_color1,
                  // Color(0xff537895)
                ],
              ),
            ),
            margin:const EdgeInsets.only(left: 25,right: 25,bottom: 20),
            child:const Text("View Detail",
              style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),
          ),
        ),
      ):

      BaketDataa['isSubscribed']==true && BaketDataa['isActive']==false ?
      Container(
          height: 125,
          color: Colors.white,
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Rebalance(Basket_id: '${BaketDataa['_id']}', Investment_amount: '${BaketDataa['mininvamount']}',)));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 42,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                  margin:const EdgeInsets.only(left: 25,right: 25,bottom: 20),
                  child:const Text("View Detail",
                    style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Basket_Payments(BaketDataa:BaketDataa )));
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 42,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                    margin:const EdgeInsets.only(left: 25,right: 25,bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Subscribe Now  ",
                          style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),
                        BaketDataa['full_price']==null||BaketDataa['full_price']==""||BaketDataa['full_price']=="0"||BaketDataa['full_price']==0?
                        const SizedBox(width: 0,):
                        Text("₹${BaketDataa['full_price']}",
                          style:const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough,decorationThickness: 3),
                        ),
                        Text("  ₹${BaketDataa['basket_price']}",
                          style:const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600,),),
                      ],
                    )
                ),
              ),
            ],
          )
      ):

      Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: (){
            // openCheckout();
            Navigator.push(context, MaterialPageRoute(builder: (context) => Basket_Payments(BaketDataa:BaketDataa )));
          },
          child: Container(
              alignment: Alignment.center,
              height: 42,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
              margin:const EdgeInsets.only(left: 25,right: 25,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Subscribe Now  ",
                    style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),

                  BaketDataa['full_price']==null||BaketDataa['full_price']==""||BaketDataa['full_price']=="0"||BaketDataa['full_price']==0?
                  SizedBox(width: 0,):
                  Text("₹${BaketDataa['full_price']}",
                    style:const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough,decorationThickness: 3),
                  ),

                  Text("  ₹${BaketDataa['basket_price']}",
                    style:const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600,),),

                ],
              )
          ),
        ),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                margin:const EdgeInsets.only(top: 15,left: 10),
                child: Row(
                  children: [
                    Container(
                      margin:const EdgeInsets.only(left: 4),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: ColorValues.Splash_bg_color1,
                        backgroundImage: NetworkImage("${BaketDataa['image']}"),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            margin:const EdgeInsets.only(left: 15,top: 3),
                            alignment: Alignment.topLeft,
                            child: Text("${BaketDataa['title']} ( ${BaketDataa['themename']} )",style: TextStyle(fontSize: 18,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.bold),),
                          ),

                          Container(
                            margin:const EdgeInsets.only(top: 5,left: 15),
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width/1.5,
                            child: Text("${removeHtmlTags(BaketDataa['description'])}",maxLines:2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Colors.grey.shade700),),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                margin:const EdgeInsets.only(left: 12,right: 12,top: 10),
                child: Divider(color: Colors.grey.shade400,),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 5, left: 20),
                    child: Text(
                      "Basic Details",
                      style: TextStyle(
                          fontSize: 17,
                          color: ColorValues.Splash_bg_color1,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5, right: 20),
                        child:  Text(
                          "Launch date :",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2,right: 20),
                        child: Text(
                          "${(DateFormat('dd MMM, yyyy').format(DateTime.parse(BaketDataa['created_at'])).toString())}",
                          style:const TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),

              Card(
                margin:const EdgeInsets.only(top: 15,left: 15,right: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  // height: 185,
                  color: Color(0xff6be5e9ec),
                  child: Column(
                    children: [
                      Container(
                        margin:const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15, left: 5),
                                  child:  Text(
                                    "Theme :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  width: 190,
                                  margin: const EdgeInsets.only(top: 6,left: 5),
                                  child: Text(
                                    "${BaketDataa['themename']}",
                                    style:const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15, right: 10),
                                  child:  Text(
                                    "$cagrorSincelaunch :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 6,right: 10),
                                  child:
                                  Text(
                                    "$cagrr %",
                                    style:const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),

                      Container(
                        margin:const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15, left: 5),
                                  child:  Text(
                                    "No. of Stocks :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 6,left: 5),
                                  child: Text(
                                    "${Stocks_data.length}",
                                    style:const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15, right: 10),
                                  child:  Text(
                                    "Validity :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 6,right: 10),
                                  child: Text(
                                    "${BaketDataa['validity']}",
                                    style:const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),

                      Container(
                        margin:const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15, left: 5),
                                  child:  Text(
                                    "Rebalance Frequency",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 6,left: 5),
                                  child: Text(
                                    "${BaketDataa['frequency']}",
                                    style:const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15, right: 10),
                                  child:  Text(
                                    "Next Rebalance Date :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 6,right: 10),
                                  child:  Text(
                                    "${BaketDataa['next_rebalance_date']}",
                                    style:const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                                  ),
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

              Container(
                margin:const EdgeInsets.only(left: 12,right: 12,top: 10),
                child: Divider(color: Colors.grey.shade400,),
              ),

              Card(
                margin:const EdgeInsets.only(top: 10,left: 15,right: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding:const EdgeInsets.only(top: 12,bottom: 12),
                  color: Color(0xff6be5e9ec),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin:const EdgeInsets.only(left: 20,right: 25),
                        child:const Text("Minimum Investment Amount :",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        margin:const EdgeInsets.only(top: 4,left: 20,right: 25),
                        child: Text("₹${BaketDataa['mininvamount']}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: ColorValues.Splash_bg_color1),),
                      ),
                    ],
                  ),
                ),
              ),

              BaketDataa_Stocks.length==0 || loder_graph==true?
              const SizedBox(height: 0,):
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    margin:const EdgeInsets.only(right: 20,top: 20),
                    child: PieChart(
                      // key:const ValueKey("10"),
                      // centerWidget: Container(
                      //   child: Container(
                      //     child:const Text(
                      //       "Mid Cap",
                      //       style: TextStyle(
                      //         fontSize: 11,
                      //         color: Colors.black,
                      //         fontWeight: FontWeight.w900,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      dataMap: resultList,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 20,
                      chartRadius: math.min(
                        MediaQuery.of(context).size.width / 3.2, 250,
                      ),
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.left,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: false,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                      ),
                      ringStrokeWidth: 20,
                      colorList: colour_list,
                      baseChartColor: Colors.transparent,
                    ),
                  ),
                ],
              ),


              Container(
                margin:const EdgeInsets.only(left: 12,right: 12,top: 10),
                child: Divider(color: Colors.grey.shade300,),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin:const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Text("Description",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17,color: ColorValues.Splash_bg_color1),),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin:const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Html(
                  data: BaketDataa['description'],
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

              Container(
                margin:const EdgeInsets.only(left: 12,right: 12,top: 10),
                child: Divider(color: Colors.grey.shade300,),
              ),

              BaketDataa['rationale']==null||BaketDataa['rationale']==""?
              SizedBox(height: 0,):
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                child: Column(
                  children: [
                    Container(
                      height: 30,
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
                            colors: [ColorValues.Splash_bg_color1, ColorValues.Splash_bg_color1,],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tabs:  <Widget>  [
                          Tab(
                            child: SizedBox(
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Rationale'),
                              ),
                            ),
                          ),

                          Tab(
                            child: SizedBox(
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Methodology'),
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
                          SingleChildScrollView(
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin:const EdgeInsets.only(top: 5,left: 25,right: 25),
                              child: Html(
                                data: BaketDataa['rationale'],
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

                          SingleChildScrollView(
                            child:Container(
                              alignment: Alignment.topLeft,
                              margin:const EdgeInsets.only(top: 5,left: 25,right: 25),
                              child: Html(
                                data: BaketDataa['methodology'],
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
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height/10),

            ],
          ),
        ),
      ),

    );
  }


  // void openCheckout() async {
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   String? Name= prefs.getString("FullName");
  //   String? Email= prefs.getString("Email");
  //   String? PhoneNo= prefs.getString("PhoneNo");
  //   String? Razorpay_key= prefs.getString("Razorpay_key");
  //   try {
  //     var amount = FinalPrice == null || FinalPrice!.isEmpty
  //         ? (double.parse(BaketDataa['basket_price'].toString()) * 100).toInt()
  //         : (double.parse(FinalPrice!) * 100).toInt();
  //
  //     var options = {
  //       'key': '$Razorpay_key',
  //       'amount': amount, // Ensure the amount is an integer
  //       'name': '$Name',
  //       'description': 'Account Opening Charges',
  //       'retry': {'enabled': true, 'max_count': 1},
  //       'prefill': {'contact': '$PhoneNo', 'email': '$Email'},
  //       'external': {
  //         'wallets': ['paytm']
  //       },
  //     };
  //
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //   }
  // }
  //
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
  //
  //   // String? paymentId = response.paymentId;
  //   //
  //   // String? orderId = response.orderId;
  //   //
  //   // String? signature = response.signature;
  //
  //   // payment_Api(paymentId, orderId, signature, Price_final);
  // }
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   Fluttertoast.showToast(
  //       msg: "Payment cancelled by user",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }
  //
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   Fluttertoast.showToast(
  //       msg: "EXTERNAL_WALLET: " + response.walletName!,
  //       gravity: ToastGravity.CENTER,
  //       toastLength: Toast.LENGTH_SHORT);
  // }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}
