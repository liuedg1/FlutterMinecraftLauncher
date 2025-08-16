import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<NavigationDrawerItem> downloadPageSubItems = [
      NavigationDrawerItem(
        page: const DownloadPageMinecraft(),
        destination: NavigationDrawerDestination(
          icon: const Icon(Icons.code),
          label: Text(FlutterI18n.translate(context, 'download.minecraft')),
        ),
      ),
      NavigationDrawerItem(
        page: const DownloadPageMod(),
        destination: NavigationDrawerDestination(
          icon: const Icon(Icons.extension),
          label: Text(FlutterI18n.translate(context, 'download.mods')),
        ),
      ),
      NavigationDrawerItem(
        page: const DownloadPageModpack(),
        destination: NavigationDrawerDestination(
          icon: const Icon(Icons.backpack),
          label: Text(FlutterI18n.translate(context, 'download.modpacks')),
        ),
      ),
    ];

    ThemeData theme = Theme.of(context);
    return Material(
      child: Row(
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
                if (_selectedIndex == index) return;
                //Removes all focus in the current context
                FocusScope.of(context).unfocus();

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
                  child: Text(
                    FlutterI18n.translate(context, 'download.title'),
                    style: theme.textTheme.headlineMedium,
                  ),
                ),

                //Destinations
                for (var item in downloadPageSubItems) item.destination,
              ],
            ),
          ),

          //Display current page
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: downloadPageSubItems.map((item) => item.page).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
