import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stock_box/Constants/Colors.dart';

class Stock_detail extends StatefulWidget {
  const Stock_detail({Key? key}) : super(key: key);

  @override
  State<Stock_detail> createState() => _Stock_detailState();
}

class _Stock_detailState extends State<Stock_detail> {

  int selectedOption = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 0,
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        // title:const Text("Detail",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
           children: [
             Container(
               margin:const EdgeInsets.only(left: 10,right: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(
                     margin: const EdgeInsets.only(top: 8, left: 10),
                     child: const Text(
                       "TATA MOTORS",
                       style: TextStyle(
                           fontSize: 15,
                           color: Colors.black,
                           fontWeight: FontWeight.w600),
                     ),
                   ),
                   Container(
                     margin: const EdgeInsets.only(top: 8, right: 8),
                     child: const Text(
                       "572.70",
                       style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w600),
                     ),
                   ),
                 ],
               ),
             ),

             Container(
               margin:const EdgeInsets.only(left: 10,right: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(
                     margin: const EdgeInsets.only(top: 8, left: 10),
                     child: const Text(
                       "TATA MOTORS LIMITED",
                       style: TextStyle(
                           fontSize: 12,
                           color: Colors.grey,
                           fontWeight: FontWeight.w500),
                     ),
                   ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 8, right: 6),
                         child:const CircleAvatar(
                           radius: 8,
                           backgroundColor: Colors.green,
                           child: Icon(Icons.arrow_upward,size: 12,color: Colors.white,),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 8, right: 8),
                         child: const Text(
                           "+0.00",
                           style: TextStyle(fontSize: 12, color: Colors.green),
                         ),
                       ),
                     ],
                   ),

                 ],
               ),
             ),

             Container(
               margin:const EdgeInsets.only(left: 14,right: 10,top: 7),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Container(
                         width: 30,
                         height: 10,
                         child: Radio<int>(
                           value: 1,
                           groupValue: selectedOption,
                           onChanged: (value) {
                             setState(() {
                               selectedOption = value!;
                             });
                           },
                         ),
                       ),

                       Container(
                         margin: const EdgeInsets.all(0),
                         child: const Text(
                           "NSE",
                           style: TextStyle(fontSize: 12, color: Colors.black),
                         ),
                       ),

                       Container(
                         margin:const EdgeInsets.only(left: 15),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Container(
                               width: 30,
                               height: 10,
                               child: Radio<int>(
                                 activeColor: Colors.red,
                                 fillColor:MaterialStateProperty.all(Colors.red),
                                 value: 0,
                                 groupValue: selectedOption,
                                 onChanged: (value) {
                                   setState(() {
                                     selectedOption = value!;
                                   });
                                 },
                               ),
                             ),

                             Container(
                               margin: const EdgeInsets.all(0),
                               child: const Text(
                                 "BSE",
                                 style: TextStyle(fontSize: 12, color: Colors.black),
                               ),
                             ),

                           ],
                         ),
                       ),

                     ],
                   ),

                   Container(
                     margin:const EdgeInsets.only(right: 8),
                     child: const Text(
                       "(+0.00%)",
                       style: TextStyle(
                           fontSize: 12,
                           color: Colors.green,
                           fontWeight: FontWeight.w500
                       ),
                     ),
                   ),

                 ],
               ),
             ),

             Container(
               margin:const EdgeInsets.only(top: 10,left: 10,right: 10),
               child: Divider(color: Colors.grey.shade300,),
             ),

             Container(
               alignment: Alignment.topLeft,
               margin:const EdgeInsets.only(top: 7,left: 20),
               child:const Text("Overview",style: TextStyle(fontSize: 18,),),
             ),

             Container(
               height: 200,
               margin:const EdgeInsets.only(left: 0,right: 40,top: 30),
               child: LineChart(
                 LineChartData(
                   gridData: FlGridData(show: true),
                   titlesData: FlTitlesData(
                     rightTitles: AxisTitles(
                       sideTitles: SideTitles(showTitles: false), // Hide right titles
                     ),
                     topTitles: AxisTitles(
                       sideTitles: SideTitles(showTitles: false), // Hide top titles
                     ),
                   ),
                   borderData: FlBorderData(
                     show: true,
                     border:const Border(
                       top: BorderSide.none, // Hide the top border
                       right: BorderSide.none, // Hide the right border
                       left: BorderSide(color: Colors.black),
                       bottom: BorderSide(color: Colors.black),
                     ),
                   ),
                   lineBarsData: [
                     LineChartBarData(
                       spots: [
                         FlSpot(0, 1),
                         FlSpot(1, 3),
                         FlSpot(2, 2),
                         FlSpot(3, 4),
                       ],
                       isCurved: true,
                       color: Colors.blue,
                       dotData: FlDotData(show: true),
                       belowBarData: BarAreaData(show: false),
                     ),
                   ],
                   minX: 0,
                   maxX: 3,  // Adjust to limit the x-axis range shown
                   minY: 0,
                   maxY: 5,
                 ),
               ),
             ),

             Container(
               margin:const EdgeInsets.only(top: 15,left: 10,right: 10),
               child: Divider(color: Colors.grey.shade300,),
             ),

             Container(
               alignment: Alignment.topLeft,
               margin:const EdgeInsets.only(top: 7,left: 20),
               child: Text("Live market snapshot",style: TextStyle(fontSize: 18,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600,letterSpacing: 0.4),),
             ),

             Container(
               margin:const EdgeInsets.only(left: 10,right: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, left: 10),
                         child:  Text(
                           "Today's low",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,left: 10),
                         child: const Text(
                           "100.10",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, right: 10),
                         child:  Text(
                           "Today's high",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,right: 10),
                         child: const Text(
                           "140.10",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),

                 ],
               ),
             ),

             Container(
               margin:const EdgeInsets.only(left: 10,right: 10,top: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, left: 10),
                         child:  Text(
                           "52 weeks low",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,left: 10),
                         child: const Text(
                           "10.10",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, right: 10),
                         child:  Text(
                           "52 weeks low",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),

                       Container(
                         margin: const EdgeInsets.only(top: 6,right: 10),
                         child: const Text(
                           "250.10",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),

                     ],
                   ),
                 ],
               ),
             ),

             Container(
               margin:const EdgeInsets.only(left: 10,right: 10,top: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, left: 10),
                         child:  Text(
                           "Open",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,left: 10),
                         child: const Text(
                           "100.10",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, right: 10),
                         child:  Text(
                           "Prev. close",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,right: 10),
                         child: const Text(
                           "90.10",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
             ),

             Container(
               alignment: Alignment.topLeft,
               margin:const EdgeInsets.only(top: 25,left: 20),
               child: Text("Fundamentals",style: TextStyle(fontSize: 18,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600,letterSpacing: 0.4),),
             ),

             Container(
               margin:const EdgeInsets.only(left: 10,right: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, left: 10),
                         child:  Text(
                           "Market cap",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,left: 10),
                         child: const Text(
                           "3.99 lakh crores",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, right: 10),
                         child:  Text(
                           "ROE",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,right: 10),
                         child: const Text(
                           "19.5%",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),

                 ],
               ),
             ),

             Container(
               margin:const EdgeInsets.only(left: 10,right: 10,top: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, left: 10),
                         child:  Text(
                           "P/E ratio",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,left: 10),
                         child: const Text(
                           "52.01",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, right: 10),
                         child:  Text(
                           "P/B ratio",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,right: 10),
                         child: const Text(
                           "12.01",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),

                     ],
                   ),
                 ],
               ),
             ),

             Container(
               margin:const EdgeInsets.only(left: 10,right: 10,top: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, left: 10),
                         child:  Text(
                           "Industry P/E",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,left: 10),
                         child: const Text(
                           "34.77",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Container(
                         margin: const EdgeInsets.only(top: 15, right: 10),
                         child:  Text(
                           "Dividend yield",
                           style: TextStyle(
                               fontSize: 14,
                               color: Colors.grey.shade600,
                               fontWeight: FontWeight.w500),
                         ),
                       ),
                       Container(
                         margin: const EdgeInsets.only(top: 6,right: 10),
                         child: const Text(
                           "1.17%",
                           style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500),
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
             ),

             Container(
               alignment: Alignment.topLeft,
               margin:const EdgeInsets.only(top: 25,left: 20),
               child: Text("About",style: TextStyle(fontSize: 18,color: ColorValues.Splash_bg_color1,fontWeight: FontWeight.w600,letterSpacing: 0.4),),
             ),

             Container(
               alignment: Alignment.topLeft,
               margin:const EdgeInsets.only(top: 12,left: 20),
               child: Row(
                 children: [
                   Container(
                     width: 100,
                     child:const Text("Founded :"),
                   ),
                   Container(
                     margin:const EdgeInsets.only(left: 25),
                     child:const Text("1945"),
                   ),
                 ],
               ),
             ),

             Container(
               alignment: Alignment.topLeft,
               margin:const EdgeInsets.only(top: 12,left: 20),
               child: Row(
                 children: [
                   Container(
                     width: 100,
                     child:const Text("Headquarters :"),
                   ),

                   Container(
                     margin:const EdgeInsets.only(left: 25),
                     child:const Text("Mumbai"),
                   ),
                 ],
               ),
             ),

             Container(
               alignment: Alignment.topLeft,
               margin:const EdgeInsets.only(top: 12,left: 20,right: 10,bottom: 25),
               child:const Text("Tata Motors Limited is a leading global automobile manufacturer of cars, tility vehicles,buses,trucks and defence vehicles")
             ),
           ],
          ),
        ),
      ),

    );
  }
}
