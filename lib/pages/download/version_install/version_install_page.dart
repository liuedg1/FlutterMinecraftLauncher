import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/models/minecraft_version.dart';

class VersionInstallPage extends StatefulWidget {
  final MinecraftVersion minecraftVersion;
  const VersionInstallPage({super.key, required this.minecraftVersion});

  @override
  State<StatefulWidget> createState() => VersionInstallPageState();
}

class VersionInstallPageState extends State<VersionInstallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.minecraftVersion.id)),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Download'),
        icon: const Icon(Icons.download),
        onPressed: _downloadMinecraftVersion,
      ),
    );
  }

  void _downloadMinecraftVersion() {
    //Navigator.pop(context);
  }
}
