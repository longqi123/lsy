//
//  WebViewController.swift
//  Office
//
//  Created by GA GA on 24/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    let webView = WKWebView()

    init(url: URL, titleStr: String, cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad, timeout: TimeInterval = 8){
        super.init(nibName: nil, bundle: nil)
        title = titleStr
        webView.load(URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = webView
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
