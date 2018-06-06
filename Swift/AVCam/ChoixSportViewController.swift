//
//  ChoixSportViewController.swift
//  AVCam
//
//  Created by Anthony Praud on 15/04/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ChoixSportViewController: UIViewController ,UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var validerChoix: UIButton!
    @IBOutlet weak var listeSports: UIPickerView!
    var pickerDataSource = ["Hand", "Foot", "Basket", "Rugby"]
    var resultat="Foot"
    /// The delegate property for "Passing data back with delegation"
    var mainViewController:AccueilViewController?
    var delegate:choixDelegate?
    //resultat="Foot"
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
      //  NSLog("I want to log: %@",resultat)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        validerChoix.isEnabled=true
        self.listeSports.dataSource = self;
        self.listeSports.delegate = self;
       
    }

    @IBAction func choixsport(_ sender: UIButton) {
        //mainViewController?.onUserAction(data: resultat)
        self.delegate?.onSportReady(type: resultat)
        //NotificationCenter.default.post(name: AccueilViewController.notificationName, object: nil, userInfo:["data": resultat, "isImportant": true])

        dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onMatchReady (type: String) {
       
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        var rowString = String()
        switch row {
        case 0:
            rowString = "Hand"
            myImageView.image = UIImage(named:"Hand.png")
        case 1:
            rowString = "Foot"
            myImageView.image = UIImage(named:"but.png")
        case 2:
            rowString = "Basket"
            myImageView.image = UIImage(named:"panier.png")
        case 3:
            rowString = "Rugby"
            myImageView.image = UIImage(named:"essai.png")
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60))
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        return myView
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // do something with selected row
    }
    //Note that the label la
    
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
*/

}
