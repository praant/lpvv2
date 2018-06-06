//
//  CompteViewController.swift
//  AVCam
//
//  Created by Anthony Praud on 15/04/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CompteViewController: UIViewController {

    
   
    @IBOutlet weak var loginCreateChoice: UISegmentedControl!
    @IBOutlet weak var registerBouton: UIButton!
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var onCancel: UIButton!
    @IBOutlet weak var cancelBouton: UIButton!
    @IBOutlet weak var connexionBouton: UIButton!
    
    @IBOutlet weak var maiLabel: UILabel!
    
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
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        let _url=URL(string:"http://preprod.lapassevideo.eu/api/v1/user.json")
        _ = URLSession.shared
        
        var request = URLRequest(url: _url!,cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let paramToSend = "?username=" + _user + "&password=" + _pwd
        
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
                print(responseString as Any)
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
    
   
    func doRegister() {
        let username=_username.text
        let password=_password.text
        let e_mail = _email.text
        if ((username?.isEmpty)! || (password?.isEmpty)! || (e_mail?.isEmpty)! )
        {
            self.displayMessage(usermessage: "Un des champs est manquant")
            return
        }
        enregistrerInscritption(_user: username!, _pwd: password!, _email: e_mail!)
        
    }
    func enregistrerInscritption(_user: String,_pwd:String,_email: String)
    {
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        myActivityIndicator.center=view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        let _url=URL(string:"http://preprod.lapassevideo.eu/api/v1/user.json")
        _ = URLSession.shared
        
        var request = URLRequest(url: _url!,cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let paramToSend = "?username=" + _user + "&password=" + _pwd+"&mail="+_email
        
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
                    print(responseString as Any)
                }
                catch {
                    print("Error deserializing JSON: \(error)")
                    
                }
                
            }
        }
        
        task.resume()

    }
    @IBAction func onRegister(_ sender: Any) {
        doRegister()
            }
    
    func removeActivityIndicator(activityIndicator:UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    private enum CaptureMode: Int {
        case login = 0
        case create = 1
    }
    
    
    
    @IBAction func toggleLoginMode(_ sender: Any) {
        
        connexionBouton.isEnabled = false
        registerBouton.isEnabled = false
        if loginCreateChoice.selectedSegmentIndex == CaptureMode.login.rawValue {
            self._email.isHidden = true
            self.maiLabel.isHidden = true
            self.loginCreateChoice.isEnabled = true
            self.connexionBouton.isEnabled = true
            self.connexionBouton.isHidden = false
            self.registerBouton.isEnabled = false
            self.registerBouton.isHidden = true
            
        } else if loginCreateChoice.selectedSegmentIndex == CaptureMode.create.rawValue {
            connexionBouton.isEnabled = false
            self._email.isHidden = false
            self.maiLabel.isHidden = false
            self._email.isEnabled = true
            self.loginCreateChoice.isEnabled = true
            self.registerBouton.isEnabled = true
            self.connexionBouton.isHidden = true
            self.registerBouton.isEnabled = true
            self.registerBouton.isHidden = false
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
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
