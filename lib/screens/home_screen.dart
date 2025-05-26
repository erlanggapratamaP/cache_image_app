import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../services/custom_cache_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final customCacheManager = CustomCacheManager();
  Map<String, dynamic> cacheInfo = {
    'fileCount': 0,
    'totalSize': 0,
    'maxSize': 0,
    'maxAge': 0,
  };

  @override
  void initState() {
    super.initState();
    _updateCacheInfo();
  }

  Future<void> _updateCacheInfo() async {
    final info = await customCacheManager.getCacheInfo();
    setState(() {
      cacheInfo = info;
    });
  }

  Future<void> _clearCache() async {
    await customCacheManager.clearCache();
    await _updateCacheInfo();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Caching Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearCache,
            tooltip: 'Clear Cache',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _updateCacheInfo,
            tooltip: 'Refresh Cache Info',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cache Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cache Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Files in cache: ${cacheInfo['fileCount']}'),
                      Text(
                        'Total size: ${(cacheInfo['totalSize'] / 1024 / 1024).toStringAsFixed(2)} MB',
                      ),
                      Text('Max files: ${cacheInfo['maxSize']}'),
                      Text('Cache duration: ${cacheInfo['maxAge']} days'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Basic Cached Network Image',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CachedNetworkImage(
                imageUrl: 'https://picsum.photos/200/300',
                cacheManager: customCacheManager,
                placeholder:
                    (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 32),
              const Text(
                'Image Grid with Caching',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              MasonryGridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/200/${300 + index * 50}',
                    cacheManager: customCacheManager,
                    placeholder:
                        (context, url) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
