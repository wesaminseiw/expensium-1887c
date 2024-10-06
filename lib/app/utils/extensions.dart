extension DateTimeWeekOfYear on DateTime {
  int get weekOfYear {
    // Get the first day of the year
    DateTime firstDayOfYear = DateTime(year);
    // Calculate the difference in days between the current date and the first day of the year
    int dayOfYear = difference(firstDayOfYear).inDays + 1;
    // Calculate the week number
    return ((dayOfYear - 1) / 7).floor() + 1;
  }
}
