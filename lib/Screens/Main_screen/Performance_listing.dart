import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:stock_box/Constants/Util.dart';
import 'package:stock_box/Global_widgets/Pdf_view.dart';
import '../../Constants/Colors.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';



class PerformanceListing extends StatefulWidget {
  final String? serviceId;
  final String? segmentName;

  PerformanceListing({Key? key, required this.serviceId, required this.segmentName}) : super(key: key);

  @override
  State<PerformanceListing> createState() => _PerformanceListingState();
}

class _PerformanceListingState extends State<PerformanceListing> {
  late String serviceId;
  late String segmentName;

  bool? status;
  String? message;
  List<dynamic> closeSignalData = [];
  List<dynamic> filteredData = [];
  bool isButtonClicked = false;


  bool loader = false;

  Future<void> _fetchCloseSignalData() async {
    setState(() {
      loader = false;
      closeSignalData.clear();
      filteredData.clear();
    });

    print("'service_id': $serviceId,'search': ${searchController.text},  'page':'1'");
    print("Urllllll:${Util.Main_BasrUrl}/api/list/closesignal");
    var response = await http.post(Uri.parse("${Util.Main_BasrUrl}/api/list/closesignal"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'search': searchController.text,
        'page':'1'
              }),
    );

    var jsonString = jsonDecode(response.body);
    status = jsonString['status'];
    message = jsonString['message'];

