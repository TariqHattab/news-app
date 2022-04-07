import 'package:hive/hive.dart';

part 'local_lang.g.dart';

@HiveType(typeId: 2)
class LocalLang extends HiveObject {
  @HiveField(0)
  late String langCode;

  LocalLang(this.langCode);
}
