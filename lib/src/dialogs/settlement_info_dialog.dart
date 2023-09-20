import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

class SettlementInfoDialog {
  static show(
    BuildContext context, {
    @required double? widthDp,
    @required double? heightDp,
    @required double? fontSp,
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    String text = "",
    bool barrierDismissible = false,
    int delaySecondes = 2,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Expanded(
            child: Text("Settlement Info"),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Success : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Successfull settlement",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Failed : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Settlement failed, please click on particular transaction to checkout the reason on failure.",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "M",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Text("Amount withdrawed on-demand/manually."),
                  )
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "A",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Text("Amount settled automatically."),
                  )
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
