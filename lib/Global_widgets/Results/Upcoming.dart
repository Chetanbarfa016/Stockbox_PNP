import 'package:flutter/material.dart';
import 'package:stock_box/Constants/Colors.dart';

class Upcoming_results extends StatefulWidget {
  const Upcoming_results({Key? key}) : super(key: key);

  @override
  State<Upcoming_results> createState() => _Upcoming_resultsState();
}

class _Upcoming_resultsState extends State<Upcoming_results> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin:const EdgeInsets.only(top: 12,bottom: 12,left: 15,right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                     height: 28,
                     width: 60,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(5),
                       gradient:const LinearGradient(
                         begin: Alignment.topRight,
                         end: Alignment.bottomLeft,
                         stops: [
                           0.1,
                           0.5,
                         ],
                         colors: [
                           Color(0xff93A5CF),
                           Color(0xffE4EfE9)
                         ],
                       ),
                     ),
                     alignment: Alignment.center,
                     child:const Text("28 Aug",style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.w600),),
                   ),

                  Container(
                    height: 180,
                    width:MediaQuery.of(context).size.width/1.4,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade500,width: 0.3),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: ListView.builder(
                      itemCount: 3,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Column(
                            children: [
                              Container(
                                // margin:const EdgeInsets.only(top: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Tata_Power_Logo.png/640px-Tata_Power_Logo.png",height: 45,width: 45,),
                                        ),
                                        Container(
                                          margin:const EdgeInsets.only(left: 1,top: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child:const Text("TATA POWER",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 6),
                                                child:const Text("TATA POWER Ltd.",style: TextStyle(fontSize: 10,color: Colors.grey),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Container(
                                      margin:const EdgeInsets.only(right: 5,top: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child:const Text("1,400.35",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 6),
                                            child:const Text("-15.20 (0.10%)",style: TextStyle(fontSize: 10,color: Colors.red),),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey.shade300,)
                            ],
                          ),
                        );
                      },

                    ),
                  )
                ],
              ),
            );
          },

        ),
    );
  }
}
