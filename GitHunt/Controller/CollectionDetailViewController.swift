//
//  CollectionDetailViewController.swift
//  GitHunt
//
//  Created by Othmane on 7/1/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit
import Firebase

class CollectionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var repoArray : [Repo] = [Repo]()
    var repoKeys : [String] = [String]()
    var selectedCollectionKey : String = ""
    @IBOutlet weak var repoListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        repoListTable.delegate = self
        repoListTable.dataSource = self
        repoListTable.register(UINib(nibName: "BookmarksCustomCell", bundle: nil), forCellReuseIdentifier: "bookmarkCell")
        
        configureTableView()
        retrieveRepos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarksCustomCell
        
        cell.addButton.isHidden = true
        cell.repoNameLabel.text = repoArray[indexPath.row].repoName
        cell.repoDescriptionLabel.text = repoArray[indexPath.row].repoDescription
        cell.repoOwnerLabel.text = repoArray[indexPath.row].repoOwner
        cell.repoOwnerAvatar.image = convertUrlToImage(imageUrl: repoArray[indexPath.row].repoOwnerAvatar)
        
        cell.didClickRemoveBtn = { cell in
            let selectedRepo = self.repoArray[indexPath.row]
        Database.database().reference().child("collections").child(self.selectedCollectionKey).child("repos").child(self.repoKeys[indexPath.row]).removeValue()
            self.repoArray.remove(at: indexPath.row)
            self.repoKeys.remove(at: indexPath.row)
            self.repoListTable.reloadData()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoWebpage = URL(string: repoArray[indexPath.row].repoURL)
        UIApplication.shared.open(repoWebpage!, options: [:])
    }
    
    //Configure the Table View cells to have an optimal height
    
    func configureTableView() {
        
        repoListTable.rowHeight = UITableViewAutomaticDimension
        repoListTable.estimatedRowHeight = 120.0
        
    }
    
    //MARK: - Database
    
    func retrieveRepos() {
        let reposDB = Database.database().reference().child("collections").child(selectedCollectionKey).child("repos")
        reposDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            let repoName = snapshotValue["name"]!
            let repoDescription = snapshotValue["description"]!
            let repoOwner = snapshotValue["owner"]
            let ownerAvatar = snapshotValue["avatar"]
            let repoStars = (snapshotValue["stars"])!
            let repoURL = snapshotValue["url"]
            let repo = Repo(name: repoName as! String, description: repoDescription as! String, owner: repoOwner! as! String, ownerAvatar: ownerAvatar! as! String, stars: repoStars as! Float , url: repoURL! as! String)
            self.repoArray.append(repo)
            let key = snapshot.key
            self.repoKeys.append(key)
            self.configureTableView()
            self.repoListTable.reloadData()
        }
    }
    
    //MARK: - Helper Functions
    
    func convertUrlToImage(imageUrl : String) -> UIImage {
        
        let url = URL(string : imageUrl)
        let data = try? Data(contentsOf: url!)
        let image : UIImage = UIImage(data: data!)!
        return image
        
    }

}
