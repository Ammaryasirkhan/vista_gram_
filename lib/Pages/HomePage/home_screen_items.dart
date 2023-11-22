import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vista_gram_/Pages/HomePage/feeds_screens.dart';
import 'package:vista_gram_/Pages/HomePage/profile_screen.dart';

import 'add_post_screen.dart';
import 'search_screen.dart';

List<Widget> homeScreenItems = [
  ScreenFeeds(),
  SearchScreen(),
  AddPostScreen(),
  Text('aa'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
