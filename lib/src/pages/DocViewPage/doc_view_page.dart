import 'package:flutter/material.dart';

import 'index.dart';

class DocViewPage extends StatelessWidget {
  final String? doc;
  final String? appBarTitle;
  final bool isShare;

  DocViewPage({@required this.doc, @required this.appBarTitle, this.isShare = false});

  @override
  Widget build(BuildContext context) {
    return DocViewView(doc: doc, appBarTitle: appBarTitle, isShare: isShare);
  }
}
