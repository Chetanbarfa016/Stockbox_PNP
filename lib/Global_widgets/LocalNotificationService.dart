// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//
//   FlutterLocalNotificationsPlugin();
//
//
//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//     const AndroidInitializationSettings('flutter_logo');
//
//     var initializationSettingsIOS = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification:
//             (int id, String? title, String? body, String? payload) async {});
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS
//     );
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
//         }
//     );
//   }
//
//   notificationDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails('channelId', 'channelName',
//           importance: Importance.max,
//           styleInformation: BigTextStyleInformation(''),
//           // styleInformation: BigTextStyleInformation(
//           //   'This is a large text notification with custom content.',
//           //   htmlFormatBigText: true,
//           //   contentTitle: 'Custom Notification Title',
//           //   summaryText: 'This is the summary text of the notification.',
//           // ),
//           // actions: [
//           //   AndroidNotificationAction(
//           //     'button1', // Action ID for button 1
//           //     'Action 1', // Button title
//           //   ),
//           //   AndroidNotificationAction(
//           //     'button2',
//           //     'Action 2',
//           //   ),
//           // ],
//         ),
//         iOS: DarwinNotificationDetails()
//     );
//   }
//
//   Future showNotification(
//       {int id = 1, String? title, String? body}) async {
//     await NotificationService().initNotification();
//     return notificationsPlugin.show(id, title, body, await notificationDetails());
//   }
// }


















//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:lohare_samaj/Notification.dart';
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotification(BuildContext context) async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//     const AndroidInitializationSettings('flutter_logo');
//
//     var initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
//     );
//
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//
//     // Handle notification tap
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
//           if (notificationResponse.payload != null && notificationResponse.payload!.isNotEmpty) {
//             _handleNotificationTap(context, notificationResponse.payload!);
//           }
//         });
//   }
//
//   void _handleNotificationTap(BuildContext context, String payload) {
//     // Navigate to the desired screen based on the payload
//     if (payload == 'screen1') {
//       Navigator.of(context).push(MaterialPageRoute(builder: (_) => Notifications()));
//     }
//     // Add more screens as needed
//   }
//
//   notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channelId',
//         'channelName',
//         importance: Importance.max,
//         styleInformation: BigTextStyleInformation(''),
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }
//
//   Future showNotification({int id = 1, String? title, String? body, String? payload}) async {
//     return notificationsPlugin.show(
//       id,
//       title,
//       body,
//       await notificationDetails(),
//       payload: payload, // Pass payload to identify the notification action
//     );
//   }
// }
//




// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:lohare_samaj/Notification.dart';
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotification(BuildContext context) async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//     const AndroidInitializationSettings('flutter_logo');
//
//     var initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
//     );
//
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//
//     // Handle notification tap
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
//           if (notificationResponse.payload != null && notificationResponse.payload!.isNotEmpty) {
//             _handleNotificationTap(context, notificationResponse.payload!);
//           }
//         });
//   }
//
//   void _handleNotificationTap(BuildContext context, String payload) {
//     // Navigate to the desired screen based on the payload
//     if (payload == 'screen1') {
//       Navigator.of(context).push(MaterialPageRoute(builder: (_) => Notifications()));
//     }
//     // Add more screens as needed
//   }
//
//   notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channelId',
//         'channelName',
//         importance: Importance.max,
//         styleInformation: BigTextStyleInformation(''),
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }
//
//   Future showNotification({int id = 1, String? title, String? body, String? payload}) async {
//     return notificationsPlugin.show(
//       id,
//       title,
//       body,
//       await notificationDetails(),
//       payload: payload, // Pass payload to identify the notification action
//     );
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stock_box/Screens/Main_screen/Blogs.dart';
import 'package:stock_box/Screens/Main_screen/Broadcasts.dart';
import 'package:stock_box/Screens/Main_screen/Coupons.dart';
import 'package:stock_box/Screens/Main_screen/News.dart';
import 'package:stock_box/Screens/Main_screen/Trades/Trades.dart';
import 'package:stock_box/Screens/Main_screen/Wallet.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  Future<void> initNotification(BuildContext context) async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('flutter_logo');


    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body,
            String? payload) async {
        });


    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);


    await notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse, ) async {
      String? payload = notificationResponse.payload;

      List<String> data = List<String>.from(json.decode(payload!));
      String? Type = data[0].toString();
      String? Segment = data[1].toString();

      if (payload != null) {
        payload.toString()=="open signal"?
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Trades(indexchange: 0,Segment:Segment=="Cash"? 0:Segment=="Future"? 1: 2)), (route) => false,):
        payload.toString()=="close signal"?
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Trades(indexchange: 1,Segment:Segment=="Cash"? 0:Segment=="Future"? 1: 2)), (route) => false,):

        payload.toString()=="add coupon"?
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Coupons()), (route) => false,):

        payload.toString()=="add broadcast"?
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Broadcasts()), (route) => false,):

        payload.toString()=="add news"?
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Newss()), (route) => false,):

        payload.toString()=="payout"?
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wallet(index_tab: 1)), (route) => false,):

        payload.toString()=="add blog"?
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Blogs()), (route) => false,):

        payload.toString()=="add news"?
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Newss()), (route) => false,):

        print("No other routes");

      }

    });

  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }


  Future<void> showNotification(BuildContext context, {int id = 1, String? title, String? body, String? payload}) async {
    await initNotification(context);
    return notificationsPlugin.show(
        id, title, body, notificationDetails(), payload: payload);
  }
}

