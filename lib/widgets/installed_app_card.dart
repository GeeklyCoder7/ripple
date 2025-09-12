import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/apk_item.dart';

class InstalledAppCard extends StatefulWidget {
  final ApkItem item;
  const InstalledAppCard({super.key, required this.item});

  @override
  State<InstalledAppCard> createState() => _InstalledAppCardState();
}

class _InstalledAppCardState extends State<InstalledAppCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppConstants.borderRadiusSmall,
        )
      ),
    );
  }
}
