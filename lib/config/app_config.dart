import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mt;

class Colors {
  Color _mainColor = Color(0xFFf46f2c);
  Color _mainDarkColor = Color(0xFFf46f2c);
  Color _main1Color = Color.fromRGBO(53, 110, 162, 1);
  Color _main1DarkColor = Color.fromRGBO(53, 81, 162, 1);
  Color _main2Color = mt.Colors.green.shade500;
  Color _main2DarkColor = mt.Colors.green.shade600;
  Color _secondColor = Color(0xFF000000);
  Color _secondDarkColor = Color(0xFFccccdd);
  Color _accentColor = Color(0xFF8C98A8);
  Color _accentDarkColor = Color(0xFF9999aa);

  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color main1Color(double opacity) {
    return this._main1Color.withOpacity(opacity);
  }

  Color main2Color(double opacity) {
    return this._main2Color.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color main1DarkColor(double opacity) {
    return this._main1DarkColor.withOpacity(opacity);
  }

  Color main2DarkColor(double opacity) {
    return this._main2DarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }

  Map<String, Color> _pieColors = {
    "below_20": mt.Colors.blue.shade500,
    "20_45": mt.Colors.green.shade500,
    "46_65": mt.Colors.pink.shade500,
    "66_above": mt.Colors.orange.shade500,
  };

  Color customerAgeGroup(String key) {
    return this._pieColors[key] ?? mt.Colors.blue.shade500;
  }
}
