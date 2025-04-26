import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Basket_stocks.dart';
import 'package:stock_box/Screens/Main_screen/Service_plan.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Screens/Main_screen/Thankyou.dart';

class Basket_subscription extends StatefulWidget {
  var BasketDetail;
  Basket_subscription({Key? key, required this.BasketDetail}) : super(key: key);

  @override
  State<Basket_subscription> createState() => _Basket_subscriptionState(BasketDetail:BasketDetail);
}

class _Basket_subscriptionState extends State<Basket_subscription> with SingleTickerProviderStateMixin{
  var BasketDetail;
  _Basket_subscriptionState({
    required this.BasketDetail
});
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;


  // var Basket_data;
  // bool? Status;
  // String? Message;
  // bool loader= false;
  // var Basket_value;
  //
  // Basket_Api() async {
  //   var data = await API.Basket_Api();
  //   setState(() {
  //     Status = data['status'];
  //     Message = data['message'];
  //   });
  //
  //   if(Status==true){
  //     setState(() {});
  //     Basket_data=data['data'];
  //
  //     loader=true;
  //   }
  //
  //   else{
  //     print("error");
  //   }
  // }

  bool? Status;

   BasketSubscription_Api() async {
     SharedPreferences prefs= await SharedPreferences.getInstance();
     String? Id_Login = prefs.getString('Login_id');
    var response = await http.post(Uri.parse("${Util.BASE_URL}addbasketsubscription"),
        body:{
          'basket_id': '${BasketDetail['_id']}',
          'client_id': '$Id_Login',
          'price': '${FinalPrice==null|| FinalPrice==0.0?BasketDetail['price'] : FinalPrice }',
          'discount': '${Discount==0.0||Discount==null? "0": Discount }',
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");
    Status= jsonString['status'];

    if(Status==true){
      setState(() {});
      // var Basket_valuee=BasketDetail['groupedData']!;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Thankyou()));
    }

    else{
      print("Error");
    }


  }


  String? Message_coupon;
  double? Discount=0.0;
  double? FinalPrice;
  double? price;

  Future<void> ApplyCoupon_Api(context,setState) async {
    var response = await http.post(Uri.parse(Util.ApplyCoupon_Api),
        body:{
          'code': '${coupon.text}',
          'purchaseValue': '${BasketDetail['price']}',
        }
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");

    Message_coupon=jsonString['message'];

    print("Message: $Message_coupon");

    if(Message_coupon=="Coupon applied successfully"){
      setState(() {

      });

      Discount=double.parse(jsonString['discount'].toString());
      FinalPrice=double.parse(jsonString['finalPrice'].toString());

      print("FinalPrice: $FinalPrice");
      print("FinalDiscount: $Discount");

      Fluttertoast.showToast(
          msg: "$Message_coupon",
          backgroundColor: Colors.green,
          textColor: Colors.white
      );

      coupon.clear();
      couponfield_show=false;

      // Navigator.pop(context);
    }

    else{
      Fluttertoast.showToast(
          msg: "$Message_coupon",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }
  }



  void _showPopupAfterDelay() async {
    // Add a 2-second delay
    await Future.delayed(Duration(seconds: 1));

    // Show the popup after the delay
    SubscribeDetail_popup(context,setState);
  }


  @override
  void initState() {
    super.initState();
    // Basket_Api();
    _controller = AnimationController(
      duration:const Duration(seconds: 8),
      vsync: this,
    );

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Start the animation
    _controller.forward();
    _showPopupAfterDelay();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          title:const Text("Subscribe Now",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
        ),

        body: Container(
          margin:const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 15),
          // height: 140,
          child: ListView.builder(
            // scrollDirection: Axis.horizontal,
            // shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color:Colors.white,
                margin:const EdgeInsets.only(left: 20,right: 20,top: 12,bottom: 12),
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: ColorValues.Splash_bg_color1,
                      width: 0.2,
                    )
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  width: 140,
                  child: Column(
                    children: [
                      Container(
                          height: 27,
                          width: MediaQuery.of(context).size.width/2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)
                            ),
                            border: Border.all(color: Colors.black,width: 0.1),
                            // gradient:const LinearGradient(
                            //   begin: Alignment.topRight,
                            //   end: Alignment.bottomLeft,
                            //   stops: [
                            //     0.1,
                            //     0.5,
                            //   ],
                            //   colors: [
                            //     // Color(0xff93A5CF),
                            //     Color(0xffE4EfE9),
                            //     Color(0xffE4EfE9)
                            //   ],
                            // ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:const EdgeInsets.only(left: 5,right: 5),
                                child: Icon(Icons.shopping_bag_outlined,size: 15,color: ColorValues.Splash_bg_color1,),
                              ),
                              Container(
                                child: Text("${BasketDetail['title']}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black),),
                              )
                            ],
                          )
                      ),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:const EdgeInsets.only(left: 15,top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child:const Text("Amount : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                  ),
                                  Container(
                                    child: Text("${BasketDetail['price']}",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:const EdgeInsets.only(right: 15,top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child:const Text("Return : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                  ),

                                  BasketDetail['returnpercentage']==null?
                                  Container(
                                    child:const Text("--",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                                  ):
                                  Container(
                                    child: Text("${BasketDetail['returnpercentage']}%",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:const EdgeInsets.only(left: 15,top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child:const Text("Accuracy : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                  ),
                                  Container(
                                    child: Text("${BasketDetail['accuracy']}",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:const EdgeInsets.only(right: 15,top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child:const Text("Holding period : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                  ),
                                  Container(
                                    child: Text("${BasketDetail['holdingperiod']}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                          margin:const EdgeInsets.only(top: 5,left: 15,right: 15),
                          child: Divider(color: Colors.grey.shade500,thickness: 0.1,)
                      ),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child:const Text("Potential left : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                  ),
                                  Container(
                                    child: Text("${BasketDetail['potentialleft']}%",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(right: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child:const Text("Theme : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                  ),
                                  Container(
                                    child: Text("${BasketDetail['themename']}",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(right: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child:const Text("No. of stocks : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                  ),
                                  Container(
                                    child: Text("${BasketDetail['groupedData'].length}",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                          margin:const EdgeInsets.only(top: 5,left: 15,right: 15),
                          child: Divider(color: Colors.grey.shade500,thickness: 0.1,)
                      ),


                      // GestureDetector(
                      //   onTap: (){
                      //     Basket_value=Basket_data[index]['groupedData'];
                      //     price=double.parse(Basket_data[index]['price'].toString());
                      //     // Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_stocks(Basket_value:Basket_value)));
                      //     // SubscribeDetail_popup(Basket_value,price,context,setState);
                      //   },
                      //   child: ScaleTransition(
                      //     scale: _scaleAnimation,
                      //     child: Container(
                      //         alignment: Alignment.center,
                      //         height: 30,
                      //         width: MediaQuery.of(context).size.width/1.8,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(15),
                      //           border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.1),
                      //           gradient:const LinearGradient(
                      //             begin: Alignment.topRight,
                      //             end: Alignment.bottomLeft,
                      //             stops: [
                      //               0.1,
                      //               0.5,
                      //             ],
                      //             colors: [
                      //               Color(0xff09203F),
                      //               Color(0xff09203F),
                      //               // Color(0xff537895)
                      //             ],
                      //           ),
                      //         ),
                      //         margin:const EdgeInsets.only(bottom: 8),
                      //         child:const Text("Subscribe Now",style: TextStyle(fontSize: 11,color: Colors.white,fontWeight: FontWeight.w600),)
                      //     ),
                      //   ),
                      // ),

                    ],
                  ),
                ),
              );
            },
          ),
        )

    );
  }

  bool? couponfield_show=false;
  SubscribeDetail_popup(context,setState){
    print("Discount: $Discount");
    return showModalBottomSheet(
      isScrollControlled:true,
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return Container(
                  height: MediaQuery.of(context).size.height/2.5,
                  child:Column(
                    children: [
                      Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                        child: Image.asset("images/whistle.png",height: 25,width: 25,)
              ),
                            Container(
                                margin:const EdgeInsets.only(top: 5,left: 10),
                                child:const Text("Your total savings is of ₹0",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6),)
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin:const EdgeInsets.only(top: 5),
                          child: Divider(color: Colors.grey.shade500,thickness: 0.2,)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Container(
                            margin:const EdgeInsets.only(top: 5,left: 20),
                            child:const Text("PR(1 month) :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                          ),

                          Container(
                            margin:const EdgeInsets.only(top: 5,right: 20),
                            child: Text("₹${BasketDetail['price']}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                          ),

                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin:const EdgeInsets.only(top: 15,left: 20),
                            child:const Text("Coupon discount :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing: 0.6),),
                          ),

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                couponfield_show=true;
                              });

                            },
                            child: Container(
                              margin:const EdgeInsets.only(top: 15,right: 20),
                              child: Discount==0.0||Discount==null?
                               Text("Apply Coupon",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color2),):
                              Text("$Discount",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: ColorValues.Splash_bg_color2),),
                            ),
                          ),

                        ],
                      ),

                      couponfield_show == true ?
                      Container(
                        margin:const EdgeInsets.only(top: 25,left: 10,right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width/2,
                              margin:const EdgeInsets.only(left: 15),
                              padding:const EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: ColorValues.Splash_bg_color2,
                                    width: 0.3
                                ),
                              ),

                              child: TextFormField(
                                controller: coupon,
                                style:const TextStyle(fontSize: 14),
                                textInputAction: TextInputAction.done,
                                onSaved: (email) {},
                                decoration: const InputDecoration(
                                  hintText: "Enter coupon code",
                                  enabledBorder:InputBorder.none,
                                  border: InputBorder.none,

                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if(coupon.text.trim()==""||coupon.text.trim()==null){
                                  Fluttertoast.showToast(
                                      msg: "Please enter coupon code",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white
                                  );
                                }
                                else{
                                  ApplyCoupon_Api(context,setState);
                                }
                              },

                              child: Container(
                                height: 35,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width/3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.red,width: 0.4),
                                    color: ColorValues.Splash_bg_color1
                                ),
                                child:const Text("Apply",style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ],
                        ),
                      ):
                      const SizedBox(height: 0,),

                      Container(
                          margin:const EdgeInsets.only(top: 5),
                          child: Divider(color: Colors.grey.shade500,thickness: 0.2,)
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin:const EdgeInsets.only(top: 4,left: 20),
                            child:const Text("Grand total :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6),),
                          ),

                          FinalPrice==null|| FinalPrice==0.0?
                          Container(
                              margin:const EdgeInsets.only(top: 4,right: 20),
                              child: Text("₹${BasketDetail['price']}",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6,color: Colors.black),)
                          ):

                          Container(
                              margin:const EdgeInsets.only(top: 4,right: 20),
                              child: Text("$FinalPrice",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.6,color: Colors.black),)
                          )
                        ],
                      ),

                      GestureDetector(
                        onTap: (){
                          BasketSubscription_Api();
                        },
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: MediaQuery.of(context).size.width/1.8,
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
                                    // Color(0xff537895)
                                  ],
                                ),
                              ),
                              margin:const EdgeInsets.only(top: 25),
                              child:const Text("Subscribe Now",style: TextStyle(fontSize: 11,color: Colors.white,fontWeight: FontWeight.w600),)
                          ),
                        ),
                      ),
                    ],
                  )
              );
            }
        );
      },
    );
  }

  TextEditingController coupon =TextEditingController();
  String _appliedCoupon = '';

//
//
// Apply_coupon() async {
//   final result = await showModalBottomSheet(
//     isScrollControlled:true,
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//           builder: (BuildContext ctx, StateSetter setState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SingleChildScrollView(
//                 child: Container(
//                     margin:const EdgeInsets.only(bottom: 20),
//                     // height: MediaQuery.of(context).size.height/5,
//                     child:Column(
//                       children: [
//                         Container(
//                           alignment: Alignment.topLeft,
//                           margin:const EdgeInsets.only(top: 15,left: 15),
//                           child:const Text("Do you have coupon ?",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w500),),
//                         ),
//
//                         Container(
//                           margin:const EdgeInsets.only(top: 25,left: 15,right: 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 height: 40,
//                                 width: MediaQuery.of(context).size.width/2,
//                                 margin:const EdgeInsets.only(left: 15),
//                                 padding:const EdgeInsets.only(left: 15, right: 15),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                       color: ColorValues.Splash_bg_color2,
//                                       width: 0.3
//                                   ),
//                                 ),
//
//                                 child: TextFormField(
//                                   controller: coupon,
//                                   style:const TextStyle(fontSize: 14),
//                                   textInputAction: TextInputAction.done,
//                                   onSaved: (email) {},
//                                   decoration: const InputDecoration(
//                                     hintText: "Enter coupon code",
//                                     enabledBorder:InputBorder.none,
//                                     border: InputBorder.none,
//
//                                   ),
//                                 ),
//                               ),
//
//                               GestureDetector(
//                                 onTap: () async {
//                                   if(coupon.text.trim()==""||coupon.text.trim()==null){
//                                     Fluttertoast.showToast(
//                                         msg: "Please enter coupon code",
//                                         backgroundColor: Colors.red,
//                                         textColor: Colors.white
//                                     );
//                                   }
//                                   else{
//                                     ApplyCoupon_Api(context,setState);
//                                   }
//                                 },
//
//                                 child: Container(
//                                   height: 40,
//                                   alignment: Alignment.center,
//                                   width: MediaQuery.of(context).size.width/3,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(color: Colors.red,width: 0.4),
//                                       color: ColorValues.Splash_bg_color1
//                                   ),
//                                   child:const Text("Apply",style: TextStyle(color: Colors.white),),
//                                 ),
//                               ),
//
//                             ],
//                           ),
//                         )
//                       ],
//                     )
//                 ),
//               ),
//             );
//           }
//       );
//     },
//   );
//   if (result != null && result.isNotEmpty) {
//     setState(() {
//       _appliedCoupon = result;
//     });
//   }
// }

}
