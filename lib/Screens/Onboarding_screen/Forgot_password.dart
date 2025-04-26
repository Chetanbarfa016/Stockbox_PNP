// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:stock_box/Api/Apis.dart';
// import 'package:stock_box/Constants/Colors.dart';
// import 'package:stock_box/Screens/Onboarding_screen/Reset_password.dart';
// import 'package:stock_box/Screens/Onboarding_screen/Signup.dart';
//
// class Forgot_password extends StatefulWidget {
//   const Forgot_password({super.key});
//
//   @override
//   State<Forgot_password> createState() => _Forgot_passwordState();
// }
//
// class _Forgot_passwordState extends State<Forgot_password> {
//
//   TextEditingController username =TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//
//
//   bool? Status;
//   String? loader = "false";
//   String? message;
//
//   ForgotPassword_Api() async {
//     var data = await API.forgot_Api(username.text);
//     setState(() {
//       Status = data['status'];
//       message=data['message'];
//     });
//
//     if(Status==true){
//       setState(() {});
//       ScaffoldMessenger.of(context).showSnackBar(
//          SnackBar(
//           content: Text('$message',style: TextStyle(color: Colors.white)),
//           duration:Duration(seconds: 3),
//           backgroundColor: Colors.green,
//         ),
//       );
//       Navigator.push(context, MaterialPageRoute(builder: (context)=> Reset_password()));
//     }
//
//     else{
//       print("error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$message',style: TextStyle(color: Colors.white)),
//           duration:Duration(seconds: 3),
//           backgroundColor: Colors.green,
//         ),
//       );
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         decoration:const BoxDecoration(
//           color: Colors.white,
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             // stops: [
//             //   0.1,
//             //   0.2,
//             //   0.4 ,
//             // ],
//             colors: [
//               ColorValues.Splash_bg_color1,
//               ColorValues.Splash_bg_color1,
//               ColorValues.Splash_bg_color1,
//             ],
//           ),
//         ),
//
//         child: SingleChildScrollView(
//           // physics:const NeverScrollableScrollPhysics(),
//           child: Column(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height/2.2,
//                 child: Column(
//                   children: [
//                     // const Spacer(),
//                     const SizedBox(height: 90,),
//                     Image.asset('images/icon.png',height: MediaQuery.of(context).size.height/5.5,),
//                     const SizedBox(height: 20,),
//                     Container(
//                       margin:const EdgeInsets.only(bottom: 25, left: 10, right: 10),
//                       alignment: Alignment.center,
//                       child:const Text("Stock Box", style:
//                       TextStyle(
//                           color: Colors.white,
//                           fontSize: 30,
//                           fontWeight: FontWeight.w600
//                       ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(30),
//                       topLeft: Radius.circular(30),
//                     ),
//                     color:  Colors.grey.shade100,
//                 ),
//                 height: MediaQuery.of(context).size.height/1.83,
//                 width: double.infinity,
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//
//                       Container(
//                         margin:const EdgeInsets.only(top: 35, left: 35, right: 20),
//                         // padding:const EdgeInsets.only(),
//                         alignment: Alignment.topLeft,
//                         child: Text("Forgot Password", style:
//                         TextStyle(color: Colors.grey.shade800, fontSize: 25, fontWeight: FontWeight.w900),
//                         ),
//                       ),
//
//                       Container(
//                         margin:const EdgeInsets.only(top: 40, left: 35, right: 20),
//                         // padding:const EdgeInsets.only(),
//                         alignment: Alignment.topLeft,
//                         child:const Text("Email", style:
//                         TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//
//                       Container(
//                         height: 45,
//                         margin:const EdgeInsets.only(top: 10, left: 35, right: 35),
//                         padding:const EdgeInsets.only(left: 15, right: 15),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                               color: ColorValues.Splash_bg_color2,
//                               width: 0.3
//                           ),
//                         ),
//
//                         child: TextFormField(
//                           controller: username,
//                           textInputAction: TextInputAction.done,
//                           onSaved: (email) {},
//                           decoration: const InputDecoration(
//                               hintText: "Email",
//                               enabledBorder:InputBorder.none,
//                               border: InputBorder.none,
//                               prefixIcon: Icon(Icons.email_outlined,size:25,),
//                               contentPadding: EdgeInsets.only(top: 9)
//                           ),
//                         ),
//                       ),
//
//
//                       GestureDetector(
//                         onTap: (){
//                           if (username.text.trim()==""||username.text.trim()==null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Please Enter Your Email',style: TextStyle(color: Colors.white)),
//                                 duration:Duration(seconds: 3),
//                                 backgroundColor: Color(0xbeea0904),
//                                 behavior: SnackBarBehavior.floating,
//                               ),
//                             );
//                           }
//                           else{
//                             ForgotPassword_Api();
//                           }
//
//                         },
//
//                         child: Card(
//                           clipBehavior: Clip.antiAliasWithSaveLayer,
//                           color: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           // margin: EdgeInsets.only(left: 35, right: 35, top: 25, bottom: 15),
//                           elevation: 0,
//                           child: Container(
//                             height: 50,
//                             margin:const EdgeInsets.only(top: 50, left: 30, right: 30),
//                             width: MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.grey.shade300,
//                               gradient:const LinearGradient(
//                                 begin: Alignment.topRight,
//                                 end: Alignment.bottomLeft,
//                                 stops: [
//                                   0.1,
//                                   0.5,
//                                 ],
//                                 colors: [
//                                   ColorValues.Splash_bg_color1,
//                                   ColorValues.Splash_bg_color1,
//                                 ],
//                               ),
//                             ),
//
//                             child:Container(
//                                 alignment: Alignment.center,
//                                 child:const Text(
//                                   "Submit",
//                                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
//                                 )
//                             ),
//
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Onboarding_screen/Reset_password.dart';
import 'package:stock_box/Screens/Onboarding_screen/Signup.dart';

class Forgot_password extends StatefulWidget {
  const Forgot_password({super.key});

  @override
  State<Forgot_password> createState() => _Forgot_passwordState();
}

class _Forgot_passwordState extends State<Forgot_password> {

  TextEditingController username =TextEditingController();
  final _formKey = GlobalKey<FormState>();



  bool? Status;
  String? loader = "false";
  String? message;

  ForgotPassword_Api() async {
    var data = await API.forgot_Api(username.text);
    setState(() {
      Status = data['status'];
      message=data['message'];
    });

    if(Status==true){
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$message',style: TextStyle(color: Colors.white)),
          duration:Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Reset_password()));
    }

    else{
      print("error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$message',style: TextStyle(color: Colors.white)),
          duration:Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      // Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // stops: [
            //   0.1,
            //   0.2,
            //   0.4 ,
            // ],
            colors: [
              ColorValues.Splash_bg_color1,
              ColorValues.Splash_bg_color1,
              ColorValues.Splash_bg_color1,
            ],
          ),
        ),

        child: SingleChildScrollView(
          // physics:const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/2.7,
                child: Column(
                  children: [
                    // const Spacer(),
                    const SizedBox(height: 50,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin:const EdgeInsets.only(left: 35),
                        child:const Icon(Icons.arrow_back,color: Colors.white,),
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Container(
                      margin:const EdgeInsets.only(left: 35, right: 10),
                      alignment: Alignment.topLeft,
                      child:const Text("Forgot Password", style:
                      TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w600
                      ),
                      ),
                    ),

                    Container(
                      margin:const EdgeInsets.only(left: 35, right: 10,top: 20),
                      alignment: Alignment.topLeft,
                      child: Text("Enter your email address to reset your password", style:
                      TextStyle(
                          color: Colors.grey.shade100,
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      ),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color:  Colors.grey.shade100,
                ),
                height: MediaQuery.of(context).size.height/1.57,
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      Container(
                        margin:const EdgeInsets.only(top: 60, left: 35, right: 20),
                        // padding:const EdgeInsets.only(),
                        alignment: Alignment.topLeft,
                        child:const Text("Email", style:
                        TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),

                      Container(
                        // height: 45,
                        margin:const EdgeInsets.only(top: 10, left: 35, right: 35),
                        // padding:const EdgeInsets.only(left: 15, right: 15),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(12),
                        //   border: Border.all(
                        //       color: ColorValues.Splash_bg_color2,
                        //       width: 0.3
                        //   ),
                        // ),

                        child: TextFormField(
                          cursorColor: Colors.black,
                          cursorWidth: 1.1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                          controller: username,
                          style:const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1)
                              ),
                              hintText: "Email",
                              contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                              hintStyle:const TextStyle(
                                  fontSize: 13
                              ),
                              prefixIcon:const Icon(Icons.email)
                          ),
                        )
                      ),


                      GestureDetector(
                        onTap: (){
                          if (_formKey.currentState!.validate()) {
                            ForgotPassword_Api();
                          }
                          else{
                            print("Hello");
                          }
                          // if (username.text.trim()==""||username.text.trim()==null) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       content: Text('Please Enter Your Email',style: TextStyle(color: Colors.white)),
                          //       duration:Duration(seconds: 3),
                          //       backgroundColor: Color(0xbeea0904),
                          //       behavior: SnackBarBehavior.floating,
                          //     ),
                          //   );
                          // }
                          // else{
                          //   ForgotPassword_Api();
                          // }

                        },

                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // margin: EdgeInsets.only(left: 35, right: 35, top: 25, bottom: 15),
                          elevation: 0,
                          child: Container(
                            height: 50,
                            margin:const EdgeInsets.only(top: 50, left: 30, right: 30),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade300,
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                stops: [
                                  0.1,
                                  0.5,
                                ],
                                colors: [
                                  ColorValues.Splash_bg_color1,
                                  ColorValues.Splash_bg_color1,
                                ],
                              ),
                            ),

                            child:Container(
                                alignment: Alignment.center,
                                child:const Text(
                                  "Submit",
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
                                )
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

