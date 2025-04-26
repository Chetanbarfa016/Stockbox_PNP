import 'package:flutter/material.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:stock_box/Global_widgets/Results/Declared.dart';
import 'package:stock_box/Global_widgets/Results/Upcoming.dart';
import 'package:stock_box/Screens/Main_screen/Stock_detail.dart';
import 'package:stock_box/Screens/Main_screen/Trades/Stocks.dart';

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

  bool show=false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            title:const Text("Results",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
            bottom: TabBar(
              unselectedLabelColor: Colors.grey,
              indicatorColor: ColorValues.Splash_bg_color2,
              labelColor: Colors.black,
              labelStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
              tabs: [
                Tab(text: 'Upcoming'),
                Tab( text: 'Declared'),
              ],
            ),

          ),

          body: TabBarView(
            children: [
              Upcoming_results(),
              Declared_results(),
            ],
          )

      ),
    );
  }
}
