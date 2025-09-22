import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_colors.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/services/selection_manager_service.dart';
import 'package:ripple/widgets/selected_items_dialog.dart';

class SelectionBottomBar extends StatefulWidget {
  const SelectionBottomBar({super.key});

  @override
  State<SelectionBottomBar> createState() => _SelectionBottomBarState();
}

class _SelectionBottomBarState extends State<SelectionBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1), // Hidden below screen
          end: Offset.zero, // Visible position
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionManagerService>(
      builder: (context, selectionManager, child) {
        // Control animation based on selection status
        if (selectionManager.hasSelection) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }

        // Getting item counts from viewmodel getters
        final filesCount = selectionManager.filesCount;
        final imagesCount = selectionManager.imagesCount;
        final videosCount = selectionManager.videosCount;
        final appsCount = selectionManager.appsCount;

        return SlideTransition(
          position: _slideAnimation,
          child: Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Files count icon
                _buildIconWithBadge(
                  icon: AppConstants.getIconFromFileType(FileType.unknown),
                  count: filesCount,
                  color: AppConstants.getColorFromFileType(FileType.word),
                  onTap: () {
                    _showSelectedItems(
                      isDocument: true,
                      context: context,
                      selectionMangerService: selectionManager,
                    );
                  },
                ),

                // Images count icon
                _buildIconWithBadge(
                  icon: AppConstants.imageIcon,
                  count: imagesCount,
                  color: AppConstants.getColorFromFileType(FileType.image),
                  onTap: () {
                    _showSelectedItems(
                      isDocument: false,
                      context: context,
                      selectionMangerService: selectionManager,
                      fileType: FileType.image,
                    );
                  },
                ),

                // Videos count icon
                _buildIconWithBadge(
                  icon: AppConstants.videoIcon,
                  count: videosCount,
                  color: AppConstants.getColorFromFileType(FileType.video),
                  onTap: () {
                    _showSelectedItems(
                      isDocument: false,
                      context: context,
                      selectionMangerService: selectionManager,
                      fileType: FileType.video,
                    );
                  },
                ),

                // Apps count icon
                _buildIconWithBadge(
                  icon: AppConstants.apkIcon,
                  count: appsCount,
                  color: AppConstants.getColorFromFileType(FileType.apk),
                  onTap: () {
                    _showSelectedItems(
                      isDocument: false,
                      context: context,
                      selectionMangerService: selectionManager,
                      fileType: FileType.apk,
                    );
                  },
                ),

                // Send button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/qr_scanner');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyanSplash,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusLarge,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Send',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Builds circular icons for different items
  Widget _buildIconWithBadge({
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 30,
        height: 30,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main circle icon
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
              child: Icon(icon, size: 20, color: color),
            ),

            // Badge counter
            if (count > 0)
              Positioned(
                top: -10,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 15,
                    minHeight: 15,
                  ),
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Displays a list of the items of selected types
  void _showSelectedItems({
    required bool isDocument,
    required BuildContext context,
    required SelectionManagerService selectionMangerService,
    FileType? fileType,
  }) {
    List<FileSystemItem> items;
    String title;
    IconData dialogIcon;
    Color dialogColor;

    if (isDocument) {
      items = selectionMangerService.getDocumentsFromSelection();
      title = 'Selected items ${items.length}';
      dialogIcon = AppConstants.getIconFromFileType(FileType.unknown);
      dialogColor = AppConstants.getColorFromFileType(FileType.unknown);
    } else {
      switch (fileType) {
        case FileType.image:
          items = selectionMangerService.getSelectionByType(FileType.image);
          title = 'Selected images ${items.length}';
          dialogIcon = AppConstants.getIconFromFileType(FileType.image);
          dialogColor = AppConstants.getColorFromFileType(FileType.image);
        case FileType.video:
          items = selectionMangerService.getSelectionByType(FileType.video);
          title = 'Selected videos ${items.length}';
          dialogIcon = AppConstants.getIconFromFileType(FileType.video);
          dialogColor = AppConstants.getColorFromFileType(FileType.video);
        case FileType.apk:
          items = selectionMangerService.getApksFromSelection();
          title = 'Selected apps ${items.length}';
          dialogIcon = AppConstants.getIconFromFileType(FileType.apk);
          dialogColor = AppConstants.getColorFromFileType(FileType.apk);
        default:
          return;
      }
    }

    if (items.isEmpty) {
      _showNoItemsSnackbar(context, title);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectedItemsDialog(
        items: items,
        title: title,
        icon: dialogIcon,
        color: dialogColor,
        selectionManagerService: selectionMangerService,
        showSendButton: true,
        isDocument: isDocument,
        fileType: fileType,
      ),
    );
  }

  void _showNoItemsSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No items in $message'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
