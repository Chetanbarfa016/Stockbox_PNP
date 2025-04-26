// import 'package:flutter/material.dart';
// import 'package:onboarding_overlay/onboarding_overlay.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   final prefs = await SharedPreferences.getInstance();
// //   final showOnboarding = prefs.getBool('showOnboarding') ?? true;
// //
// //   runApp(MyApp(showOnboarding: showOnboarding));
// // }
// //
// // class MyApp extends StatelessWidget {
// //   final bool showOnboarding;
// //
// //   const MyApp({super.key, required this.showOnboarding});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: HomeScreen(showOnboarding: showOnboarding),
// //     );
// //   }
// // }
//
// class onboarding extends StatefulWidget {
//   final bool showOnboarding;
//
//   const onboarding({super.key, required this.showOnboarding});
//
//   @override
//   State<onboarding> createState() => _onboardingState();
// }
//
// class _onboardingState extends State<onboarding> {
//   final onboardingKey = GlobalKey<OnboardingState>();
//
//   final FocusNode fabFocusNode = FocusNode();
//   final FocusNode iconFocusNode = FocusNode();
//   final FocusNode textFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (widget.showOnboarding) {
//         onboardingKey.currentState?.show();
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('showOnboarding', false); // Mark as seen
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     fabFocusNode.dispose();
//     iconFocusNode.dispose();
//     textFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Onboarding(
//       key: onboardingKey,
//       steps: [
//         OnboardingStep(
//           focusNode: fabFocusNode,
//           titleText: 'Tap to Add',
//           bodyText: 'Tap this button to add a new item.',
//           shape: const CircleBorder(),
//         ),
//         OnboardingStep(
//           focusNode: iconFocusNode,
//           titleText: 'Your Profile',
//           bodyText: 'Click here to view your profile settings.',
//
//         ),
//         OnboardingStep(
//           focusNode: textFocusNode,
//           titleText: 'Welcome!',
//           bodyText: 'This is your main screen. Explore freely.',
//         ),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Onboarding Overlay Example'),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: Focus(
//                 focusNode: iconFocusNode,
//                 child: const Icon(Icons.person),
//               ),
//             ),
//           ],
//         ),
//         body: Center(
//           child: Focus(
//             focusNode: textFocusNode,
//             child: const Text('Main Content'),
//           ),
//         ),
//         floatingActionButton: Focus(
//           focusNode: fabFocusNode,
//           child: FloatingActionButton(
//             onPressed: () {},
//             child: const Icon(Icons.add),
//           ),
//         ),
//       ),
//     );
//   }
// }
