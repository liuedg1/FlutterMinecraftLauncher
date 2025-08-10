import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../models/minecraft_version.dart';

class DownloadPageMinecraft extends StatefulWidget {
  const DownloadPageMinecraft({super.key});

  @override
  State<DownloadPageMinecraft> createState() => _DownloadPageMinecraftState();
}

class _DownloadPageMinecraftState extends State<DownloadPageMinecraft> {
  late final Future<List<MinecraftVersion>> _versionsFuture;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _versionsFuture = _fetchAndParseVersions();
  }

  Future<List<MinecraftVersion>> _fetchAndParseVersions() async {
    try {
      final response = await _dio.get(
        "https://piston-meta.mojang.com/mc/game/version_manifest.json",
      );

      if (response.statusCode == 200) {
        /**
         * {
            "latest": {
            ...
            },
            "versions": [
            {
            ...
            },
            {
            ...
            }
            ]
            }
         */
        final List<dynamic> rawList = response.data['versions'] as List;
        //Convert JSON to Dart Model
        final List<MinecraftVersion> versions = rawList
            .map((json) => MinecraftVersion.fromJson(json))
            .toList();
        return versions;
      } else {
        throw Exception('Error: ${response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder<List<MinecraftVersion>>(
        future: _versionsFuture,
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<MinecraftVersion>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.done) {
                final List<MinecraftVersion> versions = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: versions.length,
                  itemBuilder: (context, index) {
                    final version = versions[index];
                    return ListTile(
                      title: Text(version.id),
                      subtitle: Text(
                        'Type: ${version.type}, Release time: ${version.releaseTime}, Time: ${version.time}, Url: ${version.url}',
                      ),
                    );
                  },
                );
              }

              //Return if error
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              //Display progress indicator while loading
              return CircularProgressIndicator();
            },
      ),
    );
  }
}
