import 'package:hive/hive.dart';

part 'transaction_record.g.dart';

@HiveType(typeId: 2)
class Transaction extends HiveObject {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final DateTime date;

  Transaction({
    required this.amount,
    required this.date,
  });
}