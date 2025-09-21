import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_colors.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/apk_item.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/models/folder_item.dart';
import 'package:ripple/services/selection_manager_service.dart';

class FileSystemItemTile extends StatefulWidget {
  final FileSystemItem item;
  final VoidCallback? onTap;

  const FileSystemItemTile({super.key, required this.item, this.onTap});

  @override
  State<FileSystemItemTile> createState() => _FileSystemItemTileState();
}

class _FileSystemItemTileState extends State<FileSystemItemTile> {
  bool? checkState = false;

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    // Check the item type (folder, file, apk)
    if (widget.item.isFolder) {
      iconData = AppConstants.folderIcon;
      iconColor = AppColors.folderColor;
    } else if (widget.item is FileItem) {
      FileItem fileItem = widget.item as FileItem;
      iconData = AppConstants.getIconFromFileType(fileItem.fileType);
      iconColor = AppConstants.getColorFromFileType(fileItem.fileType);
    } else if (widget.item is ApkItem) {
      iconData = AppConstants.apkIcon;
      iconColor = AppColors.apkColor;
    } else {
      iconData = AppConstants.getIconFromFileType(FileType.unknown);
      iconColor = AppConstants.getColorFromFileType(FileType.unknown);
    }

    return Consumer<SelectionManagerService>(
      builder: (context, viewmodel, child) {
        bool isCurrentlySelected = viewmodel.isSelected(widget.item);

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadiusExtraSmall,
            ),
          ),
          child: InkWell(
            onTap: () {
              if (widget.item.isFile || widget.item is ApkItem) {
                viewmodel.toggleSelection(widget.item);
              } else {
                widget.onTap?.call();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                children: [
                  // Display selection checkbox on condition
                  if (viewmodel.hasSelection && !widget.item.isFolder)
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Icon(
                        isCurrentlySelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),

                  // Item icon (either folder or file)
                  Icon(
                    iconData,
                    color: iconColor,
                    size: AppConstants.iconSizeMedium,
                  ),

                  // Item name and size column
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item name text
                        Text(
                          widget.item.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: AppConstants.fontSizeSmall,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Item size text
                        _buildSubtitleText(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitleText() {
    if (widget.item is FileItem) {
      // Handle FileItem
      FileItem fileItem = widget.item as FileItem;
      return Text(
        AppConstants.getFormattedFileSize(fileItem.fileSizeBytes),
        style: const TextStyle(
          color: AppColors.itemPropertiesTextColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (widget.item is ApkItem) {
      // Handle ApkItem
      ApkItem apkItem = widget.item as ApkItem;
      return Text(
        apkItem.sizeBytes != null
            ? AppConstants.getFormattedFileSize(apkItem.sizeBytes!)
            : 'APK File',
        style: const TextStyle(
          color: AppColors.itemPropertiesTextColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (widget.item is FolderItem) {
      // Handle FolderItem
      FolderItem folderItem = widget.item as FolderItem;
      return Text(
        folderItem.itemCountText,
        style: const TextStyle(
          color: AppColors.itemPropertiesTextColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      // Fallback for unknown types
      return const SizedBox.shrink();
    }
  }
}
