import 'package:flutter/cupertino.dart';

Widget breadCrumbText(List<String> breadcrumbPaths) {
  return Align(
    alignment: Alignment.topLeft,
    child: Text('/${breadcrumbPaths.join('/')}', textAlign: TextAlign.left),
  );
}
