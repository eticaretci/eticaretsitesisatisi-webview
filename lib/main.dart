import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://www.eticaretsitesisatisi.com');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UniversalEticaretSitesiSatisiApp());
}

class UniversalEticaretSitesiSatisiApp extends StatefulWidget {
  const UniversalEticaretSitesiSatisiApp({super.key});

  @override
  State<UniversalEticaretSitesiSatisiApp> createState() => _UniversalEticaretSitesiSatisiAppState();
}

class _UniversalEticaretSitesiSatisiAppState extends State<UniversalEticaretSitesiSatisiApp> {
  String? finalSiteUrl;
  String appName = "Yükleniyor...";
  Color mainColor = Colors.black;
  bool isReady = false;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await [Permission.camera, Permission.microphone, Permission.storage, Permission.photos].request();

    try {
      final response = await http.get(Uri.parse("$baseUrl/index.php?ozesbilisim=api/app_config")).timeout(const Duration(seconds: 8));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          finalSiteUrl = data['site_url'] ?? baseUrl;
          appName = data['app_name'] ?? "Eticaret Sitesi";
          String colorCode = data['theme_color'] ?? "#000000";
          mainColor = Color(int.parse(colorCode.replaceAll('#', '0xff')));
          isReady = true;
        });
      } else {
        _setDefaults();
      }
    } catch (e) {
      _setDefaults();
    }
    _setupWebView();
  }

  void _setDefaults() {
    setState(() {
      finalSiteUrl = baseUrl;
      appName = "Eticaret Sitesi";
      mainColor = Colors.black;
      isReady = true;
    });
  }

  void _setupWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(allowsInlineMediaPlayback: true);
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1")
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (!request.url.startsWith('http')) {
              launchUrl(Uri.parse(request.url), mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Sayfa hatası: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(finalSiteUrl!));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: isReady ? AppBar(
          title: Text(appName, style: const TextStyle(color: Colors.white, fontSize: 18)),
          backgroundColor: mainColor,
          centerTitle: true,
        ) : null,
        body: isReady 
            ? SafeArea(child: WebViewWidget(controller: _controller))
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
