import 'package:employee_tracker/src/presentation/screens/add_edit_employee_screen.dart';
import 'package:employee_tracker/src/presentation/screens/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'src/cubit/employee_cubit.dart';
import 'src/presentation/services/employee_service.dart';

import 'src/database/employee_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeCubit(EmployeeService()),
      child: MaterialApp(
        title: 'Employee Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: EmployeeListScreen(),
      ),
    );
  }
}
// yo
