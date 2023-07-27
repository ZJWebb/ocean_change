import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/user_report.dart';
import '../../../screens/view_report_screen.dart';

class BottomSheetCard extends StatelessWidget {
  final UserReport report;
  const BottomSheetCard({super.key, required this.report});

  Widget? _populateSubtitle(UserReport report) {
    if (report.species != null) {
      return Text(report.species!);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () => Navigator.pushNamed(context, ViewReportScreen.routeName,
          arguments: report),
      title: Text(report.observation!),
      subtitle: _populateSubtitle(report),
      trailing: Text(DateFormat('MM-dd-yyyy | hh:mm a').format(report.date!)),
    ));
  }
}
