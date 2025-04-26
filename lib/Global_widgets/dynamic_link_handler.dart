import 'dart:developer';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stock_box/Constants/Util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:stock_box/Screens/Onboarding_screen/Signup.dart';

class DynamicLinkHandler {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();

  /// Initializes the [DynamicLinkHandler].
  Future<void> initialize(BuildContext context) async {
    try {
      // Listen to dynamic links.
      _appLinks.uriLinkStream.listen((Uri uri) {
        log('Dynamic Link Stream: $uri', name: 'Dynamic Link Handler');
        _handleLinkData(context, uri);
      }).onError((error) {
        log('Error in Dynamic Link: $error', name: 'Dynamic Link Handler');
      });

      // Check initial dynamic link if app is opened from it
      await _checkInitialLink(context);
    } catch (e) {
      log('Initialization error: $e', name: 'Dynamic Link Handler');
    }
  }

  /// Handle navigation if initial link is found on app start.
  Future<void> _checkInitialLink(BuildContext context) async {
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        log('Initial Link Found: $initialLink', name: 'Dynamic Link Handler');
        _handleLinkData(context, initialLink);
      } else {
        log('No initial link found', name: 'Dynamic Link Handler');
      }
    } catch (e) {
      log('Error fetching initial link: $e', name: 'Dynamic Link Handler');
    }
  }

  /// Handles the link navigation from dynamic links.
  void _handleLinkData(BuildContext context, Uri data) {
    final queryParams = data.queryParameters;

    // Logging the dynamic link
    log('Handling Link Data: ${data.toString()}', name: 'Dynamic Link Handler');
    log('Path: ${data.path}', name: 'Dynamic Link Handler');
    log('Query Params: ${queryParams.toString()}', name: 'Dynamic Link Handler');

    // Check if path or query parameter has 'referral'
    if (data.path.contains('/referral') || queryParams['page'] == 'referral') {
      // Debugging log
      print("Navigating to Signup Page");

      // Navigate to the Signup page
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Signup(), // Replace with your Signup page
      //   ),
      // );
    } else {
      // If no matching referral link is found, log it
      log('No referral found in link', name: 'Dynamic Link Handler');
    }
  }

  /// Provides the short URL for your dynamic link.
  Future<String> createProductLink({
    required String title,
  }) async {
    try {
      // Construct the dynamic link with your custom domain
      final String dynamicLink = '${Util.Main_BasrUrl}/api/refer?ref=$title';
      log('Dynamic Link Created: $dynamicLink', name: 'Dynamic Link Handler');
      return dynamicLink;
    } catch (e) {
      log('Error creating dynamic link: $e', name: 'Dynamic Link Handler');
      throw Exception('Failed to create dynamic link');
    }
  }

  /// Shares the product link.
  // Future<void> shareProductLink(String title) async {
  //   try {
  //     // Generate the dynamic link
  //     String link = await createProductLink(title: title);
  //     // Share the link using share_plus
  //     Share.share('Sign up using this referral link: $link');
  //   } catch (e) {
  //     log('Error sharing the product link: $e', name: 'Dynamic Link Handler');
  //   }
  // }
  Future<void> shareProductLink(String title, String imageUrl, String referDesc) async {
    try {
      // 🔹 Generate the dynamic link
      String link = await createProductLink(title: title);

      // 🔹 Download image from URL & save locally
      File imageFile = await _downloadImage(imageUrl);

      // 🔹 Share the link with the image
      // await Share.shareFiles(
      //   [imageFile.path],
      //   text: '$referDesc: $link',
      // );
      await Share.shareXFiles(
        [XFile(imageFile.path)], // Convert String to XFile
        text: '$referDesc: $link',
      );
    } catch (e) {
      log('Error sharing the product link: $e', name: 'Dynamic Link Handler');
    }
  }
}

Future<File> _downloadImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/shared_image.jpg');
  await file.writeAsBytes(response.bodyBytes);
  return file;
}


