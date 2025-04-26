import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Screens/Main_screen/Kyc/Digio_kyc.dart';

class Kyc_formView extends StatefulWidget {
  int? amount;
  String? planId;
  String? clientid;
  double? discount;
  String? couponCode;
  String? type;
  String? Inv_amount;
  Kyc_formView({Key? key, required this.amount,required this.planId,required this.clientid,required this.discount,required this.couponCode,required this.type,required this.Inv_amount}) : super(key: key);

  @override
  State<Kyc_formView> createState() => _Kyc_formViewState(amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount:Inv_amount);
}

class _Kyc_formViewState extends State<Kyc_formView> {
  int? amount;
  String? planId;
  String? clientid;
  double? discount;
  String? couponCode;
  String? type;
  String? Inv_amount;
  _Kyc_formViewState({
    required this.amount,
    required this.planId,
    required this.clientid,
    required this.discount,
    required this.couponCode,
    required this.type,
    required this.Inv_amount
});

    String? Name;
    String? Email;
    String? Phone;

    GetValue() async {
      SharedPreferences prefs= await SharedPreferences.getInstance();
      Name= prefs.getString("Name");
      Email= prefs.getString("Email");
      Phone= prefs.getString("Phone");
       print("Nameeeeeeeeee: $Name");

      setState(() {
        name.text=Name!;
        email.text=Email!;
        mobile.text=Phone!;
      });
    }

   TextEditingController name = TextEditingController();
   TextEditingController email = TextEditingController();
   TextEditingController mobile = TextEditingController();
   TextEditingController aadhar = TextEditingController();
   TextEditingController pan = TextEditingController();
   final _formKey = GlobalKey<FormState>();

   String? K_id;
   String? G_id;
   String? Customer_identifier;
   bool? loader_button=false;

   Digio() async {
     setState(() {
       loader_button=true;
     });
     SharedPreferences prefs= await SharedPreferences.getInstance();
     String? Id_Login = prefs.getString('Login_id');
    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/client/clientkycandagreement"),
        headers: {
          'Content-Type': 'application/json',
        },
        body:jsonEncode(
            {
              "id":"$Id_Login",
              "email":"${email.text}",
              "phone":"${mobile.text}",
              "name":"${name.text}",
              "panno":"${pan.text}",
              "aadharno":"${aadhar.text}"
            }
        )
    );
    var jsonString = jsonDecode(response.body);
    print("Jsnnnnnn: $jsonString");

     K_id= jsonString['kid'];
     G_id= jsonString['gid'];
     Customer_identifier= jsonString['customer_identifier'];

     print("K iddddd: $K_id");
     print("G iddddd: $G_id");
     print("Customer_identifier: $Customer_identifier");


     setState(() {
       loader_button=false;
     });

