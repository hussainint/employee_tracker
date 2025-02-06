import 'package:hive_ce/hive.dart';
import '../../database/employee_model.dart';

class EmployeeService {
  static const String _boxName = 'employee_box';

  Future<Box<Employee>> getEmployeeBox() async {
    return await Hive.openBox<Employee>(_boxName);
  }

  Future<void> addEmployee(Employee employee) async {
    var box = await getEmployeeBox();
    box.add(employee);
  }

  Future<void> updateEmployee(int index, Employee employee) async {
    var box = await getEmployeeBox();
    box.putAt(index, employee);
  }

  Future<void> deleteEmployee(int index) async {
    var box = await getEmployeeBox();
    box.deleteAt(index);
  }

  Future<List<Employee>> getAllEmployees() async {
    var box = await getEmployeeBox();
    return box.values.toList();
  }
}
