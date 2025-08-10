//https://piston-meta.mojang.com/mc/game/version_manifest.json

/// A Minecraft version from Mojang api
/// e.g. :
/// {
///   "id": "1.20.1",
///   "type": "release",
///   "url": "https://piston-meta.mojang.com/v1/packages/0e416921378f6d442c057499ba3e5dcbd36f80a9/1.20.1.json",
///   "time": "2025-08-05T06:42:15+00:00",
///   "releaseTime": "2023-06-12T13:25:51+00:00"
/// }

library;

class MinecraftVersion {
  final String id, type, url, time, releaseTime;

  const MinecraftVersion({
    required this.id,
    required this.type,
    required this.url,
    required this.time,
    required this.releaseTime,
  });

  factory MinecraftVersion.fromJson(Map<String, dynamic> json) {
    return MinecraftVersion(
      id: json['id'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      time: json['time'] as String,
      releaseTime: json['releaseTime'] as String,
    );
  }

  @override
  String toString() {
    return 'MinecraftVersion(id: $id, type: $type, url: $url, time: $time releaseTime: $releaseTime)';
  }
}
