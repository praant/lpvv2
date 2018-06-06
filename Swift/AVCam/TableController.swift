//
//  TableController.swift
//  uitableview_load_data_from_json_swift_3
//


import UIKit
struct videomatch : Codable
    
{
    var nom_club_equipe_1: String
    var nom_club_equipe_2: String
    var video:String
    var date_heure:String
    var lieu:String
    var typeAction:String
    var categorie_match:String
    var type_equipe_1:String
    var type_equipe_2: String
    var duree:String
    var  video_thumbnail:String
    var username:String
    var node_id:String
    var match_id:String
    var stream_id:String
    private enum CodingKeys: String, CodingKey {
        case nom_club_equipe_1
        case nom_club_equipe_2
        case video
        case date_heure
        case lieu
        case typeAction="type_video"
        case categorie_match
        case type_equipe_1
        case type_equipe_2
        case duree
        case  video_thumbnail
        case username
        case node_id
        case match_id
        case stream_id="video_stream"
        
    }
}
class videoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imagematch: UIImageView!
    @IBOutlet weak var match: UILabel!
    @IBOutlet weak var categorie: UILabel!
    
    @IBOutlet weak var filmeur: UILabel!
    @IBOutlet weak var Lieu: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var nommatch: UILabel!
    
    
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
class TableController: UITableViewController {

    var TableData:Array< videomatch > = Array < videomatch >()

    override func viewDidLoad() {
        super.viewDidLoad()

        get_data_from_url(link: "http://preprod.lapassevideo.eu/api/v1/videospures?_format=json&items_per_page=10&offset=0")
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cheminvue="http://preprod.lapassevideo.eu/"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! videoTableViewCell
        
        cell.match.text = TableData[indexPath.row].typeAction
        cell.nommatch.text = TableData[indexPath.row].nom_club_equipe_1
        cell.categorie.text = TableData[indexPath.row].categorie_match
        cell.Lieu.text = TableData[indexPath.row].lieu
        cell.filmeur.text = TableData[indexPath.row].username
        cell.date.text = TableData[indexPath.row].date_heure
        cheminvue+=TableData[indexPath.row].video_thumbnail
        cell.imagematch.load(url: URL.init(string: cheminvue)!)
        return cell
    }
  

    
    
    
    
    func get_data_from_url(link:String)
    {
     
        guard let gitUrl = URL(string: link) else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode([videomatch].self, from: data)
                 for i in 0 ..< gitData.count
                 {
                   
                    self.TableData.append(gitData[i] )
                }
            } catch let err {
                print("Err", err)
            }
            DispatchQueue.main.async {
                      self.do_table_refresh()
            }
            }.resume()
    
   
    }

   
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    

}
