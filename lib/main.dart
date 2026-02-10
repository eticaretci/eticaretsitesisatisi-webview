import charms from 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String siteUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://www.eticaretsitesisatisi.com');
const String primaryColorHex = String.fromEnvironment('PRIMARY_COLOR', defaultValue: '#000000');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Hex rengini Flutter rengine çevirir
    final Color themeColor = Color(int.parse(primaryColorHex.replaceFirst('#', '0xff')));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: themeColor),
      home: const WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;

  @override
  void initialize() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(siteUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea içine alarak çentiklere girmesini önlüyoruz
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
