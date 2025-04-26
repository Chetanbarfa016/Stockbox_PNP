import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';

class Terms_condition extends StatefulWidget {
  const Terms_condition({Key? key}) : super(key: key);

  @override
  State<Terms_condition> createState() => _Terms_conditionState();
}

class _Terms_conditionState extends State<Terms_condition> {

  var Data;
  bool? Status;
  bool loader = false;

  TermsCondition_Api() async {
    var data = await API.TermsCondition_Api();
    setState(() {
      Status = data['status'];
    });

    if(Status==true){
      setState(() {});
      Data = data['data'];

      print("Dataaaaaa: $Data");

      loader=true;
    }

    else{
      print("error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TermsCondition_Api();
  }

  String removeHtmlTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
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
            child:const Icon(Icons.arrow_back,color: Colors.black,)),
        title:const Text("Terms & Conditions",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),

      body: loader==true?
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin:const EdgeInsets.only(top: 20,left: 20),
              child: Text("${Data['title']}",style:const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
            ),

            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 5, left: 15, right: 20, bottom: 0),
              child: Html(
                data: Data['description'], // HTML content directly render karein
                style: {
                  "p": Style(fontSize: FontSize.medium),
                  "h1": Style(fontSize: FontSize.large, fontWeight: FontWeight.bold),
                },
              ),
            ),
          ],
        ),
      ):

          Container(
            child: Center(
              child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
            ),
          )
    );
  }
}