    if (status == true) {
      setState(() {
        closeSignalData = jsonString['data'];
        page_get = jsonString['pagination']['page'];
        totalPages = jsonString['pagination']['totalPages'];
        filteredData = List.from(closeSignalData);
        loader = true;
        page=2;
      });
    }
  }


  Search(){
    _fetchCloseSignalData();
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    serviceId = widget.serviceId ?? "";
    segmentName = widget.segmentName ?? "";
    _fetchCloseSignalData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  int page = 2;
  bool max_page = false;
  int page_get=0;
  int totalPages=1;

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      fetchMoreItems();
    }
  }

  Future<void> fetchMoreItems() async {
    if(page_get<totalPages){
      setState(() {
        isLoading = true;
      });
      print('"service_id":"$serviceId","search":"${searchController.text}","page":"$page"');
      var response = await http.post(
        Uri.parse("${Util.Main_BasrUrl}/api/list/closesignal"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'search': searchController.text,
          "page":"$page",
        }),
      );
      var jsonString = jsonDecode(response.body);

      if( jsonString['status']==true){
        var  data = jsonString['data'];
        setState(() {
          page_get = jsonString['pagination']['page'];
          totalPages = jsonString['pagination']['totalPages'];
          filteredData.addAll(List.from(data));
        });


        if(page_get<totalPages){
          setState(() {
            max_page=false;
            isLoading = false;
            page++;
          });

        }else{
          setState(() {
            max_page=true;
          });
        }
      }else{
        setState(() {
          max_page=true;
        });
      }
    }
  }

  bool _isSearchFieldVisible = false;  // To toggle visibility of search field
  void _toggleSearchField() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Performance for $segmentName", style:const TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.black)),
        backgroundColor: Colors.grey.shade200,
        elevation: 0.5,
        titleSpacing: 0,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:  Container(
        height: MediaQuery.of(context).size.height+20,
            child: Column(
                    children: [
            //           Container(
            //     margin:const EdgeInsets.only(top: 10, left: 35, right: 35, bottom: 10),
            //     child: TextFormField(
            //       cursorColor: Colors.black,
            //       cursorWidth: 1.1,
            //       controller: searchController,
            //       // validator: (value) {
            //       //   if (value == null || value.isEmpty) {
            //       //     return 'Please Enter Stock Name or Entry Type';
            //       //   }
            //       //   return null;
            //       // },
            //       style:const TextStyle(fontSize: 13),
            //       decoration: InputDecoration(
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide:const BorderSide(color: ColorValues.Splash_bg_color1,width: 1.1),
            //           ),
            //           border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(10),
            //               borderSide:const BorderSide(color: ColorValues.Splash_bg_color1,width:1.1)
            //           ),
            //           hintText: "Search by Stock Name or Entry Type",
            //           contentPadding:const EdgeInsets.only(left: 15,bottom: 4),
            //           hintStyle:const TextStyle(
            //               fontSize: 13
            //           ),
            //           prefixIcon:const Icon(Icons.search)
            //       ),
            //       onChanged: (query) => Search(),
            //     )
            // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            alignment: Alignment.topLeft,
                            duration:const Duration(milliseconds: 300), // Duration of the animation
                            width:_isSearchFieldVisible?
                            MediaQuery.of(context).size.width/1.1:60, // Container will take up the full width
                            height: _isSearchFieldVisible ? 40 : 40, // Height expands when the field is visible
                            // decoration: BoxDecoration(
                            //   color: Colors.grey[200],
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            margin:const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                            child: GestureDetector(
                              onTap: _toggleSearchField, // Toggle the visibility of the search field
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: _isSearchFieldVisible
                                    ? TextFormField(
                                  controller: searchController,
                                  cursorColor: Colors.black,
                                  cursorWidth: 1.1,
                                  style: const TextStyle(fontSize: 13),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.1),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.1),
                                      ),
                                      hintText: "Search by Stock Name or Entry Type",
                                      contentPadding: const EdgeInsets.only(left: 15, bottom: 4),
                                      hintStyle: const TextStyle(fontSize: 13),
                                      prefixIcon:const Icon(Icons.search)
                                  ),
                                  onChanged: (query) => Search(),
                                )
                                    : Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade500)
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],

                      ),


            loader ?
             Expanded(
              child:SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 25,
                  headingRowHeight: 50,
                  headingRowColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return ColorValues.Splash_bg_color1.withOpacity(
                            0.5); // Color when hovered
                      }

                      return ColorValues.Splash_bg_color1;
                    },
                  ),
                  columns: const <DataColumn>[
                    DataColumn(label: Text('S.No.', style: TextStyle(fontSize: 11, color: Colors.white))),
                    DataColumn(label: Text('Stock Name', style: TextStyle(fontSize: 11, color: Colors.white))),
                    DataColumn(label: Text('Entry Type', style: TextStyle(fontSize: 11, color: Colors.white))),
                    DataColumn(label: Text('Entry Date', style: TextStyle(fontSize: 11, color: Colors.white))),
                    DataColumn(label: Text('Entry Price', style: TextStyle(fontSize: 11, color: Colors.white))),
                    DataColumn(label: Text('Exit Date', style: TextStyle(fontSize: 11, color: Colors.white))),
                    DataColumn(label: Text('Exit Price', style: TextStyle(fontSize: 11, color: Colors.white))),
                    DataColumn(label: Text('Net Gain/Loss', style: TextStyle(fontSize: 11, color: Colors.white))),
                    DataColumn(label: Text('Description', style: TextStyle(fontSize: 11, color: Colors.white))),
                    DataColumn(label: Text('Report PDF', style: TextStyle(fontSize: 11, color: Colors.white))),
                  ],
                  rows: List<DataRow>.generate(
                    filteredData.length,
                        (index) {
                          DateTime dateTime = DateTime.parse(filteredData[index]['created_at']);
                         String? entryTime = DateFormat('d MMM, yyyy').format(dateTime);

                          DateTime dateTime2 = DateTime.parse(filteredData[index]['closedate']);
                          String? exitTime =DateFormat('d MMM, yyyy').format(dateTime2);
                            print("POPO: ${filteredData[index]['closeprice']}");
                            print("OPOP: ${filteredData[index]['price']}");
                          double percentage = 0.0;
                          double closePrice = double.parse(filteredData[index]['closeprice'] ?? "0.0");
                          double entryPrice = double.parse(filteredData[index]['price'] ?? "0.0");
                          percentage = filteredData[index]['calltype'] == "BUY"
                              ? ((closePrice - entryPrice) / entryPrice) * 100
                              : ((entryPrice - closePrice) / entryPrice) * 100;
                              return DataRow(
                                cells: [
                                  DataCell(Text('${index+1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                                  DataCell(Text('${filteredData[index]['tradesymbol']}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                                  DataCell(Text('${filteredData[index]['calltype']}', style: TextStyle(fontSize: 10, color: filteredData[index]['calltype'] == "BUY" ? Colors.green : Colors.red))),
                                  DataCell(Text('${entryTime}', style: TextStyle(fontSize: 10, color: Colors.black))),
                                  DataCell(Text('₹${filteredData[index]['price']}', style: TextStyle(fontSize: 10, color: Colors.black))),
                                  DataCell(Text('${exitTime}', style: TextStyle(fontSize: 10, color: Colors.black))),
                                  DataCell(Text('₹${filteredData[index]['closeprice']}', style: TextStyle(fontSize: 10, color: Colors.black))),
                                  DataCell(Text('${percentage.toStringAsFixed(2)}%',style: TextStyle(fontSize: 11, color: percentage >= 0 ? Colors.green : Colors.red),),),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showDescriptionDialog(filteredData[index]['description']),
                                      child: Text('View', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  DataCell(
                                    filteredData[index]['report_full_path']==null||filteredData[index]['report_full_path']==""?
                                    Text('No Analysis\navailable', style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500)):
                                    // GestureDetector(
                                    //   onTap: (){
                                    //     if(filteredData[index]['report_full_path']==null||filteredData[index]['report_full_path']==""){
                                    //       ScaffoldMessenger.of(context).showSnackBar(
                                    //       const SnackBar(content:
                                    //       Text('NA',style: TextStyle(color: Colors.white)),
                                    //         duration:Duration(seconds: 3),
                                    //         backgroundColor: Colors.red,
                                    //       ),
                                    //       );
                                    //     }
                                    //
                                    //     else{
                                    //       String? pdf_path=filteredData[index]['report_full_path'];
                                    //       print("pdf_path == $pdf_path");
                                    //
                                    //       downloadFile(pdf_path!, 'sample.pdf').then((file) {
                                    //         setState(() {
                                    //           localPath = file.path;
                                    //           Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewAnalysisPdf(localPath: localPath,)));
                                    //           // View_analysis_popup(pdf_path);
                                    //         });});
                                    //       }
                                    //     },
                                    //   child:const Text('View Analysis', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w600)),
                                    // ),
                                    GestureDetector(
                                      onTap: () {
                                        if (isButtonClicked) return; // If already clicked, do nothing
                                        setState(() {
                                          isButtonClicked = true; // Set the flag to true
                                        });

                                        if (filteredData[index]['report_full_path'] == null || filteredData[index]['report_full_path'] == "") {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('NA', style: TextStyle(color: Colors.white)),
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          setState(() {
                                            isButtonClicked = false; // Reset the flag if no action happens
                                          });
                                        } else {
                                          String? pdfPath = filteredData[index]['report_full_path'];
                                          print("pdf_path == $pdfPath");

                                          downloadFile(pdfPath!, 'sample.pdf').then((file) {
                                            setState(() {
                                              localPath = file.path;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ViewAnalysisPdf(localPath: localPath),
                                                ),
                                              );
                                              isButtonClicked = false; // Reset the flag after navigation
                                            });
                                          }).catchError((error) {
                                            // Handle error and reset the flag
                                            print("Error downloading file: $error");
                                            setState(() {
                                              isButtonClicked = false;
                                            });
                                          });
                                        }
                                      },
                                      child: const Text(
                                        'View Analysis',
                                        style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w600),
                                      ),
                                    ),

                                  ),
                                ],
                              );
                        },
                  ),
                )
                ),
              ),
            )
                          : const Center(child: CircularProgressIndicator(color: Colors.black)),
                    ],
                  ),
          )

    );
  }

  _showDescriptionDialog(description) {
    return showModalBottomSheet(
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
          )
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setState) {
            return Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Minimum size ke hisaab se adjust karega
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.black),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          description,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  String? localPath;
  Future<File> downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
  View_analysis_popup(pdf_path){
    return showModalBottomSheet(
      isScrollControlled:true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  child:Column(
                    children: [
                      const SizedBox(height: 45,),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin:const EdgeInsets.only(left: 20),
                              child:const Icon(Icons.clear,color: Colors.black,),
                            ),
                          ),
                          Container(
                            margin:const EdgeInsets.only(left: 12),
                            child:const Text("Analysis",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),

                      Container(
                        height:MediaQuery.of(context).size.height-100,
                        child:localPath != null
                       ? PDFView(
                          filePath: localPath!,
                          fitEachPage: true,
                          fitPolicy: FitPolicy.WIDTH,
                          pageFling: false,
                        )

                            : const Center(child: CircularProgressIndicator()),
                      )


                    ],
                  )
              );
            }
        );
      },
    );
  }
}
