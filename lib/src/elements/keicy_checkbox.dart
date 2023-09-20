library keicy_checkbox;

import 'package:flutter/material.dart';

class KeicyCheckBox extends FormField<Map<String, dynamic>> {
  KeicyCheckBox({
    Key? key,
    bool? value = false,
    IconData? trueIcon = Icons.check_box,
    IconData? falseIcon = Icons.check_box_outline_blank,
    @required double? iconSize,
    Color? iconColor = Colors.blue,
    Color? trueIconColor,
    Color? falseIconColor,
    Color? disabledColor = Colors.grey,
    String? label = "",
    TextStyle? labelStyle,
    double? labelSpacing = 10,
    bool? autovalidate = false,
    bool? enabled = true,
    bool? readOnly = false,
    bool? stateChangePossible = false,
    Function(bool)? onSaveHandler,
    Function(bool)? onChangeHandler,
    FormFieldValidator<bool>? onValidateHandler,
  }) : super(
          key: key,
          initialValue: {"value": value, "oldValue": value},
          autovalidateMode: autovalidate! ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (onValidateHandler != null) return onValidateHandler(value!["value"]);
            return null;
          },
          onSaved: (value) {
            if (onSaveHandler != null) onSaveHandler(value!["value"]);
          },
          builder: (FormFieldState<Map<String, dynamic>> state) {
            trueIconColor = trueIconColor ?? iconColor;
            falseIconColor = falseIconColor ?? iconColor;
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              if (stateChangePossible! || value != state.value!["oldValue"]) {
                state.didChange({"value": value, "oldValue": value});
              }
            });

            return Padding(
              padding: EdgeInsets.zero,
              child: state.value!["value"]
                  ? _createTappableIcon(
                      state,
                      enabled,
                      readOnly,
                      trueIcon,
                      trueIconColor,
                      disabledColor,
                      iconSize,
                      label,
                      stateChangePossible,
                      onChangeHandler,
                      labelStyle,
                      labelSpacing,
                    )
                  : _createTappableIcon(
                      state,
                      enabled,
                      readOnly,
                      falseIcon,
                      falseIconColor,
                      disabledColor,
                      iconSize,
                      label,
                      stateChangePossible,
                      onChangeHandler,
                      labelStyle,
                      labelSpacing,
                    ),
            );
          },
        );

  static Widget _createTappableIcon(
    FormFieldState<Map<String, dynamic>>? state,
    bool? enabled,
    bool? readOnly,
    IconData? icon,
    Color? iconColor,
    Color? disabledColor,
    double? iconSize,
    String? label,
    bool? stateChangePossible,
    Function(bool)? onChangeHandler,
    TextStyle? labelStyle,
    double? labelSpacing,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (enabled! && !readOnly!)
              ? () {
                  tapHandler(state, stateChangePossible, onChangeHandler);
                }
              : null,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Icon(icon, color: enabled ? iconColor : disabledColor, size: iconSize),
              (label == "") ? const SizedBox() : SizedBox(width: labelSpacing),
              (label == "") ? const SizedBox() : Text(label!, style: labelStyle)
            ],
          ),
        ),
        (state!.hasError)
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  (state.errorText ?? ""),
                  style: TextStyle(fontSize: (labelStyle != null) ? labelStyle.fontSize! * 0.8 : 12, color: Colors.red),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

void tapHandler(FormFieldState<Map<String, dynamic>>? state, bool? stateChangePossible, Function(bool)? onChangeHandler) {
  bool newState = !state!.value!["value"];
  state.didChange({"value": newState, "oldValue": state.value!["oldValue"]});
  if (onChangeHandler != null) onChangeHandler(newState);
}
