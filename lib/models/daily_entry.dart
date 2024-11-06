import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

class DailyEntry extends Equatable {
  final String id;
  final String userId;
  final String teamId;
  final DateTime date;
  final int noOfCalendar;
  final int soldNo;
  final double balance;
  final int d500;
  final int d200;
  final int d100;
  final int d50;
  final int d20;
  final int d10;
  final int d5;
  final int d2;
  final int d1;
  final double expense;
  final double batta;
  final double total;

  const DailyEntry({
    required this.id,
    required this.userId,
    required this.teamId,
    required this.date,
    required this.noOfCalendar,
    required this.soldNo,
    required this.balance,
    required this.d500,
    required this.d200,
    required this.d100,
    required this.d50,
    required this.d20,
    required this.d10,
    required this.d5,
    required this.d2,
    required this.d1,
    required this.expense,
    required this.batta,
    required this.total,
  });

  factory DailyEntry.create({
    required String id,
    required String userId,
    required String teamId,
    required DateTime date,
    required int noOfCalendar,
    required int soldNo,
    required int d500,
    required int d200,
    required int d100,
    required int d50,
    required int d20,
    required int d10,
    required int d5,
    required int d2,
    required int d1,
    required double expense,
    required double batta,
  }) {
    final total = (d500 * 500) +
        (d200 * 200) +
        (d100 * 100) +
        (d50 * 50) +
        (d20 * 20) +
        (d10 * 10) +
        (d5 * 5) +
        (d2 * 2) +
        (d1 * 1).toDouble();

    return DailyEntry(
      id: id,
      userId: userId,
      teamId: teamId,
      date: date,
      noOfCalendar: noOfCalendar,
      soldNo: soldNo,
      balance: (noOfCalendar - soldNo).toDouble(),
      d500: d500,
      d200: d200,
      d100: d100,
      d50: d50,
      d20: d20,
      d10: d10,
      d5: d5,
      d2: d2,
      d1: d1,
      expense: expense,
      batta: batta,
      total: total,
    );
  }

  static DailyEntry fromRecord(RecordModel record) {
    return DailyEntry(
      id: record.id,
      userId: record.getStringValue('user'),
      teamId: record.getStringValue('team'),
      date: DateTime.parse(record.getStringValue('date')),
      noOfCalendar: record.getIntValue('no_of_calendar'),
      soldNo: record.getIntValue('sold_no'),
      balance: record.getDoubleValue('balance'),
      d500: record.getIntValue('d500'),
      d200: record.getIntValue('d200'),
      d100: record.getIntValue('d100'),
      d50: record.getIntValue('d50'),
      d20: record.getIntValue('d20'),
      d10: record.getIntValue('d10'),
      d5: record.getIntValue('d5'),
      d2: record.getIntValue('d2'),
      d1: record.getIntValue('d1'),
      expense: record.getDoubleValue('expense'),
      batta: record.getDoubleValue('batta'),
      total: record.getDoubleValue('total'),
    );
  }

  Map<String, dynamic> toJson() {
    final total = calculateTotal();
    return {
      'user': userId,
      'team': teamId,
      'date': date.toIso8601String().split('T')[0],
      'no_of_calendar': noOfCalendar,
      'sold_no': soldNo,
      'balance': noOfCalendar - soldNo,
      'd500': d500,
      'd200': d200,
      'd100': d100,
      'd50': d50,
      'd20': d20,
      'd10': d10,
      'd5': d5,
      'd2': d2,
      'd1': d1,
      'expense': expense,
      'batta': batta,
      'total': total,
    };
  }

  double calculateTotal() {
    return (d500 * 500) +
        (d200 * 200) +
        (d100 * 100) +
        (d50 * 50) +
        (d20 * 20) +
        (d10 * 10) +
        (d5 * 5) +
        (d2 * 2) +
        (d1 * 1).toDouble();
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        teamId,
        date,
        noOfCalendar,
        soldNo,
        balance,
        d500,
        d200,
        d100,
        d50,
        d20,
        d10,
        d5,
        d2,
        d1,
        expense,
        batta,
        total,
      ];
}
