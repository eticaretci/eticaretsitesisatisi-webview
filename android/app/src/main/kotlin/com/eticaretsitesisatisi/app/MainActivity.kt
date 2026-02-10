package com.eticaretsitesisatisi.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.webkit.WebView
import android.webkit.WebViewClient
import android.net.http.SslError
import android.webkit.SslErrorHandler

class MainActivity: FlutterActivity() {
    
    override fun onPostResume() {
        super.onPostResume()

        val view = (window.decorView.findViewById(android.R.id.content) as android.view.ViewGroup).getChildAt(0)
        
        if (view is WebView) {
            view.webViewClient = object : WebViewClient() {
                override fun onReceivedSslError(
                    view: WebView?,
                    handler: SslErrorHandler?,
                    error: SslError?
                ) {
                  handler?.proceed()
                }
            }
        }
    }
}
