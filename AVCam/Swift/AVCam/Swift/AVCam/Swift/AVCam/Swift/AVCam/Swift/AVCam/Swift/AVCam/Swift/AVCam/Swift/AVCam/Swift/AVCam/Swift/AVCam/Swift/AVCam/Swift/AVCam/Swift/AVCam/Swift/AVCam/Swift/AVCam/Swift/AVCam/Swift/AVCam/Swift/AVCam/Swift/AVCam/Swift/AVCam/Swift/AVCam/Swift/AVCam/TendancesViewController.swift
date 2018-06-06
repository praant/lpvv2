//
//  TendancesViewController.swift
//  AVCam
//
//  Created by Anthony Praud on 15/04/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import WebKit


class TendancesViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
        override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //first we will create a NSURL with the url that we want to load in the webview
        
        let url = NSURL (string: "https://lapassevideo.fr/top-top-essai")
        let request = URLRequest(url: url! as URL)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.load(request);
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
      func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.host {
            if host.contains("passevideo.fr") {
                decisionHandler(.allow)
                return
            }
            if host.contains("sudouest.fr") {
                decisionHandler(.allow)
                return
            }
            
        }
        
        decisionHandler(.cancel)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
