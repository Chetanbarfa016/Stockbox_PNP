// import 'package:flutter/material.dart';
// import 'package:stock_box/Api/Apis.dart';
// import 'package:stock_box/Constants/Colors.dart';
// import 'package:stock_box/Screens/Onboarding_screen/Login.dart';
//
// class Reset_password extends StatefulWidget {
//   const Reset_password({super.key});
//
//   @override
//   State<Reset_password> createState() => _Reset_passwordState();
// }
//
// class _Reset_passwordState extends State<Reset_password> {
//
//   TextEditingController token =TextEditingController();
//   TextEditingController newpassword =TextEditingController();
//   TextEditingController confirmpassword =TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   bool? Status;
//   String? loader = "false";
//   String? message;
//
//   ResetPassword_Api() async {
//     var data = await API.resetPassword_Api(token.text,newpassword.text);
//     setState(() {
//       Status = data['status'];
//       message=data['message'];
//     });
//
//     print("Statusssss: $Status");
//     print("Messageeee: $message");
//     if(Status==true){
//       setState(() {});
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$message',style: TextStyle(color: Colors.white)),
//           duration:Duration(seconds: 3),
//           backgroundColor: Colors.green,
//         ),
//       );
//       print("111111");
//       Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
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
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(30),
//                     topLeft: Radius.circular(30),
//                   ),
//                   color:  Colors.grey.shade100,
//                 ),
//                 height: MediaQuery.of(context).size.height/1.83,
//                 width: double.infinity,
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//
//                       Container(
//                         margin:const EdgeInsets.only(top: 20, left: 35, right: 20),
//                         // padding:const EdgeInsets.only(),
//                         alignment: Alignment.topLeft,
//                         child: Text("Reset Password", style:
//                         TextStyle(color: Colors.grey.shade800, fontSize: 22, fontWeight: FontWeight.w900),
//                         ),
//                       ),
//
//                       Container(
//                         margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
//                         // padding:const EdgeInsets.only(),
//                         alignment: Alignment.topLeft,
//                         child:const Text("Otp", style:
//                         TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
//                         ),
//                       ),
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
//                         child: TextFormField(
//                           controller: token,
//                           textInputAction: TextInputAction.done,
//                           onSaved: (email) {},
//                           decoration: const InputDecoration(
//                               hintText: "Otp",
//                               enabledBorder:InputBorder.none,
//                               border: InputBorder.none,
//                               prefixIcon: Icon(Icons.email_outlined,size:25,),
//                               contentPadding: EdgeInsets.only(top: 9)
//                           ),
//                         ),
//                       ),
//
//                       Container(
//                         margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
//                         // padding:const EdgeInsets.only(),
//                         alignment: Alignment.topLeft,
//                         child:const Text("New Password", style:
//                         TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
//                         ),
//                       ),
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
//                           controller: newpassword,
//                           textInputAction: TextInputAction.done,
//                           onSaved: (email) {},
//                           decoration: const InputDecoration(
//                               hintText: "New password",
//                               enabledBorder:InputBorder.none,
//                               border: InputBorder.none,
//                               prefixIcon: Icon(Icons.email_outlined,size:25,),
//                               contentPadding: EdgeInsets.only(top: 9)
//                           ),
//                         ),
//                       ),
//
//                       Container(
//                         margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
//                         // padding:const EdgeInsets.only(),
//                         alignment: Alignment.topLeft,
//                         child:const Text("Confirm New Password", style:
//                         TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
//                         ),
//                       ),
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
//                           controller: confirmpassword,
//                           textInputAction: TextInputAction.done,
//                           onSaved: (email) {},
//                           decoration: const InputDecoration(
//                               hintText: "Confirm New password",
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
//
//                           if (token.text.trim()==""||token.text.trim()==null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Please Enter Otp',style: TextStyle(color: Colors.white)),
//                                 duration:Duration(seconds: 3),
//                                 backgroundColor: Color(0xbeea0904),
//                                 behavior: SnackBarBehavior.floating,
//                               ),
//                             );
//                           }
//
//                           else if (newpassword.text.trim()==""||newpassword.text.trim()==null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Please Enter New Password',style: TextStyle(color: Colors.white)),
//                                 duration:Duration(seconds: 3),
//                                 backgroundColor: Color(0xbeea0904),
//                                 behavior: SnackBarBehavior.floating,
//                               ),
//                             );
//                           }
//
//                           else if (newpassword.text.trim() != confirmpassword.text.trim()) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Please Confirm Your Password',style: TextStyle(color: Colors.white)),
//                                 duration:Duration(seconds: 3),
//                                 backgroundColor: Color(0xbeea0904),
//                                 behavior: SnackBarBehavior.floating,
//                               ),
//                             );
//                           }
//
//                           else{
//                             ResetPassword_Api();
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
//                             margin:const EdgeInsets.only(top: 20, left: 30, right: 30),
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
//
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


