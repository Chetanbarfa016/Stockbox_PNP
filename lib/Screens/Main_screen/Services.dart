import 'package:flutter/material.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Service_plan.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          toolbarHeight: 60,
          titleSpacing: 0,
          backgroundColor: Colors.grey.shade200,
          elevation: 0,
          leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child:const Icon(Icons.arrow_back,color: Colors.black,)),
          title:const Text("Services",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body: Container(
        margin:const EdgeInsets.only(top: 15),
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              margin:const EdgeInsets.only(left: 27,right: 27,top: 8,bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade500,width: 0.3)
              ),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    margin:const EdgeInsets.only(left: 8,top: 5,bottom: 5),
                    padding:const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black,width: 0.08)
                    ),
                    child: Image.asset("images/gift_refer.png"),
                  ),
                  Container(
                    margin:const EdgeInsets.only(top: 10,left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width/1.9,
                          child:const Text("Testing",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                        ),
                        Row(
                          children: [
                            Container(
                              margin:const EdgeInsets.only(top: 3),
                              child:const Text("Accuracy : ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                            ),
                            Container(
                              margin:const EdgeInsets.only(top: 3),
                              child:const Text("80%",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Subscribe()));
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 25,
                              width: 110,
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
                                  ],
                                ),
                              ),
                              margin:const EdgeInsets.only(top: 8,bottom: 8),
                              child:const Text("Subscribe Now",style: TextStyle(fontSize: 11,color: Colors.white,fontWeight: FontWeight.w600),)
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
    );
  }
}
