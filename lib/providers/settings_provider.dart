import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Currency {
  pyg('PYG', '₲', 'Guaraní Paraguayo'),
  usd('USD', '\$', 'Dólar Estadounidense'),
  eur('EUR', '€', 'Euro'),
  ars('ARS', '\$', 'Peso Argentino'),
  brl('BRL', 'R\$', 'Real Brasileño');

  final String code;
  final String symbol;
  final String name;

  const Currency(this.code, this.symbol, this.name);
}

class SettingsProvider with ChangeNotifier {
  static const String _currencyKey = 'currency';
  static const String _exchangeRateKey = 'exchange_rate_usd_pyg';

  Currency _currency = Currency.pyg;
  double _exchangeRateUsdPyg = 7500.0; // Tipo de cambio por defecto

  Currency get currency => _currency;
  double get exchangeRateUsdPyg => _exchangeRateUsdPyg;
  String get currencySymbol => _currency.symbol;
  String get currencyCode => _currency.code;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currencyCode = prefs.getString(_currencyKey);
      if (currencyCode != null) {
        _currency = Currency.values.firstWhere(
          (c) => c.code == currencyCode,
          orElse: () => Currency.pyg,
        );
      }
      _exchangeRateUsdPyg = prefs.getDouble(_exchangeRateKey) ?? 7500.0;
      notifyListeners();
    } catch (e) {
      // Si hay error, usar valores por defecto
      _currency = Currency.pyg;
      _exchangeRateUsdPyg = 7500.0;
    }
  }

  Future<void> setCurrency(Currency currency) async {
    if (_currency == currency) return;
    _currency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency.code);
    notifyListeners();
  }

  Future<void> setExchangeRateUsdPyg(double rate) async {
    if (rate <= 0) return;
    _exchangeRateUsdPyg = rate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_exchangeRateKey, rate);
    notifyListeners();
  }

  // Convertir de USD a PYG
  double convertUsdToPyg(double usdAmount) {
    return usdAmount * _exchangeRateUsdPyg;
  }

  // Convertir de PYG a USD
  double convertPygToUsd(double pygAmount) {
    return pygAmount / _exchangeRateUsdPyg;
  }

  // Convertir cualquier moneda a la moneda principal configurada
  double convertToMainCurrency(double amount, Currency fromCurrency) {
    if (fromCurrency == _currency) return amount;
    
    // Primero convertir a PYG
    double amountInPyg;
    if (fromCurrency == Currency.usd) {
      amountInPyg = convertUsdToPyg(amount);
    } else if (fromCurrency == Currency.pyg) {
      amountInPyg = amount;
    } else {
      // Para otras monedas, asumimos que ya están en la moneda principal
      // En una implementación completa, se agregarían más conversiones
      amountInPyg = amount;
    }

    // Luego convertir de PYG a la moneda principal
    if (_currency == Currency.usd) {
      return convertPygToUsd(amountInPyg);
    } else if (_currency == Currency.pyg) {
      return amountInPyg;
    } else {
      // Para otras monedas, retornar el valor en PYG
      return amountInPyg;
    }
  }
}

