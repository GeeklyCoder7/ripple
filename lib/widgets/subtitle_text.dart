import 'package:flutter/cupertino.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/apk_item.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/models/folder_item.dart';

import '../core/constants/app_colors.dart';

class SubtitleText extends StatelessWidget {
  final FileSystemItem item;
  const SubtitleText({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item is FolderItem) {
      // Item is directory
      FolderItem folderItem = item as FolderItem;
      return Text(
        folderItem.itemCountText,
        style: const TextStyle(
          color: AppColors.itemPropertiesTextColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (item is FileItem) {
      // Item if file
      FileItem fileItem = item as FileItem;
      return Text(
        AppConstants.getFormattedFileSize(fileItem.fileSizeBytes),
        style: const TextStyle(
          color: AppColors.itemPropertiesTextColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (item is ApkItem) {
      // Item is apk
      ApkItem apkItem = item as ApkItem;
      return Text(
        AppConstants.getFormattedFileSize(apkItem.sizeBytes!),
        style: const TextStyle(
          color: AppColors.itemPropertiesTextColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
