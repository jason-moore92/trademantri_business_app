import 'package:flutter/material.dart';
import 'package:trapp/src/elements/LanguageItemWidget.dart';
import 'package:trapp/src/models/language.dart';

class LanguagesWidget extends StatefulWidget {
  @override
  _LanguagesWidgetState createState() => _LanguagesWidgetState();
}

class _LanguagesWidgetState extends State<LanguagesWidget> {
  LanguagesList? languagesList;
  @override
  void initState() {
    languagesList = new LanguagesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Languages',
          style: Theme.of(context).textTheme.headline6!.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 10),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: 1,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return LanguageItemWidget(language: languagesList!.languages!.elementAt(index));
              },
            ),
          ],
        ),
      ),
    );
  }
}
