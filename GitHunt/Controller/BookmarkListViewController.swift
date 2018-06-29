//
//  BookmarkListViewController.swift
//  GitHunt
//
//  Created by Othmane on 6/28/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit
import Firebase

class BookmarkListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bookmarkArray : [Repo] = [Repo]()
    var bookmarkKeys : [String] = [String]()
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.register(UINib(nibName: "BookmarksCustomCell", bundle: nil), forCellReuseIdentifier: "bookmarkCell")
        
        configureTableView()
        
        retrieveBookmarks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarksCustomCell
        
        cell.repoNameLabel.text = bookmarkArray[indexPath.row].repoName
        cell.repoDescriptionLabel.text = bookmarkArray[indexPath.row].repoDescription
        cell.repoOwnerLabel.text = bookmarkArray[indexPath.row].repoOwner
        cell.repoOwnerAvatar.image = convertUrlToImage(imageUrl: bookmarkArray[indexPath.row].repoOwnerAvatar)
        
        cell.didClickRemoveBtn = { cell in
            let selectedRepo = self.bookmarkArray[indexPath.row]
            selectedRepo.isBookmarked = false

            Database.database().reference().child("bookmarks").child(self.bookmarkKeys[indexPath.row]).removeValue()
            print(self.bookmarkKeys[indexPath.row])
            self.bookmarkArray.remove(at: indexPath.row)
            self.bookmarkKeys.remove(at: indexPath.row)
            self.bookmarkTableView.reloadData()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookmarkArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoWebpage = URL(string: bookmarkArray[indexPath.row].repoURL)
        UIApplication.shared.open(repoWebpage!, options: [:])
    }
    
    //Configure the Table View cells to have an optimal height
    
    func configureTableView() {
        
        bookmarkTableView.rowHeight = UITableViewAutomaticDimension
        bookmarkTableView.estimatedRowHeight = 120.0
        
    }
    
    //MARK: - Database
    
    func retrieveBookmarks() {
        let messageDB = Database.database().reference().child("bookmarks")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            let repoName = snapshotValue["name"]!
            let repoDescription = snapshotValue["description"]!
            let repoOwner = snapshotValue["owner"]
            let ownerAvatar = snapshotValue["avatar"]
            let repoStars = (snapshotValue["stars"])!
            let repoURL = snapshotValue["url"]
            let bookMark = Repo(name: repoName as! String, description: repoDescription as! String, owner: repoOwner! as! String, ownerAvatar: ownerAvatar! as! String, stars: repoStars as! Float , url: repoURL! as! String)
            self.bookmarkArray.append(bookMark)
            let key = snapshot.key
            self.bookmarkKeys.append(key)
            self.configureTableView()
            self.bookmarkTableView.reloadData()
        }
    }
    
    //MARK: - Log Out
    
    @IBAction func logOutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
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
    
}
