import 'package:flutter/material.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Dashboard.dart';
import 'package:stock_box/Screens/Main_screen/My_subscription.dart';

class Thankyou extends StatefulWidget {
  const Thankyou({Key? key}) : super(key: key);

  @override
  State<Thankyou> createState() => _ThankyouState();
}

class _ThankyouState extends State<Thankyou> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        // int count = 0;
        // Navigator.popUntil(context, (route) {
        //   return count++ == 5;
        // });
        Navigator.push(context, MaterialPageRoute(builder: (context)=> My_subscription(go_home: true)));
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
                // int count = 0;
                // Navigator.popUntil(context, (route) {
                //   return count++ == 2;
                // });
                Navigator.push(context, MaterialPageRoute(builder: (context)=> My_subscription(go_home: true)));
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
                child:const Text("You have successfully subscribed the plan.",style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> My_subscription(go_home: true)));
                  // int count = 0;
                  // Navigator.popUntil(context, (route) {
                  //   return count++ == 5;
                  // });
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
                  child:const Text("View Plans",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }
}
