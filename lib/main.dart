import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// OpenCart / Build Script üzerinden gelen değişkenler
const String siteUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://www.eticaretsitesisatisi.com');
const String themeColorHex = String.fromEnvironment('THEME_COLOR', defaultValue: '#000000');
const String appName = String.fromEnvironment('APP_NAME', defaultValue: 'EticaretSitesi');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gelen Hex kodunu (#ffffff) Flutter formatına çevirir
    final Color themeColor = Color(int.parse(themeColorHex.replaceFirst('#', '0xff')));

    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: themeColor,
        appBarTheme: AppBarTheme(backgroundColor: themeColor),
      ),
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
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(siteUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea: Çentikli telefonlarda ekranın kaymasını engeller
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
