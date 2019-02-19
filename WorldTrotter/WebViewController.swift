//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by MJC-iCloud on 2/19/19.
//  Copyright © 2019 Matthew. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    // Based on the documentation:
    // https://developer.apple.com/documentation/webkit/wkwebview
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myUrl = URL(string: "https://www.minneapolis.edu/")
        let myRequest = URLRequest(url: myUrl!)
        webView.load(myRequest)
    }
}

