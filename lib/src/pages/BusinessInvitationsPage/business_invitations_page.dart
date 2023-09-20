import 'package:flutter/material.dart';

import 'index.dart';

class BusinessInvitationsPage extends StatelessWidget {
  final List<String>? status;

  BusinessInvitationsPage({@required this.status});

  @override
  Widget build(BuildContext context) {
    return BusinessInvitationsView(status: status);
  }
}
