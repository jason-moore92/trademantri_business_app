import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart' as IMG;
import 'package:intl/intl.dart';
import 'package:trapp/src/models/store_model.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

class POSWidget extends StatefulWidget {
  final String? path;
  final double? size;
  final Color? color;
  final Function(Uint8List)? callback;

  POSWidget({
    Key? key,
    @required this.path,
    this.size,
    this.color = Colors.black,
    this.callback,
  }) : super(key: key);

  @override
  _POSWidgetState createState() => _POSWidgetState();
}

class _POSWidgetState extends State<POSWidget> {
  double deviceWidth = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;

  KeicyProgressDialog? _progressDialog;

  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  List<PrinterBluetooth>? _posDevices = [];

  AuthProvider? _authProvider;
  StoreModel? _storeModel;

  StreamSubscription<int>? _posBluetoothSubscription;

  bool _bluetoothStatus = false;
  bool _connectivityStatus = false;

  @override
  void initState() {
    super.initState();

    deviceWidth = 1.sw;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    _authProvider = AuthProvider.of(context);

    _storeModel = AuthProvider.of(context).authState.storeModel;

    if (Platform.isAndroid) {
      _posBluetoothSubscription = bluetoothManager.state.listen((event) {
        if (event == 12) {
          _bluetoothStatus = true;
          printerManager.startScan(Duration(seconds: 4));
        } else if (event == 10) {
          _bluetoothStatus = false;
        }
        if (mounted) setState(() {});
      });
    } else if (Platform.isIOS) {
      printerManager.startScan(Duration(seconds: 4));
    }
  }

  @override
  void dispose() {
    _posBluetoothSubscription!.cancel();
    printerManager.stopScan();
    bluetoothManager.stopScan();
    bluetoothManager.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_progressDialog == null) _progressDialog = KeicyProgressDialog.of(context);

