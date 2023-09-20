import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

class WalletInfoDialog {
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
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text("Wallet Info"),
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
                      text: "Unsettled : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "The balance that will be settled in future.",
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
                      text: "Settled : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "The balance that is settled and can be used or withdraw.",
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
                      text: "Total : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Total amount of settled and unsettled.",
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
                      "T",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text("Normal transaction.")
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
                      "R",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text("Refund Transaction.")
                ],
              ),
              SizedBox(
                height: 32.0,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "+ 200.00",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: " : Amount credited.",
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
                      text: "- 200.00",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: " : Amount debited.",
                    ),
                  ],
                ),
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
