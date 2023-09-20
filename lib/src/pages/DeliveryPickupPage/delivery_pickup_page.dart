import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class DeliveryPickupPage extends StatelessWidget {
  final OrderModel? orderModel;

  DeliveryPickupPage({@required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: DeliveryPickupView(orderModel: orderModel),
    );
  }
}
