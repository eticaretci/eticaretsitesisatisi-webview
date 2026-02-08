import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await [
    Permission.camera, 
    Permission.microphone,
    Permission.photos, 
    Permission.storage
  ].request();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    const String appName = String.fromEnvironment('APP_NAME', defaultValue: 'Eticaret Sitesi');
    const String themeColorHex = String.fromEnvironment('THEME_COLOR', defaultValue: '#000000');
    
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(int.parse(themeColorHex.replaceFirst('#', '0xff'))),
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
  @override
  Widget build(BuildContext context) {
    const String siteUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://www.eticaretsitesisatisi.com');
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(siteUrl)),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            allowsInlineMediaPlayback: true,
            useOnDownloadStart: true,
            useOnLongPressRequestOverride: true,
            userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1",
          ),
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url;
            if (uri != null && !["http", "https", "file", "chrome", "data", "javascript"].contains(uri.scheme)) {
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
        ),
      ),
    );
  }
}

