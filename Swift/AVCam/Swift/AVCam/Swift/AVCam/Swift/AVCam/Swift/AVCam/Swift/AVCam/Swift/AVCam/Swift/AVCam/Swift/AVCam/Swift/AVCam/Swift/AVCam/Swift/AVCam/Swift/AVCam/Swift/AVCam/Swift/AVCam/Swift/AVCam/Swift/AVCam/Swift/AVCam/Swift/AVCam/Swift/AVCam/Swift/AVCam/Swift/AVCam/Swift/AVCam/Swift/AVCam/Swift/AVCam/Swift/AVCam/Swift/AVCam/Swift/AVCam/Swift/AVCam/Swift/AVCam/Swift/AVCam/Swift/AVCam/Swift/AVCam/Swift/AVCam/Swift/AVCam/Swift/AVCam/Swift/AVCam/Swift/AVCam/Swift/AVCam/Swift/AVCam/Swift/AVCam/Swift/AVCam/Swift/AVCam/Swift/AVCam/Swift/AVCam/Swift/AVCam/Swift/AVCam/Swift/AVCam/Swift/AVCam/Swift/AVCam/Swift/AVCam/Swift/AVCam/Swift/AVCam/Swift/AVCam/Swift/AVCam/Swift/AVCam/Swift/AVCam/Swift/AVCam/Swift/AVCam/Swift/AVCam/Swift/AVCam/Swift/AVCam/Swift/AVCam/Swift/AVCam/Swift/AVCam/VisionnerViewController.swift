//
//  VisionnerViewController.swift
//  AVCam
//
//  Created by Anthony Praud on 15/04/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import WebKit
class VisionnerViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
    super.viewDidLoad()
          // Do any additional setup after loading the view.
      
        let url = NSURL (string: "https://lapassevideo.fr/videos?type_de_sport=12")
        let request = URLRequest(url: url! as URL)
        webView.allowsBackForwardNavigationGestures = true
        webView.load(request);
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
