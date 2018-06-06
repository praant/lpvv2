//
//  AccueilViewController.swift
//  AVCam
//
//  Created by Anthony Praud on 15/04/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import WebKit
import AVKit
import AVFoundation

class utilisateur{
    var login : String = ""
    var mail : String = ""
    var sport: String = ""
    var match: String=" "
    var actionR :String = " "
}


class AccueilViewController: UIViewController,choixDelegate,WKNavigationDelegate{
    func onConnexionReady(type: String) {
        self.nickname=type
    }
    
    var nickname: String?
    
    var sport: String?
    
    var matchchoix: String?
    
    var name: String = ""
    
    
    
    @IBOutlet weak var choixSportBouton: UIButton!
    @IBOutlet weak var filmerButton: UIButton!
    @IBOutlet weak var accueilConnexionBouton: UIButton!
    var utilisateur:utilisateur?
    /// The notification name you want to observe and post
    static let notificationName = Notification.Name("myNotificationName")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /* let filePath = Bundle.main.path(forResource: "background_foot", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)
        
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.scalesPageToFit = true
        webViewBG.load(gif! as Data, mimeType: "image/gif", textEncodingName: "utf-8", baseURL: NSURL(fileURLWithPath: filePath!) as URL)
        
        webViewBG.isUserInteractionEnabled = false;
        self.view.addSubview(webViewBG)
        self.view.sendSubview(toBack: webViewBG)
    
        let filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.black
        filter.alpha = 0.30
        self.view.addSubview(filter)
        self.view.sendSubview(toBack: filter)
       */
    }
    
   
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayMessage(usermessage:String)
    {
        let alertController = UIAlertController(title: "ALerte", message: usermessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: nil)
            }
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChoixSportViewController {
            destination.delegate = self
        }
        if let destination = segue.destination as? choixMatchViewController {
            destination.delegate = self
                 }
    }
    
    @IBAction func OnFilmer(_ sender: Any) {
        
        
         performSegue(withIdentifier: "fimerSegue", sender: nil)
    }
    @IBAction func choixSport(_ sender: UIButton) {
        
        performSegue(withIdentifier: "choixSportSegue", sender: nil)
        
   }
    
    @IBAction func onConnexion(_ sender: Any) {
       

      performSegue(withIdentifier: "connexionSegue", sender: self)
    }
    
    @IBAction func onChoixMatch(_ sender: Any) {
        
        performSegue(withIdentifier: "choixMatchSegue", sender: nil)

       
    }
    func onMatchReady(type: String) {
        self.matchchoix=type
    }
    func onSportReady(type: String) {
        self.sport=type
      
    }
   
}
