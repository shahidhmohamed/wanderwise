import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'EventPath.dart';

class TimeLineTileUI extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventChild;

  const TimeLineTileUI(
      {super.key,
        required this.isFirst,
        required this.isLast,
        required this.isPast,
        required this.eventChild});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // Reduced bottom gap
      child: SizedBox(
        height: 320.0,
        child: TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          beforeLineStyle: LineStyle(color: Colors.red ,thickness: 6),
          indicatorStyle: IndicatorStyle(
            width: 40.0,
            color: Colors.red,
            iconStyle: IconStyle(
              iconData: Icons.arrow_downward,
              color: Colors.white,
            ),
          ),
          endChild: EventPath(
            isPast: isPast,
            childWidget: eventChild,
          ),
        ),
      ),
    );
  }
}
