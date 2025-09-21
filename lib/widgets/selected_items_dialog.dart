import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_colors.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/core/utils/helper_methods.dart';
import 'package:ripple/models/apk_item.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/services/selection_manager_service.dart';
import 'package:ripple/widgets/selected_item_tile.dart';

class SelectedItemsDialog extends StatefulWidget {
  final List<FileSystemItem> items;
  final String title;
  final IconData icon;
  final Color color;
  final SelectionManagerService selectionManagerService;
  final bool showSendButton;
  final bool isDocument;
  final FileType? fileType;

  const SelectedItemsDialog({
    super.key,
    required this.items,
    required this.title,
    required this.icon,
    required this.color,
    required this.selectionManagerService,
    this.showSendButton = false,
    this.isDocument = false,
    this.fileType,
  });

  @override
  State<SelectedItemsDialog> createState() => _SelectedItemsDialogState();
}

class _SelectedItemsDialogState extends State<SelectedItemsDialog> {
  // Returns current items from the selection
  List<FileSystemItem> _getCurrentItems() {
    List<FileSystemItem> currentItemsList = [];
    if (widget.showSendButton) {
      if (widget.isDocument) {
        // Show document items
        currentItemsList = widget.selectionManagerService
            .getDocumentsFromSelection();
      } else {
        // Show specific file type
        switch (widget.fileType) {
          case FileType.image:
            currentItemsList = widget.selectionManagerService
                .getSelectionByType(FileType.image);
          case FileType.video:
            currentItemsList = widget.selectionManagerService
                .getSelectionByType(FileType.video);
          case FileType.apk:
            currentItemsList = widget.selectionManagerService
                .getApksFromSelection();
          default:
            return [];
        }
      }
    }
    return currentItemsList;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<SelectionManagerService>(
      builder:
          (
            BuildContext context,
            SelectionManagerService viewmodel,
            Widget? child,
          ) {
            final currentItems = _getCurrentItems();

            return Container(
              height: screenHeight * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getCountTitle(currentItems.length),
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),

                              Text(
                                'Total ${_getTotalSelectionSize()}',
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Items list
                  Expanded(
                    child: currentItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),

                                Text(
                                  'No items selected',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: currentItems.length,
                            itemBuilder: (context, index) {
                              final item = currentItems[index];
                              return SelectedItemTile(
                                item: item,
                                selectionManagerService:
                                    widget.selectionManagerService,
                                onRemove: () {
                                  widget.selectionManagerService
                                      .toggleSelection(item);
                                },
                              );
                            },
                          ),
                  ),

                  // Bottom actions
                  if (widget.showSendButton && currentItems.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                if (widget.isDocument) {
                                  widget.selectionManagerService
                                      .clearSelectionByType(
                                        isDocument: widget.isDocument,
                                      );
                                } else {
                                  widget.selectionManagerService
                                      .clearSelectionByType(
                                        isDocument: widget.isDocument,
                                        filetype: widget.fileType,
                                      );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Clear All',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _handleSend(context, currentItems.length);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.cyanSplash,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send, size: 18),
                                  const SizedBox(width: 8),

                                  Text(
                                    'Send ${currentItems.length} files',
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
    );
  }

  // Returns the total size of the entire selection
  String _getTotalSelectionSize() {
    double totalBytes = 0;
    if (widget.isDocument) {
      for (var item in widget.selectionManagerService.getDocumentsFromSelection()) {
        if (item is FileItem) {
          totalBytes += item.fileSizeBytes;
        } else if (item is ApkItem) {
          totalBytes += item.sizeBytes!;
        }
      }
    } else {
      for (var item in widget.selectionManagerService.getSelectionByType(widget.fileType!)) {
        if (item is FileItem) {
          totalBytes += item.fileSizeBytes ?? 0;
        } else if (item is ApkItem) {
          totalBytes += item.sizeBytes ?? 0;
        }
      }
    }
    return AppConstants.getFormattedFileSize(totalBytes.toInt());
  }

  // Handles the further process for sending
  void _handleSend(BuildContext context, int currentCount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending $currentCount files...'),
        backgroundColor: AppColors.cyanSplash,
      ),
    );
  }

  // Returns item count title dynamically
  String _getCountTitle(int currentCount) {
    if (widget.isDocument) {
      return HelperMethods.getFormattedCountText(count: currentCount);
    } else {
      return HelperMethods.getFormattedCountText(count: currentCount, type: widget.fileType);
    }
  }
}
