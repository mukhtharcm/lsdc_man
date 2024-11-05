import 'package:equatable/equatable.dart';

class Donation extends Equatable {
  final String id;
  final String userId;
  final String teamId;
  final DateTime date;
  final int stock;
  final int calendars; // Number of calendars
  final int balance;
  final Map<String, int> denominations; // {500: 3, 200: 2, etc}
  final int expense;
  final int batta;

  const Donation({
    required this.id,
    required this.userId,
    required this.teamId,
    required this.date,
    required this.stock,
    required this.calendars,
    required this.balance,
    required this.denominations,
    required this.expense,
    required this.batta,
  });

  // Calculate total amount from denominations
  int get totalAmount {
    return denominations.entries
        .fold(0, (sum, entry) => sum + (int.parse(entry.key) * entry.value));
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        teamId,
        date,
        stock,
        calendars,
        balance,
        denominations,
        expense,
        batta,
      ];

  // Factory method to create from PocketBase response
  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      id: map['id'],
      userId: map['user_id'],
      teamId: map['team_id'],
      date: DateTime.parse(map['date']),
      stock: map['stock'],
      calendars: map['calendars'],
      balance: map['balance'],
      denominations: Map<String, int>.from(map['denominations']),
      expense: map['expense'],
      batta: map['batta'],
    );
  }

  // Convert to map for PocketBase
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'team_id': teamId,
      'date': date.toIso8601String(),
      'stock': stock,
      'calendars': calendars,
      'balance': balance,
      'denominations': denominations,
      'expense': expense,
      'batta': batta,
    };
  }
}
