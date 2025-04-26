import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Global_widgets/Logout.dart';
import 'package:stock_box/Screens/Main_screen/Blogs.dart';
import 'package:stock_box/Screens/Main_screen/News.dart';
import 'package:stock_box/Screens/Onboarding_screen/Splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Browse extends StatefulWidget {
  const Browse({Key? key}) : super(key: key);

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {

  String removeHtmlTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // var Data=[];
  // bool? Status;
  // bool loader=false;
  // List<String> time1=[];
  // List entryTime1=[];
  // Blogs_Api() async {
  //   var data = await API.Blogs_Api(1);
  //   setState(() {
  //     Status = data['status'];
  //   });
  //
  //   print("Statussss: $Status");
  //
  //   if(Status==true){
  //     setState(() {});
  //     Data = data['data'];
  //
  //     for(int i=0; i<Data.length; i++){
  //       time1.add(Data[i]['created_at']);
  //       entryTime1 = time1.map((dateTimeString1) {
  //         DateTime dateTime1 = DateTime.parse(dateTimeString1);
  //         return DateFormat('d MMM, yyyy HH:mm').format(dateTime1);
  //       }).toList();
  //     }
  //
  //     loader=true;
  //   }
  //
  //   else{
  //     print("error");
  //   }
  // }

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

  int _page = 1;
  String? loader = "false";
  var Data;
  bool? Status;
  List<String> time1=[];
  List entryTime1=[];

  void _firstLoad() async {
    setState(() {
      loader = "false";
      _page = 1;
    });

    try {
      var data = await API.Blogs_Api(_page);
      setState(() {
        // _posts = data["productdata"]["allEquipment"]['data'];
        Data = data['data'];

        for(int i=0; i<Data.length; i++){
          time1.add(Data[i]['created_at']);
          entryTime1 = time1.map((dateTimeString1) {
            DateTime dateTime1 = DateTime.parse(dateTimeString1);
            DateTime istTime = dateTime1.add(Duration(hours: 5, minutes: 30));
            return DateFormat('d MMM, yyyy HH:mm').format(istTime);
          }).toList();
        }
        Data.length>0?
        loader = "true":
        loader = "No_data";
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
      var data = await API.Blogs_Api(_page);
      Product = data['data'];

      if (Product.isNotEmpty) {
        setState(() {
          Data.addAll(Product);
          for(int i=0; i<Data.length; i++){
            time1.add(Data[i]['created_at']);
            entryTime1 = time1.map((dateTimeString1) {
              DateTime dateTime1 = DateTime.parse(dateTimeString1);
              DateTime istTime = dateTime1.add(const Duration(hours: 5, minutes: 30));
              return DateFormat('d MMM, yyyy HH:mm').format(istTime);
            }).toList();
          }

          Data.length>0?
          loader = "true":
          loader = "No_data";
        });
      } else {

        setState(() {
          data_loder =false;
          _hasNextPage = false;
        });
        var snackBar = SnackBar(
            backgroundColor: ColorValues.Splash_bg_color1,
            content: Text("You have seen all blogs.",
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



  int _page_news = 1;
  String? loader1 = "false";
  var News;
  bool? Status_news;
  List<String> time=[];
  List entryTime=[];

  void _firstLoad_news() async {
    setState(() {
      loader1 = "false";
      _page = 1;
    });

    try {
      var data = await API.News_Api(_page);
      setState(() {
        // _posts = data["productdata"]["allEquipment"]['data'];
        News = data['data'];

        for(int i=0; i<News.length; i++){
          time.add(News[i]['created_at']);
          entryTime = time.map((dateTimeString) {
            DateTime dateTime = DateTime.parse(dateTimeString);
            DateTime istTime = dateTime.add(Duration(hours: 5, minutes: 30));
            return DateFormat('d MMM, HH:mm').format(istTime);
          }).toList();
        }
        News.length>0?
        loader1 = "true":
        loader1 = "No_data";
      });
    }
    catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
        setState(() {
          loader1 = "No_data";
        });
      }
    }
  }

  bool _isLoadMoreRunning_news = false;
  var Product_news=[];
  bool _hasNextPage_news = false;
  bool data_loder_news = true;

  void _loadMore_news(_page) async {

    setState(() {
      _isLoadMoreRunning = true;
    });



    try {
      var data = await API.News_Api(_page);
      Product = data['data'];

      if (Product.isNotEmpty) {
        setState(() {
          News.addAll(Product);
          for(int i=0; i<News.length; i++){
            time.add(News[i]['created_at']);
            entryTime = time.map((dateTimeString) {
              DateTime dateTime = DateTime.parse(dateTimeString);
              DateTime istTime = dateTime.add(const Duration(hours: 5, minutes: 30));
              return DateFormat('d MMM, HH:mm').format(istTime);
            }).toList();
          }

          loader1 = "true";
        });
      } else {

        setState(() {
          data_loder =false;
          _hasNextPage = false;
        });
        var snackBar = SnackBar(
            backgroundColor: ColorValues.Splash_bg_color1,
            content:const Text("You have seen all blogs.",
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


  String? Delete_status;
  String? Active_status;
  // getAccountStatus() async {
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   Delete_status= prefs.getString("Delete_status");
  //   Active_status= prefs.getString("Active_status");
  //
  //   Delete_status=="1"||Active_status=="0"?
  //   handleLogout(context):
  //   print("Account not deleted");
  // }

  var Data_profile;
  bool? Status_profile;
  String? Delete_status_profile;
  String? Active_status_profile;
  bool loader_profile=false;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken_Api();
    // getAccountStatus();
    Profile_Api();
    // Blogs_Api();
    // News_Api();
    _firstLoad();
    _firstLoad_news();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.grey.shade100,
      body: RefreshIndicator(
        onRefresh: () async{
          setState(() {
           Profile_Api();
          });
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
               const SizedBox(height: 42,),

                Container(
                  margin:const EdgeInsets.only(left: 20,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child:const Text("Blogs",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Blogs()));
                        },
                        child: Row(
                          children: [
                            Container(
                              child:const Text("View all",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black),),
                            ),

                            Container(
                              margin:const EdgeInsets.only(left: 4),
                              child: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade600,size: 12,),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                loader=="true" ?
                Container(
                  child: ListView.builder(
                    physics:const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: Data.length>=5?5: Data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          String? Blogs_image = Data[index]['image'];
                          String? Blogs_title = Data[index]['title'];
                          String? Blogs_desc = Data[index]['description'];

                          Posts_detail(Blogs_image,Blogs_title,Blogs_desc);
                        },
                        child: Container(
                          // height: 165,
                          width: double.infinity,
                          margin:const EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white60
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                width: double.infinity,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration:const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12)
                                    )
                                ),
                                child: Image.network("${Data[index]['image']}",fit: BoxFit.cover),
                              ),

                              Container(
                                alignment: Alignment.topLeft,
                                margin:const EdgeInsets.only(left: 10,right: 10,top: 8),
                                child: Text("${Data[index]['title']}",maxLines: 2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Colors.grey.shade800,height: 1.4),),
                              ),

                              Container(
                                alignment: Alignment.topLeft,
                                margin:const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
                                child: Text("${entryTime1[index]}",style: TextStyle(fontSize: 15,color: Colors.grey.shade500,height: 1.4),),
                              ),

                            ],
                          ),
                        ),
                      );
                    },

                  ),
                ):
                loader=="false"?
                Container(
                  height: MediaQuery.of(context).size.height/2.8,
                  child: Center(
                    child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
                  ),
                ):
                Container(
                  height: MediaQuery.of(context).size.height/2.8,
                  child:const Center(
                      child:Text("No Record Found")
                  ),
                ),

                Container(
                  margin:const EdgeInsets.only(top: 25),
                  child:const Divider(color: Colors.grey,thickness: 0.9),
                ),

                Container(
                  margin:const EdgeInsets.only(left: 20,right: 20,top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child:const Text("News",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Newss()));
                        },
                        child: Row(
                          children: [
                            Container(
                              child:const Text("View all",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black),),
                            ),

                            Container(
                              margin:const EdgeInsets.only(left: 4),
                              child: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade600,size: 12,),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                loader1=="true" ?
                Container(
                  child: ListView.builder(
                    physics:const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:News.length>=5?5: News.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          String? News_image = News[index]['image'];
                          String? News_title = News[index]['title'];
                          String? News_desc =  News[index]['description'];
                          News_detail(News_image,News_title,News_desc);
                        },
                        child: Container(
                          // height: 150,
                          width: double.infinity,
                          margin:const EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white60
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/2,
                                      margin:const EdgeInsets.only(left: 10,top: 10),
                                      child: Text("${News[index]['title']}",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16),),
                                    ),
                                    Container(
                                      margin:const EdgeInsets.only(right: 10,top: 10),
                                      child: Text("${entryTime[index]}",style: TextStyle(fontSize: 14,color: Colors.grey.shade800),),
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                margin:const EdgeInsets.only(bottom: 12,top: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/1.6,
                                      margin:const EdgeInsets.only(left: 10,top: 8,),
                                      child: Text("${removeHtmlTags(News[index]['description'])}",maxLines: 3,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,style: TextStyle(fontSize: 13,color: Colors.grey.shade700,letterSpacing: 0.6,height: 1.3),),
                                    ),

                                    Container(
                                      margin:const EdgeInsets.only(right: 10),
                                      height: 70, width: 70,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Image.network("${News[index]['image']}",fit: BoxFit.fill,),
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },

                  ),
                ):
                loader1=="false"?
                Container(
                  height: MediaQuery.of(context).size.height/2.8,
                  child: Center(
                    child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
                  ),
                ):
                Container(
                  height: MediaQuery.of(context).size.height/2.8,
                  child:const Center(
                      child:Text("No Record Found")
                  ),
                )


              ],
            ),
          ),
        ),
      )

    );
  }

  Posts_detail(Blogs_image,Blogs_title,Blogs_desc){
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

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                // height: 130,
                                width: double.infinity,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                margin:const EdgeInsets.only(left: 20,right: 20,top: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Image.network("$Blogs_image",fit: BoxFit.contain),
                              ),

                              Container(
                                alignment: Alignment.topLeft,
                                margin:const EdgeInsets.only(left: 20,right: 20,top: 10),
                                child: Text("$Blogs_title",maxLines: 2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize: 19,color: Colors.black,height: 1.4),),
                              ),

                              Container(
                                alignment: Alignment.topLeft,
                                margin:const EdgeInsets.only(left: 2,right: 20,top: 20,bottom: 10),
                                child: Html(
                                  data: Blogs_desc,
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
                            ],
                          ),
                        ),
                      )

                      // Container(
                      //   alignment: Alignment.topLeft,
                      //   margin:const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 10),
                      //     child: Text("${removeHtmlTags(Blogs_desc)}",
                      //     style: TextStyle(fontSize: 13,color: Colors.grey.shade700,height: 1.4),),
                      // ),

                    ],
                  ),
              );
            }
        );
      },
    );
  }

  News_detail(News_image,News_title,News_desc){
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

                      Expanded(
                        child:SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                // height: 130,
                                width: double.infinity,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                margin:const EdgeInsets.only(left: 20,right: 20,top: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Image.network("$News_image",fit: BoxFit.contain),
                              ),

                              Container(
                                alignment: Alignment.topLeft,
                                margin:const EdgeInsets.only(left: 20,right: 20,top: 10),
                                child: Text("$News_title",maxLines: 2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize: 19,color: Colors.black,height: 1.4),),
                              ),

                              Container(
                                alignment: Alignment.topLeft,
                                margin:const EdgeInsets.only(left: 2,right: 20,top: 20,bottom: 10),
                                child: Html(
                                  data: News_desc,
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
                                // Html(
                                //   data: News_desc,
                                //   style: {
                                //     "p": Style(fontSize: FontSize.medium),
                                //     "h1": Style(fontSize: FontSize.large, fontWeight: FontWeight.bold),
                                //   },
                                // ),
                              ),
                            ],
                          ),
                        ),
                      )


                      // Container(
                      //   margin:const EdgeInsets.only(left: 20,right: 20,top: 20),
                      //   child: Text("${removeHtmlTags(News_desc)}",
                      //     style: TextStyle(fontSize: 13,color: Colors.grey.shade700,height: 1.4),),
                      // ),

                    ],
                  ),
              );
            }
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
