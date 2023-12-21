import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'logger.dart';

StorageService get storageService => Get.find();

class StorageService {
  Logger logger = Logger('StorageService');
  late GetStorage storage;

  static final StorageService _cache = StorageService._internal();

  factory StorageService() {
    return _cache;
  }

  StorageService._internal() {
    init();
  }

  Future<dynamic> init() async {
    logger.log('intialiazing storage service...');
    await GetStorage.init();
    storage = GetStorage();
  }

  dynamic fetch(String key) {
    logger.log('fetching data with key');
    return storage.read(key);
  }

  dynamic fetchWithDefault(String key, dynamic defaultValue) {
    logger.log('fetching data with key');
    var value = fetch(key);
    return value ?? defaultValue;
  }

  Future<dynamic> insert(String key, dynamic value) async {
    logger.log('inserting data with key');
    return await storage.write(key, value);
  }

  Future<void> remove(String key) async {
    logger.log('removing data with key');
    return storage.remove(key);
  }


  
}