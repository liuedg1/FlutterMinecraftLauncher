import 'package:hive/hive.dart';

import '../core/network/api_urls.dart';

///Adapt ApiProvider for Hive
class ApiProviderAdapter extends TypeAdapter<ApiProvider> {
  @override
  final int typeId = 2;

  @override
  ApiProvider read(BinaryReader reader) =>
      ApiProvider.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, ApiProvider obj) =>
      writer.writeByte(obj.index);
}
