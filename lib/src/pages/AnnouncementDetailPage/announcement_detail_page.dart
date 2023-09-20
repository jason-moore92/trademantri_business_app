import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class AnnouncementDetailPage extends StatelessWidget {
  final StoreModel? storeModel;
  final bool? isNew;
  final Map<String, dynamic>? announcementData;

  AnnouncementDetailPage({@required this.storeModel, @required this.isNew, this.announcementData});

  @override
  Widget build(BuildContext context) {
    return AnnouncementDetailView(storeModel: storeModel, isNew: isNew, announcementData: announcementData);
  }
}
