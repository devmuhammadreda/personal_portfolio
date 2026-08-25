import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in a new browser tab. No-op for malformed URLs.
Future<void> openExternalUrl(String url) async {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Opens the device mail client pre-filled with a contact message.
Future<void> composeEmail({
  required String to,
  required String subject,
  required String body,
}) async {
  final Uri uri = Uri(
    scheme: 'mailto',
    path: to,
    query:
        'subject=${Uri.encodeComponent(subject)}'
        '&body=${Uri.encodeComponent(body)}',
  );
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
