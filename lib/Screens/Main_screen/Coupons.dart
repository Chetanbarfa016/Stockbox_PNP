import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';

class Coupons extends StatefulWidget {
  const Coupons({Key? key}) : super(key: key);

  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {


  var Coupons;
  bool? Status;
  String loader="false";

  List<String> time=[];
  List expiryTime=[];

  Coupons_Api() async {
    var data = await API.Coupons_Api();
    setState(() {
      Status= data['status'];
    });

    print("Statussss: $Status");
    print("data: $data");

    if(Status==true){

      if(data['data'].length>0){
        Coupons = data['data'];
        for(int i=0; i<Coupons.length; i++){
          time.add(Coupons[i]['enddate']);
          expiryTime = time.map((dateTimeString) {
            DateTime dateTime = DateTime.parse(dateTimeString);
            return DateFormat('dd MMM, yyyy HH:mm').format(dateTime);
          }).toList();
        }
        setState(() {
          loader="true";
        });

      }else{
        setState(() {
          loader="No_DATA";
        });
      }
    }else{
      print("error");
    }
  }

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
        backgroundColor: Colors.black,
        msg: "Copied to clipboard!",
        textColor: Colors.white
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Coupons_Api();
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
        title:const Text("Coupons",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body: loader=="true" ?
      Container(
        margin:const EdgeInsets.only(top: 12),
        child: ListView.builder(
          itemCount: Coupons.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin:const EdgeInsets.only(left: 15,right: 15,bottom: 11,top: 11),
              // height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.2)
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 124,
                        decoration: BoxDecoration(
                          // color: ColorValues.Splash_bg_color1,
                          color: ColorValues.Splash_bg_color1,
                          border: Border.all(color: ColorValues.Splash_bg_color1,),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: RotatedBox(
                          quarterTurns: 3, // Rotates the text 90 degrees counterclockwise
                          child: Text(
                            "${Coupons[index]['serviceName']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14, // Adjust the font size as needed
                            ),
                            textAlign: TextAlign.center, // Center align the text
                            overflow: TextOverflow.ellipsis, // Add ellipsis if it overflows
                            maxLines: 1, // Ensure it is a single line
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/1.3,
                        margin:const EdgeInsets.only(top: 5,left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Image.asset("images/offer.png",height: 30,width: 30,),
                                ),
                                Container(
                                  margin:const EdgeInsets.only(left: 5),
                                  child:const Text("Limited Time Only",
                                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),),
                                ),
                              ],
                            ),

                            // Container(
                            //   margin: EdgeInsets.only(left: 5),
                            //   child: Text("Use code",style: TextStyle(fontSize: 12),),
                            // ),
                            Container(
                              margin:const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text("Use Code :"),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 25,
                                    width: 110,
                                    alignment: Alignment.center,
                                    padding:const EdgeInsets.only(left: 5,right: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(color: ColorValues.Splash_bg_color2,width: 0.5)
                                    ),

                                    child: Text("${Coupons[index]['code']}",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                                  ),

                                  GestureDetector(
                                    onTap: () => copyToClipboard(context, "${Coupons[index]['code']}"),
                                    child: Container(
                                      height: 25,
                                      alignment: Alignment.center,
                                      padding:const EdgeInsets.only(left: 10,right: 8),
                                      margin:const EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color: ColorValues.Splash_bg_color2
                                      ),
                                      child: Icon(Icons.copy,color: Colors.white,size: 15,),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Coupons[index]['type']=="percentage"?
                            Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${Coupons[index]['value']}%",
                                        style: TextStyle(fontSize:16,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                      ),
                                      TextSpan(
                                        text: " Off",
                                        style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                          text: ",  ${Coupons[index]['name']} Offer",
                                          style:const TextStyle(fontSize: 12,letterSpacing: 0.01,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                    ]),),
                            ):
                            Container(
                              margin:const EdgeInsets.only(left: 10,top: 10),
                              child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Save Upto ",
                                        style: TextStyle(fontSize: 12,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: "₹${Coupons[index]['value']}",
                                        style: TextStyle(fontSize:14,letterSpacing: 0.01, color: ColorValues.Splash_bg_color1, fontWeight: FontWeight.w900),
                                      ),
                                      TextSpan(
                                          text: ",  ${Coupons[index]['name']} Offer",
                                          style: TextStyle(fontSize: 12,letterSpacing: 0.01,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                    ]),),
                            ),


                            Container(
                              margin:const EdgeInsets.only(left: 10, top: 5,bottom: 10),
                              child:  RichText(
                                text: TextSpan(
                                    children: [
                                      // TextSpan(
                                      //     text: "*${Coupons[index]['name']}",
                                      //     style: TextStyle(fontSize: 10,letterSpacing: 0.01,fontWeight: FontWeight.bold,color: Colors.black)
                                      // ),
                                      TextSpan(
                                        text: "Minimum Purchase value ",
                                        style: TextStyle(fontSize: 14,letterSpacing: 0.01, color: Colors.black87, fontWeight: FontWeight.w300),),
                                      TextSpan(
                                          text: "₹${Coupons[index]['minpurchasevalue']}",
                                          style: TextStyle(fontSize: 14,letterSpacing: 0.01,fontWeight: FontWeight.w900,color: ColorValues.Splash_bg_color1)),
                                    ]),),

                              /*Text("*${Coupons[index]['name']} offer Minmum Purchase value ₹${Coupons[index]['minpurchasevalue']}",
                                style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black54),),*/
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ):
      loader=="No_DATA"?
      Container(
        alignment: Alignment.center,
        child: Center(
            child: Text("No Record Found.")
            // Image.asset(
            //   "images/notrades.png",
            //   height: 100,
            // )
        ),
      ):
      Container(
        child: Center(
          child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
        ),
      )
    );
  }
}
