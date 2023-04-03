import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:pfe/accueil/utils/extension.dart';

import '../models/event.dart';
import '../widgets/month_view_widget.dart';

class MonthViewPageDemo extends StatefulWidget {
  const MonthViewPageDemo({
    Key? key,
  }) : super(key: key);

  @override
  _MonthViewPageDemoState createState() => _MonthViewPageDemoState();
}

class _MonthViewPageDemoState extends State<MonthViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: _addEvent,
      ),
      body: MonthViewWidget(),
    );
  }

  Future<void> _addEvent() async {
    // final event = await context.pushRoute<CalendarEventData<Event>>(
    //   CreateEventPage(
    //     withDuration: true,
    //   ),
    // );
    // if (event == null) return;
    // CalendarControllerProvider.of<Event>(context).controller.add(event);
  }
}
