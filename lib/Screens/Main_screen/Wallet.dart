import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';

class Wallet extends StatefulWidget {
  int? index_tab;
   Wallet({Key? key,required this.index_tab}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState(index_tab:index_tab);
}

class _WalletState extends State<Wallet> with SingleTickerProviderStateMixin {
  int? index_tab;
  _WalletState({
    required this.index_tab
});
  late TabController _tabController;
  TextEditingController amount= TextEditingController();
   
  String? Wallet_amount="";
  String? FullName="";
  String? Email="";
  String? First_Letter;
  getAmount() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    Wallet_amount=prefs.getString("Wallet_amount");
    FullName=prefs.getString("FullName");
    Email=prefs.getString("Email");

    List<String> nameParts = FullName!.split(' ');
    First_Letter = nameParts.map((word) => word[0].toUpperCase()).join('');
    setState(() {});
  }

  bool? Status;
  String? Message;
  RequestPayout_Api() async {
    var data = await API.Request_payout_Api(amount.text);
    setState(() {
      Status = data['status'];
      Message = data['message'];
    });

    if(Status==true){
      setState(() {

      });

      Navigator.pop(context);
      amount.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Profile_Api();
      ReferEarn_Api();
      PayoutHistory_Apii();
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
      amount.clear();
    }

  }


