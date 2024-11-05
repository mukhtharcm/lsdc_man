import 'package:equatable/equatable.dart';
import 'user.dart';
import 'team.dart';

class DailyEntry extends Equatable {
  final String id;
  final User user;
  final Team team;
  final DateTime date;
  final int noOfCalendar;
  final int soldNo;
  final int balance;
  final int d500;
  final int d200;
  final int d100;
  final int d50;
  final int d20;
  final int d10;
  final int d5;
  final int d2;
  final int d1;
  final int expense;
  final int batta;

  const DailyEntry({
    required this.id,
    required this.user,
    required this.team,
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
  });

  // Calculate total amount from denominations
  int get totalAmount {
    return (d500 * 500) +
        (d200 * 200) +
        (d100 * 100) +
        (d50 * 50) +
        (d20 * 20) +
        (d10 * 10) +
        (d5 * 5) +
        (d2 * 2) +
        d1;
  }

  @override
  List<Object?> get props => [
        id,
        user,
        team,
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
      ];

  factory DailyEntry.fromMap(Map<String, dynamic> map) {
    return DailyEntry(
      id: map['id'],
      user: User.fromMap(map['expand']['user']),
      team: Team.fromMap(map['expand']['team']),
      date: DateTime.parse(map['date']),
      noOfCalendar: map['no_of_calendar'],
      soldNo: map['sold_no'],
      balance: map['balance'],
      d500: map['d500'],
      d200: map['d200'],
      d100: map['d100'],
      d50: map['d50'],
      d20: map['d20'],
      d10: map['d10'],
      d5: map['d5'],
      d2: map['d2'],
      d1: map['d1'],
      expense: map['expense'],
      batta: map['batta'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.id,
      'team': team.id,
      'date': date.toIso8601String(),
      'no_of_calendar': noOfCalendar,
      'sold_no': soldNo,
      'balance': balance,
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
    };
  }
}
