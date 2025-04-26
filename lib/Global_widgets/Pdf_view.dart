import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewAnalysisPdf extends StatefulWidget {
  final String? localPath;

  ViewAnalysisPdf({super.key, required this.localPath});

  @override
  State<ViewAnalysisPdf> createState() => _ViewAnalysisPdfState(localPath: localPath);
}

class _ViewAnalysisPdfState extends State<ViewAnalysisPdf> {
  final String? localPath;
  int totalPages = 0;
  int currentPage = 0;
  _ViewAnalysisPdfState({required this.localPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: PDFView(
            filePath: localPath!,
            fitEachPage: true,
            fitPolicy: FitPolicy.WIDTH,
            autoSpacing: false,
            // Enable autoSpacing for smoother scrolling
            pageFling: false,
            // Disable pageFling for smoother scrolling
            enableSwipe: true,
            pageSnap: false,
            // Disable pageSnap for smoother scrolling
            onPageChanged: (int? current, int? total) {
              setState(() {
                currentPage = current!;

                totalPages = total!;
              });
            },
          ),

/*PDFView(

filePath: localPath!,

fitEachPage: true,

fitPolicy: FitPolicy.WIDTH,

autoSpacing: false,

pageFling: true,

enableSwipe: true,

pageSnap: true,


// pageSnap: true,

onPageChanged: (int? current, int? total) {

setState(() {

currentPage = current!;

totalPages = total!;

});

},

),*/
        ),
      ),
    );
  }
}
