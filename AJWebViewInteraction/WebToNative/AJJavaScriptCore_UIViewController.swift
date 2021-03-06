//
//  AJJavaScriptCore_UIViewController.swift
//  AJWebViewInteraction
//
//  Created by apple on 2020/2/27.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import JavaScriptCore

class AJJavaScriptCore_UIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
    }
    deinit {
        print("deinit")
    }

    fileprivate func showAlert(title: String? , _ message: String? , confirm: (() -> Void)?) -> Void {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "confirm", style: .default) { (_) in
            confirm?()
        }
        
        alertVC.addAction(confirmAction)
        present(alertVC, animated: true, completion: nil)
    }

    fileprivate func jsCallNative(_ context: JSContext) {
        context.exceptionHandler = { (context, value) in
            print("JavaScript Exception" + (value?.toString() ?? ""))
        }
        
        let block: @convention(block)(String, String) -> Void = { (action, params) in
            DispatchQueue.main.async {
                self.showAlert(title: action, params, confirm: nil)
            }
        }
        
//        let block: @convention(block)([String: String]) -> Void = { (dic) in
//            print(dic)
//        }
        context.setObject(block, forKeyedSubscript: "webToNative" as NSCopying & NSObjectProtocol)
    }
    
    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: self.view.bounds)
        guard let url = Bundle.main.url(forResource: "Login", withExtension: "html") else {
            return webView
        }
        webView.delegate = self
        webView.loadRequest(URLRequest(url: url))
        return webView
    }()
}

extension AJJavaScriptCore_UIViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else { return }
        
        jsCallNative(context)
    }
}
