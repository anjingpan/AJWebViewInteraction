//
//  AJHomeViewController.swift
//  AJWebViewInteraction
//
//  Created by apple on 2020/2/27.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

let webToNativeArray = ["UIWebView Intercept", "UIWebView JavaScriptCore direct", "UIWebView JavaScriptCore JSExport", "WKWebView Intercept", "WKWebView WKScriptMessageHandler", "WKWebView uiDelegate (Alert Confirm Prompt)"]
let nativeToWebArray = ["UIWebView StringByEvaluating", "UIWebView JavaScriptCore", "WKWebView EvaluateJavaScript"]

let kTableViewCell = "tableViewCell"

class AJHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "WebViewInteraction"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
}

extension AJHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? webToNativeArray.count : nativeToWebArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCell)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: kTableViewCell)
        }
        cell?.textLabel?.text = indexPath.section == 0 ? webToNativeArray[indexPath.row] : nativeToWebArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Web -> Native": "Native -> Web"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var pushVC: UIViewController?
        
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            pushVC = AJIntercept_UIViewController()
        default:
            break
        }
        
        guard let viewController = pushVC else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
