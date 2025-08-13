import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_minecraft_launcher/pages/settings/settings_page_about.dart';
import 'package:flutter_minecraft_launcher/pages/settings/settings_page_game.dart';
import 'package:flutter_minecraft_launcher/pages/settings/settings_page_launcher.dart';

import '../../constants.dart';
import '../../models/navigation_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<NavigationDrawerItem> settingsPageSubItems = [
      NavigationDrawerItem(
        page: const SettingsPageLauncher(),
        destination: NavigationDrawerDestination(
          icon: const Icon(Icons.rocket_launch),
          label: Text(
            FlutterI18n.translate(context, 'settings.launcher.title'),
          ),
        ),
      ),
      NavigationDrawerItem(
        page: const SettingsPageGame(),
        destination: NavigationDrawerDestination(
          icon: const Icon(Icons.gamepad),
          label: Text(FlutterI18n.translate(context, 'settings.game')),
        ),
      ),
      NavigationDrawerItem(
        page: const SettingsPageAbout(),
        destination: NavigationDrawerDestination(
          icon: const Icon(Icons.book),
          label: Text(FlutterI18n.translate(context, 'settings.about')),
        ),
      ),
    ];

    ThemeData theme = Theme.of(context);
    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            //Divider()
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
                  child: Text(
                    'Settings',
                    style: theme.textTheme.headlineMedium,
                  ),
                ),

                //Destinations
                for (var item in settingsPageSubItems) item.destination,
              ],
            ),
          ),

          //Display current page
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: settingsPageSubItems.map((item) => item.page).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
