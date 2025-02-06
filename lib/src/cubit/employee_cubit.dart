import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../database/employee_model.dart';
import '../presentation/services/employee_service.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeService employeeService;

  EmployeeCubit(this.employeeService) : super(EmployeeInitial()) {
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      emit(EmployeeLoading());
      final employees = await employeeService.getAllEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to load employees'));
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await employeeService.addEmployee(employee);
      await loadEmployees();
    } catch (e) {
      emit(EmployeeError('Failed to add employee'));
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      final employees = await employeeService.getAllEmployees();
      int? index;
      for (int i = 0; i < employees.length; i++) {
        if (employees[i].key == employee.key) index = i;
      }
      if (index != null) await employeeService.updateEmployee(index, employee);
      await loadEmployees();
    } catch (e) {
      emit(EmployeeError('Failed to update employee'));
    }
  }

  Future<void> deleteEmployee(Employee employee) async {
    try {
      final employees = await employeeService.getAllEmployees();
      int? index;
      for (int i = 0; i < employees.length; i++) {
        if (employees[i].key == employee.key) index = i;
      }
      if (index != null) await employeeService.updateEmployee(index, employee);
      await employeeService.deleteEmployee(index!);
      await loadEmployees();
    } catch (e) {
      emit(EmployeeError('Failed to delete employee'));
    }
  }
}
