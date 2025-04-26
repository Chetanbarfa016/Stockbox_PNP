import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Screens/Onboarding_screen/Login.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Screens/Onboarding_screen/Otp.dart';

class Signup extends StatefulWidget {
 String? referralCode;
   Signup({super.key, required this.referralCode});

  @override
  State<Signup> createState() => _SignupState(referralCode:referralCode);
}

class _SignupState extends State<Signup> {
  String? referralCode;
  _SignupState({
    required this.referralCode
});

  TextEditingController username =TextEditingController();
  TextEditingController password =TextEditingController();
  TextEditingController name =TextEditingController();
  TextEditingController email =TextEditingController();
  TextEditingController referral =TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  bool _isChecked = false;

  bool obscureText = true, passwordVisible = false;
  bool obscureText1 = true, passwordVisible1 = false;

  String? _selectedState;
  List<String> _indianStates = [];

   State_Api() async {
    var data = await API.getState_Api();
    final List<Map<String, dynamic>> stateData = List<Map<String, dynamic>>.from(data);
    _indianStates = stateData.map((e) => e['name'] as String).toList();
     setState(() {});
  }

  String? _selectedCity="Select City";
  List<String> _City = [];

  City_Api(_selectedState) async {
    _City.clear();
    _selectedCity="Select City";
    var data = await API.getCity_Api(_selectedState);
    final List<Map<String, dynamic>> stateData = List<Map<String, dynamic>>.from(data);
    _City = stateData.map((e) => e['city'] as String).toList();
    setState(() {});

    print("City: $_City");
  }


  bool? Status;
  String? loader = "false";
  String? Message;

  String? Otp;
  String? Email;

