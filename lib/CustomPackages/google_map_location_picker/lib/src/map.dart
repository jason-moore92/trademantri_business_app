import 'dart:async';
import 'dart:convert';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/generated/l10n.dart';
import 'package:google_map_location_picker/src/providers/location_provider.dart';
import 'package:google_map_location_picker/src/utils/loading_builder.dart';
import 'package:google_map_location_picker/src/utils/log.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

import 'model/location_result.dart';
import 'utils/location_utils.dart';

class MapPicker extends StatefulWidget {
  const MapPicker(
    this.apiKey, {
    Key? key,
    this.initialCenter,
    this.initialZoom,
    this.requiredGPS,
    this.myLocationButtonEnabled,
    this.layersButtonEnabled,
    this.automaticallyAnimateToCurrentLocation,
    this.mapStylePath,
    this.appBarColor,
    this.searchBarBoxDecoration,
    this.hintText,
    this.resultCardConfirmIcon,
    this.resultCardAlignment,
    this.resultCardDecoration,
    this.resultCardPadding,
    this.language,
    this.desiredAccuracy,
    this.necessaryField,
  }) : super(key: key);

  final String? apiKey;

  final LatLng? initialCenter;
  final double? initialZoom;

  final bool? requiredGPS;
  final bool? myLocationButtonEnabled;
  final bool? layersButtonEnabled;
  final bool? automaticallyAnimateToCurrentLocation;

  final String? mapStylePath;

  final Color? appBarColor;
  final BoxDecoration? searchBarBoxDecoration;
  final String? hintText;
  final Widget? resultCardConfirmIcon;
  final Alignment? resultCardAlignment;
  final Decoration? resultCardDecoration;
  final EdgeInsets? resultCardPadding;

  final String? language;

  final LocationAccuracy? desiredAccuracy;

  final String? necessaryField;

  @override
  MapPickerState createState() => MapPickerState();
}

class MapPickerState extends State<MapPicker> {
  Completer<GoogleMapController> mapController = Completer();

  MapType _currentMapType = MapType.normal;

  String? _mapStyle;

  LatLng? _lastMapPosition;

  Position? _currentPosition;

  String _address = "";
  String _city = "";
  String _state = "";
  String _zipcode = "";
  String? _placeId = "";

  void _onToggleMapTypePressed() {
    final MapType nextType = MapType.values[(_currentMapType.index + 1) % MapType.values.length];

    setState(() => _currentMapType = nextType);
  }

  // this also checks for location permission.
  Future<void> _initCurrentLocation() async {
    Position? currentPosition;
    try {
      currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: widget.desiredAccuracy!);
      d("position = $currentPosition");

      setState(() => _currentPosition = currentPosition);
    } catch (e) {
      currentPosition = null;
      d("_initCurrentLocation#e = $e");
    }

    if (!mounted) return;

    setState(() => _currentPosition = currentPosition);

