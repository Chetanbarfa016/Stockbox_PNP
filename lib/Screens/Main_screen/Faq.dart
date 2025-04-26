import 'package:flutter/material.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {

  var Faq_data;
  bool? Status;
  bool loader = false;

  Faq_Api() async {
    var data = await API.Faq_Api();
    setState(() {
      Status = data['status'];
    });

    print("Dataaaaaa: $Faq_data");

    if(Status==true){
      setState(() {});
      Faq_data = data['data'];

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
    Faq_Api();
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
        title:const Text("FAQ's",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),

      body: loader == true ?

       Container(
          margin:const EdgeInsets.only(bottom: 15),
          height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
               children: [
                Container(
                 padding:const EdgeInsets.only(bottom: 10),
                 width: MediaQuery.of(context).size.width,
                 margin:const EdgeInsets.only(left: 15,right: 15,top: 20),
                 decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            margin:const EdgeInsets.only(top: 20,left: 20),
                            child: Icon(Icons.question_answer,size: 30,color: ColorValues.Splash_bg_color1)
                        ),
                        Container(
                            margin:const EdgeInsets.only(top: 20,left: 10),
                            child: Text("Frequently Asked Question",style: TextStyle(fontSize: 16,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w700),)
                        )

                      ],
                    ),
                   /* Container(
                        margin:const EdgeInsets.only(top: 20,left: 20),
                        child:const Text("Need Help?",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.w700),)
                    ),*/
                    Container(
                      margin:const EdgeInsets.only(top: 5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics:const NeverScrollableScrollPhysics(),
                        itemCount:Faq_data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.grey.shade50,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent, // Removes the underline
                              ),
                              child: ExpansionTile(
                                title: Text("${Faq_data[index]['title']}",style:const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),),
                                children: [
                                  Container(
                                      alignment: Alignment.topLeft,
                                      margin:const EdgeInsets.only(left: 5,right: 5,bottom: 5, top: 5),
                                      padding:const EdgeInsets.only(left: 5,right: 5,bottom: 5, top: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ColorValues.Splash_bg_color1,
                                          width: 0.5
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text("${Faq_data[index]['description']}",
                                        style: TextStyle(fontSize: 12,letterSpacing: 0.05, color: Colors.black87,
                                      )
                                  )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          :
       Container(
           child: Center(
           child: CircularProgressIndicator(color: ColorValues.Splash_bg_color1,),
           ),
        ),

    );
  }
}
