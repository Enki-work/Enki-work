import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(BuildContext context, String url) async {
  final canLaunch = await canLaunchUrl(Uri.parse(url));

  if (canLaunch && context.mounted) {
    Navigator.of(context).pushNamed("WebViewPage", arguments: url);
  }
}
