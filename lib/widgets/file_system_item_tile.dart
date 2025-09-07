import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/constants/app_colors.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/models/folder_item.dart';

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

    if (widget.item.isFolder) {
      iconData = AppConstants.folderIcon;
      iconColor = AppColors.folderColor;
    } else {
      FileItem fileItem = widget.item as FileItem;
      iconData = AppConstants.getIconFromFileType(fileItem.fileType);
      iconColor = AppConstants.getColorFromFileType(fileItem.fileType);
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppConstants.borderRadiusExtraSmall,
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: AppConstants.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Item size text
                    widget.item.isFile
                        ? Text(
                            // Item is file
                            (widget.item as FileItem).formattedFileSize,
                            style: const TextStyle(
                              color: AppColors.itemPropertiesTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Text(
                            // Item is folder
                            (widget.item as FolderItem).itemCountText,
                            style: const TextStyle(
                              color: AppColors.itemPropertiesTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ],
                ),
              ),

              // Item selected checkbox
              Checkbox(
                value: checkState,
                onChanged: (_) {
                  setState(() {
                    checkState = !checkState!;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
