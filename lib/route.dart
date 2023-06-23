// logged Out
// loggedIn

import 'package:flutter/material.dart';
import 'package:reddit/Features/auth/screens/login_screen.dart';
import 'package:reddit/Features/comunity/screen/cominity_screen.dart';
import 'package:reddit/Features/home/screen/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes:  {
  '/': (_) => const MaterialPage(child: LoginScreen())
});
final loggedInRoute = RouteMap(routes:  {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-comunity': (_) => const MaterialPage(child: CreateCommunityScreen())
});
