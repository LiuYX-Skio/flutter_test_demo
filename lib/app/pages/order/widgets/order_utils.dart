class OrderPriceUtils {
  static String priceInt(String? price) {
    final value = price ?? '';
    if (value.isEmpty) return '0';
    if (value.contains('.')) {
      return value.split('.').first;
    }
    return value;
  }

  static String priceDecimal(String? price) {
    final value = price ?? '';
    if (value.isEmpty) return '.00';
    if (value.contains('.')) {
      final parts = value.split('.');
      final decimal = parts.length > 1 ? parts[1] : '00';
      final fixed = decimal.padRight(2, '0');
      return '.${fixed.substring(0, 2)}';
    }
    return '.00';
  }

  static String priceWithSymbol(String? price) {
    final value = price ?? '';
    if (value.isEmpty) return '￥0.00';
    return '￥$value';
  }
}
