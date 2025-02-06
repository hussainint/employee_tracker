import 'package:hive_ce/hive.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  String key;
  @HiveField(1)
  String name;

  @HiveField(2)
  String position;

  @HiveField(3)
  DateTime joiningDate;

  @HiveField(4)
  DateTime? quittingDate;

  Employee({
    required this.key,
    required this.name,
    required this.position,
    required this.joiningDate,
    this.quittingDate,
  });
}
