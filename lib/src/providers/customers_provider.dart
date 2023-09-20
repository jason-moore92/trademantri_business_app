import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/customer_api_provider.dart';
import 'package:trapp/src/dto/customer_age_group.dart';
import 'package:trapp/src/dto/customer_frequent_order.dart';
import 'package:trapp/src/dto/customer_quick_insights.dart';
import 'package:trapp/src/dto/order_status_group.dart';
import 'package:trapp/src/models/index.dart';

class CustomersProvider extends ChangeNotifier {
  static CustomersProvider of(BuildContext context, {bool listen = false}) => Provider.of<CustomersProvider>(context, listen: listen);

  Future<List<CustomerAgeGroup>> getCustomersByAgeGroup({
    @required String? storeId,
  }) async {
    var result = await CustomerApiProvider.groupByAge(
      storeId: storeId,
    );
    if (result["success"]) {
      List<CustomerAgeGroup> data = [];
      for (var i = 0; i < result["data"].length; i++) {
        data.add(CustomerAgeGroup.fromJson(result["data"][i]));
      }
      return data;
    } else {
      return [];
    }
  }

  Future<List<OrderModel>> getRecentOrders({
    @required String? storeId,
    String? userId,
  }) async {
    var result = await CustomerApiProvider.recentOrders(
      storeId: storeId,
      userId: userId,
    );
    if (result["success"]) {
      List<OrderModel> data = [];
      for (var i = 0; i < result["data"]["docs"].length; i++) {
        data.add(OrderModel.fromJson(result["data"]["docs"][i]));
      }
      return data;
    } else {
      return [];
    }
  }

  Future<List<CustomerFrequentOrder>> getFrequentOrders({
    @required String? storeId,
  }) async {
    var result = await CustomerApiProvider.frequentOrders(
      storeId: storeId,
    );
    if (result["success"]) {
      List<CustomerFrequentOrder> data = [];
      for (var i = 0; i < result["data"]["docs"].length; i++) {
        data.add(CustomerFrequentOrder.fromJson(result["data"]["docs"][i]));
      }
      return data;
    } else {
      return [];
    }
  }

  Future<List<OrderModel>> getMonetaryOrders({
    @required String? storeId,
    String? userId,
  }) async {
    var result = await CustomerApiProvider.monetaryOrders(
      storeId: storeId,
      userId: userId,
    );
    if (result["success"]) {
      List<OrderModel> data = [];
      for (var i = 0; i < result["data"]["docs"].length; i++) {
        data.add(OrderModel.fromJson(result["data"]["docs"][i]));
      }
      return data;
    } else {
      return [];
    }
  }

  Future<List<OrderStatusGroup>> getOrdersByStatus({
    @required String? storeId,
    String? userId,
    List<String> onlyStatus = const [],
  }) async {
    var result = await CustomerApiProvider.getOrdersByStatus(
      storeId: storeId,
      userId: userId,
    );
    if (result["success"]) {
      List<OrderStatusGroup> data = [];
      for (var i = 0; i < result["data"].length; i++) {
        OrderStatusGroup osg = OrderStatusGroup.fromJson(result["data"][i]);
        if (onlyStatus.contains(osg.id)) {
          data.add(osg);
        }
      }
      return data;
    } else {
      return [];
    }
  }

  Future<CustomerQuickInsights> getQuickInsights({
    @required String? storeId,
    @required String? userId,
  }) async {
    var result = await CustomerApiProvider.getQuickInsights(
      storeId: storeId,
      userId: userId,
    );
    if (result["success"]) {
      return CustomerQuickInsights.fromJson(result["data"]);
    } else {
      return CustomerQuickInsights.fromJson({});
    }
  }
}
