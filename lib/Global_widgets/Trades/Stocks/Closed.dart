import 'package:flutter/material.dart';
import 'package:stock_box/Constants/Colors.dart';

class Stock_closedtrades extends StatefulWidget {
  const Stock_closedtrades({Key? key}) : super(key: key);

  @override
  State<Stock_closedtrades> createState() => _Stock_closedtradesState();
}

class _Stock_closedtradesState extends State<Stock_closedtrades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:const EdgeInsets.only(top: 15),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin:const EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color:const Color(0x7193a5cf),
              ),

              child: Column(
                children: [
                  Container(
                    margin:const EdgeInsets.only(top: 10,left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              const Icon(Icons.lock_clock,size: 18,),
                              Container(
                                margin:const EdgeInsets.only(left: 10),
                                child:const Text("26 Dec 2024 | 3:26",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600),),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black,width: 0.3),
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          child:const Text("Short term",style: TextStyle(fontSize: 11),),
                        )
                      ],
                    ),
                  ),

                  Container(
                    margin:const EdgeInsets.only(top: 15,left: 15,right: 15),
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin:const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Container(
                                child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Tata_Power_Logo.png/640px-Tata_Power_Logo.png",height: 50,width: 60,),
                              ),
                              Container(
                                margin:const EdgeInsets.only(left: 1,top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child:const Text("TATA POWER",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                        child:Row(
                                          children: [
                                            Container(
                                              child:const Text("₹1365.54",style: TextStyle(fontSize: 11),),
                                            ),

                                            Container(
                                                child:const Icon(Icons.arrow_drop_up,color: Colors.green,)
                                            ),

                                            Container(
                                              child:const Text("67.32(5.45%)",style: TextStyle(fontSize: 11,color: Colors.green),),
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        Container(
                          margin:const EdgeInsets.only(top: 15,left: 15,right: 15),
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.5),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                  margin:const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text("Suggested Entry: ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.only(left: 8),
                                        child: Text("1320.50",style: TextStyle(fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color1),),
                                      )
                                    ],
                                  ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin:const EdgeInsets.only(top: 17,left: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child:const Text("Stoploss:",style: TextStyle(fontSize: 12),),
                                    ),
                                    Container(
                                      margin:const EdgeInsets.only(top: 5),
                                      child:const Text("₹1300.00",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child:const Text("Target:",style: TextStyle(fontSize: 12),),
                                    ),
                                    Container(
                                      margin:const EdgeInsets.only(top: 5),
                                      child:const Text("₹1500.00",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child:const Text("Hold duration:",style: TextStyle(fontSize: 12),),
                                    ),
                                    Container(
                                      margin:const EdgeInsets.only(top: 5),
                                      child:const Text("1-3 months",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        const Spacer(),

                        Container(
                          height: 25,
                          color: Colors.green,
                          alignment: Alignment.center,
                          child:const Text("Closed trade profitably at ₹1400.20",style: TextStyle(fontSize: 11,color: Colors.white),),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin:const EdgeInsets.only(top: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child:const Text("Net gain : "),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.arrow_drop_up,color: Colors.white,size: 15,),
                              Container(
                                child:const Text("1.50%",style: TextStyle(fontSize: 12,color: Colors.white),),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    margin:const EdgeInsets.only(top: 10,left: 15,right: 15),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)
                      ),
                    ),

                    child:Column(
                      children: [
                        Container(
                          margin:const EdgeInsets.only(top: 7),
                          child:const Text("Closed trade in 27 days",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),),
                        ),
                        Container(
                          margin:const EdgeInsets.only(top: 5),
                          child: Text("on 27/08- 01:32 PM at ₹1420.20",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
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
