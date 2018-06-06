//
//  choixMatchViewController.swift
//  AVCam
//
//  Created by Anthony Praud on 15/04/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class choixMatchViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate  {

    @IBOutlet weak var choixMatchAction: UIButton!
    @IBOutlet weak var choixMatchPicker: UIPickerView!
    var delegate:choixDelegate?
    var mainViewController:AccueilViewController?
    var resultat:String = "Libre"
    var pickerDataSource = ["Libre", "Lege/girondins", "OM/Losc", "FCGB/PSG"]
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        resultat =  pickerDataSource[row]
       // NSLog("I want to log: %@",resultat)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        choixMatchAction.isEnabled=true
        // Do any additional setup after loading the view.
        self.choixMatchPicker.dataSource = self ;
        self.choixMatchPicker.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
//    @IBAction func onChoixMatch(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//
//    }
    
    @IBAction func choixMatcAction(_ sender: Any) {
        //mainViewController?.onUserAction(data: resultat)
        delegate?.onMatchReady(type: resultat);
       // NSLog("I want to log: %@",resultat)
        NotificationCenter.default.post(name: AccueilViewController.notificationName, object: nil, userInfo:["data": resultat, "isImportant": true])

    dismiss(animated: true, completion: nil)
        
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
