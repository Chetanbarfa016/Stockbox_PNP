import 'package:flutter/material.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/Basket_stocks.dart';

class Thankyou_basket extends StatefulWidget {
  String? Basket_id;
  String? Investment_amount;
  Thankyou_basket({Key? key, required this.Basket_id,required this.Investment_amount}) : super(key: key);

  @override
  State<Thankyou_basket> createState() => _Thankyou_basketState(Basket_id:Basket_id,Investment_amount:Investment_amount);
}

class _Thankyou_basketState extends State<Thankyou_basket> {
  String? Basket_id;
  String? Investment_amount;
  _Thankyou_basketState({
    required this.Basket_id,
    required this.Investment_amount
  });
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_stocks(Basket_id: '$Basket_id', Investment_amount: '$Investment_amount',)));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          titleSpacing: 0,
          backgroundColor: Colors.grey.shade200,
          elevation: 0.5,
          leading: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_stocks(Basket_id: '$Basket_id', Investment_amount: '$Investment_amount',)));
              },
              child:const Icon(Icons.arrow_back,color: Colors.black,)
          ),
          title:const Text("Thank You",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                child: Image.asset("images/thanku.png",height: 60,color: ColorValues.Splash_bg_color1,),
              ),

              Container(
                child: Text("Thank You",style: TextStyle(fontSize: 20,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600),),
              ),

              Container(
                margin:const EdgeInsets.only(top: 5),
                child:const Text("You have successfully subscribed the basket.",style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Basket_stocks(Basket_id: '$Basket_id', Investment_amount: '$Investment_amount',)));
                },
                child: Container(
                  margin:const EdgeInsets.only(top: 15),
                  width: 140,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorValues.Splash_bg_color1
                  ),
                  alignment: Alignment.center,
                  child:const Text("View Basket",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }
}
