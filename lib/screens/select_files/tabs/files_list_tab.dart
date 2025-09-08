import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/folder_item.dart';
import 'package:ripple/viewmodels/select_files_viewmodel.dart';
import 'package:ripple/widgets/file_system_item_tile.dart';
import 'package:ripple/widgets/path_breadcrumb.dart';

class FilesListTab extends StatelessWidget {
  const FilesListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectFilesViewModel>(
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
