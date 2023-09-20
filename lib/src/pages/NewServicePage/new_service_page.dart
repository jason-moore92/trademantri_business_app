import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class NewServicePage extends StatelessWidget {
  final String? type;
  final bool? isNew;
  final ServiceModel? serviceModel;

  NewServicePage({
    @required this.type,
    @required this.isNew,
    this.serviceModel,
  });

  @override
  Widget build(BuildContext context) {
    return NewServiceView(type: type, isNew: isNew, serviceModel: serviceModel);
  }
}
