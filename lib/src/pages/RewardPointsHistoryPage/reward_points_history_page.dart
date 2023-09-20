import 'package:flutter/material.dart';

import 'index.dart';

class RewardPointsHistoryPage extends StatelessWidget {
  final List<dynamic>? historyData;

  RewardPointsHistoryPage({@required this.historyData});

  @override
  Widget build(BuildContext context) {
    return RewardPointsHistoryView(historyData: historyData);
  }
}
