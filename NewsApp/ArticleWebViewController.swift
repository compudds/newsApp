//
//  ArticleWebViewController.swift
//  NewsFun
//
//  Created by zappycode on 4/27/18.
//  Copyright © 2018 Nick Walter. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController {
    
    var article = Article()

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: article.url) {
        
            webView.load(URLRequest(url: url))
        }
    }

    
}
