import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/constants.dart';
import 'package:flutter_minecraft_launcher/pages/download/download_page_minecraft.dart';
import 'package:flutter_minecraft_launcher/pages/download/download_page_mod.dart';

import '../../models/navigation_item.dart';
import 'download_page_modpack.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  int _selectedIndex = 0;

  final List<NavigationDrawerItem> _downloadPageSubItems = [
    const NavigationDrawerItem(
      page: DownloadPageMinecraft(),
      destination: NavigationDrawerDestination(
        icon: Icon(Icons.code),
        label: Text('Minecraft'),
      ),
    ),
    const NavigationDrawerItem(
      page: DownloadPageMod(),
      destination: NavigationDrawerDestination(
        icon: Icon(Icons.extension),
        label: Text('Mods'),
      ),
    ),
    const NavigationDrawerItem(
      page: DownloadPageModpack(),
      destination: NavigationDrawerDestination(
        icon: Icon(Icons.backpack),
        label: Text('Modpacks'),
      ),
    ),
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
              for (var item in _downloadPageSubItems) item.destination,
            ],
          ),
        ),

        //Display current page
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: _downloadPageSubItems.map((item) => item.page).toList(),
          ),
        ),
      ],
    );
  }
}
