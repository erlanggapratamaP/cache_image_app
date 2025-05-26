import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CustomCacheManager extends CacheManager {
  static const key = 'customCacheKey';
  static const Duration maxAge = Duration(days: 7);
  static const int maxNrOfCacheObjects = 100;

  static final CustomCacheManager _instance = CustomCacheManager._();

  factory CustomCacheManager() {
    return _instance;
  }

  CustomCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: maxAge,
          maxNrOfCacheObjects: maxNrOfCacheObjects,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );

  Future<String> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  Future<void> clearCache() async {
    await emptyCache();
  }

  Future<void> removeFile(String url) async {
    await removeFile(url);
  }
}
