import 'package:flutter/material.dart';


class TodoList extends StatelessWidget {
  final String time;
  final String timeRange;
  final String title;
  final int statusBg;
  final int statusTitle;
  final int statusRange;
  final Color color;

  const TodoList({
    Key? key,
    required this.time,
    required this.timeRange,
    required this.title,
    required this.statusBg,
    required this.statusTitle,
    required this.color,
    required this.statusRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // backgroundColor() {
    //   switch (statusBg) {
    //     case 0:
    //       return kSamePrimaryColor;
    //     case 1:
    //       return kSameYellowColor;
    //     case 2:
    //       return kSameRedColor;
    //     default:
    //       return kBlueColor;
    //   }
    // }

    // titleColor() {
    //   switch (statusTitle) {
    //     case 0:
    //       return blueTextStyle;
    //     case 1:
    //       return yellowTextStyle;
    //     case 2:
    //       return redTextStyle;
    //     default:
    //       return blueTextStyle;
    //   }
    // }

    // rangeColor() {
    //   switch (statusRange) {
    //     case 0:
    //       return blueTextStyle;
    //     case 1:
    //       return yellowTextStyle;
    //     case 2:
    //       return redTextStyle;
    //     default:
    //       return blueTextStyle;
    //   }
    // }

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 8,
                height: 1,
                color: Colors.grey,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            margin: EdgeInsets.only(left: 57),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                    ),
                   
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  timeRange,
                  style: TextStyle(
                  fontSize: 12,
               //   fontWeight: FontWeight.,
                ),
                ),
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}