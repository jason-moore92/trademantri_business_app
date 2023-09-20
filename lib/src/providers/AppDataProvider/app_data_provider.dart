import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/ApiDataProviders/release_history_firestore_provider.dart';
import 'package:trapp/src/entities/maintenance.dart';

import '../index.dart';
import 'index.dart';

class AppDataProvider extends ChangeNotifier {
  static AppDataProvider of(BuildContext context, {bool listen = false}) => Provider.of<AppDataProvider>(context, listen: listen);

  AppDataState _appDataState = AppDataState.init();
  AppDataState get appDataState => _appDataState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setAppDataState(AppDataState appDataState, {bool isNotifiable = true}) {
    if (_appDataState != appDataState) {
      _appDataState = appDataState;
      if (isNotifiable) notifyListeners();
    }
  }

  void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<Position?> getCurrentPosition() async {
    Position position;
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition();
      // _appDataState = _appDataState.update(currentPosition: position);
      return position;
    } else {
      return null;
    }
  }

  Future<String> checkForUpdates({
    int delay = 10,
    String? forceResult,
  }) async {
    try {
      AppUpdateInfo info = await InAppUpdate.checkForUpdate();
      FlutterLogs.logInfo(
        "app_data_provider",
        "checkForUpdates",
        info.toString(),
      );

      if (forceResult != null) {
        await Future.delayed(
          Duration(
            seconds: delay,
          ),
        );
        return forceResult;
      }
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        int latestNumber = info.availableVersionCode!;
        Map<String, dynamic>? releaseData = await ReleaseHistoryFirestoreProvider.getReleaseByNumber(
          number: latestNumber,
        );
        FlutterLogs.logInfo(
          "app_data_provider",
          "onupdateAvailable",
          releaseData.toString(),
        );
        bool forceupdate = true;
        if (releaseData != null) {
          forceupdate = releaseData["forceUpdate"];
        }

        if (forceupdate) {
          return "do_immediate_update";
        } else {
          return "do_flexible_update";
        }
      }

      if (info.updateAvailability == UpdateAvailability.developerTriggeredUpdateInProgress) {
        if (info.immediateUpdateAllowed) {
          return "do_immediate_update";
        } else {
          return "complete_flexible_update";
        }
      }

      return "navigate_walkthrough";
    } catch (e) {
      return "navigate_walkthrough";
    }
  }

  Future<Maintenance?> checkForMaintenance() async {
    dynamic maintenanceResponse = await UserApiProvider.getMaintenance();
    if (maintenanceResponse["status"]) {
      return Maintenance.fromJson(maintenanceResponse["data"]);
    }
    return null;
  }

  void initProviderHandler(BuildContext context) {
    try {
      AuthProvider.of(context).setAuthState(AuthState.init(), isNotifiable: false);
      StorePageProvider.of(context).setStorePageState(StorePageState.init(), isNotifiable: false);
      DeliveryAddressProvider.of(context).setDeliveryAddressState(DeliveryAddressState.init(), isNotifiable: false);
      PromocodeProvider.of(context).setPromocodeState(PromocodeState.init(), isNotifiable: false);
      OrderProvider.of(context).setOrderState(OrderState.init(), isNotifiable: false);
      ContactUsRequestProvider.of(context).setContactUsRequestState(ContactUsRequestState.init(), isNotifiable: false);
      NotificationProvider.of(context).setNotificationState(NotificationState.init(), isNotifiable: false);
      StoreProvider.of(context).setStoreState(StoreState.init(), isNotifiable: false);
      CategoryProvider.of(context).setCategoryState(CategoryState.init(), isNotifiable: false);
      KYCDocsProvider.of(context).setKYCDocsState(KYCDocsState.init(), isNotifiable: false);
      BargainRequestProvider.of(context).setBargainRequestState(BargainRequestState.init(), isNotifiable: false);
      ReverseAuctionProvider.of(context).setReverseAuctionState(ReverseAuctionState.init(), isNotifiable: false);
      NewCustomerForChatPageProvider.of(context).setNewCustomerForChatPageState(NewCustomerForChatPageState.init(), isNotifiable: false);
      PaymentLinkProvider.of(context).setPaymentLinkState(PaymentLinkState.init(), isNotifiable: false);
      PaymentLinkProvider.of(context).setPaymentLinkState(PaymentLinkState.init(), isNotifiable: false);
      StoreBankDetailProvider.of(context).setStoreBankDetailState(StoreBankDetailState.init(), isNotifiable: false);
      DeliveryPartnerProvider.of(context).setDeliveryPartnerState(DeliveryPartnerState.init(), isNotifiable: false);
      StoreDataProvider.of(context).setStoreDataState(StoreDataState.init(), isNotifiable: false);
      CatalogProductListPageProvider.of(context).setCatalogProductListPageState(CatalogProductListPageState.init(), isNotifiable: false);
      CatalogServiceListPageProvider.of(context).setCatalogServiceListPageState(CatalogServiceListPageState.init(), isNotifiable: false);
      RewardPointsListProvider.of(context).setRewardPointsListState(RewardPointsListState.init(), isNotifiable: false);
      StoreJobPostingsProvider.of(context).setStoreJobPostingsState(StoreJobPostingsState.init(), isNotifiable: false);
      AppliedJobProvider.of(context).setAppliedJobState(AppliedJobState.init(), isNotifiable: false);
      InvoicesProvider.of(context).setInvoicesState(InvoicesState.init(), isNotifiable: false);
      ProductListPageProvider.of(context).setProductListPageState(ProductListPageState.init(), isNotifiable: false);
      BusinessConnectionsProvider.of(context).setBusinessConnectionsState(BusinessConnectionsState.init(), isNotifiable: false);
      BusinessStoresProvider.of(context).setBusinessStoresState(BusinessStoresState.init(), isNotifiable: false);
      BusinessInvitationsProvider.of(context).setBusinessInvitationsState(BusinessInvitationsState.init(), isNotifiable: false);
      ProductItemReviewProvider.of(context).setProductItemReviewState(ProductItemReviewState.init(), isNotifiable: false);
      PurchaseHistoryProvider.of(context).setPurchaseHistoryState(PurchaseHistoryState.init(), isNotifiable: false);
      PurchaseListProvider.of(context).setPurchaseListState(PurchaseListState.init(), isNotifiable: false);
      B2BOrderProvider.of(context).setB2BOrderState(B2BOrderState.init(), isNotifiable: false);
      ProductStockProvider.of(context).setProductStockState(ProductStockState.init(), isNotifiable: false);
      ReferralRewardS2UOffersProvider.of(context).setReferralRewardS2UOffersState(ReferralRewardS2UOffersState.init(), isNotifiable: false);
      ReferralRewardS2SOffersProvider.of(context).setReferralRewardU2SOffersState(ReferralRewardS2SOffersState.init(), isNotifiable: false);
      AppointmentProvider.of(context).setAppointmentState(AppointmentState.init(), isNotifiable: false);
    } catch (e) {
      FlutterLogs.logThis(
        tag: "app_data_provider",
        level: LogLevel.ERROR,
        subTag: "initProviderHandler",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }
}
