//
//  AJIntercept_UIViewController.swift
//  AJWebViewInteraction
//
//  Created by apple on 2020/2/27.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AJIntercept_UIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
    }
    

    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: self.view.bounds)
        webView.delegate = self
        guard let url = Bundle.main.url(forResource: "Login", withExtension: "html") else {
            return webView
        }
        webView.loadRequest(URLRequest(url: url))
        return webView
    }()

    fileprivate func showAlert(title: String? , _ message: String? , confirm: (() -> Void)?) -> Void {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "confirm", style: .default) { (_) in
            confirm?()
        }
        
        alertVC.addAction(confirmAction)
        present(alertVC, animated: true, completion: nil)
    }
}

extension AJIntercept_UIViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if request.url?.scheme?.lowercased() == "webtonative" {
            showAlert(title: request.url?.host, request.url?.query, confirm: nil)
            return false
        }
        
        return true
    }
    
}
