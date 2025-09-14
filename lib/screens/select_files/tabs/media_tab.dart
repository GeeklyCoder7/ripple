import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/core/constants/app_colors.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/services/fetch_media_service.dart';
import 'package:ripple/viewmodels/fetch_media_items_viewmodel.dart';
import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';

class MediaTab extends StatefulWidget {
  const MediaTab({super.key});

  @override
  State<MediaTab> createState() => _MediaTabState();
}

class _MediaTabState extends State<MediaTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchMediaItemsViewModel>().loadMediaFolders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FetchMediaItemsViewModel>(
      builder: (context, viewmodel, child) {
        return Column(
          children: [
            // Media options buttons
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: _buildMediaTypesSegmentedButtons(viewmodel),
            ),

            // Remaining content
            Expanded(child: _buildContent(viewmodel)),
          ],
        );
      },
    );
  }

  // Builds segmented buttons for selecting media type
  Widget _buildMediaTypesSegmentedButtons(FetchMediaItemsViewModel viewmodel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // center the buttons
      children: [
        // Photos Button
        OutlinedButton.icon(
          onPressed: () {
            viewmodel.switchMediaType(MediaType.photos); // update ViewModel
          },
          icon: const Icon(
            AppConstants.imageIcon,
            size: AppConstants.iconSizeSmall,
          ),
          label: const Text("Pictures"),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(AppConstants.paddingSmall),
            foregroundColor: viewmodel.selectedMediaType == MediaType.photos
                ? AppColors
                      .waveBlue // text/icon color when selected
                : Colors.black, // text/icon color when unselected
            backgroundColor: Colors.transparent,
            side: BorderSide(
              color: viewmodel.selectedMediaType == MediaType.photos
                  ? AppColors
                        .waveBlue // border color when selected
                  : Colors.black, // border color when unselected
              width: viewmodel.selectedMediaType == MediaType.photos ? 1.5 : 1,
            ),
            textStyle: viewmodel.selectedMediaType == MediaType.photos
                ? TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppConstants.fontSizeXSmall,
                  )
                : TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppConstants.fontSizeXSmall,
                  ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusExtraSmall,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8), // spacing between buttons
        // Videos Button
        OutlinedButton.icon(
          onPressed: () {
            viewmodel.switchMediaType(MediaType.videos); // update ViewModel
          },
          icon: const Icon(
            AppConstants.videoIcon,
            size: AppConstants.iconSizeSmall,
          ),
          label: const Text("Videos"),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(AppConstants.paddingSmall),
            foregroundColor: viewmodel.selectedMediaType == MediaType.videos
                ? AppColors.waveBlue
                : Colors.black,
            backgroundColor: Colors.transparent,
            side: BorderSide(
              color: viewmodel.selectedMediaType == MediaType.videos
                  ? AppColors.waveBlue
                  : Colors.black,
              width: viewmodel.selectedMediaType == MediaType.videos ? 1.5 : 1,
            ),
            textStyle: viewmodel.selectedMediaType == MediaType.videos
                ? TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppConstants.fontSizeXSmall,
                  )
                : TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppConstants.fontSizeXSmall,
                  ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusExtraSmall,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Builds remaining content (other than segmented buttons)
  Widget _buildContent(FetchMediaItemsViewModel viewmodel) {
    // Handle loading states
    if (viewmodel.isLoadingFolders || viewmodel.isLoadingFiles) {
      return Center(child: CircularProgressIndicator());
    }

    // Handle error state
    if (viewmodel.hasError) {
      return Center(child: Text('${viewmodel.errorMessage}'));
    }

    // Checking if inside any folder
    if (viewmodel.isInsideFolder) {
      // Inside a folder - check if it has files
      if (viewmodel.hasFilesData) {
        // Has files data - show files grid view
        return _buildFilesGrid(viewmodel);
      } else {
        // No files data - show message
        return Center(
          child: Text(
            'No specified files found ${viewmodel.selectedMediaType}',
          ),
        );
      }
    } else {
      // No folder selected - check if has folders data
      if (viewmodel.hasFoldersData) {
        // Has folders - show folders grid view
        return _buildMediaFoldersGridView(viewmodel);
      } else {
        // No folders - show message
        return Center(
          child: Text(
            'No folders found with specified media type... ${viewmodel.selectedMediaType}',
          ),
        );
      }
    }
  }

  // Builds media folders grid view
  Widget _buildMediaFoldersGridView(FetchMediaItemsViewModel viewmodel) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: viewmodel.mediaFolders.length,
      itemBuilder: (context, index) {
        final folder = viewmodel.mediaFolders[index];
        return Card(
          elevation: 2,
          child: InkWell(
            onTap: () {
              viewmodel.loadMediaFiles(folder.itemPath);
            },
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AppConstants.folderIcon,
                    color: AppColors.folderColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    folder.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    folder.itemCountText,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Builds media files grid view
  Widget _buildFilesGrid(FetchMediaItemsViewModel viewmodel) {
    return Column(
      children: [
        // Back button with title
        Padding(
          padding: EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              IconButton(
                onPressed: () => viewmodel.navigateBack(),
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                '${viewmodel.selectedMediaType == MediaType.photos ? "Pictures" : "Videos"} (${viewmodel.mediaFiles.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Enhanced files grid with preview
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: viewmodel.mediaFiles.length,
            itemBuilder: (context, index) {
              final file = viewmodel.mediaFiles[index];
              return Card(
                elevation: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                        child: _buildMediaPreview(
                          file,
                          viewmodel.selectedMediaType,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        file.itemName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Builds preview for files like thumbnails
  Widget _buildMediaPreview(FileItem file, MediaType mediaType) {
    // Check if the media type is photos
    if (mediaType == MediaType.photos) {
      // show picture
      return Image.file(
        File(file.itemPath),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Icon(Icons.broken_image, size: 32, color: Colors.grey[600]),
          );
        },
      );
    } else {
      // show video thumbnail
      return _showVideoThumbnail(file);
    }
  }

  // Shows the video thumbnail
  Widget _showVideoThumbnail(FileItem file) {
    return FutureBuilder<Uint8List?>(
      future: VideoThumbnail.thumbnailData(
        video: file.itemPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200, // Reasonable size for grid
        quality: 75,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading thumbnail
          return Container(
            color: Colors.grey[100],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          // Error or no thumbnail
          return Container(
            color: Colors.grey[200],
            child: Icon(Icons.video_file, size: 32, color: Colors.grey[600]),
          );
        } else {
          // Show actual video thumbnail
          return Stack(
            children: [
              Image.memory(
                snapshot.data!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          );
        }
      },
    );
  }
}
