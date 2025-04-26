import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Onboarding_screen/Splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

String? token;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> backgroundHandler(RemoteMessage message) async {
  print("==========Background data:${message.data.toString()}");
  print("==========Background data body:${message.notification!.body.toString()}");
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  token = await FirebaseMessaging.instance.getToken();
  HttpOverrides.global = MyHttpOverrides();
  print("11444444");
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;
  print("showOnboarding: $showOnboarding");
  runApp(MyApp(showOnboarding:showOnboarding));
}
  String? AppName;
Future<void> initializeApp() async {
  try {
    final response = await http.get(Uri.parse('https://stockboxpnp.pnpuniverse.com/backend/api/list/basicsetting'));
    final jsonData = jsonDecode(response.body);

    if (jsonData['status'] == true && jsonData['data'] != null) {
      ColorValues.initializeFromApi(jsonData['data']);
      final String newBaseUrl = jsonData['data']['base_url'];
      AppName=jsonData['data']['website_title'];
      Util.updateBaseUrl(newBaseUrl);
    }
  } catch (e) {
    debugPrint('Error fetching settings: $e');
  }
}

class MyApp extends StatelessWidget {
   bool? showOnboarding;
  MyApp({super.key, this.showOnboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
  )
  );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'StockBox',
      theme: ThemeData(
        fontFamily:GoogleFonts.openSans().fontFamily,
        // fontFamily:GoogleFonts.ubuntu().fontFamily,
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: SplashScreen(showOnboarding:showOnboarding),
    );
  }
}

Future<void> requestNotificationPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(

  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,

  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  }
  else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  }
  else {
  print('User declined or has not accepted permission');
  }
}



//
//
// import 'package:flutter/material.dart';
//
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// void main() => runApp(StockPriceApp());
//
// class StockPriceApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: StockPriceScreen(),
//     );
//   }
// }
//
// class StockPriceScreen extends StatefulWidget {
//   @override
//   _StockPriceScreenState createState() => _StockPriceScreenState();
// }
//
// class _StockPriceScreenState extends State<StockPriceScreen> {
//   late IO.Socket socket;
//
//   final List<String> _symbols = [
//     "gbpjpy",
//     "usdchf",
//     "audusd",
//     "audnzd",
//     "gbpchf",
//     "audjpy",
//     "eurusd",
//     "nzdjpy",
//   ];
//
//   Map<String, double> _prices = {};
//
//   Map<String, double> _previousPrices = {}; // To track previous prices
//
//   @override
//   void initState() {
//     super.initState();
//
// // Initialize prices with 0
//
//     for (var symbol in _symbols) {
//       _prices[symbol] = 0.0;
//
//       _previousPrices[symbol] = 0.0;
//     }
//
// // Connect to socket
//
//     socket = IO.io('http://140.99.208.36:5009/', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//     });
//
//     socket.on('connect', (_) {
//       print('Connected to socket server');
//     });
//
//     socket.on('receive_data_forex', (data) {
//       print(data);
//
//       final symbol = data['data'][1]; // Extract symbol from the second index
//
//       final price = double.tryParse(data['data'][4]?.toString() ?? '0') ??
//           0.0; // Extract price from the 5th index
//
//       if (_symbols.contains(symbol)) {
//         setState(() {
//           _previousPrices[symbol] =
//               _prices[symbol] ?? 0.0; // Store the current price as previous
//
//           _prices[symbol] = price;
//         });
//       }
//     });
//
//     socket.on('disconnect', (_) {
//       print('Disconnected from socket server');
//     });
//   }
//
//   @override
//   void dispose() {
//     socket.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("22222222222222222222222222222222");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Live Stock Prices'),
//       ),
//       body: ListView.builder(
//         itemCount: _symbols.length,
//         itemBuilder: (context, index) {
//           print("111111111111111111111111111");
//
//           final symbol = _symbols[index];
//
//           final currentPrice = _prices[symbol] ?? 0.0;
//
//           final previousPrice = _previousPrices[symbol] ?? 0.0;
//
//           final priceColor = currentPrice > previousPrice
//               ? Colors.green
//               : currentPrice < previousPrice
//                   ? Colors.red
//                   : Colors.black;
//
//           return ListTile(
//             title: Text(symbol),
//             trailing: Text(
//               currentPrice.toString(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: priceColor,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }