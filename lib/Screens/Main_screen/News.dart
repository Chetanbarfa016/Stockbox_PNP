import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Newss extends StatefulWidget {
  const Newss({Key? key}) : super(key: key);

  @override
  State<Newss> createState() => _NewssState();
}

class _NewssState extends State<Newss> {

  String removeHtmlTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // var News;
  // bool? Status_news;
  // bool loader1=false;
  // List<String> time=[];
  // List entryTime=[];
  // News_Api() async {
  //   var data = await API.News_Api();
  //   setState(() {
  //     Status_news = data['status'];
  //   });
  //
  //   print("Statussss: $Status_news");
  //
  //   if(Status_news==true){
  //     setState(() {});
  //     News = data['data'];
  //     for(int i=0; i<News.length; i++){
  //       time.add(News[i]['created_at']);
  //       entryTime = time.map((dateTimeString) {
  //         DateTime dateTime = DateTime.parse(dateTimeString);
  //         return DateFormat('d MMM, HH:mm').format(dateTime);
  //       }).toList();
  //     }
  //     loader1=true;
  //   }
  //
  //   else{
  //     print("error");
  //   }
  // }



  int _page = 1;
  String? loader1 = "false";
  var News;
  bool? Status_news;
  List<String> time=[];
  List entryTime=[];

  void _firstLoad() async {
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

  bool _isLoadMoreRunning = false;
  var Product=[];
  bool _hasNextPage = false;
  bool data_loder = true;

  void _loadMore(_page) async {

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
              DateTime istTime = dateTime.add(Duration(hours: 5, minutes: 30));
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // News_Api();
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
        title:const Text("News",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body: loader1=="true"?
      Container(
        margin:const EdgeInsets.only(top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics:const NeverScrollableScrollPhysics(),
                itemCount:News.length,
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

              _isLoadMoreRunning==true?
              Container(
                height: 40,
                margin:const EdgeInsets.only(top: 15),
                child:const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),

              ):

              News.length>5?
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
      loader1=="false"?
      const Center(
        child: CircularProgressIndicator(color: Colors.black,),
      ):
      const Center(
        child: Text("No Record Found")
      )
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
