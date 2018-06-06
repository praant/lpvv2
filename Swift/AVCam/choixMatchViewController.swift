//
//  choixMatchViewController.swift
//  AVCam
//
//  Created by Anthony Praud on 15/04/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
struct match : Codable
    
{
    var nom_club_equipe_1: String
    var nom_club_equipe_2: String
    var date_heure:String
    var lieu:String
    var match_id:String
    private enum CodingKeys: String, CodingKey {
        case nom_club_equipe_1
        case nom_club_equipe_2
        case date_heure
        case lieu
        case match_id
        
    }
}
class choixMatchViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate  {

    @IBOutlet weak var choixMatchAction: UIButton!
    @IBOutlet weak var choixMatchPicker: UIPickerView!
    var delegate:choixDelegate?
    var sport: String = " "
     var resultat:String = "Libre"
    var pickerDataSource = ["Libre"]
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
    override func viewDidAppear(_ animated: Bool) {
        if self.delegate?.sport != nil {
        get_data_from_url(link: "http://preprod.lapassevideo.eu/api/v1/matchs?_format=json&type_sport_equipe_1="+(self.delegate?.sport)!)
        }
        else {
            get_data_from_url(link: "http://preprod.lapassevideo.eu/api/v1/matchs?_format=json")
        }
    }
    @IBAction func choixMatcAction(_ sender: Any) {
        //mainViewController?.onUserAction(data: resultat)
        delegate?.onMatchReady(type: resultat);
       // NSLog("I want to log: %@",resultat)
        NotificationCenter.default.post(name: AccueilViewController.notificationName, object: nil, userInfo:["data": resultat, "isImportant": true])

    dismiss(animated: true, completion: nil)
        
    }
    func get_data_from_url(link:String)
    {
        
        guard let gitUrl = URL(string: link) else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode([match].self, from: data)
                for i in 0 ..< gitData.count
                {
                    
                    self.pickerDataSource.append(gitData[i].nom_club_equipe_1)
                }
            } catch let err {
                print("Err", err)
            }
           /* DispatchQueue.main.async {
                self.do_table_refresh()
            }*/
            }.resume()
        
        
    }
    
    /*
    func do_table_refresh()
    {
        self.pickerDataSource
    }
*/
}
