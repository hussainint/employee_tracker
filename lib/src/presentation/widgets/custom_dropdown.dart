import 'package:flutter/material.dart';

// Define a CustomDropdown widget that shows options in a bottom sheet
class CustomDropdown<T> extends StatefulWidget {
  final String hintText;
  T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final Icon? prefixIcon;

  CustomDropdown({
    Key? key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show bottom sheet when tapped
        _showBottomSheet(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              SizedBox(width: 8),
            ],
            Text(
              widget.value?.toString() ?? widget.hintText,
              style: TextStyle(
                color: widget.value != null ? Colors.black : Colors.grey,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  // Function to show the bottom sheet with options
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<T>(
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white),
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: widget.items.map<Widget>((T item) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.value = item;
                        });
                        widget.onChanged(item);
                        Navigator.pop(context); // Close bottom sheet
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(child: Text(item.toString())))),
                  if (item != widget.items.last)
                    Divider(
                      height: 3,
                      color: Colors.grey.shade300,
                    ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
