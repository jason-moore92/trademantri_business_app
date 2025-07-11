import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class DeliveryPartnerProvider extends ChangeNotifier {
  static DeliveryPartnerProvider of(BuildContext context, {bool listen = false}) => Provider.of<DeliveryPartnerProvider>(context, listen: listen);

  DeliveryPartnerState _deliveryPartnerState = DeliveryPartnerState.init();
  DeliveryPartnerState get deliveryPartnerState => _deliveryPartnerState;

  void setDeliveryPartnerState(DeliveryPartnerState deliveryPartnerState, {bool isNotifiable = true}) {
    if (_deliveryPartnerState != deliveryPartnerState) {
      _deliveryPartnerState = deliveryPartnerState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getDeliveryPartnerData({@required String? zipCode}) async {
    try {
      var result = await DeliveryPartnerApiProvider.getDeliveryPartners(zipCode: zipCode);
      if (result["success"]) {
        _deliveryPartnerState = _deliveryPartnerState.update(
          progressState: 2,
          message: "",
          deliveryPartnerData: result["data"],
        );
      } else {
        _deliveryPartnerState = _deliveryPartnerState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _deliveryPartnerState = _deliveryPartnerState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<void> getDeliveryPartnerListData({@required String? zipCode, String searchKey = ""}) async {
    List<dynamic>? deliveryPartnerListData = _deliveryPartnerState.deliveryPartnerListData;
    Map<String, dynamic>? deliveryPartnerMetaData = _deliveryPartnerState.deliveryPartnerMetaData;
    try {
      if (deliveryPartnerListData == null) deliveryPartnerListData = [];
      if (deliveryPartnerMetaData == null) deliveryPartnerMetaData = Map<String, dynamic>();

      var result;

      result = await DeliveryPartnerApiProvider.getDeliveryPartnerList(
        zipCode: zipCode,
        searchKey: searchKey,
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          deliveryPartnerListData.add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        deliveryPartnerMetaData = result["data"];

        _deliveryPartnerState = _deliveryPartnerState.update(
          progressState: 2,
          deliveryPartnerListData: deliveryPartnerListData,
          deliveryPartnerMetaData: deliveryPartnerMetaData,
        );
      } else {
        _deliveryPartnerState = _deliveryPartnerState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _deliveryPartnerState = _deliveryPartnerState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Map<String, dynamic> getDeliveryPartnerDetail1(
    Map<String, dynamic> selectedDeliveryAddress,
    Map<String, dynamic> deliveryPartnerData,
  ) {
    Map<String, dynamic> deliveryPartnerDetails = Map<String, dynamic>();

    deliveryPartnerDetails = {
      "deliveryPartnerId": deliveryPartnerData["_id"],
      "deliveryPartnerName": deliveryPartnerData["name"],
    };

    int distance = (selectedDeliveryAddress["distance"] / 1000).toInt();
    List<dynamic> charges = deliveryPartnerData["charges"];
    for (var j = 0; j < charges.length; j++) {
      if (distance >= int.parse(charges[j]["minKm"].toString()) && distance <= int.parse(charges[j]["maxKm"].toString())) {
        deliveryPartnerDetails["charge"] = charges[j];
        double deliveryPrice = 0;
        if (charges[j]["chargingType"] == "PER_DELIVERY") {
          deliveryPrice = double.parse(charges[j]["amount"].toString());
        } else if (charges[j]["chargingType"] == "PER_KM") {
          deliveryPrice = double.parse(charges[j]["amount"].toString()) * distance;
        }
        deliveryPartnerDetails["charge"]["deliveryPrice"] = deliveryPrice;
      }
    }

    return deliveryPartnerDetails;
  }

  Map<String, dynamic> getDeliveryPartnerDetail(Map<String, dynamic> selectedDeliveryAddress, double maxDeliveryDistance) {
    Map<String, dynamic> deliveryPartnerDetails = Map<String, dynamic>();
    for (var i = 0; i < _deliveryPartnerState.deliveryPartnerData!.length; i++) {
      List<dynamic> servicingAreas = _deliveryPartnerState.deliveryPartnerData![i]["servicingAreas"];
      double _maxDeliveryDistance = double.parse(_deliveryPartnerState.deliveryPartnerData![i]["charges"].last["maxKm"].toString());

      for (var j = 0; j < servicingAreas.length; j++) {
        if (servicingAreas[j]["zipCode"] == selectedDeliveryAddress["address"]["zipCode"] && _maxDeliveryDistance <= maxDeliveryDistance) {
          deliveryPartnerDetails = {
            "deliveryPartnerId": _deliveryPartnerState.deliveryPartnerData![i]["_id"],
            "deliveryPartnerName": _deliveryPartnerState.deliveryPartnerData![i]["name"],
          };
          break;
        }
      }
      if (deliveryPartnerDetails.isNotEmpty) {
        int distance = (selectedDeliveryAddress["distance"] / 1000).toInt();
        List<dynamic> charges = _deliveryPartnerState.deliveryPartnerData![i]["charges"];
        for (var j = 0; j < charges.length; j++) {
          if (distance >= int.parse(charges[j]["minKm"].toString()) && distance <= int.parse(charges[j]["maxKm"].toString())) {
            deliveryPartnerDetails["charge"] = charges[j];
            double deliveryPrice = 0;
            if (charges[j]["chargingType"] == "PER_DELIVERY") {
              deliveryPrice = double.parse(charges[j]["amount"].toString());
            } else if (charges[j]["chargingType"] == "PER_KM") {
              deliveryPrice = double.parse(charges[j]["amount"].toString()) * distance;
            }
            deliveryPartnerDetails["charge"]["deliveryPrice"] = deliveryPrice;
          }
        }
        break;
      }
    }

    return deliveryPartnerDetails;
  }
}
