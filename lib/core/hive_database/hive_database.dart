import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/base_entity.dart';
import 'hive_constants.dart';

class HiveDatabase {
  Future<void> init() async {
   
  
    var storage = Platform.isAndroid
    ? await getExternalStorageDirectory() : await getApplicationSupportDirectory();

    var hivePath = storage!.path + '/hive';

    Hive.init(hivePath);
    _registerAdapters();
    await _initBoxes();
  }

  Box<T> getMyBox<T extends BaseEntity>() {
    return Hive.box<T>(HiveBoxMap.hiveBoxMap[T]!.boxName);
  }

  Future<void> _initBoxes() async {
    for (var key in HiveBoxMap.hiveBoxMap.keys) {
      await HiveBoxMap.hiveBoxMap[key]!.openBoxFunction!();
    }
  }

  void _registerAdapters() {
    for (var key in HiveBoxMap.hiveBoxMap.keys) {
      HiveBoxMap.hiveBoxMap[key]!.registerAdapterFunction();
    }
  }
}
