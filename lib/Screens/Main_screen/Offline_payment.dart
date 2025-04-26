import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_box/Constants/Colors.dart';

import '../../Api/Apis.dart';

class Offline_payment extends StatefulWidget {
  const Offline_payment({Key? key}) : super(key: key);

  @override
  State<Offline_payment> createState() => _Offline_paymentState();
}

class _Offline_paymentState extends State<Offline_payment> {


  var Qrcodes_data=[];
  bool? Status;
  bool loader=false;

  Qrcodes_Api() async {
    var data = await API.Qrcodes_Api();
    setState(() {
      Status= data['status'];
    });

    print("Statussss: $Status");
    print("data: $data");

    if(Status==true){
      Qrcodes_data = data['data'];

        setState(() {
          loader=true;
        });

    }else{
      print("error");
    }
  }

  var Bank_data=[];
  bool? Status_bank;
  bool loadebank=false;

  BankDetails_Api() async {
    var data = await API.BankDetails_Api();
    setState(() {
      Status_bank= data['status'];
    });

    print("Statussss: $Status");
    print("data: $data");

    if(Status_bank==true){
      Bank_data = data['data'];

      setState(() {
        loadebank=true;
      });

    }
    else{
      print("error");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Qrcodes_Api();
    BankDetails_Api();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 0,
        backgroundColor: Colors.grey.shade200,
        elevation: 0.5,
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              // ExtraOff_popup();
              Navigator.pop(context);
            },
            child:const Icon(Icons.arrow_back,color: Colors.black,)
        ),
        title:const Text("Offline Payment",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body:
      // loader==false && loadebank ==false?
      //    const Center(
      //       child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
      //     ):
      Container(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Qrcodes_data.length> 0?
              Container(
                height: 35,
                width: double.infinity,
                alignment: Alignment.center,
                color: ColorValues.Splash_bg_color1,
                margin:const EdgeInsets.only(top: 20,left: 20,right: 20),
                child:const Text("Qr Codes",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),),
              ):
              const SizedBox(height: 0,),

              Qrcodes_data.length> 0?
              const SizedBox(height: 0,):
              Container(
                child: ListView.builder(
                  physics:const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Qrcodes_data.length,
                  itemBuilder: (BuildContext context, int index) { 
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin:const EdgeInsets.only(left: 25,right: 25,top: 12,bottom: 12),
                      child: Container(
                        // height: 200,
                        child: Image.network("${Qrcodes_data[index]['image']}",fit: BoxFit.fill,),
                      ),
                    );
                  },
                  
                ),
              ),


              loadebank==false?
              const SizedBox(height: 0,):
              Container(
                height: 35,
                color: ColorValues.Splash_bg_color1,
                alignment: Alignment.center,
                margin:const EdgeInsets.only(top: 20,left: 20,right: 20),
                child:const Text("Bank Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
              ),

             const SizedBox(height: 10,),

              loadebank==false?
              const SizedBox(height: 0,):
              Container(
                child: ListView.builder(
                  physics:const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Bank_data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin:const EdgeInsets.only(left: 25,right: 25,top: 12,bottom: 12),
                      child: Container(
                        // height: 250,
                        margin:const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                margin:const EdgeInsets.only(top: 10),
                                child: Image.network("${Bank_data[index]['image']}",height: 50,width: 140,),
                              ),
                            Divider(color: Colors.grey.shade600,),


                            Container(
                              margin:const EdgeInsets.only(top: 5,left: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    child:const Text('NAME : ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width/2.2,
                                    child: Text('${Bank_data[index]['name']}',style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  )
                                ],
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 3),
                                child: Divider(color: Colors.grey.shade300,)
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 3,left: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    child:const Text('BRANCH :  ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width/2.2,
                                    child: Text('${Bank_data[index]['branch']}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                margin:const EdgeInsets.only(top: 3),
                                child: Divider(color: Colors.grey.shade300,)),

                            Container(
                              margin:const EdgeInsets.only(top: 3,left: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    child:const Text('ACCOUNT NO :  ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width/2.2,
                                    child: Text('${Bank_data[index]['accountno']}',style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                margin:const EdgeInsets.only(top: 3),
                                child: Divider(color: Colors.grey.shade300,)),

                            Container(
                              margin:const EdgeInsets.only(top: 3,left: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    child:const Text('IFSC CODE :  ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width/2.2,
                                    child: Text('${Bank_data[index]['ifsc']}',style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  )
                                ],
                              ),
                            ),

                            // Container(
                            //     margin: EdgeInsets.only(top: 3),
                            //     child: Divider(color: Colors.grey.shade300,)),

                            // Container(
                            //   margin:const EdgeInsets.only(top: 3,left: 20),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Container(
                            //         width: 120,
                            //         child:const Text('ACCOUNT TYPE :  ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                            //       ),
                            //
                            //       Container(
                            //         width: MediaQuery.of(context).size.width/2.2,
                            //         child: Text('${Bank_data[index]['type']}',style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                            //       )
                            //     ],
                            //   ),
                            // )

                          ],
                        )
                      ),
                    );
                  },

                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }

}
