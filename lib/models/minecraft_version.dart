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

import 'dart:developer' as developer;

class MinecraftVersion {
  final String id, url, time, releaseTime;
  final VersionType type;
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
      type: VersionType.fromString(json['type'] as String)!,
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

enum VersionType {
  release,
  snapshot,
  oldBeta,
  oldAlpha;

  static VersionType? fromString(String name) {
    final normalizedName = name.toLowerCase().replaceAll('_', '');

    try {
      return values.firstWhere(
        (type) => type.name.toLowerCase() == normalizedName,
      );
    } catch (e) {
      developer.log(
        "Couldn't parse '$name' as VersionType!",
        name: 'VersionType',
        level: 900,
        error: e,
      );
      return null;
    }
  }

  ///Matches the version types returned by Mojang's version manifest API
  @override
  String toString() {
    switch (this) {
      case VersionType.oldBeta:
        return 'old_beta';
      case VersionType.oldAlpha:
        return 'old_alpha';
      default:
        return name;
    }
  }
}
