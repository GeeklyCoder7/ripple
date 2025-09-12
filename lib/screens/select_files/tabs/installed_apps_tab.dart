import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../models/apk_item.dart';
import '../../../services/fetch_apk_service.dart';

class InstalledAppsTab extends StatefulWidget {
  const InstalledAppsTab({super.key});

  @override
  State<InstalledAppsTab> createState() => _InstalledAppsTabState();
}

class _InstalledAppsTabState extends State<InstalledAppsTab> {
  // ✅ State variables to hold data
  List<ApkItem> apkItems = [];
  bool isLoading = false;
  String? errorMessage;

  final FetchApkService _apkService = FetchApkService();

  @override
  void initState() {
    super.initState();
    // ✅ Load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadApks();
    });
  }

  // ✅ Async method to load APKs
  Future<void> _loadApks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apps = await _apkService.getInstalledApps(includeIcons: true);

      // ✅ Check if widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          apkItems = apps;
          isLoading = false;
        });

        // ✅ Debug print to see results
        print('✅ Loaded ${apps.length} APK apps');
        for (final app in apps.take(3)) {
          // Print first 3
          print('📱 ${app.displayName} (${app.packageName})');
        }
      }
    } catch (e) {

      print('❌ Error loading APKs: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load apps: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Show loading indicator
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading installed apps...'),
          ],
        ),
      );
    }

    // ✅ Show error message
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(errorMessage!, textAlign: TextAlign.center),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _loadApks, child: Text('Retry')),
          ],
        ),
      );
    }

    // ✅ Show empty state
    if (apkItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apps, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No apps found'),
          ],
        ),
      );
    }

    // ✅ Show the APK list
    return RefreshIndicator(
      onRefresh: _loadApks, // Pull to refresh
      child: ListView.builder(
        itemCount: apkItems.length,
        itemBuilder: (context, index) {
          final apk = apkItems[index];
          return ListTile(
            // ✅ App icon with fallback
            leading: apk.iconBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      apk.iconBytes!,
                      width: 40,
                      height: 40,
                      cacheWidth: 40, // ✅ Optimize memory
                      cacheHeight: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.android, color: Colors.grey),
                  ),
            // ✅ App name
            title: Text(apk.displayName, overflow: TextOverflow.ellipsis),
            // ✅ Version info
            subtitle: Text(
              apk.versionName != null && apk.versionName!.isNotEmpty
                  ? 'Version: ${apk.versionName}'
                  : 'Package: ${apk.packageName ?? 'Unknown'}',
              overflow: TextOverflow.ellipsis,
            ),
            // ✅ Optional: Add tap handler for future actions
            onTap: () {
              print('Tapped: ${apk.displayName}');
            },
          );
        },
      ),
    );
  }
}
