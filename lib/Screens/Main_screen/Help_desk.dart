import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';

class Help_desk extends StatefulWidget {
  const Help_desk({Key? key}) : super(key: key);

  @override
  State<Help_desk> createState() => _Help_deskState();
}

class _Help_deskState extends State<Help_desk> {

  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();


  bool? Status;
  String? Message;
  String? loader="false";
  AddHelpDesk_Apii() async {
    var data = await API.AddHelpDesk_Api(subject.text,message.text);
    print("Data: $data");
    setState(() {
      Status = data['status'];
      Message = data['message'];
    });

    if(Status==true){
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$Message',style:const TextStyle(color: Colors.white)),
          duration:const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

      subject.clear();
      message.clear();

      HelpDesk_Apii();


      loader="true";

    }

    else{
      setState(() {

      });
      loader="No_data";
      print("Error");
    }

  }

  bool? Status1;
  var HelpDeskData=[];
  String? loader1="false";
  List<String> time=[];
  List entryTime=[];
  HelpDesk_Apii() async {
    var data = await API.HelpDesk_Api();
    print("Data: $data");
    setState(() {
      Status1 = data['status'];
    });

    if(Status1==true){
      setState(() {});
      HelpDeskData=data['data'];
      print("DDDDD: $HelpDeskData");

      for(int i=0; i<HelpDeskData.length; i++){
        time.add(HelpDeskData[i]['created_at']);
        entryTime = time.map((dateTimeString) {
          DateTime dateTime = DateTime.parse(dateTimeString);
          return DateFormat('d MMM, yyyy').format(dateTime);
        }).toList();
      }


      HelpDeskData.length>0?
      loader1="true":
      loader1="No_data";

    }

    else{
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HelpDesk_Apii();
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
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: const Text(
            "Help Desk",
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Add_query_popup();
              },
              child: Container(
                height: 28,
                width: 85,
                margin: const EdgeInsets.only(right: 15, top: 13, bottom: 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorValues.Splash_bg_color1),
                alignment: Alignment.center,
                child: const Text(
                  "Add Query",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          ],
        ),
      body: loader1=="true"?
      Container(
        margin:const EdgeInsets.only(top: 15),
        child: ListView.builder(
          itemCount: HelpDeskData.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin:const EdgeInsets.only(left: 15,right: 15,bottom: 7,top: 7),
              // height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300)
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:const EdgeInsets.only(top: 7,left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/1.5,
                              child: Text("${HelpDeskData[index]['subject']}",style:const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                            ),
                            Container(
                              margin:const EdgeInsets.only(top: 3,bottom: 7),
                              width: MediaQuery.of(context).size.width/1.5,
                              child: Text("${HelpDeskData[index]['message']}",
                                style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey.shade500),),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  Container(
                    alignment: Alignment.topRight,
                    margin:const EdgeInsets.only(bottom: 8,right: 8),
                    child: Text("${entryTime[index]}",style:const TextStyle(fontSize: 10),),
                  ),

                ],
              ),
            );
          },

        ),
      ):
      loader1=="false"?
      Container(
          child:const Center(
            child: CircularProgressIndicator(color: Colors.black,),
          )
      ):
      Container(
          child:const Center(
              child: Text("No data found...")
          )
      )
    );
  }

  Add_query_popup() {
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
                              'Add Query',
                              style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w600),
                            )
                        ),
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
                                  margin:const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    cursorWidth: 1.1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Subject';
                                      }
                                      return null;
                                    },
                                    controller: subject,
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
                                      hintText: "Subject",
                                      contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                      hintStyle:const TextStyle(
                                          fontSize: 13
                                      ),
                                      prefixIcon:const Icon(Icons.subject),
                                    ),
                                  )
                              ),

                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin:const EdgeInsets.only(top: 18, left: 10, right: 10),
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    cursorWidth: 1.1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Message';
                                      }
                                      return null;
                                    },
                                    controller: message,
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
                                      hintText: "Message",
                                      contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
                                      hintStyle:const TextStyle(
                                          fontSize: 13
                                      ),
                                      prefixIcon:const Icon(Icons.message),
                                    ),
                                  )
                              ),

                              GestureDetector(
                                onTap: () {
                                  AddHelpDesk_Apii();
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
                                    )
                                ),
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
}
