import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/fetch_apk_viewmodel.dart';

class InstalledAppsTab extends StatefulWidget {
  const InstalledAppsTab({super.key});

  @override
  State<InstalledAppsTab> createState() => _InstalledAppsTabState();
}

class _InstalledAppsTabState extends State<InstalledAppsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchApkViewModel>().loadInstalledApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FetchApkViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(viewModel.errorMessage ?? 'Unknown error'),
              ElevatedButton(
                onPressed: viewModel.refresh,
                child: const Text('Retry'),
              ),
            ],
          );
        }

        if (!viewModel.hasData) {
          return const Center(child: Text('No apps found'));
        }

        return ListView.builder(
          itemCount: viewModel.installedApps.length,
          itemBuilder: (context, index) {
            final app = viewModel.installedApps[index];
            return ListTile(
              leading: app.iconBytes != null
                  ? Image.memory(app.iconBytes!, width: 40, height: 40)
                  : const Icon(Icons.android),
              title: Text(app.displayName),
              subtitle: Text(app.versionName ?? ''),
            );
          },
        );
      },
    );
  }
}
