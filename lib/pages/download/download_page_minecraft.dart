import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/constants.dart';
import 'package:flutter_minecraft_launcher/core/instances.dart';
import 'package:flutter_minecraft_launcher/core/network/api_urls.dart';
import 'package:flutter_minecraft_launcher/core/network/dio_client.dart';
import 'package:flutter_minecraft_launcher/core/service_locator.dart';
import 'package:flutter_minecraft_launcher/models/setting_key.dart';
import 'package:flutter_minecraft_launcher/notifiers/settings_notifier.dart';
import 'package:flutter_minecraft_launcher/pages/download/version_install/version_install_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/minecraft_version.dart';

class DownloadPageMinecraft extends StatefulWidget {
  const DownloadPageMinecraft({super.key});

  @override
  State<DownloadPageMinecraft> createState() => _DownloadPageMinecraftState();
}

class _DownloadPageMinecraftState extends State<DownloadPageMinecraft> {
  Set<VersionType> _versionTypeSelection = <VersionType>{VersionType.release};
  late Future<List<MinecraftVersion>> _versionsFuture;
  late ApiProvider _currentProvider;

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
    _currentProvider = getIt<SettingsNotifier>().getCustom(
      SettingKey.apiProvider,
    );
    _versionsFuture = _fetchAndParseVersions(_currentProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, settingsNotifier, child) {
        return Container(
          alignment: Alignment.center,
          child: FutureBuilder<List<MinecraftVersion>>(
            future: _versionsFuture,
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<List<MinecraftVersion>> snapshot,
                ) {
                  ///Display progress indicator while loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  ///Return if error
                  if (snapshot.hasError || snapshot.data == null) {
                    ApiProvider providerFromSetting = settingsNotifier
                        .getCustom(SettingKey.apiProvider);

                    ///Refetch if there are errors and API provider changes
                    if (providerFromSetting != _currentProvider) {
                      _currentProvider = providerFromSetting;
                      Future.microtask(() => refetch(providerFromSetting));

                      return const CircularProgressIndicator();
                    }

                    ///Error handling
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48),
                        const SizedBox(height: kDefaultPadding),
                        Text('Loading failed'),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding / 2,
                            horizontal: kDefaultPadding * 2,
                          ),
                          child: Text(
                            snapshot.error?.toString() ?? 'Data is null',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            refetch(_currentProvider);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    ///Data must not be null here
                    final List<MinecraftVersion> versions = snapshot.data!;

                    ///Filter the currently selected version type
                    final filteredVersions = versions
                        .where(
                          (version) =>
                              version.type == _versionTypeSelection.first,
                        )
                        .toList();

                    return CustomScrollView(
                      slivers: [
                        ///Sticky SegmentedButton
                        SliverAppBar(
                          pinned: true,
                          floating: false,
                          snap: false,

                          ///FIXME: SegmentButton 'twitch' animation on change selection
                          title: SegmentedButton<VersionType>(
                            segments: _segments,
                            selected: _versionTypeSelection,
                            onSelectionChanged:
                                (Set<VersionType> newSelection) {
                                  setState(() {
                                    _versionTypeSelection = newSelection;
                                  });
                                },
                          ),
                          elevation: 4,
                        ),

                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final version = filteredVersions[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: kDefaultPadding / 2,
                                horizontal: kDefaultPadding / 2,
                              ),

                              ///InkWell: Add ripple effect && process on tap
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VersionInstallPage(
                                        minecraftVersion: version,
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12.0),

                                child: ListTile(
                                  dense: true,
                                  title: Text(
                                    version.id,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    'Release time: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(version.releaseTime).toLocal())}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            );
                          }, childCount: filteredVersions.length),
                        ),
                      ],
                    );
                  }

                  ///Display progress indicator while loading
                  return CircularProgressIndicator();
                },
          ),
        );
      },
    );
  }

  void refetch(ApiProvider apiProvider) {
    if (!mounted) return;

    setState(() {
      Instances.log.i('Trying to refetch versions');
      _versionsFuture = _fetchAndParseVersions(apiProvider);
    });
  }

  Future<List<MinecraftVersion>> _fetchAndParseVersions(
    ApiProvider apiProvider,
  ) async {
    try {
      final response = await getIt<DioClient>().dio.get(
        ApiProvider.fromProvider(apiProvider).versionManifest(),
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
