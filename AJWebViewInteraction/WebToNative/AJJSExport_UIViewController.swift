//
//  AJJSExport_UIViewController.swift
//  AJWebViewInteraction
//
//  Created by apple on 2020/3/5.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import JavaScriptCore

//需要添加@objc
@objc protocol NativeWebProtocal: JSExport {
    //js中方法名带参数需要加With，参数首字母大写
    func webToNative(action: String, params: String)
}

class AJJSExport_UIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
    }

    fileprivate func showAlert(title: String? , _ message: String? , confirm: (() -> Void)?) -> Void {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "confirm", style: .default) { (_) in
            confirm?()
        }
        
        alertVC.addAction(confirmAction)
        
        self.present(alertVC, animated: true, completion: nil)
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
}

extension AJJSExport_UIViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else { return }
        
        //webNativeBridge为web和native中协商好的名字
        //self循环引用deinit不调用
        context.setObject(self, forKeyedSubscript: "webNativeBridge" as NSCopying & NSObjectProtocol)
    }
}

extension AJJSExport_UIViewController: NativeWebProtocal {
    func webToNative(action: String, params: String) {
        DispatchQueue.main.async {
            self.showAlert(title: action, params, confirm: nil)
        }
    }
}
