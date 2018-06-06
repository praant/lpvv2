//
//  AccueilViewController.swift
//  AVCam
//
//  Created by Anthony Praud on 15/04/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import WebKit

class utilisateur{
    var login : String = ""
    var mail : String = ""
    var sport: String = ""
    var match: String=" "
}


class AccueilViewController: UIViewController,choixDelegate{
    var name: String = ""
    var nickname: String?
    @IBOutlet weak var choixSportBouton: UIButton!
    @IBOutlet weak var filmerButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var accueilConnexionBouton: UIButton!
    var utilisateur:utilisateur?
    /// The notification name you want to observe and post
    static let notificationName = Notification.Name("myNotificationName")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Observe for the notification, and define the function that's called when the notification is received
        //NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: AccueilViewController.notificationName, object: nil)

        filmerButton.isEnabled=true
        choixSportBouton.isEnabled=true
        accueilConnexionBouton.isEnabled=true
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
        
        self.utilisateur?.match=type
    }
    func onSportReady(type: String) {
        
        self.utilisateur?.sport=type
    }
   
}