  bool? Status1;
  String? Message1;
  var ReferEarnData=[];
  List<String> time=[];
  List entryTime=[];
  ReferEarn_Api() async {
    setState(() {
      ReferEarnData=[];
    });
    var data = await API.ReferandEarn_Api();
    setState(() {
      Status1 = data['status'];
      Message1 = data['message'];
    });

    if(Status1==true){
      setState(() {});

      ReferEarnData=data['data'];

      for(int i=0; i<ReferEarnData.length; i++){
        time.add(ReferEarnData[i]['created_at']);
        entryTime = time.map((dateTimeString) {
          DateTime dateTime = DateTime.parse(dateTimeString);
          return DateFormat('d MMM, yyyy').format(dateTime);
        }).toList();
      }
      print("DDDDD: $ReferEarnData");
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message1',style: TextStyle(color: Colors.white)),
          duration:Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool? Status2;
  String? Message2;
  var PayoutHistoryData=[];
  List<String> time1=[];
  List entryTime1=[];
  PayoutHistory_Apii() async {
    setState(() {
      PayoutHistoryData=[];
      time1=[];
      entryTime1=[];
    });
    var data = await API.PayoutHistory_Api();
    setState(() {
      Status2 = data['status'];
      Message2 = data['message'];
    });

    if(Status2==true){
      setState(() {});

      PayoutHistoryData=data['data'];

      for(int i=0; i<PayoutHistoryData.length; i++){
        time1.add(PayoutHistoryData[i]['created_at']);
        entryTime1 = time1.map((dateTimeString) {
          DateTime dateTime1 = DateTime.parse(dateTimeString);
          return DateFormat('d MMM, yyyy').format(dateTime1);
        }).toList();
      }
      print("DDDDD: $PayoutHistoryData");
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message2',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }

  }


  var Profile_data;
  String? Namee;
  String? Emaill;
  String? Phonee_no;
  String? firstLetter='';
  String? Wallett_amount='';
  bool loader=false;
  bool? Statuss;

  Profile_Api() async {
    setState(() {
      Profile_data=[];
      loader=false;
    });
    var data = await API.Profile_Api();
    setState(() {
      Statuss = data['status'];
    });
    print("Status: $Statuss");

    if(Statuss==true){
      setState(() {});
      Profile_data = data['data'];
      print("1111111: $Profile_data");
      Namee=Profile_data['FullName'];
      Emaill=Profile_data['Email'];
      Phonee_no=Profile_data['PhoneNo'];

      firstLetter = Namee!.isNotEmpty ? Namee!.toUpperCase() : '';
      Wallett_amount=Profile_data['wamount'].toStringAsFixed(2);
      print("Amoun: $Wallett_amount");
      loader=true;
    }

    else{
      print("error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAmount();
    ReferEarn_Api();
    PayoutHistory_Apii();
    Profile_Api();
    _tabController = TabController(length: 2, vsync: this,initialIndex: index_tab!);
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
        title:const Text("Wallet",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                margin:const EdgeInsets.only(left: 25,right: 25,top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.2)
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin:const EdgeInsets.only(top: 15,left: 15),
                          child: CircleAvatar(
                            backgroundColor: ColorValues.Splash_bg_color1,
                            radius: 22,
                            child: Text("$First_Letter",style:const TextStyle(color: Colors.white),),
                          ),
                        ),

                        Container(
                          margin:const EdgeInsets.only(left: 10,top: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("$FullName",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                              ),
                              Container(
                                child: Text("$Email",style: TextStyle(fontSize: 13,color: Colors.grey.shade600),),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                    Container(
                      margin:const EdgeInsets.only(left: 7,right: 7,top: 8),
                      child: Divider(
                        color: Colors.grey.shade600,
                        thickness: 0.2,
                      ),
                    ),
          
                    Container(
                      margin:const EdgeInsets.only(left: 15),
                      alignment: Alignment.topLeft,
                      child: Text("Balance :",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.grey.shade600,letterSpacing: 0.5),),
                    ),
          
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:const EdgeInsets.only(left: 15,top: 2),
                          alignment: Alignment.topLeft,
                          child: Text("₹$Wallett_amount",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: ColorValues.Splash_bg_color1,letterSpacing: 0.9),),
                        ),
          
                        GestureDetector(
                          onTap: (){
                            Withdraw_popup();
                          },
                          child: Container(
                            margin:const EdgeInsets.only(right: 20),
                            height: 25,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [
                                  0.1,
                                  0.7,
                                ],
                                colors: [
                                  ColorValues.Splash_bg_color1,
                                  ColorValues.Splash_bg_color3,
                                ],
                              ),
                            ),
                            alignment: Alignment.center,
                            child:const Text("Withdraw",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600,color: Colors.white),),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
          
              Container(
                alignment: Alignment.topLeft,
                margin:const EdgeInsets.only(top: 25,left: 25),
                child:const Text("History",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),),
              ),
          
              Container(
              height: MediaQuery.of(context).size.height - 350,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 5, bottom: 25),
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
                        gradient:  LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [ColorValues.Splash_bg_color3, ColorValues.Splash_bg_color1,],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tabs:  <Widget>  [
                        Tab(
                          child: SizedBox(
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Earnings'),
                            ),
                          ),
                        ),
          
                        Tab(
                          child: SizedBox(
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Payouts'),
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

                        ReferEarnData.length>0?
                        Container(
                          margin:const EdgeInsets.only(top: 20,left: 25,right: 25),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                  columnSpacing: 20,
                                  headingRowHeight: 50,
                                  headingRowColor: MaterialStateColor.resolveWith(
                                        (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered)) {
                                        return ColorValues.Splash_bg_color1.withOpacity(
                                            0.5); // Color when hovered
                                      }

                                      return ColorValues
                                          .Splash_bg_color1; // Default color
                                    },
                                  ),
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text('Name',
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                    ),
                                    DataColumn(
                                      label: Text('Earning Amt.',
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                    ),
                                    DataColumn(
                                      label: Text('Status',
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                    ),
                                    DataColumn(

                                      label: Text('Date',
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                    ),

                                  ],

                                  rows:
                                  List<DataRow>.generate(
                                      ReferEarnData.length, (index) {

                                    return DataRow(
                                        color: MaterialStateColor.resolveWith(
                                                (Set<MaterialState> states) {
                                              return Colors.white; // Default color
                                            }),
                                        cells: <DataCell>[
                                          DataCell(
                                              Container(
                                              child: Text(
                                                '${ReferEarnData[index]['clientName']}',
                                                style:const TextStyle(fontSize: 10),
                                              ))),


                                          DataCell(Container(
                                              child:Text("${ReferEarnData[index]['amountType']['amount']}")
                                          )),


                                          DataCell(Container(
                                              child:ReferEarnData[index]['status']==1?
                                              Text(
                                                'Completed',
                                                style: TextStyle(fontSize: 10,color: Colors.green),
                                              ):
                                              Text(
                                                'Pending',
                                                style: TextStyle(fontSize: 10,color: Colors.red),
                                              ),
                                          )
                                          ),


                                          DataCell(Container(
                                              child: Text(
                                                '${entryTime[index]}',
                                                style: TextStyle(fontSize: 10,color: Colors.black),
                                              )
                                          )),

                                        ]
                                    );

                                  }))),
                        ):
                        Container(
                          child:const Center(child: Text("No Record Found")),
                        ),


                        PayoutHistoryData.length>0?
                        Container(
                          margin:const EdgeInsets.only(top: 20,left: 25,right: 25),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                  columnSpacing: 20,
                                  headingRowHeight: 50,
                                  headingRowColor: MaterialStateColor.resolveWith(
                                        (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered)) {
                                        return ColorValues.Splash_bg_color1.withOpacity(
                                            0.5); // Color when hovered
                                      }

                                      return ColorValues
                                          .Splash_bg_color1; // Default color
                                    },
                                  ),
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text('Price',
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                    ),
                                    DataColumn(
                                      label: Text('Transaction',
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                    ),
                                    DataColumn(
                                      label: Text('Status',
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                    ),

                                    DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                    ),

                                  ],

                                  rows:
                                  List<DataRow>.generate(
                                      PayoutHistoryData.length, (index) {

                                    return DataRow(
                                        color: MaterialStateColor.resolveWith(
                                                (Set<MaterialState> states) {
                                              return Colors.white; // Default color
                                            }),
                                        cells: <DataCell>[

                                          DataCell(Container(
                                              child:Text("₹${PayoutHistoryData[index]['amount']}")
                                          )
                                        ),


                                          DataCell(Container(
                                              child:PayoutHistoryData[index]['status']==0?
                                               const Icon(Icons.pending,color: Colors.orange,):
                                               PayoutHistoryData[index]['status']==1?
                                               const Icon(Icons.approval,color: Colors.green,):
                                               const Icon(Icons.clear,color: Colors.red,)
                                            )
                                          ),


                                          DataCell(Container(
                                              child: PayoutHistoryData[index]['status']==0?
                                              const Text(
                                                'Pending',
                                                style: TextStyle(fontSize: 10,color: Colors.orange),):
                                              PayoutHistoryData[index]['status']==1?
                                             const Text(
                                                'Approved',
                                                style: TextStyle(fontSize: 10,color: Colors.green),):

                                              const Text(
                                                'Rejected',
                                                style: TextStyle(fontSize: 10,color: Colors.red),)
                                          )),

                                          DataCell(Container(
                                              child: Text(
                                                '${entryTime1[index]}',
                                                style:const TextStyle(fontSize: 10),
                                              ))),

                                        ]
                                    );

                                  }))),
                        ):
                        Container(
                              child:const Center(child: Text("No Record Found")),
                            )
                      ],
                    ),
                  ),

                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Withdraw_popup() {
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
                              'Withdraw',
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
                        scrollDirection: Axis.vertical,
                        child: Form(
                          child: Column(
                            children: [
                              const Divider(
                                color: Colors.black,
                              ),

                              Container(
                                margin:const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                   const Text("Available Balance : "),
                                   Text("₹${Wallett_amount}",style:const TextStyle(fontWeight: FontWeight.w600),)
                                  ],
                                ),
                              ),

                              Container(
                                height: 45,
                                margin: const EdgeInsets.only(
                                  top: 25,
                                ),
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: ColorValues.Splash_bg_color2,
                                      width: 0.3),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: amount,
                                  textInputAction: TextInputAction.done,
                                  // cursorColor: kPrimaryColor,
                                  onSaved: (email) {},
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(fontSize: 12),
                                      hintText: "Enter Amount",
                                      enabledBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.currency_rupee,
                                        size: 20,
                                      ),
                                      contentPadding: EdgeInsets.only(top: 6)),
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  RequestPayout_Api();
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    // width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(
                                        top: 32, left: 5, right: 5),
                                    padding: const EdgeInsets.only(left: 10),
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorValues.Splash_bg_color1),
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }) ??
        false;
  }
}