     Navigator.push(context, MaterialPageRoute(builder: (context)=> Digio_kyc(K_id:K_id,G_id:G_id,Customer_identifier:Customer_identifier,amount:amount,planId:planId,clientid:clientid,discount:discount,couponCode:couponCode,type:type,Inv_amount:Inv_amount)));
   }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetValue();
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
            onTap: (){
              Navigator.pop(context);
            },
            child:const Icon(Icons.arrow_back,color: Colors.black,)
        ),
        title:const Text("KYC",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),

      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin:const EdgeInsets.only(top: 30, left: 35, right: 20),
                  alignment: Alignment.topLeft,
                  child:const Text("Name", style:
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
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      controller: name,
                      style:const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width:1.1)
                          ),
                          hintText: "Name",
                          contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                          hintStyle:const TextStyle(
                              fontSize: 13
                          ),
                          prefixIcon:const Icon(Icons.person)
                      ),
                    )
                ),

                Container(
                  margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
                  alignment: Alignment.topLeft,
                  child:const Text("Email", style:
                  TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                    margin:const EdgeInsets.only(top: 10, left: 35, right: 35),
                    child: TextFormField(
                      enabled: false,
                      cursorColor: Colors.black,
                      cursorWidth: 1.1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        }
                        return null;
                      },
                      controller: email,
                      style:const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width:1.1)
                          ),
                          hintText: "Email",
                          contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                          hintStyle:const TextStyle(
                              fontSize: 13
                          ),
                          prefixIcon:const Icon(Icons.email)
                      ),
                    ),
                ),

                Container(
                  margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
                  // padding:const EdgeInsets.only(),
                  alignment: Alignment.topLeft,
                  child:const Text("Mobile No.", style:
                  TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                    margin:const EdgeInsets.only(top: 10, left: 35, right: 35),
                    child: TextFormField(
                      enabled: false,
                      cursorColor: Colors.black,
                      cursorWidth: 1.1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Plese Enter Mobile No.';
                        }
                        if (value.length != 10 ) {
                          return 'The contact number must be 10 digits';
                        }
                        return null;
                      },
                      controller: mobile,
                      style:const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width:1.1)
                          ),
                          hintText: "Mobile No.",
                          contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                          hintStyle:const TextStyle(
                              fontSize: 13
                          ),
                          prefixIcon:const Icon(Icons.phone)
                      ),
                    )
                ),

                Container(
                  margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
                  // padding:const EdgeInsets.only(),
                  alignment: Alignment.topLeft,
                  child:const Text("Aadhaar No.", style:
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
                          return 'Plese Enter Aadhaar No.';
                        }
                        if (value.length != 12 ) {
                          return 'The aadhaar number must be 12 digits';
                        }
                        return null;
                      },
                      controller: aadhar,
                      style:const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width:1.1)
                          ),
                          hintText: "Aadhaar No.",
                          contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                          hintStyle:const TextStyle(
                              fontSize: 13
                          ),
                          prefixIcon:Container(
                            padding: EdgeInsets.all(11),
                            child: Image.asset("images/aahar.png",height: 15,width: 15,color: Colors.grey,),
                          )
                      ),
                    )
                ),

                Container(
                  margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
                  // padding:const EdgeInsets.only(),
                  alignment: Alignment.topLeft,
                  child:const Text("PAN No.", style:
                  TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),

                // Container(
                //     margin:const EdgeInsets.only(top: 10, left: 35, right: 35),
                //     child: TextFormField(
                //       cursorColor: Colors.black,
                //       cursorWidth: 1.1,
                //       validator: (value) {
                //         if (value == null || value.isEmpty) {
                //           return 'Please Enter PAN No.';
                //         }
                //         String pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]$';
                //         RegExp regExp = RegExp(pattern);
                //         if (!regExp.hasMatch(value)) {
                //           return 'Please Enter Valid PAN No.';
                //         }
                //         return null;
                //       },
                //       controller: pan,
                //       style: const TextStyle(fontSize: 13),
                //       decoration: InputDecoration(
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10),
                //           borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
                //         ),
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10),
                //           borderSide: const BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
                //         ),
                //         hintText: "PAN No.",
                //         contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
                //         hintStyle: const TextStyle(fontSize: 13),
                //           prefixIcon:Container(
                //             padding: EdgeInsets.all(11),
                //             child: Image.asset("images/pan.png",height: 15,width: 15,color: Colors.grey,),
                //           )
                //       ),
                //     ),
                // ),

        Container(
        margin: const EdgeInsets.only(top: 10, left: 35, right: 35),
        child: TextFormField(
          cursorColor: Colors.black,
          cursorWidth: 1.1,
          controller: pan,
          style: const TextStyle(fontSize: 13),
          textCapitalization: TextCapitalization.characters, // 🔹 Automatically Capital Letters
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // 🔹 Only A-Z & 0-9 Allowed
          ],
          onChanged: (value) {
            pan.value = TextEditingValue(
              text: value.toUpperCase(), // 🔹 Convert to UpperCase
              selection: pan.selection,
            );
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter PAN No.';
            }
            String pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]$';
            RegExp regExp = RegExp(pattern);
            if (!regExp.hasMatch(value)) {
              return 'Please Enter Valid PAN No.';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:  BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
            ),
            hintText: "PAN No.",
            contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
            hintStyle: const TextStyle(fontSize: 13),
            prefixIcon: Container(
              padding: EdgeInsets.all(11),
              child: Image.asset("images/pan.png", height: 15, width: 15, color: Colors.grey),
            ),
          ),
        ),
      ),



      GestureDetector(
                  onTap: (){
                    if (_formKey.currentState!.validate()) {
                      Digio();
                    }
                    else{

                    }
                 },

                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    child:Container(
                      height: 50,
                      margin:const EdgeInsets.only(top: 40, left: 30, right: 30),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
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
                          child:loader_button==false?
                         const Text(
                            "Submit",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
                          ):
                          const CircularProgressIndicator(color: Colors.white)
                      ),

                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
