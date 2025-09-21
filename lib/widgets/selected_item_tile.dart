import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/apk_item.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/services/selection_manager_service.dart';

class SelectedItemTile extends StatelessWidget {
  final FileSystemItem item;
  final SelectionManagerService selectionManagerService;
  final VoidCallback onRemove;

  const SelectedItemTile({
    super.key,
    required this.item,
    required this.selectionManagerService,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    IconData itemIcon;
    Color itemColor;
    String subtitle;

    if (item is FileItem) {
      FileItem fileItem = item as FileItem;
      itemIcon = AppConstants.getIconFromFileType(fileItem.fileType);
      itemColor = AppConstants.getColorFromFileType(fileItem.fileType);
      subtitle = AppConstants.getFormattedFileSize(fileItem.fileSizeBytes);
    } else if (item is ApkItem) {
      ApkItem apkItem = item as ApkItem;
      itemIcon = AppConstants.getIconFromFileType(FileType.apk);
      itemColor = AppConstants.getColorFromFileType(FileType.apk);
      subtitle = apkItem.sizeBytes != null
          ? AppConstants.getFormattedFileSize(apkItem.sizeBytes!)
          : 'APK File';
    } else {
      itemIcon = AppConstants.getIconFromFileType(FileType.unknown);
      itemColor = AppConstants.getColorFromFileType(FileType.unknown);
      subtitle = 'File';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: itemColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: item is ApkItem && (item as ApkItem).iconBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    (item as ApkItem).iconBytes!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(itemIcon, color: itemColor, size: 24),
        ),
        title: Text(
          item.displayName,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.quicksand(color: Colors.grey[600], fontSize: 14),
        ),
        trailing: IconButton(
          onPressed: onRemove,
          icon: Icon(Icons.remove_circle, color: Colors.red[400], size: 24),
          tooltip: 'Remove from selection',
        ),
      ),
    );
  }
}
