import 'package:employee_tracker/src/presentation/layout/resonsive_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/employee_model.dart';
import '../../utils/format_date.dart';
import '../../utils/snackbar_helper.dart';
import '../../cubit/employee_cubit.dart';

import 'add_edit_employee_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBody(
      body: Scaffold(
        appBar: AppBar(
          title: Text(
            'Employee List',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: false,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey[200],
        body: BlocBuilder<EmployeeCubit, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is EmployeeLoaded) {
              if (state.employees.isEmpty)
                return Center(child: Image.asset('assets/empty_list.png'));
              final currentEmployees =
                  state.employees.where((e) => e.quittingDate == null).toList();
              final previousEmployees =
                  state.employees.where((e) => e.quittingDate != null).toList();

              return ListView(
                children: [
                  if (currentEmployees.isNotEmpty)
                    _buildEmployeeSection('Current Employees', currentEmployees),
                  if (previousEmployees.isNotEmpty)
                    _buildEmployeeSection('Previous Employees', previousEmployees),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text('Swipe left to delete', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No employees found.'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () => _navigateToAddEditScreen(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  /// Builds a section for employees (Current/Previous)
  Widget _buildEmployeeSection(String title, List<Employee> employees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            title,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Container(
          color: Colors.white,
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: employees.length,
            separatorBuilder: (_, __) => Divider(height: 1),
            itemBuilder: (context, index) => EmployeeDetailsTile(employee: employees[index]),
          ),
        ),
      ],
    );
  }

  /// Navigates to Add/Edit Employee Screen
  void _navigateToAddEditScreen(BuildContext context, {Employee? employee}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditEmployeeScreen(existingEmployee: employee),
      ),
    );
  }
}

class EmployeeDetailsTile extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailsTile({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete_outline_rounded, color: Colors.white),
        ),
      ),
      onDismissed: (direction) => _deleteEmployeeWithUndo(context),
      child: ListTile(
        title: Text(employee.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              employee.position,
              style: TextStyle(fontSize: 16, color: Color(0xff949C9E)),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  employee.quittingDate == null
                      ? 'From ${formatDate(employee.joiningDate)}'
                      : formatDate(employee.joiningDate),
                  style: TextStyle(fontSize: 14, color: Color(0xff949C9E)),
                ),
                if (employee.quittingDate != null)
                  Text(
                    ' - ${formatDate(
                      employee.quittingDate!,
                    )}',
                    style: TextStyle(fontSize: 14, color: Color(0xff949C9E)),
                  )
              ],
            )
          ],
        ),
        onTap: () => _navigateToEditScreen(context),
      ),
    );
  }

  /// Handles delete with undo functionality
  void _deleteEmployeeWithUndo(BuildContext context) {
    final cubit = context.read<EmployeeCubit>();

    cubit.deleteEmployee(employee);

    showSnackbar(
      context,
      'Employee data has been deleted',
      undo: () => cubit.addEmployee(employee),
    );
  }

  /// Navigates to Edit Employee Screen
  void _navigateToEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditEmployeeScreen(existingEmployee: employee)),
    );
  }
}
