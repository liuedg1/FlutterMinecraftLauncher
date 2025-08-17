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
  Set<VersionType> _versionTypeSelection = <VersionType>{VersionType.release};
  final Dio _dio = Dio();

  final _segments = const <ButtonSegment<VersionType>>[
    ButtonSegment<VersionType>(
      value: VersionType.release,
      label: Text('Release'),
    ),
    ButtonSegment<VersionType>(
      value: VersionType.snapshot,
      label: Text('Snapshot'),
    ),
    ButtonSegment<VersionType>(
      value: VersionType.oldBeta,
      label: Text('Old Beta'),
    ),
    ButtonSegment<VersionType>(
      value: VersionType.oldAlpha,
      label: Text('Old Alpha'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _versionsFuture = _fetchAndParseVersions();
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

                ///Filter the currently selected version type
                final filteredVersions = versions
                    .where(
                      (version) => version.type == _versionTypeSelection.first,
                    )
                    .toList();

                return CustomScrollView(
                  slivers: [
                    ///Sticky SegmentedButton
                    SliverAppBar(
                      pinned: true,
                      floating: false,
                      snap: false,
                      title: SegmentedButton<VersionType>(
                        segments: _segments,
                        selected: _versionTypeSelection,
                        onSelectionChanged: (Set<VersionType> newSelection) {
                          setState(() {
                            _versionTypeSelection = newSelection;
                          });
                        },
                      ),
                      elevation: 4,
                    ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final version = filteredVersions[index];

                        return ListTile(
                          title: Text(version.id),
                          subtitle: Text(
                            'Type: ${version.type}, Release time: ${version.releaseTime}, Time: ${version.time}, Url: ${version.url}',
                          ),
                        );
                      }, childCount: filteredVersions.length),
                    ),
                  ],
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
}
