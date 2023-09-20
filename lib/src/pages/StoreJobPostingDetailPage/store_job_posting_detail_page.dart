import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class StoreJobPostingDetailPage extends StatelessWidget {
  final bool? isNew;
  final StoreJobPostModel? storeJobPostModel;

  StoreJobPostingDetailPage({@required this.isNew, this.storeJobPostModel});

  @override
  Widget build(BuildContext context) {
    return StoreJobPostingDetailView(isNew: isNew, storeJobPostModel: storeJobPostModel);
  }
}
