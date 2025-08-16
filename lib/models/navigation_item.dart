import 'package:flutter/material.dart';

class NavigationRailItem {
  final Widget page;
  final NavigationRailDestination destination;

  const NavigationRailItem({required this.page, required this.destination});
}

class NavigationDrawerItem {
  final Widget page;
  final NavigationDrawerDestination destination;

  const NavigationDrawerItem({required this.page, required this.destination});
}
