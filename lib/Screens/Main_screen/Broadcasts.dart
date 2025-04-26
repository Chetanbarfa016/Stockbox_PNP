import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:stock_box/Api/Apis.dart';
import 'package:stock_box/Constants/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Broadcasts extends StatefulWidget {
  const Broadcasts({Key? key}) : super(key: key);

  @override
  State<Broadcasts> createState() => _BroadcastsState();
}

class _BroadcastsState extends State<Broadcasts> {
  bool? Status;
  var BroadcastData = [];
  String? loader = "false";
  List<String> time = [];
  List entryTime = [];

  String removeHtmlTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  Broadcast_Apii() async {
    var data = await API.Broadcast_Api();
    setState(() {
      Status = data['status'];
    });

    if (Status == true) {
      BroadcastData = data['data'];

      // Add `isExpanded` field to each item in `BroadcastData`
      for (var message in BroadcastData) {
        message['isExpanded'] = false;
        message['plainText'] = removeHtmlTags(message['message']); // Store plain text
      }

      time = BroadcastData.map((item) => item['created_at'].toString()).toList();
      entryTime = time.map((dateTimeString) {
        DateTime dateTime = DateTime.parse(dateTimeString);
        return DateFormat('d MMM, yyyy').format(dateTime);
      }).toList();

      loader = "true";
    } else {
      loader = "No_data";
    }
  }

  @override
  void initState() {
    super.initState();
    Broadcast_Apii();
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
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Broadcast",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: loader == "true"
          ? ListView.builder(
        itemCount: BroadcastData.length,
        itemBuilder: (BuildContext context, int index) {
          var message = BroadcastData[index];
          bool isExpanded = message['isExpanded'];
          String plainText = message['plainText'];
          int maxLength = 150; // Adjust character limit for 2 lines

          return Container(
            margin: const EdgeInsets.only(left: 10,right: 10,top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width/1.45,
                      child: Text(
                        message['subject'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin:const EdgeInsets.only(right: 8,top: 4),
                      child: Text(
                        entryTime[index],
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),

                  ],
                ),
                Html(
                  data: isExpanded
                      ? message['message']
                      : (message['message'].length > maxLength
                      ? message['message'].substring(0, maxLength) + "..."
                      : message['message']),
                  style: {
                    "p": Style(fontSize: FontSize.medium),
                  },
                  onLinkTap: (url, _, __) {
                    if (url != null) {
                      _launchURL(url);
                    }
                  },
                ),
                if (plainText.length > maxLength)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        message['isExpanded'] = !isExpanded;
                      });
                    },
                    child: Container(
                      margin:const EdgeInsets.only(left: 10),
                      child: Text(
                        isExpanded ? "View Less" : "View More",
                        style: TextStyle(
                          color: ColorValues.Splash_bg_color1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Container(margin:const EdgeInsets.only(top: 3),child:  Divider(color: Colors.grey.shade400)),
              ],
            ),
          );
        },
      )
          : loader == "false"
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : const Center(child: Text("No broadcast message...")),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

