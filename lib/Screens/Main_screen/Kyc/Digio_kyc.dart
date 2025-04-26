import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kyc_workflow/digio_config.dart';
import 'package:kyc_workflow/environment.dart';
import 'package:kyc_workflow/gateway_event.dart';
import 'package:kyc_workflow/kyc_workflow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Kyc/Webview_signature.dart';

class Digio_kyc extends StatefulWidget {
  String? K_id;
  String? G_id;
  String? Customer_identifier;
  int? amount;
  String? planId;
  String? clientid;
  double? discount;
  String? couponCode;
  String? type;
  String? Inv_amount;

  Digio_kyc(
      {Key? key, required this.K_id, required this.G_id, required this.Customer_identifier,required this.amount,required this.planId,required this.clientid,required this.discount,required this.couponCode,required this.type,required this.Inv_amount})
      : super(key: key);

  @override
  State<Digio_kyc> createState() => _Digio_kycState(K_id: K_id, G_id: G_id, Customer_identifier: Customer_identifier,amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount:Inv_amount);
}

class _Digio_kycState extends State<Digio_kyc> {

  int? amount;
  String? planId;
  String? clientid;
  double? discount;
  String? couponCode;
  String? type;
  String? Inv_amount;

  String? K_id;
  String? G_id;
  String? Customer_identifier;

  _Digio_kycState({
    required this.K_id,
    required this.G_id,
    required this.Customer_identifier,
    required this.amount,
    required this.planId,
    required this.clientid,
    required this.discount,
    required this.couponCode,
    required this.type,
    required this.Inv_amount
  });

   String? _workflowResult ='';
   bool? loader=true;

  Future<void> startKycWorkflow() async {
     setState(() {
       loader=false;
     });
    var workflowResult;

    try {

      var digioConfig = DigioConfig();

      digioConfig.theme.primaryColor = "#32a83a";

      digioConfig.logo =

      "https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png";

      digioConfig.environment = Environment.PRODUCTION;

      final _kycWorkflowPlugin = KycWorkflow(digioConfig);

      _kycWorkflowPlugin.setGatewayEventListener((GatewayEvent? gatewayEvent) {

        print("gateway funnel event" + gatewayEvent.toString());

      });

      workflowResult = await _kycWorkflowPlugin.start(
          "$K_id",
          "$Customer_identifier",
          "$G_id",
          null
      );

      print('workflowResult : ' + workflowResult.toString());
      // print('jsnstring2222 == ${workflowResult[0]['message'].toString()}');
      var jsnstring = workflowResult.toString();

      print('jsnstring == ${jsnstring}');

      // if(jsnstring['message']=='User cancelled before completion.'){
      //   Navigator.pop(context);
      //   print('Kkkkkkkkkkkkkk');
      // }

      Digio_signature();

    } on PlatformException {

      workflowResult = 'Failed to get platform version.';

      print("1111111111111");
      print("2222222222222 : $workflowResult");

    }

    if (!mounted) return;
    setState(() {
      _workflowResult = workflowResult.toString();
    });

  }

  // Future permissionCheck() async {
  //
  //   var permissionStatus = await Permission.storage.status;
  //
  //   await Permission.camera.request();
  //
  //   // await Permission.audio.request();
  //
  //   // await Permission.manageExternalStorage.request();
  //
  //   // await Permission.accessMediaLocation.request();
  //
  //   // await Permission.backgroundRefresh.request();
  //
  //   await Permission.location.request();
  //
  //   // await Permission.mediaLibrary.request();
  //
  //   // await Permission.microphone.request();
  //
  //   // await Permission.systemAlertWindow.request();
  //
  //   // await Permission.videos.request();
  //
  //
  //   // if (!permissionStatus.isGranted) {
  //   //
  //   //   await Permission.storage.request();
  //   //
  //   // }
  //
  //   permissionStatus = await Permission.storage.status;
  //
  //   if (permissionStatus.isGranted) {
  //
  //     print("jjjjjjjjjjjjjjjjj");
  //
  //   } else {
  //
  //     openAppSettings();
  //
  //   }
  //
  // }

   var redirectUrl;
   bool? Status;

  Digio_signature() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? Id_Login = prefs.getString('Login_id');
    print("Hello1");
    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/uploaddocument"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              "id":"$Id_Login",
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn123456: $jsonString");


    Status=jsonString['status'];

    if(Status==true){
      setState(() {

      });
      redirectUrl= jsonString['redirectUrl'];
      Navigator.push(context, MaterialPageRoute(builder: (context)=> WebView_signature(redirectUrl:redirectUrl,amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type, Inv_amount:Inv_amount,)));
    }

    else{
      if(jsonString['error']=="Error uploading document to Digio"){
        print("11111118888888888");
        int count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 1;
        });
        // Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard()));
      }
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // permissionCheck();
    startKycWorkflow();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 60,
      //   titleSpacing: 0,
      //   backgroundColor: Colors.grey.shade200,
      //   elevation: 0.5,
      //   leading: GestureDetector(
      //       onTap: (){
      //         Navigator.pop(context);
      //       },
      //       child:const Icon(Icons.arrow_back,color: Colors.black,)
      //   ),
      //   title:const Text("Kyc",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      // ),
      //   body:loader==true?
      //      const Center(
      //         child: CircularProgressIndicator(color: Colors.black,)
      //       ):
      //   Container(
      //     width: MediaQuery.of(context).size.width,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //
      //       children: [
      //
      //         GestureDetector(
      //             onTap: () {
      //               setState(() {
      //                 startKycWorkflow();
      //                 loader=false;
      //               });
      //             },
      //             child: Container(
      //               height: 35,
      //                 width: 90,
      //                 alignment: Alignment.center,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(7),
      //                   color: ColorValues.Splash_bg_color1
      //                 ),
      //                 child: Text("refresh",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),))),
      //
      //       ],
      //
      //     ),
      //   ),
      body: Center(
        child: CircularProgressIndicator(color: Colors.black,),
      ),
    );
  }
}
