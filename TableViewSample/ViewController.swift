

import UIKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text  = heroes [indexPath.row].localized_name.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HeroStatsViewController") as! HeroStatsViewController
        vc.hero = self.heroes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }


    @IBOutlet weak var tblView: UITableView!
    var heroes = [HeroStats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson(){
            self.tblView.reloadData()
        }
        tblView.delegate = self
        tblView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
   
    
    
    func downloadJson(completed : @escaping  () -> ()){
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.heroes = try JSONDecoder().decode([HeroStats].self,from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("JSON Error")
                }
            }
        }.resume()
    }
}

