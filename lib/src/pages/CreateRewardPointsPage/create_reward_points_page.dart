import 'package:flutter/material.dart';

import 'index.dart';

class CreateRewardPointsPage extends StatelessWidget {
  final Map<String, dynamic>? rewardPointsData;
  final bool isNew;

  CreateRewardPointsPage({this.rewardPointsData, this.isNew = true});

  @override
  Widget build(BuildContext context) {
    return CreateRewardPointsView(rewardPointsData: rewardPointsData, isNew: isNew);
  }
}
