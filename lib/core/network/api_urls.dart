mixin MixinApiProvider {
  String versionManifest();

  String libraries();

  String formatVersionJSONAssetsIndex(String fromString);

  ApiProvider apiProvider();
}

enum ApiProvider {
  mojang,
  bmcl;

  static MixinApiProvider fromProvider(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.mojang:
        return MojangApi();
      case ApiProvider.bmcl:
        return BMCLApi();
    }
  }
}

class MojangApi with MixinApiProvider {
  @override
  String versionManifest() =>
      'https://piston-meta.mojang.com/mc/game/version_manifest.json';

  @override
  String libraries() => 'https://libraries.minecraft.net/';

  @override
  String formatVersionJSONAssetsIndex(String fromString) => fromString;

  @override
  ApiProvider apiProvider() => ApiProvider.mojang;
}

class BMCLApi with MixinApiProvider {
  @override
  String versionManifest() =>
      'https://bmclapi2.bangbang93.com/mc/game/version_manifest.json';

  @override
  String libraries() => 'https://bmclapi2.bangbang93.com/maven';

  ///Replace https://launchermeta.mojang.com/ and https://launcher.mojang.com/ to https://bmclapi2.bangbang93.com
  @override
  String formatVersionJSONAssetsIndex(String fromString) => fromString
      .replaceAll(
        'https://launchermeta.mojang.com/',
        'https://bmclapi2.bangbang93.com/',
      )
      .replaceAll(
        'https://launcher.mojang.com/',
        'https://bmclapi2.bangbang93.com',
      );

  @override
  ApiProvider apiProvider() => ApiProvider.bmcl;
}
