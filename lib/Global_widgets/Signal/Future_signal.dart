import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

class Future_signal extends StatefulWidget {
  const Future_signal({Key? key}) : super(key: key);

  @override
  State<Future_signal> createState() => _Future_signalState();
}

class _Future_signalState extends State<Future_signal> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              // height: 130,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, left: 8),
                        child: Text(
                          "Opened :",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 8),
                        child: const Text(
                          "Jan-18, 6:10 PM",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, left: 8),
                            height: 22,
                            width: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.green,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "LONG !!",
                              style:
                              TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8, left: 10),
                            child: const Text(
                              "HARDUSDT",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, right: 8),
                        height: 22,
                        width: 75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.grey.shade200),
                        alignment: Alignment.center,
                        child: const Text(
                          "In progress",
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, left: 8),
                        child: Text(
                          "Entry price :",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 8),
                        child: const Text(
                          "0.14",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, left: 8),
                        child: Text(
                          "Stop loss 40% :",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 8),
                        child: const Text(
                          "0.1",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    height: 25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: Text(
                            "Current price :",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: Text(
                            "0.0869",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: const Text(
                            "-37.93%",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffE4EfE9),
                          ),
                          margin: const EdgeInsets.only(top: 6, left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "View Chart",
                                style: TextStyle(fontSize: 12),
                              ),
                              Icon(
                                Icons.candlestick_chart,
                                size: 15,
                                color: Colors.grey.shade600,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 25,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffE4EfE9),
                          ),
                          margin: const EdgeInsets.only(top: 6, right: 8),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "View Analysis",
                                style: TextStyle(fontSize: 12),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 3),
                                  child: Icon(
                                    Icons.computer,
                                    size: 12,
                                    color: Colors.grey.shade600,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
