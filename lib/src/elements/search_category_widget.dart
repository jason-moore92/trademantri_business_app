import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_utils/keyboard_listener.dart' as KeybardListener;
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';

class SearchItemWidget extends StatefulWidget {
  final List<dynamic>? itemList;
  final double width;
  final double? height;
  final double borderRadius;
  final double contentHorizontalPadding;
  final Color fillColor;
  final String label;
  final String hint;
  final double? labelSpacing;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? suggestTextStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry suggestionPadding;
  String initValue;
  final Function()? initHandler;
  final Function(String)? validatorHandler;
  final Function(String)? completeHandler;
  bool isEmpty;
  bool isReadOnly;
  bool isImportant;

  SearchItemWidget({
    @required this.itemList,
    this.width = double.infinity,
    @required this.height,
    this.borderRadius = 0,
    this.contentHorizontalPadding = 15,
    this.fillColor = Colors.transparent,
    this.label = "",
    this.hint = "",
    this.labelSpacing,
    this.labelStyle,
    this.textStyle,
    this.hintStyle,
    this.suggestTextStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.suggestionPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.initValue = "",
    @required this.initHandler,
    @required this.completeHandler,
    this.validatorHandler,
    this.isEmpty = true,
    this.isReadOnly = false,
    this.isImportant = false,
  });
  @override
  _SearchCategoryWidgetState createState() => _SearchCategoryWidgetState();
}

class _SearchCategoryWidgetState extends State<SearchItemWidget> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  Timer? debouncer;
  OverlayEntry? overlayEntry;

  RenderBox? searchFieldRenderBox;
  Size? seachFieldSize;
  Offset? seachFieldPosition;
  String? selectedPlaceID;

  String? oldSearchString;

  double fontSp = 0;

  KeyboardUtils _keyboardUtils = KeyboardUtils();
  int? _idKeyboardListener;

  @override
  void initState() {
    super.initState();

    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    selectedPlaceID = "";

    if (widget.initValue != "") {
      _controller.text = widget.initValue;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }

    _idKeyboardListener = _keyboardUtils.add(
      listener: KeybardListener.KeyboardListener(
        willHideKeyboard: () {
          clearOverlay();
        },
        willShowKeyboard: (double keyboardHeight) {},
      ),
    );
  }

  @override
  void dispose() {
    clearOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeicyTextFormField(
      width: widget.width,
      height: widget.height,
      controller: _controller,
      focusNode: _focusNode,
      fillColor: widget.fillColor,
      border: Border.all(color: Colors.grey.withOpacity(0.6)),
      errorBorder: Border.all(color: Colors.red),
      borderRadius: widget.borderRadius,
      contentHorizontalPadding: widget.contentHorizontalPadding,
      isImportant: widget.isImportant,
      label: widget.label,
      labelStyle: widget.labelStyle,
      labelSpacing: widget.labelSpacing,
      prefixIcons: widget.prefixIcon == null ? [] : [widget.prefixIcon!],
      readOnly: widget.isReadOnly,
      suffixIcons: _controller.text.isEmpty || widget.suffixIcon == null
          ? []
          : [
              GestureDetector(
                onTap: () {
                  _controller.clear();
                  clearOverlay();
                  if (widget.initHandler != null) widget.initHandler!();
                  setState(() {
                    widget.initValue = "";
                  });
                  widget.completeHandler!("");
                },
                child: widget.suffixIcon,
              )
            ],
      textStyle: widget.textStyle,
      hintStyle: widget.hintStyle,
      hintText: widget.hint,
      errorStringFontSize: fontSp * 10,
      onChangeHandler: (input) {
        if (oldSearchString == input) return;
        oldSearchString = input;

        if (widget.completeHandler != null && _controller.text.trim().isNotEmpty) {
          widget.completeHandler!(_controller.text.trim());
        }

        onSearchInputChange();
        setState(() {});
      },
      validatorHandler: (input) => widget.validatorHandler != null ? widget.validatorHandler!(input.trim()) : null,
      onTapHandler: () {
        searchPlace("");
      },
      onEditingCompleteHandler: () {
        // if (widget.completeHandler != null && _controller.text.trim().isNotEmpty) {
        //   widget.completeHandler({"name": _controller.text.trim()});
        // }
        clearOverlay();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onFieldSubmittedHandler: (input) {
        // if (widget.completeHandler != null && _controller.text.trim().isNotEmpty) {
        //   widget.completeHandler({"name": input.trim()});
        // }
        clearOverlay();
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  void onSearchInputChange() {
    if (_controller.text.isEmpty) {
      debouncer?.cancel();
      searchPlace(_controller.text);
      return;
    }

    if (debouncer?.isActive ?? false) {
      debouncer!.cancel();
    }

    debouncer = Timer(Duration(milliseconds: 500), () {
      searchPlace(_controller.text);
    });
  }

  /// Hides the autocomplete overlay
  void clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  void searchPlace(String searchKey) {
    clearOverlay();

    searchFieldRenderBox = context.findRenderObject() as RenderBox;
    seachFieldSize = searchFieldRenderBox!.size;
    seachFieldPosition = searchFieldRenderBox!.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: seachFieldPosition!.dx,
        top: seachFieldPosition!.dy + seachFieldSize!.height,
        width: seachFieldSize!.width,
        child: Material(
          elevation: 1,
          color: Colors.white,
          child: Container(
            padding: widget.suggestionPadding,
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry!);

    autoCompleteSearch(searchKey);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(String searchKey) async {
    List<dynamic> newCategoryList = [];

    for (var i = 0; i < widget.itemList!.length; i++) {
      if (widget.itemList![i].toString().toLowerCase().contains(searchKey.toLowerCase())) {
        newCategoryList.add(widget.itemList![i]);
      } else if (searchKey == "") {
        newCategoryList.add(widget.itemList![i]);
      }
    }

    if (newCategoryList.length != 0) {
      displayAutoCompleteSuggestions(newCategoryList);
    } else {
      clearOverlay();
    }
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<dynamic> suggestions) {
    clearOverlay();

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: seachFieldPosition!.dx,
        top: seachFieldPosition!.dy + seachFieldSize!.height,
        width: seachFieldSize!.width,
        child: Material(
          elevation: 8,
          color: Colors.white,
          child: Container(
            constraints: BoxConstraints(maxHeight: widget.height! * 3.5),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowGlow();
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: suggestions
                      .map(
                        (suggestion) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              child: InkWell(
                                onTap: () {
                                  clearOverlay();
                                  if (widget.completeHandler != null) {
                                    widget.completeHandler!(suggestion);
                                    _controller.text = suggestion;
                                  }
                                  setState(() {});
                                  FocusScope.of(context).requestFocus(FocusNode());
                                },
                                child: Container(
                                  width: seachFieldSize!.width,
                                  color: Colors.white,
                                  padding: widget.suggestionPadding,
                                  child: Text(
                                    "$suggestion",
                                    style: widget.suggestTextStyle,
                                  ),
                                ),
                              ),
                            ),
                            suggestion == suggestions.last
                                ? SizedBox()
                                : Divider(
                                    color: Color(0xFFC7CBD6),
                                    height: 1,
                                    thickness: 1,
                                    indent: widget.suggestionPadding.horizontal / 2,
                                    endIndent: widget.suggestionPadding.horizontal / 2,
                                  ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry!);
  }
}
