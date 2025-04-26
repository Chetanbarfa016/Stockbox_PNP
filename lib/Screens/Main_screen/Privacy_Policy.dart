// import 'package:flutter/material.dart';
// import 'package:stock_box/Api/Apis.dart';
// import 'package:stock_box/Constants/Colors.dart';
//
// class Privacy_policy extends StatefulWidget {
//   const Privacy_policy({Key? key}) : super(key: key);
//
//   @override
//   State<Privacy_policy> createState() => _Privacy_policyState();
// }
//
// class _Privacy_policyState extends State<Privacy_policy> {
//
//   var Data;
//   bool? Status;
//   bool loader = false;
//
//   PrivacyPolicy_Api() async {
//     var data = await API.PrivacyPolicy_Api();
//     setState(() {
//       Status = data['status'];
//     });
//
//     if(Status==true){
//       setState(() {});
//       Data = data['data'];
//
//       print("Dataaaaaa: $Data");
//
//       loader=true;
//     }
//
//     else{
//       print("error");
//     }
//   }
//
//   String removeHtmlTags(String text) {
//     return text.replaceAll(RegExp(r'<[^>]*>'), '');
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     PrivacyPolicy_Api();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 60,
//         titleSpacing: 0,
//         backgroundColor: Colors.grey.shade200,
//         elevation: 0.5,
//         leading: GestureDetector(
//             onTap: (){
//               Navigator.pop(context);
//             },
//             child:const Icon(Icons.arrow_back,color: Colors.black,)),
//         title:const Text("Privacy Policy",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color: Colors.black),),
//       ),
//
//       body: loader==true?
//       Container(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 alignment: Alignment.topLeft,
//                 margin:const EdgeInsets.only(top: 20,left: 20),
//                 child: Text("${Data['title']}",style:const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
//               ),
//
//               Container(
//                 alignment: Alignment.topLeft,
//                 margin:const EdgeInsets.only(top: 15,left: 20,right: 20,bottom: 15),
//                 child: Text(
//                   removeHtmlTags(Data['description']),
//                   // "${Data['description']}",
//                   style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
//               )
//             ],
//           ),
//         ),
//       ):
//
//           Container(
//             child:const Center(
//               child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
//             ),
//           )
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';

class Privacy_policy extends StatefulWidget {
  const Privacy_policy({Key? key}) : super(key: key);

  @override
  State<Privacy_policy> createState() => _Privacy_policyState();
}

class _Privacy_policyState extends State<Privacy_policy> {
  var data;
  bool? status;
  bool loader = false;

  PrivacyPolicyApi() async {
    var response = await API.PrivacyPolicy_Api();
    setState(() {
      status = response['status'];
    });

    if (status == true) {
      setState(() {
        data = response['data'];
        loader = true;
      });

      print("Data: $data");
    } else {
      print("Error fetching privacy policy");
    }
  }

  @override
  void initState() {
    super.initState();
    PrivacyPolicyApi();
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
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: loader
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   alignment: Alignment.topLeft,
            //   margin: const EdgeInsets.only(top: 20, left: 20),
            //   child: Text(
            //     "${data['title']}",
            //     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            //   ),
            // ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 5, left: 15, right: 20, bottom: 0),
              child: Html(
                data: data['description'], // HTML content directly render karein
                style: {
                  "p": Style(fontSize: FontSize.medium),
                  "h1": Style(fontSize: FontSize.large, fontWeight: FontWeight.bold),
                },
              ),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(
          color: ColorValues.Splash_bg_color1,
        ),
      ),
    );
  }
}

