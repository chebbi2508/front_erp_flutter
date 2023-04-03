import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:pfe/accueil/utils/extension.dart';



import '../models/event.dart';
import '../widgets/day_view_widget.dart';


class DayViewPageDemo extends StatefulWidget {
  const DayViewPageDemo({Key? key}) : super(key: key);

  @override
  _DayViewPageDemoState createState() => _DayViewPageDemoState();
}

class _DayViewPageDemoState extends State<DayViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: () async {
          // final event =
          //     await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
          //   withDuration: true,
          // ));
          // if (event == null) return;
          // CalendarControllerProvider.of<Event>(context).controller.add(event);
        },
      ),
      body: DayViewWidget(),
    );
  }
}
