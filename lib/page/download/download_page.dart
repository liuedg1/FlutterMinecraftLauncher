import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/constants.dart';
import 'package:flutter_minecraft_launcher/page/download/download_page_minecraft.dart';
import 'package:flutter_minecraft_launcher/page/download/download_page_mod.dart';

import 'download_page_modpack.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  int _selectedIndex = 0;

  final List<Widget> _downloadChildrenPages = [
    const DownloadPageMinecraft(),
    const DownloadPageMod(),
    const DownloadPageModpack(),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //const VerticalDivider(),
        //I want to add a VerticalDivider, but it will cause meaningless spacing so i use a Container.
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: theme.dividerColor.withAlpha(100)),
            ),
          ),

          child: NavigationDrawer(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },

            children: [
              Padding(
                //Align Text with Destination
                padding: const EdgeInsets.fromLTRB(
                  kDefaultPadding * 1.5,
                  kDefaultPadding,
                  kDefaultPadding,
                  kDefaultPadding,
                ),
                child: Text('Download', style: theme.textTheme.headlineMedium),
              ),

              //Destinations
              NavigationDrawerDestination(
                icon: const Icon(Icons.code),
                label: Text('Minecraft'),
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.extension),
                label: Text('Mods'),
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.backpack),
                label: Text('Modpacks'),
              ),
            ],
          ),
        ),

        //Display current page
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: _downloadChildrenPages,
          ),
        ),
      ],
    );
  }
}