import 'package:flutter/material.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Onboarding_screen/Login.dart';

class Reset_password extends StatefulWidget {
  const Reset_password({super.key});

  @override
  State<Reset_password> createState() => _Reset_passwordState();
}

class _Reset_passwordState extends State<Reset_password> {

  TextEditingController token =TextEditingController();
  TextEditingController newpassword =TextEditingController();
  TextEditingController confirmpassword =TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool obscureText = true, passwordVisible = false;
  bool obscureText1 = true, passwordVisible1 = false;

  bool? Status;
  String? loader = "false";
  String? message;

  ResetPassword_Api() async {
    var data = await API.resetPassword_Api(token.text,newpassword.text);
    setState(() {
      Status = data['status'];
      message=data['message'];
    });

    print("Statusssss: $Status");
    print("Messageeee: $message");
    if(Status==true){
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$message',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      print("111111");
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
    }

    else{
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
                height: MediaQuery.of(context).size.height/3.4,
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

                    const SizedBox(height: 20,),

                    Container(
                      margin:const EdgeInsets.only(top: 10, left: 35, right: 20),
                      // padding:const EdgeInsets.only(),
                      alignment: Alignment.topLeft,
                      child:const Text("Reset Password", style:
                      TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                    ),

                    // Container(
                    //   margin:const EdgeInsets.only(top: 20, left: 35, right: 20),
                    //   // padding:const EdgeInsets.only(),
                    //   alignment: Alignment.topLeft,
                    //   child: Text("Your New Password Must Be Different From Previously Used Password.", style:
                    //   TextStyle(color: Colors.grey.shade100, fontSize: 17, fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius:const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color:  Colors.grey.shade100,
                ),
                height: MediaQuery.of(context).size.height/1.37,
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                    
                        Container(
                          margin:const EdgeInsets.only(top: 35, left: 35, right: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topLeft,
                          child:const Text("OTP", style:
                          TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin:const EdgeInsets.only(top: 10, left: 35, right: 35),
                          child: TextFormField(
                            cursorColor: Colors.black,
                            cursorWidth: 1.1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter OTP';
                              }
                              return null;
                            },
                            controller: token,
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
                                hintText: "OTP",
                                contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                hintStyle:const TextStyle(
                                    fontSize: 13
                                ),
                                prefixIcon:Container(
                                  height: 8,
                                  width: 8,
                                  padding: EdgeInsets.all(12),
                                  child: Image.asset("images/otp.png"),
                                )
                            ),
                          )
                        ),
                    
                        Container(
                          margin:const EdgeInsets.only(top: 25, left: 35, right: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topLeft,
                          child:const Text("New Password", style:
                          TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin:const EdgeInsets.only(top: 10, left: 35, right: 35),
                            child: TextFormField(
                            obscureText: obscureText,
                            cursorColor: Colors.black,
                            cursorWidth: 1.1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter New Password';
                              }
                              if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$').hasMatch(value)) {
                                return "Password should be min 8 characters long\nand include a special character, a numeric\nand a capital letter, and a small letter.";
                              }
                              return null;
                            },
                            controller: newpassword,
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
                                hintText: "New Password",
                                contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                hintStyle:const TextStyle(
                                    fontSize: 13
                                ),
                                prefixIcon: Icon(Icons.password),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                    if (passwordVisible == false) {
                                      obscureText = true;
                                    } else if (passwordVisible == true) {
                                      obscureText = false;
                                    }
                                  }
                                  );
                                },
                              ),
                            ),
                          )
                        ),
                    
                        Container(
                          margin:const EdgeInsets.only(top: 25, left: 35, right: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topLeft,
                          child:const Text("Confirm New Password", style:
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
                    
                          child:TextFormField(
                            obscureText: obscureText1,
                            cursorColor: Colors.black,
                            cursorWidth: 1.1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Confirm New Password';
                              }
                              return null;
                            },
                            controller: confirmpassword,
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
                                hintText: "Confirm New Password",
                                contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                hintStyle:const TextStyle(
                                    fontSize: 13
                                ),
                                prefixIcon: Icon(Icons.password),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  passwordVisible1 ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible1 = !passwordVisible1;
                                    if (passwordVisible1 == false) {
                                      obscureText1 = true;
                                    } else if (passwordVisible1 == true) {
                                      obscureText1 = false;
                                    }
                                  }
                                  );
                                },
                              ),
                            ),
                          )
                        ),
                    
                    
                        GestureDetector(
                          onTap: (){
                    
                            if (_formKey.currentState!.validate()) {
                              if(newpassword.text != confirmpassword.text){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please Confirm New Password",
                                        style: const TextStyle(color: Colors.white)),
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              else{
                                ResetPassword_Api();
                              }
                    
                            }
                            else{
                              print("Hello");
                            }
                    
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
                              margin:const EdgeInsets.only(top: 55, left: 30, right: 30),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

