import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/dialogs/index.dart';

class ProductAttributeWidget extends StatelessWidget {
  final Map<String, dynamic>? attributes;
  final Function(dynamic)? editHandler;
  final Function? deleteHandler;

  ProductAttributeWidget({
    @required this.attributes,
    @required this.editHandler,
    @required this.deleteHandler,
  });

  /// Responsive design variables
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  @override
  Widget build(BuildContext context) {
    /// Responsive design variables
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type :",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: widthDp * 10),
                    Expanded(
                      child: Text(
                        "${attributes!["type"]}",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Value :",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: widthDp * 10),
                    Expanded(
                      child: Text(
                        "${attributes!["value"]}",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: heightDp * 5),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       "Units :",
                //       style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
                //     ),
                //     SizedBox(width: widthDp * 10),
                //     Expanded(
                //       child: Text(
                //         "${attributes!["units"]}",
                //         style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                //       ),
                //     ),
                //   ],
                // ),
                if (attributes!["specifiers"] != null && attributes!["specifiers"] != "")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Specificers :",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: widthDp * 10),
                          Expanded(
                            child: Text(
                              "${attributes!["specifiers"]}",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(width: widthDp * 10),
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var result = await CustomAttributesDialog.show(
                    context,
                    attributes: attributes!,
                  );

                  if (result != null) {
                    editHandler!(result);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                  color: Colors.transparent,
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  NormalAskDialog.show(
                    context,
                    title: "Delete Attribute",
                    content: "Are you sure to delete attribute?",
                    callback: () {
                      deleteHandler!();
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                  color: Colors.transparent,
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
