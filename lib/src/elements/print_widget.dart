import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:printing/printing.dart';
import 'package:pdf/src/pdf/page_format.dart' as PFormat;
import 'package:trapp/src/elements/keicy_progress_dialog.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintWidget extends StatelessWidget {
  final String? path;
  final double? size;
  final Color? color;
  final Uint8List? qrCodePageImage;
  final Function(Uint8List)? callback;
  final Function()? qrCodeGen;

  KeicyProgressDialog? _progressDialog;

  PrintWidget({
    Key? key,
    @required this.path,
    this.size,
    this.color = Colors.black,
    this.callback,
    this.qrCodePageImage,
    this.qrCodeGen,
  }) : super(key: key);

  Future<File> getFileFromUrl({name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(path!));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      FlutterLogs.logInfo(
        "print_widget",
        "getFileFromUrl",
        {
          "path": dir.path,
        }.toString(),
      );
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthDp = 0;
    double heightDp = 0;

    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);

    if (_progressDialog == null) _progressDialog = KeicyProgressDialog.of(context);

    return GestureDetector(
      onTap: () async {
        if (path != "" && path != null) {
          try {
            _progressDialog!.show();
            File pdfFile = await getFileFromUrl();

            await Printing.layoutPdf(
              onLayout: (_) => pdfFile.readAsBytesSync(),
              format: PFormat.PdfPageFormat.a4,
            );
            _progressDialog!.hide();
          } catch (e) {
            FlutterLogs.logThis(
              tag: "print_widget",
              level: LogLevel.ERROR,
              subTag: "onTap:Print",
              exception: e is Exception ? e : null,
              error: e is Error ? e : null,
              errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
            );
          }
        }

        if (qrCodePageImage != null) {
          final pdf = pw.Document();
          final image = pw.MemoryImage(qrCodePageImage!);

          pdf.addPage(pw.Page(build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            ); // Center
          })); //

          await Printing.layoutPdf(
            onLayout: (_) async => pdf.save(),
            format: PFormat.PdfPageFormat.a4,
          );
        }

        if (qrCodeGen != null) {
          var imageData = await qrCodeGen!();

          final pdf = pw.Document();
          final image = pw.MemoryImage(imageData);

          pdf.addPage(pw.Page(build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            ); // Center
          })); //

          await Printing.layoutPdf(
            onLayout: (_) async => pdf.save(),
            format: PFormat.PdfPageFormat.a4,
          );
        }
      },
      child: Container(
        color: Colors.transparent,
        // padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
        child: Icon(Icons.print_outlined, size: size ?? heightDp * 25, color: color),
      ),
    );
  }
}
