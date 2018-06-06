//
//  CompteViewController.swift
//  AVCam
//
//  Created by Anthony Praud on 15/04/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CompteViewController: UIViewController {

    
   
    @IBOutlet weak var _password: UITextField!
    
    @IBOutlet weak var cancelBouton: UIButton!
    @IBOutlet weak var connexionBouton: UIButton!
    @IBOutlet weak var _username: UITextField!
    var mainViewController:AccueilViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "session") != nil)
        {
            LoginDone()
        }
        else
        {
            LoginToDo()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var onCancel: UIButton!
    
    @IBAction func onConnexion(_ sender: Any) {
        doConnexion()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func doConnexion() {
        if(connexionBouton.titleLabel?.text == "Logout")
        {
            let preferences = UserDefaults.standard
            preferences.removeObject(forKey: "session")
            
            LoginToDo()
            return
        }
        let username=_username.text
        let password=_password.text
        if ((username?.isEmpty)! || (password?.isEmpty)! )
        {
            self.displayMessage(usermessage: "un des champs est manquant")
            return
        }
        dologin(_user: username!,_pwd: password!)
        //
    }
    func dologin(_user: String,_pwd:String)
    {
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        myActivityIndicator.center=view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        let _url=URL(string:"http://preprod.lapassevideo.eu/api/v1")
        _ = URLSession.shared
        
        var request = URLRequest(url: _url!,cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let paramToSend = "username=" + _user + "&password=" + _pwd
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print(error!.localizedDescription)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                 DispatchQueue.main.async {
                    self.displayMessage(usermessage: "Probléme de connexion merci de réeesayer plus tard")
            }
                
            }
            else
            {
            let responseString = String(data: data, encoding: .utf8)
              do{
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                // TODO
                //récupérer infos de connexion et peupler la structure infos.
                /*
                self.mainViewController?.name="apraud"
                self.mainViewController?.nickname="toto"
                */
                
                 }
              catch {
                print("Error deserializing JSON: \(error)")

                }
                
            }
        }
            
        task.resume()
    }
       func LoginToDo()
    {
        _username.isEnabled = true
        _password.isEnabled = true
        
        connexionBouton.setTitle("Login", for: .normal)
    }
    
    func LoginDone()
    {
        _username.isEnabled = false
        _password.isEnabled = false
        connexionBouton.setTitle("Logout", for: .normal)
        
    }
    func removeActivityIndicator(activityIndicator:UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
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
    
    
    

}
