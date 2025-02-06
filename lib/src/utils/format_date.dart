import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('d MMM yyyy').format(date); // Format as "21 Sep 2022"
}
