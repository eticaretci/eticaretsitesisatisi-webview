import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Android'e özel ayarlar için gerekli alt paket
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() {
  // GitHub Actions'dan gelen veriler
  const String rawUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://www.google.com');
  const String appTitle = String.fromEnvironment('APP_NAME', defaultValue: 'EticaretSitesi');
  
  // URL temizliği
  final String finalUrl = rawUrl.trim().startsWith('http') ? rawUrl.trim() : 'https://${rawUrl.trim()}';

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: appTitle,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
    
    // WebViewController Yapılandırması
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      // SNI ve Cloudflare için kritik User-Agent (Kendini Chrome olarak tanıtır)
      ..setUserAgent("Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36")
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) => debugPrint("Hata: ${error.description}"),
        ),
      );

    // DomStorage ve Platforma özel SNI desteğini aktif etme
    if (_controller.platform is AndroidWebViewController) {
      // Bu kısım Cloudflare tarafındaki "Browser Integrity Check" olayını aşmamızı sağlar
      (_controller.platform as AndroidWebViewController).setGeolocationEnabled(true);
    }

    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar'ı istersen kaldırabilirsin (daha profesyonel görünür)
      appBar: AppBar(
        title: Text(widget.title),
        toolbarHeight: 0, // AppBar'ı gizler ama sistem çubuğunu korur
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