    return GestureDetector(
      onTap: () async {
        _selectOptionBottomSheet();
      },
      child: Container(
        color: Colors.transparent,
        // padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
        child: Image.asset(
          "img/pos.png",
          width: widget.size ?? heightDp * 25,
          height: widget.size ?? heightDp * 25,
          color: widget.color,
        ),
      ),
    );
  }

  void _selectOptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(heightDp * 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: deviceWidth,
                    padding: EdgeInsets.all(heightDp * 10.0),
                    child: Text(
                      "Choose Option",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _posBluetoothList();
                    },
                    child: Container(
                      width: deviceWidth,
                      padding: EdgeInsets.all(heightDp * 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.bluetooth,
                            color: Colors.black.withOpacity(0.7),
                            size: heightDp * 25.0,
                          ),
                          SizedBox(width: widthDp * 10.0),
                          Text(
                            "From Bluetooth",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _posWifiList();
                    },
                    child: Container(
                      width: deviceWidth,
                      padding: EdgeInsets.all(heightDp * 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.wifi, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                          SizedBox(width: widthDp * 10.0),
                          Text(
                            "From Wifi",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void _posBluetoothList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(heightDp * 10.0),
              child: Column(
                children: [
                  Container(
                    width: deviceWidth,
                    padding: EdgeInsets.all(heightDp * 10.0),
                    child: Text(
                      "POS Devices",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                    ),
                  ),
                  StreamBuilder<int>(
                    stream: bluetoothManager.state,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: heightDp * 40,
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      if (snapshot.hasData) {
                        if (snapshot.data == 12) {
                          _bluetoothStatus = true;
                        } else if (snapshot.data == 10) {
                          _bluetoothStatus = false;
                        }
                      }

                      if (!_bluetoothStatus)
                        return Container(
                          height: heightDp * 50,
                          alignment: Alignment.center,
                          child: Text(
                            "Bluetooth Disconnected",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                          ),
                        );

                      return Center(
                        child: StreamBuilder<List<PrinterBluetooth>>(
                          stream: printerManager.scanResults,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Container(
                                height: heightDp * 40,
                                alignment: Alignment.center,
                                child: CupertinoActivityIndicator(),
                              );
                            if (snapshot.hasError) _posDevices = [];
                            if (snapshot.hasData) _posDevices = snapshot.data;

                            return Container(
                              padding: EdgeInsets.all(heightDp * 8.0),
                              child: Column(
                                children: <Widget>[
                                  if (_posDevices!.isEmpty)
                                    Column(
                                      children: [
                                        Text(
                                          "No Devices",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                        ),
                                        SizedBox(height: heightDp * 20),
                                        KeicyRaisedButton(
                                          width: widthDp * 100,
                                          height: heightDp * 35,
                                          color: config.Colors().mainColor(1),
                                          borderRadius: heightDp * 6,
                                          child: Text(
                                            "ReScan",
                                            style: TextStyle(fontSize: fontSp * 15, color: Colors.white),
                                          ),
                                          onPressed: () {
                                            if (_bluetoothStatus) {
                                              printerManager.stopScan();
                                              printerManager.startScan(Duration(seconds: 4));
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  if (_posDevices!.isNotEmpty) Divider(color: Colors.grey),
                                  if (_posDevices!.isNotEmpty)
                                    Column(
                                      children: List.generate(_posDevices!.length, (index) {
                                        return InkWell(
                                          onTap: () => _posBluetoothPrint(_posDevices![index]),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 5),
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.print, size: heightDp * 20, color: Colors.black),
                                                    SizedBox(width: widthDp * 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            _posDevices![index].name ?? '',
                                                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                                          ),
                                                          Text(
                                                            _posDevices![index].address!,
                                                            style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                                                          ),
                                                          Text(
                                                            'Click to print a test receipt',
                                                            style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Divider(color: Colors.grey),
                                            ],
                                          ),
                                        );
                                      }),
                                    )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void _posWifiList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(heightDp * 10.0),
              child: Column(
                children: [
                  Container(
                    width: deviceWidth,
                    padding: EdgeInsets.all(heightDp * 10.0),
                    child: Text(
                      "POS Devices",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                    ),
                  ),
                  StreamBuilder<ConnectivityResult>(
                    stream: Connectivity().onConnectivityChanged,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: heightDp * 40,
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      if (snapshot.hasError || snapshot.data == ConnectivityResult.none) {
                        _connectivityStatus = false;
                        return Container(
                          height: heightDp * 50,
                          alignment: Alignment.center,
                          child: Text(
                            "Wifi Disconnected",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                          ),
                        );
                      }
                      _connectivityStatus = true;

                      if (_storeModel!.settings!["posInfo"].isEmpty)
                        return Column(
                          children: [
                            Text(
                              "Store Settings don't set",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                            ),
                            SizedBox(height: heightDp * 20),
                            KeicyRaisedButton(
                              width: widthDp * 100,
                              height: heightDp * 35,
                              color: config.Colors().mainColor(1),
                              borderRadius: heightDp * 6,
                              child: Text(
                                "Go to settings",
                                style: TextStyle(fontSize: fontSp * 15, color: Colors.white),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        );

                      if (_storeModel!.settings!["posInfo"].isNotEmpty)
                        return Column(
                          children: [
                            Divider(color: Colors.grey),
                            Column(
                              children: List.generate(_storeModel!.settings!["posInfo"].length, (index) {
                                return Column(
                                  children: <Widget>[
                                    StreamBuilder<bool>(
                                        stream: Stream.fromFuture(
                                          getSubnetAddress(
                                            _storeModel!.settings!["posInfo"][index]["ipAddress"],
                                            _storeModel!.settings!["posInfo"][index]["port"],
                                          ),
                                        ),
                                        builder: (context, snapshot) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (snapshot.hasData && snapshot.data!) _posWifiPrint(_storeModel!.settings!["posInfo"][index]);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 5),
                                              alignment: Alignment.centerLeft,
                                              color: Colors.transparent,
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.print, size: heightDp * 20, color: Colors.black),
                                                  SizedBox(width: widthDp * 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text(
                                                          _storeModel!.settings!["posInfo"][index]["name"] ?? '',
                                                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                                        ),
                                                        Text(
                                                          "${_storeModel!.settings!["posInfo"][index]["ipAddress"]}:${_storeModel!.settings!["posInfo"][index]["port"]}",
                                                          style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (!snapshot.hasData) CupertinoActivityIndicator(),
                                                  if (snapshot.hasData && snapshot.data!)
                                                    Text(
                                                      "Connected",
                                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.green, fontWeight: FontWeight.w600),
                                                    ),
                                                  if (snapshot.hasError || (snapshot.hasData && !snapshot.data!))
                                                    Text(
                                                      "Disconnected",
                                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.red, fontWeight: FontWeight.w600),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                    Divider(color: Colors.grey),
                                  ],
                                );
                              }),
                            ),
                          ],
                        );
                      return SizedBox();
                    },
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<bool> getSubnetAddress(String ip, int port) async {
    try {
      Socket socket = await Socket.connect(InternetAddress.tryParse(ip), port, timeout: Duration(seconds: 5));

      socket.destroy();
      return true;
    } on SocketException catch (e) {
      return false;
    } on PlatformException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  void _posWifiPrint(Map<String, dynamic> setting) async {
    const PaperSize paper = PaperSize.mm80;
    CapabilityProfile profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(setting["ipAddress"], port: setting["port"]);

    if (res == PosPrintResult.success) {
      testReceipt(printer);
      printer.disconnect();
    }

    FlutterLogs.logInfo(
      "pos_widget",
      "_posWifiPrint",
      {
        "res": res,
      }.toString(),
    );
  }

  void _posBluetoothPrint(PrinterBluetooth printer) async {
    printerManager.selectPrinter(printer);

    const PaperSize paper = PaperSize.mm80;

    // TEST PRINT
    // final PosPrintResult res =
    // await printerManager.printTicket(await testTicket(paper));

    // DEMO RECEIPT
    final PosPrintResult res = await printerManager.printTicket(await demoReceipt(paper));
  }

  Future<void> testReceipt(NetworkPrinter printer) async {
    printer.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ', styles: PosStyles(codeTableString: 'CP1252'));
    printer.text('Special 2: blåbærgrød', styles: PosStyles(codeTableString: 'CP1252'));

    printer.text('Bold text', styles: PosStyles(bold: true));
    printer.text('Reverse text', styles: PosStyles(reverse: true));
    printer.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    printer.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    printer.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    // Print image
    ByteData data = await rootBundle.load('assets/logo.png');
    Uint8List bytes = data.buffer.asUint8List();
    IMG.Image? image = IMG.decodeImage(bytes);
    printer.image(image!);
    // Print image using alternative commands
    // printer.imageRaster(image);
    // printer.imageRaster(image, imageFn: PosImageFn.graphics);

    // Print barcode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    printer.barcode(Barcode.upcA(barData));

    // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
    // printer.text(
    //   'hello ! 中文字 # world @ éphémère &',
    //   styles: PosStyles(codeTable: PosCodeTable.westEur),
    //   containsChinese: true,
    // );

    printer.feed(2);
    printer.cut();
  }

  Future<Ticket> demoReceipt(PaperSize paper) async {
    final Ticket ticket = Ticket(paper);

    // Print image
    ByteData data = await rootBundle.load('img/logo.jpg');
    Uint8List bytes = data.buffer.asUint8List();
    IMG.Image? image = IMG.decodeImage(bytes);
    // ticket.image(image);

    ticket.text('GROCERYLY',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    ticket.text('889  Watson Lane', styles: PosStyles(align: PosAlign.center));
    ticket.text('New Braunfels, TX', styles: PosStyles(align: PosAlign.center));
    ticket.text('Tel: 830-221-1234', styles: PosStyles(align: PosAlign.center));
    ticket.text('Web: www.example.com', styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    ticket.hr();
    ticket.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 7),
      PosColumn(text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    ticket.row([
      PosColumn(text: '2', width: 1),
      PosColumn(text: 'ONION RINGS', width: 7),
      PosColumn(text: '0.99', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(text: '1.98', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'PIZZA', width: 7),
      PosColumn(text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'SPRING ROLLS', width: 7),
      PosColumn(text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.row([
      PosColumn(text: '3', width: 1),
      PosColumn(text: 'CRUNCHY STICKS', width: 7),
      PosColumn(text: '0.85', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(text: '2.55', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.hr();

    ticket.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: '\$10.97',
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    ticket.hr(ch: '=', linesAfter: 1);

    ticket.row([
      PosColumn(text: 'Cash', width: 7, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(text: '\$15.00', width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);
    ticket.row([
      PosColumn(text: 'Change', width: 7, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(text: '\$4.03', width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    ticket.feed(2);
    ticket.text('Thank you!', styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    ticket.text(timestamp, styles: PosStyles(align: PosAlign.center), linesAfter: 2);

    ticket.feed(2);
    ticket.cut();
    return ticket;
  }
}
