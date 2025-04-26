import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Basket_broker_response.dart';


class Rebalance_history extends StatefulWidget {
  String? Basket_id;
  String? Investment_amount;
  Rebalance_history({Key? key,required this.Basket_id,required this.Investment_amount}) : super(key: key);

  @override
  State<Rebalance_history> createState() => _Rebalance_historyState(Basket_id:Basket_id,Investment_amount:Investment_amount);
}

class _Rebalance_historyState extends State<Rebalance_history> {
  String? Basket_id;
  String? Investment_amount;
  _Rebalance_historyState({
    required this.Basket_id,
    required this.Investment_amount
  });

  //

  bool loader=false;
  List<Map<String, dynamic>> data=[];
  List<int> sortedVersions=[];
  Map<int, List<Map<String, dynamic>>> groupedData={};
  Future<void> postJsonData() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Iddddd_login = prefs.getString('Login_id');
    final url = Uri.parse('${Util.BASE_URL1}basketstocks/$Basket_id/$Iddddd_login');
    print(url);
    try {
      final response = await http.get(url);

      var jsonString = jsonDecode(response.body);
      print("Jsonnnnnnnnnnn: $jsonString");

      data= List<Map<String, dynamic>>.from(jsonString['data']);
      print("Dataaaaaa: ${data[0]}");

      groupedData = {};
      for (var item in data) {
        int version = item['version'];
        if (!groupedData.containsKey(version)) {
          groupedData[version] = [];
        }
        groupedData[version]!.add(item);
      }
      sortedVersions = groupedData.keys.toList()..sort();
      print("Sorted : $sortedVersions");
      calculateTotalInvestment();
      setState(() {
        loader=true;
      });

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print('Data posted successfully: ${response.body}');
      // } else {
      //   print('Failed to post data. Status code: ${response.statusCode}');
      //   print('Response: ${response.body}');
      // }

    } catch (error) {
      print('Error occurred: $error');
    }
  }

  Map<int, double> versionWiseTotalInvestment = {};
  String? Created_At;

// Calculate the total for each version
  void calculateTotalInvestment() {
    versionWiseTotalInvestment = {};

    for (var version in groupedData.keys) {
      double totalInvestment = 0.0;

      // Iterate over items in the version
      for (var item in groupedData[version]!) {
        double price = double.parse(item['price'].toString());
        double quantity = double.parse(item['quantity'].toString());
        totalInvestment += price * quantity;
      }

      versionWiseTotalInvestment[version] = totalInvestment;
    }

    print("Version-wise Total Investment: $versionWiseTotalInvestment");
  }
  bool? Status_order;
  String? Message_order;
  var Orders=[];
  bool loader_basketversion=false;

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




  // bool? status_checkBasketsell;
  // String? Message_checkBasketsell;
  // var checkBasketsellData=[];
  //
  // CheckBasketsell_Api(version) async {
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   String? Id_logine = prefs.getString('Login_id');
  //   String? Broker_id = prefs.getString('Broker_id');
  //   print("11112222: $Broker_id");
  //   var response = await http.post(
  //     Uri.parse("${Util.Main_BasrUrl}/api/checkbasketsell"),
  //     headers: {
  //       'Content-Type':'application/json'
  //     },
  //     body: jsonEncode({
  //       "basket_id": "$Basket_id",
  //       "clientid": "$Id_logine",
  //       "brokerid": "$Broker_id",
  //       "version": version
  //     }),
  //   );
  //
  //   var jsonString = jsonDecode(response.body);
  //   print("Response JSON: $jsonString");
  //
  //   status_checkBasketsell= jsonString['status'];
  //   Message_checkBasketsell= jsonString['message'];
  //
  //   if(status_checkBasketsell==true){
  //     setState(() {});
  //     checkBasketsellData=jsonString['data'];
  //     print("TTTTTTTTTTTTTTT: $checkBasketsellData");
  //
  //     // Exit_order_popup(checkBasketsellData,version);
  //     print("111111");
  //     // Fluttertoast.showToast(
  //     //     msg: "${Message_checkBasketsell}",
  //     //     backgroundColor: Colors.green,
  //     //     textColor: Colors.white
  //     // );
  //   }
  //   else{
  //     Fluttertoast.showToast(
  //         msg: "${Message_checkBasketsell}",
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white
  //     );
  //   }
  // }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postJsonData();
  }

  String formatDate(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString);
    String formattedDate = DateFormat('d MMM, yyyy').format(parsedDate);
    return formattedDate;
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
          title:const Text("Rebalance History",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
        ),
        body: loader == true ?
        SingleChildScrollView(
          child: Container(
            margin:const EdgeInsets.only(top: 10),
            child: Column(
              children: sortedVersions.map((version) {
                List<Map<String, dynamic>> versionData = groupedData[version]!;
                bool isSingleVersion = sortedVersions.length == 1;
                bool isLastVersion = version == sortedVersions.last;
                bool isSecondLastVersion = sortedVersions.length > 1 && version == sortedVersions[sortedVersions.length - 2];
                return Card(
                  margin:const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
                  elevation: 2,
                  child: ExpansionTile(
                    title:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Investment Amount: ₹${versionWiseTotalInvestment[version]?.toStringAsFixed(2) ?? '0.00'}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                                ),
                                Container(
                                  margin:const EdgeInsets.only(top: 5),
                                  child: Text(versionData.isNotEmpty
                                       ? formatDate(versionData[0]['created_at'] ?? "")
                                       : "Date not available",style:const TextStyle(fontSize: 11,fontWeight: FontWeight.w500),),
                                ),
                              ],
                            ),
                            Orders.length>0?
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_BrokerResponse()));
                              },
                              child: Container(
                                height: 20,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorValues.Splash_bg_color1
                                ),
                                alignment: Alignment.center,
                                child:const Text("Broker Response",style: TextStyle(fontSize: 7,color: Colors.white),),
                              ),
                            )
                            : SizedBox()

                          ],
                        ),
                      ],
                    ),

                    children: [
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Orders.length>0?
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
                          ],
                        ),
                      ):
                      SizedBox(),

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
                                DataColumn(label: Text('Weightage',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                                DataColumn(label: Text('Qty.',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                              ],

                              rows: versionData.map((item) {

                                return DataRow(
                                  cells: [
                                    DataCell(Text(item['name'] ?? '',style:const TextStyle(fontSize: 12),)),
                                    DataCell(Text('₹${item['price']}',style:const TextStyle(fontSize: 12),)),
                                    DataCell(Text('${item['weightage']}%',style:const TextStyle(fontSize: 12),)),
                                    DataCell(Text('${item['quantity']}',style:const TextStyle(fontSize: 12),)),
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

                    ],
                  ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ):

        Container(
          child:const Center(child: CircularProgressIndicator(color: Colors.black,)),
        )

    );
  }


  TextEditingController MinInvAmt =TextEditingController();

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

}

