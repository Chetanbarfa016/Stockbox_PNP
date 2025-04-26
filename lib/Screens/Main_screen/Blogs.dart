import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Blogs extends StatefulWidget {
  const Blogs({Key? key}) : super(key: key);

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {

  String removeHtmlTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
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
              DateTime istTime = dateTime1.add(Duration(hours: 5, minutes: 30));
              return DateFormat('d MMM, yyyy HH:mm').format(istTime);
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
  


  // var Data;
  // bool? Status;
  //  bool loader=false;
  // List<String> time1=[];
  // List entryTime1=[];
  // Blogs_Api() async {
  //   var data = await API.Blogs_Api();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Blogs_Api();
    _firstLoad();
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
        title:const Text("Blogs",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body:loader=="true"?
      Container(
        margin:const EdgeInsets.only(top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              ListView.builder(
                shrinkWrap: true,
                itemCount: Data.length,
                physics: NeverScrollableScrollPhysics(),
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
              
              
              _isLoadMoreRunning==true?
              Container(
                height: 40,
                margin:const EdgeInsets.only(top: 15),
                child:const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
          
              ):
          
              Data.length>5?
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
      const Center(
        child: CircularProgressIndicator(color: Colors.black,),
      ):
      const Center(
        child: Text("No Record Found")
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
                      const SizedBox(height: 45),

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
                                child: Text("$Blogs_title",maxLines: 2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 19,color: Colors.black,height: 1.4),),
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
