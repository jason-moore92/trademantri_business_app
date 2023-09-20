import 'package:flutter/material.dart';

import 'index.dart';

class MyApplicantListPage extends StatelessWidget {
  final String? jobId;

  MyApplicantListPage({@required this.jobId});

  @override
  Widget build(BuildContext context) {
    return MyApplicantListView(jobId: jobId);
  }
}
