import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Kyc/Thanku_kyc.dart';
import 'package:stock_box/Screens/Main_screen/Thankyou.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebView_signature extends StatefulWidget {
  var redirectUrl;
  int? amount;
  String? planId;
  String? clientid;
  double? discount;
  String? couponCode;
  String? type;
  String? Inv_amount;

  WebView_signature({required this.redirectUrl,required this.amount,required this.planId,required this.clientid,required this.discount,required this.couponCode,required this.type,required this.Inv_amount});

  @override
  State<WebView_signature> createState() =>
      _WebView_signatureState(redirectUrl: redirectUrl,amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount:Inv_amount);
}

class _WebView_signatureState extends State<WebView_signature> {
  var redirectUrl;
  int? amount;
  String? planId;
  String? clientid;
  double? discount;
  String? couponCode;
  String? type;
  String? Inv_amount;
  bool apiCalled = false;

  bool status_nav= true;

  _WebView_signatureState({
    required this.redirectUrl,
    required this.amount,
    required this.planId,
    required this.clientid,
    required this.discount,
    required this.couponCode,
    required this.type,
    required this.Inv_amount
  });

  late final WebViewController controller;

  var loadingPercentage = 0;


  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..loadRequest(
        Uri.parse('$redirectUrl'),
      );

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            setState(() {
              loadingPercentage = 0;
            });
          },
          // onPageFinished: (String url) {
          //   setState(() {
          //     loadingPercentage = 100;
          //   });
          //   debugPrint('Page finished loading: $url');
          //
          //   String urlll = "${url.toString().split('.in/')[0]}";
          //   print("url main =============$url");
          //   setState(() {
          //
          //   });
          //   if (urlll == "http://app.rmpro"||urlll == "https://app.rmpro") {
          //     Uri uri = Uri.parse(url);
          //     String? digioDocId = uri.queryParameters['digio_doc_id'];
          //     print("Digio doc idd: $digioDocId");
          //     setState(() {
          //       status_nav==true?
          //       DownloadDocument_Api(digioDocId):
          //       print("one");
          //       status_nav=false;
          //     });
          //
          //   }
          // },
          onPageFinished: (String url) async {
            setState(() {
              loadingPercentage = 100;
            });
            debugPrint('Page finished loading: $url');
            if (url.contains("digio_doc_id") && status_nav == true) {
              Uri uri = Uri.parse(url);
              String? digioDocId = uri.queryParameters['digio_doc_id'];
              print("Digio doc idd: $digioDocId");
              status_nav = false;
              // await DownloadDocument_Api(digioDocId);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Thankyou_kyc(amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,digioDocId:digioDocId,type:type,Inv_amount:Inv_amount)));
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
            Page resource error:
            code: ${error.errorCode}
            description: ${error.description}
            errorType: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
            ''');
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        scrolledUnderElevation: 0,
        titleSpacing: 5,
        backgroundColor: const Color(0xffeff3fc),
        title: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: const Text(
            "Documents",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 20),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              color: Colors.red,
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}


// class _WebView_signatureState extends State<WebView_signature> {
//   var redirectUrl;
//
//   _WebView_signatureState({
//     required this.redirectUrl,
//   });
//
//   late final WebViewController controller;
//
//   var loadingPercentage = 0;
//
//   bool? Status;
//   String? Message;
//   DownloadDocument_Api(digioDocId) async {
//     SharedPreferences prefs= await SharedPreferences.getInstance();
//     String? Id_Login = prefs.getString('Login_id');
//     print("Hello1");
//     var response = await http.post(Uri.parse("http://192.168.0.11:5001/api/client/downloaddocument"),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//
//         body:jsonEncode(
//             {
//               "id":"$Id_Login",
//               "doc_id":"$digioDocId",
//             }
//         )
//     );
//     var jsonString = jsonDecode(response.body);
//     print("Jsnnnnnn: $jsonString");
//
//     Status= jsonString['status'];
//     Message= jsonString['message'];
//
//     if(Status==true){
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(
//       //     content: Text('$Message',
//       //         style: const TextStyle(color: Colors.white)),
//       //     duration: const Duration(seconds: 3),
//       //     backgroundColor: Colors.green,
//       //   ),
//       // );
//
//       Navigator.push(context, MaterialPageRoute(builder: (context)=> Thankyou_kyc()));
//
//
//     }
//     else{
//       print("Error");
//     }
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = WebViewController()
//       ..loadRequest(
//         Uri.parse('$redirectUrl'),
//       );
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//
//             setState(() {
//               loadingPercentage = progress;
//             });
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//
//             setState(() {
//               loadingPercentage = 0;
//             });
//           },
//           onPageFinished: (String url) {
//             setState(() {
//               loadingPercentage = 100;
//             });
//
//             debugPrint('Page finished loading: $url');
//
//             String urlll = "${url.toString().split('.com/')[0]}";
//
//             print("url main =============$url");
//
//
//             if (urlll == "https://stockboxpnp.pnpuniverse") {
//
//               Uri uri = Uri.parse(url);
//
//               // Get the 'digio_doc_id' value
//               String? digioDocId = uri.queryParameters['digio_doc_id'];
//
//               print("Digio doc idd: $digioDocId");
//
//               DownloadDocument_Api(digioDocId);
//             }
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
//
// Page resource error:
//
// code: ${error.errorCode}
//
// description: ${error.description}
//
// errorType: ${error.errorType}
//
// isForMainFrame: ${error.isForMainFrame}
//
// ''');
//           },
//         ),
//       );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 70,
//
//           scrolledUnderElevation: 0,
//
//           titleSpacing: 5,
//
// // elevation: 0,
//
//           backgroundColor: const Color(0xffeff3fc),
//
//           title: Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               child: const Text(
//                 "Documents",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
//               )),
//
//           leading: Container(
//               margin: const EdgeInsets.only(bottom: 10, left: 20),
//               child: const Icon(Icons.arrow_back_ios)),
//         ),
//         body: Stack(
//           children: [
//             WebViewWidget(controller: controller),
//             if (loadingPercentage < 100)
//               LinearProgressIndicator(
//                 color: Colors.red,
//                 value: loadingPercentage / 100.0,
//               ),
//           ],
//         ));
//   }
// }
