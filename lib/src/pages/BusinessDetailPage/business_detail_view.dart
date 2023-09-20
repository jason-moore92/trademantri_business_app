import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/RegisterStorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class BusinessDetailView extends StatefulWidget {
  BusinessDetailView({Key? key}) : super(key: key);

  @override
  _BusinessDetailViewState createState() => _BusinessDetailViewState();
}

class _BusinessDetailViewState extends State<BusinessDetailView> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  AuthProvider? _authProvider;
  StoreProvider? _storeProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _ownerFirstNameController = TextEditingController();
  TextEditingController _ownerLastNameController = TextEditingController();
  TextEditingController _businessDescriptionController = TextEditingController();
  FocusNode _businessNameFocusNode = FocusNode();
  FocusNode _ownerFirstNameFocusNode = FocusNode();
  FocusNode _ownerLastNameFocusNode = FocusNode();
  FocusNode _businessDescriptionFocusNode = FocusNode();

  StoreModel _storeModel = StoreModel();

  List<dynamic>? categories;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////

    _authProvider = AuthProvider.of(context);
    _storeProvider = StoreProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _storeModel = StoreModel.copy(_authProvider!.authState.storeModel!);

    _businessNameController.text = _storeModel.name ?? "";
    _ownerFirstNameController.text = _storeModel.profile!["ownerInfo"]["firstName"] ?? "";
    _ownerLastNameController.text = _storeModel.profile!["ownerInfo"]["lastName"] ?? "";
    _businessDescriptionController.text = _storeModel.description ?? "";

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _storeProvider!.addListener(_storeProviderListener);
      if (CategoryProvider.of(context).categoryState.progressState != 2) {
        CategoryProvider.of(context).getCategoryAll();
      }
    });
  }

  @override
  void dispose() {
    _storeProvider!.removeListener(_storeProviderListener);
    super.dispose();
  }

  void _storeProviderListener() async {
    if (_storeProvider!.storeState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_storeProvider!.storeState.progressState == 2) {
      _authProvider!.setAuthState(
        _authProvider!.authState.update(storeModel: _storeModel),
      );
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp);
    } else if (_storeProvider!.storeState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _storeProvider!.storeState.message!,
      );
    }
  }

  void saveHandler() async {
    if (!_formkey.currentState!.validate()) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Please fix missing fields that are marked as red",
      );
      return;
    }
    _formkey.currentState!.save();

    await _keicyProgressDialog!.show();
    _storeProvider!.setStoreState(_storeProvider!.storeState.update(progressState: 1), isNotifiable: false);
    _storeProvider!.updateStore(id: _storeModel.id, storeData: _storeModel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: config.Colors().mainColor(1),
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          BusinessDetailPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
        ),
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  SaveConfirmDialog.show(context, callback: saveHandler);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
            child: Column(
              children: [
                _mainPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
      if (categoryProvider.categoryState.progressState == 0) {
        return Center(child: CupertinoActivityIndicator());
      }

      if (categoryProvider.categoryState.progressState == -1) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(categoryProvider.categoryState.message!, style: TextStyle(fontSize: fontSp * 14)),
              SizedBox(height: heightDp * 30),
              KeicyRaisedButton(
                width: widthDp * 120,
                height: heightDp * 40,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text("Try again", style: TextStyle(fontSize: fontSp * 14)),
              ),
            ],
          ),
        );
      }

      if (categories == null) {
        categories = _storeModel.businessType == "store"
            ? categoryProvider.categoryState.categoryData!["store"]
            : categoryProvider.categoryState.categoryData!["services"];
      }

      String categoryDesc = "";
      for (var i = 0; i < categories!.length; i++) {
        if (categories![i]["categoryId"] == _storeModel.subType) {
          categoryDesc = categories![i]["categoryDesc"];
        }
      }

      return Form(
        key: _formkey,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Business Type:   ",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
                  decoration: BoxDecoration(
                    color: config.Colors().mainColor(1),
                    borderRadius: BorderRadius.circular(heightDp * 10),
                  ),
                  child: Text(
                    _storeModel.businessType == "store"
                        ? "Store"
                        : _storeModel.businessType == "services"
                            ? "Services"
                            : "",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Category:  ",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Text(
                          categoryDesc,
                          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: widthDp * 10),
                GestureDetector(
                  onTap: () {
                    showCategoryDialog();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
                    decoration: BoxDecoration(
                      color: config.Colors().mainColor(1),
                      borderRadius: BorderRadius.circular(heightDp * 6),
                    ),
                    child: Text(
                      "Change",
                      style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 20),
            KeicyTextFormField(
              controller: _businessNameController,
              focusNode: _businessNameFocusNode,
              width: double.infinity,
              height: heightDp * 40,
              label: RegisterStorePageString.businessNameHint,
              labelSpacing: heightDp * 5,
              textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
              hintText: RegisterStorePageString.businessNameHint,
              border: Border.all(color: Colors.grey.withOpacity(0.6)),
              errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              borderRadius: heightDp * 8,
              isImportant: true,
              onChangeHandler: (input) => _storeModel.name = input.trim(),
              validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.businessNameValidate : null,
              onSaveHandler: (input) => _storeModel.name = input.trim(),
              onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_ownerFirstNameFocusNode),
            ),

            ///
            SizedBox(height: heightDp * 20),
            KeicyTextFormField(
              controller: _ownerFirstNameController,
              focusNode: _ownerFirstNameFocusNode,
              width: double.infinity,
              height: heightDp * 40,
              label: RegisterStorePageString.ownerFirstNameHint,
              labelSpacing: heightDp * 5,
              textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
              hintText: RegisterStorePageString.ownerFirstNameHint,
              border: Border.all(color: Colors.grey.withOpacity(0.6)),
              errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              borderRadius: heightDp * 8,
              isImportant: true,
              onChangeHandler: (input) => _storeModel.profile!["ownerInfo"]["firstName"] = input.trim(),
              validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.ownerFirstNameValidate : null,
              onSaveHandler: (input) => _storeModel.profile!["ownerInfo"]["firstName"] = input.trim(),
              onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_ownerLastNameFocusNode),
            ),

            ///
            SizedBox(height: heightDp * 20),
            KeicyTextFormField(
              controller: _ownerLastNameController,
              focusNode: _ownerLastNameFocusNode,
              width: double.infinity,
              height: heightDp * 40,
              label: RegisterStorePageString.ownerLastNameHint,
              labelSpacing: heightDp * 5,
              textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
              hintText: RegisterStorePageString.ownerLastNameHint,
              border: Border.all(color: Colors.grey.withOpacity(0.6)),
              errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              borderRadius: heightDp * 8,
              isImportant: true,
              onChangeHandler: (input) => _storeModel.profile!["ownerInfo"]["lastName"] = input.trim(),
              validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.ownerLastNameValidate : null,
              onSaveHandler: (input) => _storeModel.profile!["ownerInfo"]["lastName"] = input.trim(),
              onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_businessDescriptionFocusNode),
            ),

            ///
            SizedBox(height: heightDp * 20),
            KeicyTextFormField(
              controller: _businessDescriptionController,
              focusNode: _businessDescriptionFocusNode,
              width: double.infinity,
              height: heightDp * 100,
              label: RegisterStorePageString.businessDescHint,
              labelSpacing: heightDp * 5,
              textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
              hintText: RegisterStorePageString.businessDescHint,
              border: Border.all(color: Colors.grey.withOpacity(0.6)),
              errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              borderRadius: heightDp * 8,
              maxLines: null,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              isImportant: true,
              onChangeHandler: (input) => _storeModel.description = input.trim(),
              validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.businessDescValidate : null,
              onSaveHandler: (input) => _storeModel.description = input.trim(),
              onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
            ),

            ///
            SizedBox(height: heightDp * 30),
          ],
        ),
      );
    });
  }

  void showCategoryDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => CategoryListProvider(_storeModel.subType!)),
              ],
              child: Consumer<CategoryListProvider>(builder: (context, categoryListProvider, _) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      runAlignment: WrapAlignment.spaceBetween,
                      spacing: widthDp * 10,
                      runSpacing: heightDp * 10,
                      children: List.generate(categories!.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            categoryListProvider.setCategory(categories![index]["categoryId"]);
                            setState(() {
                              _storeModel.subType = categories![index]["categoryId"];
                            });
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 8)),
                            child: Container(
                              width: widthDp * 105,
                              height: heightDp * 150,
                              decoration: BoxDecoration(
                                color: categoryListProvider.category == categories![index]["categoryId"]
                                    ? config.Colors().mainColor(1).withOpacity(0.2)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(heightDp * 8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/category-icon/${categories![index]["categoryId"].toLowerCase()}-icon.png",
                                    width: heightDp * 90,
                                    height: heightDp * 90,
                                    fit: BoxFit.cover,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        categories![index]["categoryDesc"],
                                        style: TextStyle(
                                          fontSize: fontSp * 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}

class CategoryListProvider extends ChangeNotifier {
  static CategoryListProvider of(BuildContext context, {bool listen = false}) => Provider.of<CategoryListProvider>(context, listen: listen);

  CategoryListProvider(String category) {
    _category = category;
  }

  String? _category;
  String? get category => _category;

  void setCategory(String category) {
    if (_category != category) {
      _category = category;
      notifyListeners();
    }
  }
}
