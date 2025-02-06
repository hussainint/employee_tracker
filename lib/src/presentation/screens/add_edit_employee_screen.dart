import 'package:employee_tracker/src/cubit/employee_cubit.dart';
import 'package:employee_tracker/src/presentation/layout/resonsive_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/employee_model.dart';
import '../../utils/snackbar_helper.dart';
import '../widgets/custom_datePicker.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_textfield.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? existingEmployee;
  const AddEditEmployeeScreen({this.existingEmployee});

  @override
  _AddEditEmployeeScreenState createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  late TextEditingController nameController = TextEditingController();
  String? positionController;
  DateTime? joiningDate = DateTime.now();
  DateTime? quittingDate;

  @override
  void initState() {
    super.initState();
    if (widget.existingEmployee != null) {
      nameController.text = widget.existingEmployee?.name ?? '';
      positionController = widget.existingEmployee?.position ?? '';
      joiningDate = widget.existingEmployee?.joiningDate;
      quittingDate = widget.existingEmployee?.quittingDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBody(
      body: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            widget.existingEmployee == null ? 'Add Employee Details' : 'Edit Employee Details',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            if (widget.existingEmployee != null)
              IconButton(
                onPressed: () {
                  final cubit = context.read<EmployeeCubit>();

                  // cubit.deleteEmployee(widget.existingEmployee!.id);
                  Navigator.pop(context);
                  showSnackbar(
                    context,
                    'Employee data has been deleted',
                    undo: () => cubit.addEmployee(widget.existingEmployee!),
                  );
                },
                icon: Icon(Icons.delete_outline),
              ),
          ],
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: 'Employee Name',
                      controller: nameController,
                      prefixIcon: Icon(Icons.person_outline, color: Colors.blue),
                    ),
                    SizedBox(height: 15),
                    CustomDropdown<String>(
                      hintText: 'Select role',
                      value: positionController,
                      items: [
                        'Product Designer',
                        'Flutter Developer',
                        'QA Tester',
                        'Product Owner'
                      ],
                      onChanged: (String? newValue) {
                        positionController = newValue!;
                      },
                      prefixIcon: Icon(Icons.work_outline, color: Colors.blue),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDatepicker(
                            joiningDate: true,
                            selectedDateTime: joiningDate,
                            onDateSelected: (p0) {
                              joiningDate = p0;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            Icons.arrow_right_alt_sharp,
                            color: Colors.blue,
                            size: 25,
                          ),
                        ),
                        Expanded(
                          child: CustomDatepicker(
                            joiningDate: false,
                            selectedDateTime: quittingDate,
                            onDateSelected: (p0) {
                              quittingDate = p0;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffEDF8FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      if (nameController.text.isEmpty ||
                          positionController == null ||
                          joiningDate == null) {
                        showSnackbar(context, 'Please fill all the required fields.');
                        return;
                      }

                      if (quittingDate != null && quittingDate!.isBefore(joiningDate!)) {
                        showSnackbar(context, 'Quitting date cannot be before joining date.');
                        return;
                      }

                      if (widget.existingEmployee == null) {
                        final newEmployee = Employee(
                          key: UniqueKey().toString(),
                          name: nameController.text,
                          position: positionController!,
                          joiningDate: joiningDate!,
                          quittingDate: quittingDate,
                        );

                        context.read<EmployeeCubit>().addEmployee(newEmployee);
                      } else {
                        widget.existingEmployee!.name = nameController.text;
                        widget.existingEmployee!.position = positionController!;
                        widget.existingEmployee!.joiningDate = joiningDate!;
                        widget.existingEmployee!.quittingDate = quittingDate;
                        context.read<EmployeeCubit>().updateEmployee(widget.existingEmployee!);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(widget.existingEmployee != null
                                ? "Employee Updated!"
                                : "Employee Added!")),
                      );

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
