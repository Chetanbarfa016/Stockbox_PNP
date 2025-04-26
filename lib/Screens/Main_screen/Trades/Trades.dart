import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Global_widgets/Logout.dart';
import 'package:stock_box/Screens/Main_screen/Trades/Trades_new.dart';
import 'package:stock_box/Screens/Onboarding_screen/Splash_screen.dart';

class Trades extends StatefulWidget {
  int? indexchange;
  int? Segment;
   Trades({Key? key,required this.indexchange,required this.Segment}) : super(key: key);

  @override
  State<Trades> createState() => _TradesState(indexchange:indexchange,Segment:Segment);
}

class _TradesState extends State<Trades> with SingleTickerProviderStateMixin {
  int? indexchange;
  int? Segment;
  _TradesState({
    required this.indexchange,
    required this.Segment
});
  late TabController _tabController;
  List<Widget> _tabs = [];
  List<Widget> _tabViews = [];
  bool loder = false;

  funnction() async {
    var response = await http.get(
      Uri.parse(Util.SignalTabs_Api),
    );
    print(response.body);
    var jsonString = jsonDecode(response.body);
    print("Jsonnnnn: $jsonString");

    for (int i = 0; i < jsonString['data'].length; i++) {
      _tabs.add(Tab(text: jsonString['data'][i]['title'],));

      String Samiti = jsonString['data'][i]['_id'];
      String Tab_name = jsonString['data'][i]['title'];
      print("Samiti: $Samiti");

      _tabViews.add(TradesNew(Samiti: Samiti,Tab_name:Tab_name, indexchange: indexchange,));
    }

    // Initialize the TabController after creating all tabs
    _tabController = TabController(length: _tabs.length, vsync: this,initialIndex:Segment!);

    setState(() {
      loder = true;
    });
  }

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

  String? Delete_status;
  String? Active_status;
  getAccountStatus() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    Delete_status= prefs.getString("Delete_status");
    Active_status= prefs.getString("Active_status");

    Delete_status=="1"|| Active_status=="0"?
    handleLogout(context):
    print("Account not deleted");
  }

  @override
  void initState() {
    super.initState();
    checkToken_Api();
    getAccountStatus();
    funnction();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool show = false;

  @override
  Widget build(BuildContext context) {
    return loder==true ?
      DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
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
          title:const Text("Trades",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
          bottom: TabBar(
            // isScrollable: true,
            unselectedLabelColor: Colors.grey,
            indicatorColor: ColorValues.Splash_bg_color2,
            labelColor: Colors.black,
            labelStyle:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
            tabs: _tabs,
            controller: _tabController,
          ),
        ),

        body: TabBarView(
        controller: _tabController,
        children: _tabViews,
      ),

      ),
    ):

    Scaffold(
            body: Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorValues.Splash_bg_color1,
                ),
              ),
            ),
    );
  }
}
