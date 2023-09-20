import 'package:flutter/material.dart';

import 'index.dart';

class ProfilePage extends StatelessWidget {
  final bool haveAppbar;

  ProfilePage({this.haveAppbar = true});

  @override
  Widget build(BuildContext context) {
    return ProfileView(haveAppbar: haveAppbar);
  }
}