    if (currentPosition != null) moveToCurrentLocation(LatLng(currentPosition.latitude, currentPosition.longitude));
  }

  Future moveToCurrentLocation(LatLng currentLocation) async {
    d('MapPickerState.moveToCurrentLocation "currentLocation = [$currentLocation]"');
    final controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentLocation, zoom: 16),
    ));
  }

  @override
  void initState() {
    super.initState();
    if (widget.automaticallyAnimateToCurrentLocation! && !widget.requiredGPS!) _initCurrentLocation();

    if (widget.mapStylePath != null) {
      rootBundle.loadString(widget.mapStylePath!).then((string) {
        _mapStyle = string;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.requiredGPS!) {
      _checkGeolocationPermission();
      if (_currentPosition == null) _initCurrentLocation();
    }

    if (_currentPosition != null && dialogOpen != null) Navigator.of(context, rootNavigator: true).pop();

    return Scaffold(
      body: Builder(
        builder: (context) {
          if (_currentPosition == null && widget.automaticallyAnimateToCurrentLocation! && widget.requiredGPS!) {
            return const Center(child: CircularProgressIndicator());
          }

          return buildMap();
        },
      ),
    );
  }

  Widget buildMap() {
    return Center(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.initialCenter!,
              zoom: widget.initialZoom!,
            ),
            onTap: (LatLng lat) {
              print("sssss");
            },
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
              //Implementation of mapStyle
              if (widget.mapStylePath != null) {
                controller.setMapStyle(_mapStyle);
              }

              _lastMapPosition = widget.initialCenter;
              LocationProvider.of(context, listen: false).setLastIdleLocation(_lastMapPosition!);
            },
            onCameraMove: (CameraPosition position) {
              _lastMapPosition = position.target;
            },
            onCameraIdle: () async {
              LocationProvider.of(context, listen: false).setLastIdleLocation(_lastMapPosition!);
            },
            onCameraMoveStarted: () {
              print("onCameraMoveStarted#_lastMapPosition = $_lastMapPosition");
            },
//            onTap: (latLng) {
//              clearOverlay();
//            },
            mapType: _currentMapType,
            myLocationEnabled: true,
          ),
          _MapFabs(
            myLocationButtonEnabled: widget.myLocationButtonEnabled!,
            layersButtonEnabled: widget.layersButtonEnabled!,
            onToggleMapTypePressed: _onToggleMapTypePressed,
            onMyLocationPressed: _initCurrentLocation,
          ),
          pin(),
          locationCard(),
        ],
      ),
    );
  }

  Widget locationCard() {
    return Align(
      alignment: widget.resultCardAlignment ?? Alignment.bottomCenter,
      child: Padding(
        padding: widget.resultCardPadding ?? EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Consumer<LocationProvider>(builder: (context, locationProvider, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width - 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: FutureLoadingBuilder<Map<String, dynamic>>(
                        future: getAddress(locationProvider.lastIdleLocation, locationProvider.selectedPlacedId!),
                        mutable: true,
                        loadingIndicator: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                          ],
                        ),
                        builder: (context, data) {
                          _address = data["address"] ?? "";
                          _placeId = data["placeId"] ?? "";
                          _city = data["city"] ?? "";
                          _state = data["state"] ?? "";
                          _zipcode = data["zipCode"] ?? "";
                          if (locationProvider.selectedPlacedId != null && locationProvider.selectedPlacedId != "") {
                            locationProvider.setSelectedPlacedId("");
                          }

                          return Container(
                            width: MediaQuery.of(context).size.width - 128,
                            // height: 200,
                            child: Wrap(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _address != ""
                                            ? _address
                                            : S.of(context).unnamedPlace != ""
                                                ? S.of(context).unnamedPlace
                                                : 'Unknown placeID',
                                        style: TextStyle(fontSize: 18),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                                Row(
                                  children: [
                                    Text(
                                      "City:  " + (_city != "" ? _city : 'Unknown City'),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                                Row(
                                  children: [
                                    Text(
                                      "State:  " + (_state != "" ? _state : 'Unknown state'),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                                Row(
                                  children: [
                                    Text(
                                      "Zip code:  " + (_zipcode != "" ? _zipcode : 'Unknown zipCode'),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: () {
                        if (_city == "" && widget.necessaryField == "city") {
                          showDialogHandler(
                            context,
                            title: "Pickup Address",
                            content: "Address specified is too generic. Please choose more accurate location",
                          );
                        } else if (_zipcode == "" && widget.necessaryField == "zipcode") {
                          showDialogHandler(
                            context,
                            title: "Pickup Address",
                            content: "Address specified is too generic. Please choose more accurate location",
                          );
                        } else {
                          Navigator.of(context).pop({
                            'location': LocationResult(
                              latLng: locationProvider.lastIdleLocation,
                              address: _address,
                              placeId: _placeId,
                              city: _city,
                              state: _state,
                              zipCode: _zipcode,
                            )
                          });
                        }
                      },
                      child: widget.resultCardConfirmIcon ?? Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void showDialogHandler(BuildContext context, {String title = "", String content = "", Function? callback}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          titlePadding: title == "" ? EdgeInsets.zero : EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
          content: Text(content, textAlign: TextAlign.center),
          contentPadding: content == "" ? EdgeInsets.zero : EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (callback != null) {
                        callback();
                      }
                    },
                    color: Color(0xFFf46f2c),
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> getAddress(LatLng? location, String selectedPlacedId) async {
    if (location == null) return {"placeId": null, "address": null};

    try {
      final endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}'
          '&key=${widget.apiKey}&language=${widget.language}&sensor=false';

      final response = jsonDecode((await http.get(Uri.parse(endpoint), headers: await LocationUtils.getAppHeaders())).body);

      var addrssResult = response['results'][0];
      var addressComponents = addrssResult['address_components'];

      if (selectedPlacedId != null && selectedPlacedId != "") {
        for (var i = 0; i < response['results'].length; i++) {
          if (response['results'][i]["place_id"] == selectedPlacedId) {
            addrssResult = response['results'][i];
            addressComponents = response['results'][i]['address_components'];
            break;
          }
        }
      }

      var placeId = addrssResult["place_id"];
      var address = addrssResult["formatted_address"];
      var city = "";
      var state = "";
      var nbhd = "";
      var subloc = "";
      var zipCode = "";
      var countryCode = "";
      bool hascity = false;
      bool hassub = false;
      for (var i = 0; i < addressComponents.length; i++) {
        var types = addressComponents[i]["types"];
        for (var j = 0; j < types.length; j++) {
          var type = types[j];
          if (type == "locality") {
            city = addressComponents[i]["long_name"];
            hascity = true;
          }
          if (type == "administrative_area_level_1") {
            state = addressComponents[i]["long_name"];
          }
          if (type == "neighborhood") {
            nbhd = addressComponents[i]["long_name"];
          }
          if (type == "sublocality") {
            subloc = addressComponents[i]["long_name"];
            hassub = true;
          }
          if (type == "postal_code") {
            zipCode = addressComponents[i]["long_name"];
          }
          if (type == "country") {
            countryCode = addressComponents[i]["short_name"];
          }
        }
      }

      if (hascity) {
        city = city;
      } else if (hassub) {
        city = subloc;
      } else {
        city = nbhd;
      }

      return {
        "placeId": placeId,
        "address": address,
        "city": city,
        "state": state,
        "countryCode": countryCode,
        "zipCode": zipCode,
      };
    } catch (e) {
      print(e);
    }

    return {"placeId": null, "address": null};
  }

  Widget pin() {
    return IgnorePointer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.place, size: 56),
            Container(
              decoration: ShapeDecoration(
                shadows: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black38,
                  ),
                ],
                shape: CircleBorder(
                  side: BorderSide(
                    width: 4,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            SizedBox(height: 56),
          ],
        ),
      ),
    );
  }

  var dialogOpen;

  Future _checkGeolocationPermission() async {
    final geolocationStatus = await Geolocator.checkPermission();
    d("geolocationStatus = $geolocationStatus");

    if (geolocationStatus == LocationPermission.denied && dialogOpen == null) {
      dialogOpen = _showDeniedDialog();
    } else if (geolocationStatus == LocationPermission.deniedForever && dialogOpen == null) {
      dialogOpen = _showDeniedForeverDialog();
    } else if (geolocationStatus == LocationPermission.whileInUse || geolocationStatus == LocationPermission.always) {
      d('GeolocationStatus.granted');

      if (dialogOpen != null) {
        Navigator.of(context, rootNavigator: true).pop();
        dialogOpen = null;
      }
    }
  }

  Future _showDeniedDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
            return true;
          },
          child: AlertDialog(
            title: Text(
              S.of(context).access_to_location_denied != "" ? S.of(context).access_to_location_denied : 'Access to location denied',
            ),
            content: Text(
              S.of(context).allow_access_to_the_location_services != ""
                  ? S.of(context).allow_access_to_the_location_services
                  : 'Allow access to the location services.',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  S.of(context).ok != "" ? S.of(context).ok : 'Ok',
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _initCurrentLocation();
                  dialogOpen = null;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _showDeniedForeverDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
            return true;
          },
          child: AlertDialog(
            title: Text(
              S.of(context).access_to_location_permanently_denied != ""
                  ? S.of(context).access_to_location_permanently_denied
                  : 'Access to location permanently denied',
            ),
            content: Text(
              S.of(context).allow_access_to_the_location_services_from_settings != ""
                  ? S.of(context).allow_access_to_the_location_services_from_settings
                  : 'Allow access to the location services for this App using the device settings.',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  S.of(context).ok != "" ? S.of(context).ok : 'Ok',
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Geolocator.openAppSettings();
                  dialogOpen = null;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // TODO: 9/12/2020 this is no longer needed, remove in the next release
  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                S.of(context).cant_get_current_location != "" ? S.of(context).cant_get_current_location : "Can't get current location",
              ),
              content: Text(
                S.of(context).please_make_sure_you_enable_gps_and_try_again != ""
                    ? S.of(context).please_make_sure_you_enable_gps_and_try_again
                    : 'Please make sure you enable GPS and try again',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}

class _MapFabs extends StatelessWidget {
  const _MapFabs({
    Key? key,
    @required this.myLocationButtonEnabled,
    @required this.layersButtonEnabled,
    @required this.onToggleMapTypePressed,
    @required this.onMyLocationPressed,
  })  : assert(onToggleMapTypePressed != null),
        super(key: key);

  final bool? myLocationButtonEnabled;
  final bool? layersButtonEnabled;

  final VoidCallback? onToggleMapTypePressed;
  final VoidCallback? onMyLocationPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: kToolbarHeight + 65, right: 8),
      child: Column(
        children: <Widget>[
          if (layersButtonEnabled!)
            FloatingActionButton(
              onPressed: onToggleMapTypePressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              mini: true,
              child: const Icon(Icons.layers),
              heroTag: "layers",
            ),
          if (myLocationButtonEnabled!)
            FloatingActionButton(
              onPressed: onMyLocationPressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              mini: true,
              child: const Icon(Icons.my_location),
              heroTag: "myLocation",
            ),
        ],
      ),
    );
  }
}
