import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Global_widgets/Logout.dart';
import 'package:stock_box/Screens/Main_screen/Baskets/MyBasketSubscription.dart';
import 'package:stock_box/Screens/Main_screen/Kyc/Kyc_formView.dart';
import 'package:stock_box/Screens/Main_screen/My_subscription.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Screens/Main_screen/Payment_History.dart';
import 'package:stock_box/Screens/Main_screen/Wallet.dart';
import 'package:stock_box/Screens/Onboarding_screen/Splash_screen.dart' show SplashScreen;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController current_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController confirmnew_password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();



  bool? Status_logout;
  String? Message_Logout='';

  Logoutt_Api() async {
    var data = await API.Logout_Api();
    setState(() {
      Status_logout = data['status'];
      Message_Logout = data['message'];
    });

    if(Status_logout==true){
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_Logout',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login_status', 'false');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false,
      );

    }

    else{
      print("Hello");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_Logout',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }

  }

  bool obscureText = true, passwordVisible = false;
  bool obscureText1 = true, passwordVisible1 = false;
  bool obscureText2 = true, passwordVisible2 = false;

  var Data;
  bool loader = false;
  String? message;
  bool? Status;

  String? Name;
  String? Email;
  String? Phone_no;
  String? Wallet_amount;
  String CapitalLetter='';
  String? Delete_status;
  String? Active_status;
  Profile_Api() async {
    setState(() {
      CapitalLetter = '';
    });
    var data = await API.Profile_Api();
    setState(() {
      Data = data['data'];
      Status = data['status'];
    });

    print("Dataaaaaa: $Data");

    if (Status == true) {
      setState(() {});
      Name = Data['FullName'];
      Email = Data['Email'];
      Phone_no = Data['PhoneNo'];

      Wallet_amount=Data['wamount'].toString();
      Delete_status=Data['del'].toString();
      Active_status=Data['ActiveStatus'].toString();
      print("Wallet_amount: $Wallet_amount");

      SharedPreferences prefs= await SharedPreferences.getInstance();
      prefs.setString("Wallet_amount",Wallet_amount!);
      prefs.setString("Delete_status",Delete_status!);
      prefs.setString("Active_status",Active_status!);

      Delete_status=="1"||Active_status=="0"?
      handleLogout(context):
      print("Account not deleted");

      if (Name != null && Name!.isNotEmpty) {
        List<String> nameParts = Name!.split(" ");
        for (var part in nameParts) {
          if (part.isNotEmpty) {
            CapitalLetter += part[0].toUpperCase();
          }
        }
        print("CapitalLetter: $CapitalLetter");
      }


      loader = true;
    } else {
      print("error");
    }
  }

  String? Login_id;
  bool? Status_profile;
  String? Message_profile;

  Future<void> updateProfile_Api(context, setState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Login_id = prefs.getString("Login_id");
    print("Loginnnnn idddd: $Login_id");
    var response =
        await http.post(Uri.parse("${Util.BASE_URL}update-profile"), body: {
      "FullName": "${name.text}",
      "id": "$Login_id",
    });
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");

    Status_profile = jsonString['status'];

    if (Status_profile == true) {
      setState(() {});
      Message_profile = jsonString['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_profile',
              style: const TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
      CapitalLetter="";
      Profile_Api();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_profile',
              style: const TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String? Login_idd;
  bool? Status_changepassword;
  String? Message_changepassword;

  Future<void> changePassword_Api(context, setState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Login_idd = prefs.getString("Login_id");
    print("Loginnnnn idddd: $Login_id");
    var response = await http.post(Uri.parse(Util.ChangePassword_Api), body: {
      "currentPassword": "${current_password.text}",
      "newPassword": "${new_password.text}",
      "id": "$Login_idd",
    });
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");

    Status_changepassword = jsonString['status'];
    Message_changepassword = jsonString['message'];
    if (Status_changepassword == true) {
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_changepassword',
              style: const TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login_status', 'false');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message_changepassword',
              style: const TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  var Delete_Data;
  bool? Delete_Status;
  bool delete_loader = false;
  String? Delete_Message;

  bool? Status_token;
  checkToken_Api() async {
    var data = await API.checkToken();
    setState(() {
      Status_token = data['status'];

      print("Status_tokennnnnnnn: $Status_token");
    });

    if(Status_token==true){

    }
    else{
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login_status', 'false');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  DeleteAccount_Api() async {
    var data = await API.DeleteAccount_Api();
    setState(() {
      Delete_Status = data['status'];
      Delete_Message = data['message'];
    });

    if (Delete_Status == true) {
      setState(() {});

      Fluttertoast.showToast(
        msg: "$Delete_Message",
        backgroundColor: Colors.red,
        textColor: Colors.white
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('$Delete_Message',
      //         style: const TextStyle(color: Colors.white)),
      //     duration: const Duration(seconds: 3),
      //     backgroundColor: Colors.red,
      //   ),
      // );

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('login_status', 'false');
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => SplashScreen()),
      // );

      Navigator.push(context, MaterialPageRoute(builder: (context)=> SplashScreen()));

      delete_loader = true;
    }

    else {
      Fluttertoast.showToast(
          msg: "$Delete_Message",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Profile_Api();
    checkToken_Api();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 25,
        backgroundColor: Colors.grey.shade200,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile Settings",
          style: TextStyle(
              fontSize: 19, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),

      body: loader == true ?
      RefreshIndicator(
        onRefresh: () async{
          setState(() {
            Profile_Api();
          });
        },
        child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [

                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                            radius: 45,
                            backgroundColor: ColorValues.Splash_bg_color1,
                            child: Text(
                              "$CapitalLetter",
                              style:const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                  color: Colors.white),
                            )),
                      ),

                      Container(
                          margin: const EdgeInsets.only(top: 15),
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: const Icon(
                                  Icons.person_outline,
                                  size: 22,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "$Name",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  name.text = Name.toString();
                                  phone.text = Phone_no.toString();
                                  email.text = Email.toString();
                                  Edit_profile_popup();
                                },
                                child: Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [
                                        0.1,
                                        0.7,
                                      ],
                                      colors: [
                                        ColorValues.Splash_bg_color1,
                                        ColorValues.Splash_bg_color3,
                                      ],
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(left: 15),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              )
                            ],
                          )),

                      Container(
                          margin: const EdgeInsets.only(top: 7),
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: const Icon(
                                  Icons.call,
                                  size: 22,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text("+91-$Phone_no"),
                              )
                            ],
                          )),

                      Container(
                        margin: const EdgeInsets.only(top: 7),
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: const Icon(
                                Icons.email,
                                size: 22,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text("$Email"),
                            )
                          ],
                        ),
                      ),

                      Container(
                        // height: 165,
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
                        padding:const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white60),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Changepassword_popup();
                              },
                              child: Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.password,
                                            color: ColorValues.Splash_bg_color1,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: const Text(
                                            "Change Password",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            Container(
                                margin: const EdgeInsets.only(
                                    top: 8, left: 15, right: 15),
                                child: Divider(
                                  color: Colors.grey.shade700,
                                  thickness: 0.2,
                                )),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                         My_subscription(go_home: false)));
                              },
                              child: Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.subscriptions,
                                            color: ColorValues.Splash_bg_color1,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: const Text(
                                            "My Subscription",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                                margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
                                child: Divider(
                                  color: Colors.grey.shade700,
                                  thickness: 0.2,
                                )
                            ),

                            Data['kyc_verification'].toString() =="1"?
                            GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [

                                        Container(
                                          child: Image.asset("images/kyc.png",height: 25,width: 25,color: ColorValues.Splash_bg_color1,)
                                        ),

                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: const Text(
                                            "KYC",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),

                                        Container(
                                          margin: const EdgeInsets.only(left: 10,top: 2),
                                          height: 17,
                                          width: 75,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.green
                                          ),
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child:const Icon(Icons.check_circle,color: Colors.white,size: 12,),),
                                               Container(
                                                 margin:const EdgeInsets.only(left: 2),
                                                   child: const Text("Completed",style: TextStyle(color: Colors.white,fontSize: 9),))
                                            ],

                                          ),
                                        )
                                      ],
                                    ),

                                    // Container(
                                    //   child: const Icon(
                                    //     Icons.arrow_forward_ios,
                                    //     size: 16,
                                    //   ),
                                    // ),

                                  ],
                                ),
                              ),
                            ) :
                           const SizedBox(height: 0,),
                            // GestureDetector(
                            //   onTap: (){
                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=> Kyc_formView()));
                            //   },
                            //   child: Container(
                            //      color: Colors.transparent,
                            //     margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //
                            //         Row(
                            //           children: [
                            //             Container(
                            //               child: Image.asset("images/kyc.png",height: 26,width: 26,color: ColorValues.Splash_bg_color2,)
                            //             ),
                            //
                            //             Container(
                            //               margin: const EdgeInsets.only(left: 10),
                            //               child: const Text(
                            //                 "KYC Pending",
                            //                 style: TextStyle(
                            //                     fontSize: 14,
                            //                     fontWeight: FontWeight.w600),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //
                            //         Container(
                            //           child: const Icon(
                            //             Icons.arrow_forward_ios,
                            //             size: 16,
                            //           ),
                            //         ),
                            //
                            //       ],
                            //     ),
                            //   ),
                            // ),

                            Data['kyc_verification'].toString() =="1"?
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 8, left: 15, right: 15),
                                child: Divider(
                                  color: Colors.grey.shade700,
                                  thickness: 0.2,
                                )
                            ):
                            const SizedBox(height: 0,),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                         Wallet(index_tab: 0,)));
                              },
                              child: Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.wallet,
                                            color: ColorValues.Splash_bg_color1,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: const Text(
                                            "Wallet",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Container(
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),

                            Container(
                                margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
                                child: Divider(
                                  color: Colors.grey.shade700,
                                  thickness: 0.2,
                                )
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Payment_History()));
                              },
                              child: Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.history,
                                            color: ColorValues.Splash_bg_color1,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: const Text(
                                            "Payment History",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                                margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
                                child: Divider(
                                  color: Colors.grey.shade700,
                                  thickness: 0.2,
                                )
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyBasketSubscription()));
                              },
                              child: Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.shopping_basket,
                                            color: ColorValues.Splash_bg_color1,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: const Text(
                                            "My Basket Subscription",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Container(
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Logout();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.logout,
                                  color: ColorValues.Splash_bg_color1,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Delete_account();
                        },
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 20, right: 20, top: 20,bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.delete_outline,
                                  color: ColorValues.Splash_bg_color1,
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Delete account",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
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
      )
          : Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorValues.Splash_bg_color1,
                ),
              ),
            ),
    );
  }

  Logout() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
          return Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 15, left: 15),
                    child: const Text(
                      "Do you want to logout ?",
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
                                color: Colors.white
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Logoutt_Api();
                          },
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ColorValues.Splash_bg_color1, width: 0.4),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [
                                  0.1,
                                  0.7,
                                ],
                                colors: [
                                  ColorValues.Splash_bg_color1,
                                  ColorValues.Splash_bg_color3,
                                ],
                              ),
                            ),
                            child: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ));
        });
      },
    );
  }

  Delete_account() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
          return Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 15, left: 15),
                    child: const Text(
                      "Are you sure you want to delete this account ?",
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ColorValues.Splash_bg_color1,width: 0.4),
                                color: Colors.white
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "No",
                              style: TextStyle(
                                  color: Colors.black),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            DeleteAccount_Api();
                          },
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color:ColorValues.Splash_bg_color1, width: 0.4),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [
                                  0.1,
                                  0.7,
                                ],
                                colors: [
                                  ColorValues.Splash_bg_color1,
                                  ColorValues.Splash_bg_color3,
                                ],
                              ),
                            ),
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ));
        });
      },
    );
  }

  Changepassword_popup() {
    return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    elevation: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: const Text(
                          'Change Password',
                          style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: const Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: Container(
                      // height:300,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Form(
                          child: Column(
                            children: [
                              const Divider(
                                color: Colors.black,
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                  margin:const EdgeInsets.only(top: 10, left: 1, right: 1),
                                  child: TextFormField(
                                    obscureText: obscureText,
                                    cursorColor: Colors.black,
                                    cursorWidth: 1.1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Current Password';
                                      }
                                      return null;
                                    },
                                    controller: current_password,
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
                                      hintText: "Current Password",
                                      contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                      hintStyle:const TextStyle(
                                          fontSize: 13
                                      ),
                                      prefixIcon:const Icon(Icons.password),
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
                                  width: MediaQuery.of(context).size.width,
                                  margin:const EdgeInsets.only(top: 18, left: 1, right: 1),

                                  child: TextFormField(
                                    obscureText: obscureText1,
                                    cursorColor: Colors.black,
                                    cursorWidth: 1.1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter New Password';
                                      }
                                      return null;
                                    },
                                    controller: new_password,
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

                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin:const EdgeInsets.only(top: 18, left: 1, right: 1),
                                  child: TextFormField(
                                    obscureText: obscureText2,
                                    cursorColor: Colors.black,
                                    cursorWidth: 1.1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Confirm New Password';
                                      }
                                      return null;
                                    },
                                    controller: confirmnew_password,
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
                                          passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible2 = !passwordVisible2;
                                            if (passwordVisible2 == false) {
                                              obscureText2 = true;
                                            } else if (passwordVisible2 == true) {
                                              obscureText2 = false;
                                            }
                                          }
                                          );
                                        },
                                      ),
                                    ),
                                  )
                              ),

                              GestureDetector(
                                onTap: () {
                                  if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$').hasMatch(new_password.text)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                     const SnackBar(
                                        content: Text("Password should be min 8 characters long\nand include a special character, a numeric\nand a capital letter, and a small letter.",
                                            style: TextStyle(color: Colors.white)),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }

                                  else if(new_password.text != confirmnew_password.text){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                     const SnackBar(
                                        content: Text("Confirm New Password did not Match your New Password",
                                            style: TextStyle(color: Colors.white)),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                  else{
                                    changePassword_Api(context, setState);
                                  }

                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    // width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(
                                        top: 32, left: 5, right: 5),
                                    padding: const EdgeInsets.only(left: 10),
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [
                                          0.1,
                                          0.7,
                                        ],
                                        colors: [
                                          ColorValues.Splash_bg_color1,
                                          ColorValues.Splash_bg_color3,
                                        ],
                                      ),
                                    ),
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
            }) ??
        false;
  }

  Edit_profile_popup() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 20),
                              child: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text(
                              "Update Profile",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 45,
                        margin:
                            const EdgeInsets.only(top: 20, left: 35, right: 35),
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorValues.Splash_bg_color2,
                            width: 0.3,
                          ),
                        ),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Allows only letters and spaces
                          ],
                          controller: name,
                          textInputAction: TextInputAction.done,
                          onSaved: (email) {},
                          decoration: const InputDecoration(
                            hintText: "Name",
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              size: 25,
                            ),
                            contentPadding: EdgeInsets.only(top: 9),
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 15, left: 35, right: 35),
                        padding: const EdgeInsets.only(left: 15, right: 15,bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorValues.Splash_bg_color2,
                            width: 0.3,
                          ),
                        ),
                        child: TextFormField(
                          enabled: false,
                          maxLines: 2,
                          controller: email,
                          textInputAction: TextInputAction.done,
                          onSaved: (email) {},
                          decoration: const InputDecoration(
                            hintText: "Email",
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              size: 25,
                            ),
                            contentPadding: EdgeInsets.only(top: 18),
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        margin: const EdgeInsets.only(top: 15, left: 35, right: 35),
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorValues.Splash_bg_color2,
                            width: 0.3,
                          ),
                        ),
                        child: TextFormField(
                          enabled: false,
                          controller: phone,
                          textInputAction: TextInputAction.done,
                          onSaved: (email) {},
                          decoration: const InputDecoration(
                            hintText: "Phone",
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              size: 25,
                            ),
                            contentPadding: EdgeInsets.only(top: 9),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          updateProfile_Api(context, setState);
                        },
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          child: Container(
                            height: 45,
                            margin: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [
                                  0.1,
                                  0.7,
                                ],
                                colors: [
                                  ColorValues.Splash_bg_color1,
                                  ColorValues.Splash_bg_color3,
                                ],
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

}
