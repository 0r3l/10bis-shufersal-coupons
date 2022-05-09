import 'package:intl/intl.dart';

class Util {
  static NumberFormat currency() {
    var format = NumberFormat.simpleCurrency(locale: 'he_HE');
    return format;
  }
}
