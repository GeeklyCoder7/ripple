import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/viewmodels/fetch_folder_items_viewmodel.dart';
import 'package:ripple/widgets/file_system_item_tile.dart';
import 'package:ripple/widgets/path_breadcrumb.dart';

import '../../../core/constants/app_constants.dart';

class DocumentsTab extends StatefulWidget {
  const DocumentsTab({super.key});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchFolderItemsViewModel>().loadFolder(
        AppConstants.defaultStoragePath,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FetchFolderItemsViewModel>(
      builder: (context, viewmodel, child) {
        if (viewmodel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (viewmodel.folderContentsList.isEmpty) {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                breadCrumbText(breadcrumbPaths: viewmodel.breadcrumbPaths),
                const Spacer(),
                Center(child: const Text('No items')),
                const Spacer(),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb text
            breadCrumbText(breadcrumbPaths: viewmodel.breadcrumbPaths),

            Expanded(
              child: ListView.builder(
                itemCount: viewmodel.folderContentsList.length,
                itemBuilder: (context, index) {
                  final item = viewmodel.folderContentsList[index];
                  return FileSystemItemTile(
                    item: item,
                    onTap: () {
                      if (item.isFolder) {
                        viewmodel.loadFolder(item.itemPath);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
