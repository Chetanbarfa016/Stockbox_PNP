// import 'dart:async';
// import 'package:app_links/app_links.dart';
// import 'package:flutter/material.dart';
// import 'package:stock_box/Api/Apis.dart';
// import 'package:stock_box/Constants/Colors.dart';
// import 'package:stock_box/Screens/Onboarding_screen/Login.dart';
// import 'package:stock_box/Screens/Onboarding_screen/Signup.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class Intro extends StatefulWidget {
//   bool? showOnboarding;
//   Intro({Key? key,this.showOnboarding}) : super(key: key);
//
//   @override
//   State<Intro> createState() => _IntroState(showOnboarding:showOnboarding);
// }
//
// class _IntroState extends State<Intro> {
//   bool? showOnboarding;
//   _IntroState({
//     this.showOnboarding
// });
//   late AppLinks _appLinks;
//   StreamSubscription<Uri>? _linkSubscription;
//   final _navigatorKey = GlobalKey<NavigatorState>();
//
//   Future<void> initDeepLinks() async {
//     print("1111117878");
//     _appLinks = AppLinks();
//
//     // Handle links
//     _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
//       debugPrint('onAppLink: $uri');
//       print("44444: $uri");
//       openAppLink(uri);
//     });
//   }
//
//   void openAppLink(Uri uri) async {
//     String? referralCode = uri.queryParameters['ref'];
//     print("referralCode : $referralCode");
//
//     _navigatorKey.currentState?.pushNamed(uri.fragment);
//     Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Signup(referralCode: referralCode,))
//     );
//   }
//
//
//   var BasicSettingData=[];
//   String? Logo='';
//   String? Name='';
//   bool loader=false;
//   BasicSetting_Apii() async {
//     var data = await API.BesicSetting_Api();
//     print("Data11111: $data");
//     if(data['status']==true){
//       setState(() {
//         Logo = data['data']['logo'];
//         Name = data['data']['website_title'];
//         loader=true;
//       });
//     }else{
//
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initDeepLinks();
//     BasicSetting_Apii();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: ColorValues.Splash_bg_color1,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//
//           children: [
//             SizedBox(height: MediaQuery.of(context).size.height/6),
//             Container(
//               height: 50,
//               width: 150,
//               child: loader==true?
//               Image.network(Logo!):
//               SizedBox()
//             ),
//             Container(
//               margin:const EdgeInsets.only(top: 7),
//               child: Text("$Name",style:const TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w600),),
//             ),
//             const SizedBox(height: 50,),
//
//             Container(
//               margin:const EdgeInsets.only(top: 35),
//               child:const Text("Welcome",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w600),),
//             ),
//
//             GestureDetector(
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(showOnboarding:showOnboarding)));
//               },
//               child: Container(
//                 height: 45,
//                 width: double.infinity,
//                 margin:const EdgeInsets.only(left: 50,right: 40,top: 40),
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white),
//                     borderRadius: BorderRadius.circular(20)
//                 ),
//                 alignment: Alignment.center,
//                 child:const Text("SIGN IN",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white),),
//               ),
//             ),
//
//             GestureDetector(
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup(referralCode: '',)));
//               },
//               child: Container(
//                 height: 45,
//                 width: double.infinity,
//                 margin:const EdgeInsets.only(left: 50,right: 40,top: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20)
//                 ),
//                 alignment: Alignment.center,
//                 child:const Text("SIGN UP",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
//               ),
//             )
//           ],
//         ),
//       )
//
//     );
//   }
// }



import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:flutter/material.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Onboarding_screen/Login.dart';
import 'package:stock_box/Screens/Onboarding_screen/Signup.dart';

class Intro extends StatefulWidget {
  bool? showOnboarding;
  Intro({Key? key, this.showOnboarding}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState(showOnboarding: showOnboarding);
}

class _IntroState extends State<Intro> {
  bool? showOnboarding;
  _IntroState({this.showOnboarding});

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  final _navigatorKey = GlobalKey<NavigatorState>();
  String? _referralCode; // Store referral code

  // Initialize deep links and Play Store referrer
  Future<void> initDeepLinks() async {
    print("Initializing deep links...");
    _appLinks = AppLinks();

    // Handle initial link (when app is opened via a link)
    try {
      final initialLink = await _appLinks.getInitialLink(); // Updated method
      if (initialLink != null) {
        print("Initial link: $initialLink");
        _openAppLink(initialLink);
      }
    } catch (e) {
      print("Error handling initial link: $e");
    }

    // Listen for links when the app is in the foreground/background
    _linkSubscription = _appLinks.uriLinkStream.listen(
          (uri) {
        debugPrint('onAppLink: $uri');
        print("Received link: $uri");
        _openAppLink(uri);
      },
      onError: (err) {
        print("Error handling link: $err");
      },
    );

    // Handle Play Store referral for newly installed apps (Android only)
    _handlePlayStoreReferral();
  }

  // Handle deep link and extract referral code
  void _openAppLink(Uri uri) {
    try {
      String? referralCode = uri.queryParameters['ref'];
      print("Referral Code from deep link: $referralCode");

      if (referralCode != null) {
        setState(() {
          _referralCode = referralCode;
        });
        // Navigate to Signup page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Signup(referralCode: referralCode),
          ),
        );
      }
    } catch (e) {
      print("Error processing deep link: $e");
    }
  }

  // Handle referral code from Play Store (for new installs)
  Future<void> _handlePlayStoreReferral() async {
    try {
      final referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
      final referrerUrl = referrerDetails.installReferrer;

      if (referrerUrl != null && referrerUrl.contains('ref=')) {
        final uri = Uri.parse('?$referrerUrl');
        final referralCode = uri.queryParameters['ref'];
        if (referralCode != null) {
          print("Referral Code from Play Store: $referralCode");
          setState(() {
            _referralCode = referralCode;
          });
          // Navigate to Signup page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Signup(referralCode: referralCode),
            ),
          );
        }
      }
    } catch (e) {
      print("Error fetching Play Store referrer: $e");
    }
  }

  // API call for basic settings
  var BasicSettingData = [];
  String? Logo = '';
  String? Name = '';
  bool loader = false;

  Future<void> BasicSetting_Apii() async {
    var data = await API.BesicSetting_Api();
    print("Data11111: $data");
    if (data['status'] == true) {
      setState(() {
        Logo = data['data']['logo'];
        Name = data['data']['website_title'];
        loader = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize deep links and API call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initDeepLinks();
      BasicSetting_Apii();
    });
  }

  @override
  void dispose() {
    // Clean up stream subscription
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: ColorValues.Splash_bg_color1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 6),
            Container(
              height: 50,
              width: 150,
              child: loader ? Image.network(Logo!) : SizedBox(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 7),
              child: Text(
                "$Name",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.only(top: 35),
              child: const Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(showOnboarding: showOnboarding),
                  ),
                );
              },
              child: Container(
                height: 45,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 50, right: 40, top: 40),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "SIGN IN",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Signup(referralCode: _referralCode ?? ''),
                  ),
                );
              },
              child: Container(
                height: 45,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 50, right: 40, top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
