import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Blogs.dart';
import 'package:stock_box/Screens/Main_screen/Broadcasts.dart';
import 'package:stock_box/Screens/Main_screen/Coupons.dart';
import 'package:stock_box/Screens/Main_screen/News.dart';
import 'package:stock_box/Screens/Main_screen/Trades/Trades.dart';
import 'package:stock_box/Screens/Main_screen/Wallet.dart';

class Notificationn extends StatefulWidget {
  const Notificationn({Key? key}) : super(key: key);

  @override
  State<Notificationn> createState() => _NotificationnState();
}

class _NotificationnState extends State<Notificationn> {

  int _page = 1;
  String? loader = "false";
  var Notification_data;
  List<String> time1=[];
  List entryTime1=[];
  Set<String> readNotifications = {};

  void _firstLoad() async {
    setState(() {
      loader = "false";
      _page = 1;
    });

    try {
      var data = await API.Notification_Api(_page);
      setState(() {
        Notification_data = data['data'];

        for(int i=0; i<Notification_data.length; i++){
          time1.add(Notification_data[i]['createdAt']);
          entryTime1 = time1.map((dateTimeString1) {
            DateTime dateTime1 = DateTime.parse(dateTimeString1);
            DateTime istTime = dateTime1.add(Duration(hours: 5, minutes: 30));
            return DateFormat('d MMM, yyyy HH:mm').format(istTime);
          }).toList();
        }

        loader = Notification_data.isNotEmpty ? "true" : "No_data";
      });
    }
    catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
        setState(() {
          loader = "No_data";
        });
      }
    }
  }

  bool _isLoadMoreRunning = false;
  var Product=[];
  bool _hasNextPage = false;
  bool data_loder = true;

  void _loadMore(_page) async {
    setState(() {
      _isLoadMoreRunning = true;
    });

    try {
      var data = await API.Notification_Api(_page);
      Product = data['data'];

      if (Product.isNotEmpty) {
        setState(() {
          Notification_data.addAll(Product);

          for(int i=0; i<Notification_data.length; i++){
            time1.add(Notification_data[i]['createdAt']);
            entryTime1 = time1.map((dateTimeString1) {
              DateTime dateTime1 = DateTime.parse(dateTimeString1);
              return DateFormat('d MMM, yyyy HH:mm').format(dateTime1);
            }).toList();
          }

          loader = "true";
        });
      } else {

        setState(() {
          data_loder =false;
          _hasNextPage = false;
        });
        var snackBar = SnackBar(
            backgroundColor: ColorValues.Splash_bg_color1,
            content: Text("You have seen all notifications.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),)
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong!');
      }
    }


    setState(() {
      _isLoadMoreRunning = false;
    });
  }


  void _markAsRead(String _id) {
    setState(() {
      readNotifications.add(_id);
    });
    _saveReadNotifications();
  }

  Future<void> _loadReadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final readList = prefs.getStringList('readNotifications') ?? [];
    setState(() {
      readNotifications = readList.toSet();
    });
  }

  Future<void> _saveReadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('readNotifications', readNotifications.toList());
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstLoad();
    _loadReadNotifications();
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
            child:const Icon(Icons.arrow_back,color: Colors.black,)),
        title:const Text("Notifications",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),

      body: loader=="true"?
      Container(
        margin:const EdgeInsets.only(top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemCount: Notification_data.length,
                shrinkWrap: true,
                physics:const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var notification = Notification_data[index];
                  final isRead = readNotifications.contains(notification['_id']);

                  // print("Read notification count : ${readNotifications.length}");
                  // print("All count : ${Notification_data.length}");

                  // int Unread_count = Notification_data.length - readNotifications.length;
                  // print("Unread_count : $Unread_count");

                  return GestureDetector(
                    onTap: (){

                      if (notification['_id'] != null) {
                        _markAsRead(notification['_id']);
                      } else {
                        print("Notification ID is null");
                      }
                      String? Segment =Notification_data[index]['segmentid'].toString();
                      Notification_data[index]['type']=="open signal"?
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Trades(indexchange: 0,Segment:Segment=="66d2c3bebf7e6dc53ed07626"? 0:Segment=="66dfede64a88602fbbca9b72"? 1: 2))):
                      Notification_data[index]['type']=="close signal"?
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Trades(indexchange: 1,Segment:Segment=="66d2c3bebf7e6dc53ed07626"? 0:Segment=="66dfede64a88602fbbca9b72"? 1: 2))):

                      Notification_data[index]['type']=="add coupon"?
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Coupons())):

                      Notification_data[index]['type']=="add broadcast"?
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Broadcasts())):

                      Notification_data[index]['type']=="add news"?
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Newss())):

                      Notification_data[index]['type']=="payout"?
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Wallet(index_tab: 1,))):

                      Notification_data[index]['type']=="add blog"?
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Blogs())):

                      Notification_data[index]['type']=="add news"?
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Newss())):

                      print("No other routes");

                     },

                    child: Column(
                      children: [
                        Container(
                          margin:const EdgeInsets.only(left: 15,right: 15),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                     width: 50,
                                    margin:const EdgeInsets.only(left: 8,top: 10),
                                    padding:const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: isRead ? Colors.black : ColorValues.Splash_bg_color1,width: 0.08)
                                    ),
                                    alignment: Alignment.center,
                                    child:Text("${Notification_data[index]['type']}",textAlign: TextAlign.center,style: TextStyle(fontSize: 10,color: isRead ? Colors.grey : ColorValues.Splash_bg_color1,),)
                                  ),

                                  Container(
                                    margin:const EdgeInsets.only(top: 8,left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/1.5,
                                          child: Text("${Notification_data[index]['title']}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: isRead ? Colors.grey : Colors.black,),),
                                        ),
                                        Container(
                                          margin:const EdgeInsets.only(top: 3,bottom: 7),
                                          width: MediaQuery.of(context).size.width/1.5,
                                          child: Text("${Notification_data[index]['message']}",
                                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade500),),
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                margin:const EdgeInsets.only(bottom: 8,right: 8),
                                child: Text("${entryTime1[index]}",style: TextStyle(fontSize: 10,color: isRead ? Colors.grey : Colors.black,),),
                              ),
                            ],
                          ),
                        ),
                        Container(child: Divider(color: Colors.grey.shade400,),),
                      ],
                    ),
                  );
                },

              ),

              _isLoadMoreRunning == true ?
              Container(
                height: 40,
                margin:const EdgeInsets.only(top: 15),
                child:const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              ):

              Notification_data.length>5?
              Container(
                margin:const EdgeInsets.only(top: 15,left: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {

                        });
                        _page += 1;
                        _loadMore(_page);
                      },

                      child: Container(
                        height: 35,
                        width: 120,
                        margin:const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: ColorValues.Splash_bg_color1,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child:const Icon(Icons.refresh,size: 18,color: Colors.white,),
                            ),
                            Container(
                                margin:const EdgeInsets.only(left: 5),
                                child:const Text("Load More",style: TextStyle(fontSize: 14,color: Colors.white),)
                            ),
                          ],
                        ),
                      ),

                    )
                  ],
                ),
              ):
              const SizedBox(height: 0,)
            ],
          ),
        ),
      ):
      loader=="false"?
      Container(
        height: MediaQuery.of(context).size.height-150,
        child:const Center(
          child: CircularProgressIndicator(color: Colors.black,),
        ),
      )  :
      Container(
        height: MediaQuery.of(context).size.height-150,
        child:const Center(
            child: Text("No Notification.")
        ),
      ),
    );
  }
}


