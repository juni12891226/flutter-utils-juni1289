import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_utils_juni1289/apputil/app_util_helper.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/changecase/string_change_case_helper_util.dart';
import 'package:flutter_utils_juni1289/exceptions/number_of_month_out_of_range_exception.dart';

class DateTimeHelperUtil {
  /// private constructor
  DateTimeHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = DateTimeHelperUtil._();

  ///To get the date time string from saving the file
  ///To make the file name unique, this can be used as a file name string
  String getCurrentDateTimeForFileName() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("ddMMyyyy").format(now);
    String randomString = "$formattedDate${now.hour}${now.minute}${now.millisecond}${now.microsecond}";
    return randomString;
  }

  ///Get the current date and time
  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    return now.toString();
  }

  ///get the date from the string
  ///format that date with given format
  ///and return
  ///[inputDate] is given date to get string from
  ///[outputFormat] is used to get the date string in
  String getDateAsString({required DateTime inputDate, required String outputFormat}) {
    String requiredDate = "";
    try {
      var formatter = DateFormat(outputFormat);
      requiredDate = formatter.format(inputDate);
    } catch (exception) {
      requiredDate = "";
    }
    return requiredDate;
  }

  ///convert the given time in AM PM
  ///[givenTime] is required
  String? getTimeInAmPm({required String givenTime}) {
    try {
      String formattedDate = "";
      if (givenTime.isNotEmpty) {
        DateTime parseDate = DateFormat("HH:mm:ss").parse(givenTime);
        formattedDate = DateFormat("hh:mm a").format(parseDate);
      }
      return formattedDate;
    } catch (exp) {
      AppHelperUtil.instance.showLog("Exception in getTimeInAmPm:::$exp");
    }

    return null;
  }

  ///For the calendar predicate date has a threshold to
  ///Show the calendar with current date "threshold" number of years
  ///Suppose the calendar should show the current date 18 years back later
  ///[numberOfYearsBehind] is the int value to be used as number of years behind
  DateTime getMaxDateTimeForYearsBehind({required int numberOfYearsBehind}) {
    DateTime now = DateTime.now();
    return DateTime((now.year) - numberOfYearsBehind, now.month, now.day);
  }

  ///Get the full name of the month
  ///[monthNumber] is required and should be 12 max
  ///[stringChangeCaseEnum] is optional | if you want to change the month name string case
  ///For Example 3 = March
  String getAlphabeticFullMonthName({required int monthNumber, StringChangeCaseEnums? stringChangeCaseEnum}) {
    List monthsFullAlphabet = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    if (monthNumber < monthsFullAlphabet.length) {
      return stringChangeCaseEnum != null
          ? StringChangeCaseHelperUtil.instance.changeCase(givenString: monthsFullAlphabet[monthNumber - 1], stringChangeCaseEnum: stringChangeCaseEnum)
          : monthsFullAlphabet[monthNumber - 1];
    }

    throw NumberOfMonthOutOfRangeException(cause: "The given month number is out of range (Max=12)");
  }

  ///Get the short name of the month
  ///[monthNumber] is required and should be 12 max
  ///[stringChangeCaseEnum] is optional | if you want to change the month name string case
  ///For Example 3 = Mar
  String getAlphabeticShortMonthName({required int monthNumber, StringChangeCaseEnums? stringChangeCaseEnum}) {
    List monthsAlphabet = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (monthNumber < monthsAlphabet.length) {
      return stringChangeCaseEnum != null
          ? StringChangeCaseHelperUtil.instance.changeCase(givenString: monthsAlphabet[monthNumber - 1], stringChangeCaseEnum: stringChangeCaseEnum)
          : monthsAlphabet[monthNumber - 1];
    }

    throw NumberOfMonthOutOfRangeException(cause: "The given month number is out of range (Max=12)");
  }

  ///Get the date after number of days
  ///[numberOfDays] is optional and the default value is 30
  ///Suppose you need to calculate the due date after number of days
  ///Calculated from today's date after the number of days
  ///Suppose what date will be from today to 7 days after
  ///[requiredDateFormat] is optional | if you want to get the result date time in required format
  String getDateAfterDays({int numberOfDays = 30, String requiredDateFormat = "dd/MM/yyyy"}) {
    String date = DateFormat(requiredDateFormat).format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + numberOfDays));
    return date;
  }

  ///get the date before number of days
  ///[numberOfDays] is optional and the default value is 30
  ///Suppose you need to calculate the before date for number of days
  ///calculated from today's date before the number of days
  ///suppose what date was from today to 7 days before
  ///[requiredDateFormat] is optional | if you want to get the result date time in required format
  String getDateBeforeDays({int numberOfDays = 30, String requiredDateFormat = "dd/MM/yyyy"}) {
    String date = DateFormat(requiredDateFormat).format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - numberOfDays));
    return date;
  }

  ///Get the Full name of the week day
  ///[dayNumber] is required and should be 7 max
  ///[stringChangeCaseEnum] is optional | if you want to change the month name string case
  ///For Example  5 = Friday
  String getWeekDayFullName({required int dayNumber, StringChangeCaseEnums? stringChangeCaseEnum}) {
    List dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    if (dayNumber < dayNames.length) {
      return stringChangeCaseEnum != null
          ? StringChangeCaseHelperUtil.instance.changeCase(givenString: dayNames[dayNumber - 1], stringChangeCaseEnum: stringChangeCaseEnum)
          : dayNames[dayNumber - 1];
    }

    throw NumberOfMonthOutOfRangeException(cause: "The given day number is out of range (Max=7)");
  }

  ///Get the Short name of the week day
  ///[dayNumber] is required and should be 7 max
  ///[stringChangeCaseEnum] is optional | if you want to change the month name string case
  ///For Example  5 = Fri
  String getWeekDayShortName({required int dayNumber, StringChangeCaseEnums? stringChangeCaseEnum}) {
    List dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (dayNumber < dayNames.length) {
      return stringChangeCaseEnum != null
          ? StringChangeCaseHelperUtil.instance.changeCase(givenString: dayNames[dayNumber - 1], stringChangeCaseEnum: stringChangeCaseEnum)
          : dayNames[dayNumber - 1];
    }

    throw NumberOfMonthOutOfRangeException(cause: "The given day number is out of range (Max=7)");
  }

  ///Get the number of days between the two dates
  ///[from] is required
  ///[to] is required
  int getDaysBetweenTwoDates({required DateTime from, required DateTime to}) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  ///Get the difference between the two dates
  ///[datetimeFrom] is required
  ///[dateTimeTo] is required
  ///[datesDifferenceEnum] is required
  ///[datesDifferenceEnum] ==> inDays, inHours, inMinutes, inSeconds, inMilliseconds, inMicroseconds
  int getDifferenceBetweenDates({required DateTime datetimeFrom, required DateTime dateTimeTo, required DatesDifferenceEnums datesDifferenceEnum}) {
    if (datesDifferenceEnum == DatesDifferenceEnums.inDays) {
      return datetimeFrom.difference(dateTimeTo).inDays;
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inHours) {
      return datetimeFrom.difference(dateTimeTo).inHours;
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inMicroseconds) {
      return datetimeFrom.difference(dateTimeTo).inMicroseconds;
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inMilliseconds) {
      return datetimeFrom.difference(dateTimeTo).inMilliseconds;
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inMinutes) {
      return datetimeFrom.difference(dateTimeTo).inMinutes;
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inSeconds) {
      return datetimeFrom.difference(dateTimeTo).inSeconds;
    } else {
      return datetimeFrom.difference(dateTimeTo).inDays;
    }
  }

  ///To change the given datetime to desired format
  ///'2021/01/19' ==> January 1st 2021, 12:00:00 AM;
  ///[givenDateTime] is required
  ///[requiredDateTimeFormat] is required
  String getChangedDateTimeFormatJiffy({required String givenDateTime, required String requiredDateTimeFormat}) {
    return Jiffy.parse(givenDateTime).format(pattern: requiredDateTimeFormat);
  }

  ///Get the current day name | Today name
  String getTodayDayNameJiffy() {
    return Jiffy.now().format(pattern: 'EEEE');
  }

  ///Get the current date time in required format
  ///[requiredDateTimeFormat] is required
  String getCurrentDateTimeWithFormat({required String requiredDateTimeFormat}) {
    return Jiffy.now().format(pattern: requiredDateTimeFormat);
  }

  ///Get the future date by adding the time
  ///Will return the currentDatetime+timePeriod ==> Future DateTime
  ///[requiredDateTimeFormat] is the format in which date time is required
  ///[timePeriod] is the number of days, hours, seconds, microseconds, milliseconds or hours to be added
  ///[datesDifferenceEnum] to specify the unit of Time Period ==> inDays, inHours, inMinutes, inSeconds, inMilliseconds, inMicroseconds
  String getFutureDateByAddingTimeJiffy({required String requiredDateTimeFormat, required int timePeriod, required DatesDifferenceEnums datesDifferenceEnum}) {
    var jiffy = Jiffy.now();
    if (datesDifferenceEnum == DatesDifferenceEnums.inDays) {
      jiffy.add(days: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inSeconds) {
      jiffy.add(seconds: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inMinutes) {
      jiffy.add(minutes: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inMilliseconds) {
      jiffy.add(milliseconds: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inMicroseconds) {
      jiffy.add(microseconds: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inHours) {
      jiffy.add(hours: timePeriod);
    }
    return getChangedDateTimeFormatJiffy(givenDateTime: jiffy.yMMMMd, requiredDateTimeFormat: requiredDateTimeFormat);
  }

  ///Get the past date by adding the time
  ///Will return the currentDatetime-timePeriod ==> Past DateTime
  ///[requiredDateTimeFormat] is the format in which date time is required
  ///[timePeriod] is the number of days, hours, seconds, microseconds, milliseconds or hours to be subtracted
  ///[datesDifferenceEnum] to specify the unit of Time Period ==> inDays, inHours, inMinutes, inSeconds, inMilliseconds, inMicroseconds
  String getPastDateByAddingTimeJiffy({required String requiredDateTimeFormat, required int timePeriod, required DatesDifferenceEnums datesDifferenceEnum}) {
    var jiffy = Jiffy.now();
    if (datesDifferenceEnum == DatesDifferenceEnums.inDays) {
      jiffy.subtract(days: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inSeconds) {
      jiffy.subtract(seconds: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inMinutes) {
      jiffy.subtract(minutes: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inMilliseconds) {
      jiffy.subtract(milliseconds: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inMicroseconds) {
      jiffy.subtract(microseconds: timePeriod);
    } else if (datesDifferenceEnum == DatesDifferenceEnums.inHours) {
      jiffy.subtract(hours: timePeriod);
    }
    return getChangedDateTimeFormatJiffy(givenDateTime: jiffy.yMMMMd, requiredDateTimeFormat: requiredDateTimeFormat);
  }

  ///Query the the date time
  ///[dateTimeQueryEnum] ==> isBefore, isAfter, isSame, isBetween
  ///Is the [dateTime1] is before [dateTime2]
  ///Is the [dateTime1] is after [dateTime2]
  ///Is [dateTime1] is same as [dateTime2]
  ///Is [dateTime1] and [dateTime2] are between [dateTimeToInBetween]
  bool queryDateTimeJiffy({required DateTimeQueryEnums dateTimeQueryEnum, required String dateTime1, required String dateTime2, String? dateTimeToInBetween}) {
    bool result = false;

    if (dateTimeQueryEnum == DateTimeQueryEnums.isBefore) {
      result = Jiffy.parse(dateTime1).isBefore(Jiffy.parse(dateTime2));
    } else if (dateTimeQueryEnum == DateTimeQueryEnums.isAfter) {
      result = Jiffy.parse(dateTime1).isAfter(Jiffy.parse(dateTime2));
    } else if (dateTimeQueryEnum == DateTimeQueryEnums.isSame) {
      result = Jiffy.parse(dateTime1).isSame(Jiffy.parse(dateTime2));
    } else if (dateTimeQueryEnum == DateTimeQueryEnums.isBetween) {
      if (dateTimeToInBetween != null && dateTimeToInBetween.isNotEmpty) {
        result = Jiffy.parse(dateTimeToInBetween).isBetween(Jiffy.parse(dateTime1), Jiffy.parse(dateTime1)); // true
      }
    }

    return result;
  }
}
