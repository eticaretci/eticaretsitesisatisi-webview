package com.eticaretsitesisatisi.app

import io.flutter.embedding.android.FlutterActivity
import android.webkit.WebView
import android.webkit.WebViewClient
import android.net.http.SslError
import android.webkit.SslErrorHandler
import android.view.ViewGroup
import android.view.View

class MainActivity: FlutterActivity() {
    
    override fun onPostResume() {
        super.onPostResume()
        val rootView = window.decorView.findViewById<ViewGroup>(android.R.id.content)
        findAndFixWebView(rootView)
    }

    private fun findAndFixWebView(view: View) {
        if (view is WebView) {
            view.webViewClient = object : WebViewClient() {
                override fun onReceivedSslError(v: WebView?, handler: SslErrorHandler?, e: SslError?) {
                    handler?.proceed()
                }
            }
        } else if (view is ViewGroup) {
            for (i in 0 until view.childCount) {
                findAndFixWebView(view.getChildAt(i))
            }
        }
    }
}
