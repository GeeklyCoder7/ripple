import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_colors.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/apk_item.dart';
import 'package:ripple/services/selection_manager_service.dart';

class InstalledAppCard extends StatefulWidget {
  final ApkItem item;
  const InstalledAppCard({super.key, required this.item});

  @override
  State<InstalledAppCard> createState() => _InstalledAppCardState();
}

class _InstalledAppCardState extends State<InstalledAppCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionManagerService>(
      builder: (context, selectionManagerService, child) {
        bool isCurrentlySelected = selectionManagerService.isSelected(
          widget.item,
        );

        return GestureDetector(
          onTap: () {
            selectionManagerService.toggleSelection(widget.item);
          },
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isCurrentlySelected
                  ? Colors.green.withOpacity(
                      0.2,
                    ) // Light blue background when selected
                  : Colors.grey[50],
              border: isCurrentlySelected
                  ? Border.all(
                      color: Colors.green,
                      width: 1.5,
                    ) // Blue border when selected
                  : null,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App icon - flexible to take available space
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: widget.item.iconBytes != null
                            ? Image.memory(
                                widget.item.iconBytes!,
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.android,
                                    size: 32,
                                    color: Colors.grey[400],
                                  );
                                },
                              )
                            : Icon(
                                Icons.android,
                                size: 32,
                                color: Colors.grey[400],
                              ),
                      ),
                    ),

                    const SizedBox(height: 2),

                    // App name - flexible to prevent overflow
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          widget.item.displayName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 1),

                    // App size - flexible and properly handle null
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: widget.item.sizeBytes != null
                            ? Text(
                                AppConstants.getFormattedFileSize(
                                  widget.item.sizeBytes!,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              )
                            : Text(
                                'Unknown',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  fontSize: 9,
                                  color: Colors.grey[400],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

                // Conditional checked button
                if (isCurrentlySelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.check, color: Colors.black, size: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
