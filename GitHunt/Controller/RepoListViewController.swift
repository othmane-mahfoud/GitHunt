//
//  RepoListViewController.swift
//  GitHunt
//
//  Created by Othmane on 6/22/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit
import Firebase
import Moya
import SwiftyJSON
import SVProgressHUD

class RepoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allRepos : [Repo] = [Repo]()
    
    @IBOutlet weak var repoListTableView: UITableView!
    var bookmarkKeys : [String] = [String]()
    var repoDictionary : Dictionary<String, Any> = [:]
    
    let provider = MoyaProvider<RepoService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        repoListTableView.delegate = self
        repoListTableView.dataSource = self
        repoListTableView.register(UINib(nibName: "RepoCustomCell", bundle: nil), forCellReuseIdentifier: "repoCustomCell")
        
        configureTableView()
        
        getRepoData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCustomCell", for: indexPath) as! RepoCustomCell
        
        cell.repoNameLabel.text = allRepos[indexPath.row].repoName
        cell.repoDescriptionLabel.text = allRepos[indexPath.row].repoDescription
        cell.repoOwnerNameLabel.text = allRepos[indexPath.row].repoOwner
        cell.repoStarsLabel.text = formatStarsNumber(starNumber: allRepos[indexPath.row].repoStars)
        cell.repoOwnerAvatarImageView.image = convertUrlToImage(imageUrl: allRepos[indexPath.row].repoOwnerAvatar)
        
        cell.didClickBookmark = { cell in
            let bookmarkDB = Database.database().reference().child("bookmarks")
            
            self.allRepos[indexPath.row].isBookmarked = true
            cell.bookMarkButton.setImage(UIImage(named: "bookmark-2.png"), for: UIControlState.normal)
            let selectedRepo : Repo = self.allRepos[indexPath.row]
            let bookmarkDictionary = ["user": Auth.auth().currentUser?.email as Any,
                                      "name": selectedRepo.repoName,
                                      "description": selectedRepo.repoDescription,
                                      "owner": selectedRepo.repoOwner,
                                      "stars": selectedRepo.repoStars as Float,
                                      "avatar": selectedRepo.repoOwnerAvatar,
                                      "url": selectedRepo.repoURL,
                                      "isBookmarked": selectedRepo.isBookmarked as Bool] as [String : Any]
            bookmarkDB.childByAutoId().setValue(bookmarkDictionary){
                (error, reference) in
                if error != nil {
                    print(error!)
                }
                else {
                    print("bookmark saved successfully")
                }
            }
            
            self.repoListTableView.reloadData()
            self.configureTableView()
        }
        
        cell.didClickPlusBtn = { cell in

            let selectedRepo : Repo = self.allRepos[indexPath.row]
            self.repoDictionary = ["user": Auth.auth().currentUser?.email as Any,
                                  "name": selectedRepo.repoName,
                                  "description": selectedRepo.repoDescription,
                                  "owner": selectedRepo.repoOwner,
                                  "stars": selectedRepo.repoStars as Float,
                                  "avatar": selectedRepo.repoOwnerAvatar,
                                  "url": selectedRepo.repoURL]
            self.performSegue(withIdentifier: "selectCollection", sender: self)

        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allRepos.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoWebpage = URL(string: allRepos[indexPath.row].repoURL)
        UIApplication.shared.open(repoWebpage!, options: [:])
    }
    
    //Configure the Table View cells to have an optimal height
    
    func configureTableView() {
        
        repoListTableView.rowHeight = UITableViewAutomaticDimension
        repoListTableView.estimatedRowHeight = 120.0
        
    }
    
    //Passing data with segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectCollectionViewController = segue.destination as! SelectCollectionViewController
        selectCollectionViewController.repoToAdd = repoDictionary
    }
    
    //MARK: - Networking
    
    func getRepoData() {
        let date : String = getCurrentDate()
        SVProgressHUD.show()
        provider.request(.showRepos(q: date, sort: "stars", order: "desc")) { (result) in
            switch result {
            case .success(let response):
                let json = (try? JSON(data: response.data)) ?? [:]
                self.updateRepoData(json: json)
                SVProgressHUD.dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - JSON Parsing
    
    func updateRepoData(json : JSON) {
        
        for index in 0...json["items"].count {
            if let repoName = json["items"][index]["name"].string {
                let repoDescription = json["items"][index]["description"].string ?? "No Description Provided"
                let repoOwner = json["items"][index]["owner"]["login"].string
                let repoOwnerAvatar = json["items"][index]["owner"]["avatar_url"].string
                let repoStars = json["items"][index]["stargazers_count"].float
                let repoURL = json["items"][index]["html_url"].string
                let newRepo = Repo(name: repoName, description: repoDescription, owner: repoOwner!, ownerAvatar: repoOwnerAvatar!, stars: repoStars!, url: repoURL!)
                self.allRepos.append(newRepo)
                
                self.configureTableView()
                self.repoListTableView.reloadData()
            }
            else{
                print("Error: could not parse data")
            }
        }
        
    }
    
    //MARK: - Log Out
    
    @IBAction func logOutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let authScreen = storyBoard.instantiateViewController(withIdentifier: "Start") 
            UIApplication.shared.keyWindow?.rootViewController = authScreen
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("There was an error signing out")
        }
    }
    
    //MARK: - Helper Functions
    
    func formatStarsNumber(starNumber : Float) -> String {
        
        if starNumber >= 1000 {
            let formattedStars = starNumber / 1000
            return "\(String(NSString(format: "%.01f", formattedStars)))k"
        }
        else{
            let formattedStars = Int(starNumber)
            return String(formattedStars)
        }
        
    }
    
    func convertUrlToImage(imageUrl : String) -> UIImage {
        
        let url = URL(string : imageUrl)
        let data = try? Data(contentsOf: url!)
        let image : UIImage = UIImage(data: data!)!
        return image
        
    }
    
    func getCurrentDate() -> String {
        
        let date = Date().yesterday
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: date)
        return "created:>" + formattedDate
        
    }
    
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
