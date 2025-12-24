import 'package:intl/intl.dart';
import 'package:myapp/providers/settings_provider.dart';

class CurrencyFormatter {
  static String format(double amount, {Currency? currency, SettingsProvider? settings}) {
    final currencyToUse = currency ?? settings?.currency ?? Currency.pyg;
    final symbol = currencyToUse.symbol;
    
    // Para PYG, no usar decimales (es moneda sin centavos)
    if (currencyToUse == Currency.pyg) {
      return NumberFormat.currency(
        symbol: symbol,
        decimalDigits: 0,
      ).format(amount);
    }
    
    // Para otras monedas, usar 2 decimales
    return NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    ).format(amount);
  }

  static String formatWithCode(double amount, {Currency? currency, SettingsProvider? settings}) {
    final currencyToUse = currency ?? settings?.currency ?? Currency.pyg;
    final formatted = format(amount, currency: currencyToUse, settings: settings);
    return '$formatted ${currencyToUse.code}';
  }
}

