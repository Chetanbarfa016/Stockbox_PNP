import 'package:flutter/material.dart';
import 'package:stock_box/Constants/Colors.dart';

class TableView extends StatefulWidget {
  const TableView({Key? key}) : super(key: key);

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
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
        title:const Text("Table View",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin:const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              width:MediaQuery.of(context).size.width,
              margin:const EdgeInsets.only(left: 20,right: 20),
              child: Column(
                children: [
                  Container(
                    margin:const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child:const Text("Investment Amount :",style: TextStyle(fontSize: 13),),
                            ),
                            Container(
                              margin:const EdgeInsets.only(top: 2),
                              child:const Text("₹10000",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            )
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child:const Text("Current Value :",style: TextStyle(fontSize: 13),),
                            ),
                            Container(
                              margin:const EdgeInsets.only(top: 2),
                              child:const Text("₹11000",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),

                  Container(
                    child: Divider(color: Colors.grey.shade300,),
                  ),

                  Container(
                    margin:const EdgeInsets.only(top: 3,bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child:const Text("Profit / Loss :",style: TextStyle(fontSize: 13),),
                            ),
                            Container(
                              margin:const EdgeInsets.only(top: 2),
                              child:const Text("+1000",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.green),),
                            ),
                          ],
                        ),

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Container(
                        //       child:const Text("Current Value :",style: TextStyle(fontSize: 15),),
                        //     ),
                        //     Container(
                        //       margin:const EdgeInsets.only(top: 2),
                        //       child:const Text("₹11000",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                        //     )
                        //   ],
                        // )

                      ],
                    ),
                  ),

                ],
              ),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columnSpacing: 30,
                    headingRowHeight: 50,
                    headingRowColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                        if (states
                            .contains(MaterialState.hovered)) {
                          return ColorValues.Splash_bg_color1.withOpacity(
                              0.5); // Color when hovered
                        }

                        return ColorValues
                            .Splash_bg_color1; // Default color
                      },
                    ),
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('Name',
                            style: TextStyle(
                                fontSize: 11, color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text('Type',
                            style: TextStyle(
                                fontSize: 11, color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text('Price',
                            style: TextStyle(
                                fontSize: 11, color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text('Weightage',
                            style: TextStyle(
                                fontSize: 11, color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text('Quantity',
                            style: TextStyle(
                                fontSize: 11, color: Colors.white)),
                      ),

                      DataColumn(
                        label: Text('CMP',
                            style: TextStyle(
                                fontSize: 11, color: Colors.white)),
                      ),


                    ],

                    rows:
                    List<DataRow>.generate(
                        8, (index) {

                      return DataRow(
                          color: MaterialStateColor.resolveWith(
                                  (Set<MaterialState> states) {
                                return Colors.white; // Default color
                              }),
                          cells: <DataCell>[
                            DataCell(
                                Container(
                                  // width: 100,
                                    child:const Text(
                                      'TATA POWER',
                                      style:const TextStyle(fontSize: 12),
                                    ))),


                            DataCell(Container(
                                child:const Text("Buy",style:const TextStyle(fontSize: 12),)
                            )),


                            DataCell(Container(
                              child:const Text(
                                '₹1000',
                                style: TextStyle(fontSize: 12,color: Colors.green),
                              ),
                            )
                            ),


                            DataCell(Container(
                                child:const Text(
                                  '20%',
                                  style: TextStyle(fontSize: 12,color: Colors.black),
                                )
                            )),

                            DataCell(Container(
                                child:const Text(
                                  '10',
                                  style: TextStyle(fontSize: 12,color: Colors.black),
                                )
                            )),

                            DataCell(Container(
                                child:const Text(
                                  '₹1100',
                                  style: TextStyle(fontSize: 12,color: Colors.green),
                                )
                            )),

                          ]
                      );

                    }))),
          ],
        ),
      ),
    );
  }
}
