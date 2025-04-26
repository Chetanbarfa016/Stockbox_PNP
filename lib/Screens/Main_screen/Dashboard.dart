import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Main_screen/Browse.dart';
import 'package:stock_box/Screens/Main_screen/Homepage.dart';
import 'package:stock_box/Screens/Main_screen/Profile.dart';
import 'package:stock_box/Screens/Main_screen/Signal/Signal_tabs.dart';

class Dashboard extends StatefulWidget {
  String? popup_data;
  bool? showOnboarding;
   Dashboard({Key? key, this.popup_data,this.showOnboarding}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState(showOnboarding:showOnboarding);
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  String? dynamicData;
  bool? showOnboarding;
  _DashboardState({
    this.showOnboarding
});

  // Update the dynamic data when you want
  void _updateData() {
    print("widget.Dashboard: ${widget.popup_data}");
    setState(() {
      dynamicData = "${widget.popup_data}";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateData();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      Homepage(showOnboarding: showOnboarding),
      Signal(),
      Browse(),
      Profile(),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[],
                  ),
                ),
                title: const Text('Do you want to exit the app ?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Yes',style: TextStyle(color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600)),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  TextButton(
                    child: Text('No',style: TextStyle(color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600)),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 5),
          color: Colors.grey.shade100,
          child: CustomNavigationBar(
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                if (index == 0) {
                  _updateData();
                }
              });
            },
            blurEffect: false,
            selectedColor: ColorValues.Splash_bg_color1,
            strokeColor: ColorValues.Splash_bg_color1,
            backgroundColor: Colors.white,
            // backgroundColor: ColorValues.Splash_bg_color2,
            borderRadius: const Radius.circular(20.0),
            opacity: 5,
            elevation: 0,
            currentIndex: _selectedIndex,
            isFloating: true,
            items: [
              CustomNavigationBarItem(
                icon: Icon(Icons.home, color: _selectedIndex == 0 ? ColorValues.Splash_bg_color1 : Colors.grey),
                title: Text('Home', style: TextStyle(color: _selectedIndex == 0 ? ColorValues.Splash_bg_color1  : Colors.grey, fontSize: 12,fontWeight: FontWeight.w600)),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.signal_cellular_alt, color: _selectedIndex == 1 ? ColorValues.Splash_bg_color1 : Colors.grey),
                title: Text('Signal', style: TextStyle(color: _selectedIndex == 1 ? ColorValues.Splash_bg_color1 : Colors.grey, fontSize: 12,fontWeight: FontWeight.w600)),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.view_day_outlined, color: _selectedIndex == 2 ? ColorValues.Splash_bg_color1 : Colors.grey),
                title: Text('Browse', style: TextStyle(color: _selectedIndex == 2 ? ColorValues.Splash_bg_color1 : Colors.grey, fontSize: 12,fontWeight: FontWeight.w600)),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.person, color: _selectedIndex == 3 ? ColorValues.Splash_bg_color1 : Colors.grey),
                title: Text('Profile', style: TextStyle(color: _selectedIndex == 3 ? ColorValues.Splash_bg_color1 : Colors.grey, fontSize: 12,fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class _DashboardState extends State<Dashboard> {
//
//   int _selectedIndex = 0;
//
//   List<Widget> _widgetOptions = [
//     Homepage(),
//     Signal(),
//     Browse(),
//     Profile(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_selectedIndex == 0) {
//           return await showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 content: SingleChildScrollView(
//                   child: ListBody(
//                     children: <Widget>[],
//                   ),
//                 ),
//                 title: const Text('Do you want to exit the app ?'),
//                 actions: <Widget>[
//
//                   TextButton(
//                     child: const Text('Yes',style: TextStyle(color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600),),
//                     onPressed: () {
//                       SystemNavigator.pop();
//                     },
//                   ),
//
//                   TextButton(
//                     child: const Text('No',style: TextStyle(color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600),),
//                     onPressed: () {
//                       Navigator.of(context).pop(false);
//                     },
//                   ),
//
//                 ],
//               );
//
//             },
//           );
//         }
//
//         else {
//           setState(() {
//             _selectedIndex = 0;
//           });
//           return false;
//         }
//       },
//       child: Scaffold(
//         body: _widgetOptions.elementAt(_selectedIndex),
//         bottomNavigationBar: Container(
//           padding:const EdgeInsets.only(bottom: 5),
//            color: Colors.grey.shade100,
//           child: CustomNavigationBar(
//             onTap: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//             blurEffect: false,
//             selectedColor: ColorValues.Splash_bg_color1,
//             strokeColor: ColorValues.Splash_bg_color1,
//             backgroundColor:ColorValues.Splash_bg_color2,
//             borderRadius:const Radius.circular(20.0),
//             opacity: 1,
//             elevation: 0,
//             currentIndex: _selectedIndex,
//             isFloating: true,
//             items: [
//               CustomNavigationBarItem(
//                 icon: Icon(Icons.home,color:_selectedIndex==0?Colors.white: Colors.grey,),
//                 title: Text('Home', style: TextStyle(color:_selectedIndex==0?Colors.white: Colors.grey, fontSize: 12)),
//               ),
//
//               CustomNavigationBarItem(
//                 icon: Icon(Icons.signal_cellular_alt,color:_selectedIndex==1?Colors.white: Colors.grey,),
//                 title: Text('Signal', style: TextStyle(color:_selectedIndex==1?Colors.white: Colors.grey, fontSize: 12)),
//               ),
//
//               CustomNavigationBarItem(
//                 icon: Icon(Icons.browse_gallery,color:_selectedIndex==2?Colors.white: Colors.grey,),
//                 title: Text('Browse', style: TextStyle(color:_selectedIndex==2?Colors.white: Colors.grey,fontSize: 12)),
//               ),
//
//               CustomNavigationBarItem(
//                 icon: Icon(Icons.person,color:_selectedIndex==3?Colors.white: Colors.grey,),
//                 title: Text('Profile', style: TextStyle(color:_selectedIndex==3?Colors.white: Colors.grey, fontSize: 12)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
