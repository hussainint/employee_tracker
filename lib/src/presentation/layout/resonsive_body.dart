import 'package:flutter/material.dart';

import 'responsive.dart';

class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, required this.body});
  final Widget body;
  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return body;
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Responsive(
          mobile: body,
          desktop: Center(
            child: Container(
              color: Colors.grey[100],
              width: 500,
              child: body,
            ),
          ),
          tablet: Center(
            child: Container(
              color: Colors.grey[100],
              width: 500,
              child: body,
            ),
          ),
        ),
      );
    }
  }
}