  Register() async {
    openAlertBox();
    try {
      var data = await API.register_Api(username.text,password.text,name.text,email.text,referral.text,_selectedState,_selectedCity);
      print("Data: $data");
      setState(() {
        Status = data['status'];
        Message = data['message'];
        print("Statussss: $Status");
      });

      if(Status==true){

        Otp=data['otp'].toString();
        Email=data['email'];

        print("Otpppp: $Otp");
        print("Emailll: $Email");

        setState(() {

        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$Message',style: TextStyle(color: Colors.white)),
            duration:Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(context, MaterialPageRoute(builder: (context)=>Otps(Otp:Otp,Email:Email)));

      }

      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$Message',style: TextStyle(color: Colors.white)),
            duration:Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    }
    catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
        setState(() {
          loader = "No_data";
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    State_Api();

    print("555555555555555 :$referralCode");
    referralCode != ""?
    _isChecked=true:
    _isChecked=false;
    referral.text=referralCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    print(height);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorValues.Splash_bg_color1,
              ColorValues.Splash_bg_color1,
              ColorValues.Splash_bg_color1,
            ],
          ),
        ),

        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/3.9,
                child: Column(
                  children: [
                    // const Spacer(),
                    const SizedBox(height: 50,),
                    Container(
                      margin:const EdgeInsets.only( left: 35, right: 10,top: 25),
                      alignment: Alignment.topLeft,
                      child: Text("Create Your\nAccount", style:
                      TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800
                      ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                decoration:const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    color: Colors.white
                ),
                height: MediaQuery.of(context).size.height- MediaQuery.of(context).size.height/3.9,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          margin:const EdgeInsets.only(top: 20, left: 35, right: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topLeft,
                          child:const Text("Full Name", style:
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
                            keyboardType: TextInputType.text,
                            cursorWidth: 1.1,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Allows only letters and spaces
                              CustomInputFormatter(), // Prevents multiple spaces
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please Enter Full Name';
                              }
                              return null;
                            },
                            controller: name,
                            style:const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width:1.1),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1)
                                ),
                                hintText: "Full Name",
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
                            inputFormatters: [ // Allows only letters and spaces
                              SpaceRemover(), // Prevents multiple spaces
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email';
                              }
                              if(!RegExp(r'\S+@\S+\.+\S+').hasMatch(email.text)){
                                return 'Please enter valid email address';
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
                                    borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1)
                                ),
                                hintText: "Email",
                                contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                hintStyle:const TextStyle(
                                    fontSize: 13
                                ),
                                prefixIcon: Icon(Icons.email)
                            ),
                          )
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
                            keyboardType: TextInputType.phone,
                            cursorColor: Colors.black,
                            cursorWidth: 1.1,
                            inputFormatters: [
                              MobileNo(), // Prevents multiple spaces
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Mobile No.';
                              }
                              if (value.length != 10 ) {
                                return 'The contact number must be 10 digits';
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
                                hintText: "Mobile No.",
                                contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                hintStyle:const TextStyle(
                                    fontSize: 13
                                ),
                                prefixIcon: Icon(Icons.phone)
                            ),
                          )
                        ),

                        Container(
                          margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topLeft,
                          child:const Text("State", style:
                          TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding:const EdgeInsets.only(left: 35, right: 35, top: 10),
                          child: DropdownButtonFormField<String>(
                            value: _selectedState,
                            menuMaxHeight: 350,
                            isExpanded: true,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1)
                                ),
                                hintText: "Select State",
                                contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                hintStyle:const TextStyle(
                                    fontSize: 13
                                ),
                                prefixIcon: Icon(Icons.location_on)
                            ),
                            hint: const Text('Select State'),
                            items: _indianStates.map((String state) {
                              return DropdownMenuItem<String>(
                                value: state,
                                child: Text(state),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedState = newValue;
                                _selectedCity="Select City";
                                City_Api(_selectedState);
                              });
                            },
                          ),
                        ),

                        Container(
                          margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topLeft,
                          child:const Text("City", style:
                          TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35, right: 35, top: 10),
                          child: DropdownButtonFormField<String>(
                            value: _City.contains(_selectedCity) ? _selectedCity : null,
                            menuMaxHeight: 350,
                            isExpanded: true,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: ColorValues.Splash_bg_color1, width: 1.1),
                              ),
                              hintText: "Select City",
                              contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
                              hintStyle: const TextStyle(fontSize: 13),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            hint: Text('$_selectedCity'),
                            items: _City.toSet().toList().map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCity = newValue!;
                              });
                            },
                          ),
                        ),




                        Container(
                          margin:const EdgeInsets.only(top: 15, left: 35, right: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topLeft,
                          child:const Text("Password", style:
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
                            obscureText: obscureText,
                            cursorColor: Colors.black,
                            cursorWidth: 1.1,
                            inputFormatters: [ // Allows only letters and spaces
                              Password(), // Prevents multiple spaces
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$').hasMatch(value)) {
                                return "Password should be min 8 characters long\nand include a special character, a numeric\nand a capital letter, and a small letter.";
                              }
                              return null;
                            },
                            controller: password,
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
                                hintText: "Password",
                                contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                hintStyle:const TextStyle( fontSize: 13 ),
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

                        Row(
                          children: [
                            Container(
                              margin:const EdgeInsets.only(top: 5, left: 20),
                              child: Checkbox(
                                value: _isChecked,
                                activeColor: ColorValues.Splash_bg_color1,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = !_isChecked;
                                  });
                                  print(_isChecked);
                                  if(_isChecked==false){
                                    referral.text="";
                                  }
                                  else{

                                  }


                                },
                              ),
                            ),

                            Container(
                              margin:const EdgeInsets.only(top: 5, left: 1, right: 20),
                              // padding:const EdgeInsets.only(),
                              alignment: Alignment.topLeft,
                              child:const Text("If any Referral", style:
                              TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),

                        _isChecked==true?
                        Container(
                            margin:const EdgeInsets.only(top: 2, left: 35, right: 35),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              cursorWidth: 1.1,
                              validator: (value) {
                                if (_isChecked==true && (value == null || value.isEmpty)) {
                                  return 'Please Enter Referral';
                                }
                                return null;
                              },
                              controller: referral,
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
                                hintText: "Referral",
                                contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                hintStyle:const TextStyle(
                                    fontSize: 13
                                ),
                                prefixIcon:const Icon(Icons.add_card),
                              ),
                            )
                        ):
                        const SizedBox(height: 0,),

                        GestureDetector(
                          onTap: (){
                            if (_formKey.currentState!.validate()) {
                              if(_selectedState== null|| _selectedState=="Select State"){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Setect State',style:const TextStyle(color: Colors.white)),
                                    duration:Duration(seconds: 3),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              else if(_selectedCity== null||_selectedCity=="Select City"){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Setect City',style:const TextStyle(color: Colors.white)),
                                    duration:Duration(seconds: 3),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              else{
                                Register();
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
                              margin:const EdgeInsets.only(top: 20, left: 30, right: 30),
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
                                  child:const Text(
                                    "SIGN UP",
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
                                  )
                              ),

                            ),
                          ),
                        ),

                        Container(
                          margin:const EdgeInsets.only(top: 12, left: 35, right: 35,bottom: 20),
                          // padding:const EdgeInsets.only(),
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? ", style:
                              TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
                                },
                                child: Text("Sign In", style:
                                TextStyle(color: ColorValues.Splash_bg_color1, fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],

                          ),
                        ),
                        SizedBox(height: 250,)
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

  openAlertBox() async {
    setState(() {});
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 37,
                      width: 37,
                      color:Colors.transparent,
                      child:const CircularProgressIndicator(color: Colors.black,)
                  ),
                ],
              )
          );
        }
    );
  }
}


class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Prevent leading spaces and multiple consecutive spaces
    String newText = newValue.text;

    // Remove leading spaces
    newText = newText.replaceAll(RegExp(r'^\s+'), '');

    // Replace multiple consecutive spaces with a single space
    newText = newText.replaceAll(RegExp(r'\s{2,}'), ' ');

    // Return the modified text with the correct cursor position
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class SpaceRemover extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove all spaces
    String newText = newValue.text.replaceAll(' ', '');

    // Calculate the new cursor position
    int offset = newValue.selection.baseOffset -
        (newValue.text.length - newText.length);

    // Ensure the cursor position is within valid range
    offset = offset.clamp(0, newText.length);

    // Return the modified text with the adjusted cursor position
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}


class MobileNo extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove all non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 10 digits
    if (newText.length > 10) {
      newText = newText.substring(0, 10);
    }

    // Calculate the new cursor position
    int offset = newValue.selection.baseOffset -
        (newValue.text.length - newText.length);

    // Ensure the cursor position is within valid range
    offset = offset.clamp(0, newText.length);

    // Return the modified text with the adjusted cursor position
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}


class Password extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove all spaces
    String newText = newValue.text.replaceAll(' ', '');

    // Trim the text to 15 characters
    if (newText.length > 15) {
      newText = newText.substring(0, 15);
    }

    // Calculate the new cursor position
    int offset = newValue.selection.baseOffset - (newValue.text.length - newText.length);

    // Ensure the cursor position is within bounds
    offset = offset.clamp(0, newText.length);

    // Return the modified text with the updated cursor position
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
