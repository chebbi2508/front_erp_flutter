import 'package:flutter/material.dart';

import '../screens/planning/components/itemmodel.dart';
import '../screens/planning/components/timeline_widget.dart';


class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
    static List<ItemModel> getItems() {
    return [
      ItemModel(
          dateDescription: "Today",
          date: "20",
          yearDescription: "dez/20",
          description: "Uber",
          amount: "\$ 20.00",
          showDate: true,
          showIcon: true),
      ItemModel(
          dateDescription: "Today",
          date: "20",
          yearDescription: "dez/20",
          description: "Uber",
          amount: "\$ 10.00",
          showDate: false,
          showIcon: true),
      ItemModel(
          dateDescription: "Monday",
          date: "19",
          yearDescription: "dez/20",
          description: "Five Guys",
          amount: "\$ 21.30",
          showDate: true,
          showIcon: true),
      ItemModel(
          dateDescription: "Monday",
          date: "19",
          yearDescription: "dez/20",
          description: "Dino Pizza",
          amount: "\$ 15.10",
          showDate: false,
          showIcon: true),
      ItemModel(
          dateDescription: "Monday",
          date: "19",
          yearDescription: "dez/20",
          description: "Car wash",
          amount: "\$ 34.11",
          showDate: false,
          showIcon: true),
      ItemModel(
          dateDescription: "Sunday",
          date: "18",
          yearDescription: "dez/20",
          description: "Five Guys",
          amount: "\$ 5.30",
          showDate: true,
          showIcon: true),
      ItemModel(
          dateDescription: "Sunday",
          date: "19",
          yearDescription: "dez/20",
          description: "Uber",
          amount: "\$ 18.12",
          showDate: false,
          showIcon: true),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Timeline"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: getItems().length,
              itemBuilder: (context, index) {
                return TimelineWidget(
                  model: getItems()[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}