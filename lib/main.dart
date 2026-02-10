import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  // GitHub'dan --dart-define ile gelen verileri yakala
  const String rawUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://www.eticaretsitesisatisi.com');
  const String appTitle = String.fromEnvironment('APP_NAME', defaultValue: 'EticaretSitesi');
  
  // URL'nin başında http/https yoksa ekle (Hata önleyici)
  final String finalUrl = rawUrl.startsWith('http') ? rawUrl : 'https://$rawUrl';

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: appTitle,
    // ThemeData kısmını hata vermeyecek en stabil hale getirdik
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: WebViewContainer(url: finalUrl, title: appTitle),
  ));
}

class WebViewContainer extends StatefulWidget {
  final String url;
  final String title;
  const WebViewContainer({super.key, required this.url, required this.title});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
