import 'package:flutter/material.dart';

import 'index.dart';

class StoreJobPostingDetailPage extends StatelessWidget {
  final bool? isNew;
  final Map<String, dynamic>? jobPostingData;

  StoreJobPostingDetailPage({@required this.isNew, this.jobPostingData});

  @override
  Widget build(BuildContext context) {
    return StoreJobPostingDetailView(isNew: isNew, jobPostingData: jobPostingData);
  }
}
