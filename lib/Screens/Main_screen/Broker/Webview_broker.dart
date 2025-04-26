import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Dashboard.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebView_broker extends StatefulWidget {
  var Url;
  String? Broker_idd;
  String? aliceuser_id;

  WebView_broker({required this.Url,required this.Broker_idd,required this.aliceuser_id});

  @override
  State<WebView_broker> createState() =>
      _WebView_brokerState(Url:Url,Broker_idd:Broker_idd,aliceuser_id:aliceuser_id);
}

class _WebView_brokerState extends State<WebView_broker> {
  var Url;
  String? Broker_idd;
  String? aliceuser_id;
  bool apiCalled = false;

  _WebView_brokerState({
    required this.Url,
    required this.Broker_idd,
    required this.aliceuser_id,
  });

  late final WebViewController controller;

  var loadingPercentage = 0;

  var Data;
  bool? Status;
  String? TradingStatus_client;
  bool? loader= false;
  Profile_Api() async {
    var data = await API.Profile_Api();
    setState(() {
      Data = data['data'];
      Status = data['status'];
    });

    print("Dataaaaaa: $Data");

    if(Status==true){
      setState(() {});
      TradingStatus_client=Data['tradingstatus'].toString();

      print("TradingStatus_client: $TradingStatus_client");
      loader=true;
    }
    else{}
  }


  @override
  void initState() {
    super.initState();
    Profile_Api();
    print("Urllllll333333: $Url");

    controller = WebViewController()
      ..loadRequest(
        Uri.parse('$Url'),
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

          onPageFinished: (String url) async {
            SharedPreferences prefs= await SharedPreferences.getInstance();
            String? Id_Login = prefs.getString('Login_id');
            String? AliceUser_id = prefs.getString('AliceUser_id');
            String? Broker_id = prefs.getString('Broker_id');
            String? Email_client = prefs.getString('Email');
            setState(() {
              loadingPercentage = 100;
            });
            debugPrint('Page finished loading: $url');


            RegExp regExp = RegExp(r'key=([a-zA-Z0-9]+)');
            var match = regExp.firstMatch(url);
            String key='';
            if (match != null) {
              key = match.group(1)!;
              print("Extracted keyyyyyyyyyyyyyyyyyyyyyyyyy: $key");
            } else {
              print("Key not found in URL");
            }

            Uri uri = Uri.parse(url);
            String? email_Upstox = uri.queryParameters['state'];
            String? upstoxurlEmail;
            // if (email_Upstox != null) {
            //   // Email extract karna
            //   RegExp emailRegex = RegExp(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}");
            //   Match? match1 = emailRegex.firstMatch(email_Upstox);
            //
            //
            //   if (match1 != null) {
            //     print("Extracted Email: ${match1.group(0)}");
            //     upstoxurlEmail=match1.group(0);
            //     print("09090909: $upstoxurlEmail");
            //   } else {
            //     print("No valid email found in state");
            //   }
            // } else {
            //   print("State parameter not found");
            // }

            if (email_Upstox != null) {
              // 1. Decode percent-encoded characters
              String decodedState = Uri.decodeComponent(email_Upstox);

              // 2. Replace space with '+' (only if needed)
              decodedState = decodedState.replaceAll(' ', '+');

              print("Decoded & Fixed State: $decodedState");

              // 3. Email regex pattern
              RegExp emailRegex = RegExp(r"[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}");
              Match? match = emailRegex.firstMatch(decodedState);

              if (match != null) {
                upstoxurlEmail = match.group(0);
                print("✅ Extracted Email: $upstoxurlEmail");
              } else {
                print("❌ No valid email found in state");
              }
            } else {
              print("⚠️ State parameter not found in the URL");
            }
            String? userId_url = uri.queryParameters['userId'];
            String? key_Zerodha = uri.queryParameters['key'];

            String email_zerodha = Uri.decodeComponent(key_Zerodha==null?"":key_Zerodha);
            print("Extracted Email: $email_zerodha");
            // print("UpStox Email: $email_Upstox");
            print("Client Email: $Email_client");


            // print('Login Idddddddddddddd: $Id_Login');
            // print('Brokerrrr Idddddddddd: $Broker_id');
            //
            // print('User IDDDDDDDDDDDDDDD: $userId_url');
            // print('Alice Useridddddddddd: $AliceUser_id');

            String urlll = "${url.toString().split('.in/')[0]}";
            print("url main =============$url");


            if (Id_Login == key && Broker_idd=="1") {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));

            }

            else if (aliceuser_id == userId_url && Broker_idd=="2") {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));

            }

            else if (email_zerodha == Email_client && Broker_idd=="5") {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));

            }

            else if (upstoxurlEmail == Email_client && Broker_idd=="6") {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Broker added successfuly',style: TextStyle(color: Colors.white)),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(popup_data:"false")));

            }

            // else if (upstoxurlEmail == Email_client && Broker_idd=="6" && TradingStatus_client=="0") {
            //
            //   Fluttertoast.showToast(
            //     msg: "Something went wrong.",
            //     textColor: Colors.white,
            //     backgroundColor: Colors.red
            //   );
            //   int count = 0;
            //   Navigator.popUntil(context, (route) {
            //     return count++ == 1;
            //   });
            //
            // }

            else{
              //https://app.rmpro.in
              if(urlll == "${Util.Url_kyc}"){
                Fluttertoast.showToast(
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    msg: "Invalid Api Key"
                );
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 1;
                });
              }
              else{
                print("Hello");
              }
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
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19,color: Colors.black),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 20),
          child: const Icon(Icons.arrow_back_ios,color: Colors.black,),
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
