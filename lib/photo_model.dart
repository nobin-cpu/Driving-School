import 'package:hive/hive.dart';



@HiveType(typeId: 0)
class ImageModel extends HiveObject {
  @HiveField(0)
  late String imagePath;
}
