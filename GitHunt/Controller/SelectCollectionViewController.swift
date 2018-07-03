//
//  SelectCollectionViewController.swift
//  GitHunt
//
//  Created by Othmane on 6/29/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit
import Firebase

class SelectCollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var selectCollectionTable: UITableView!
    var collectionArray : [Collection] = [Collection]()
    var collectionKeys : [String] = [String]()
    var repoToAdd : Dictionary <String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectCollectionTable.delegate = self
        selectCollectionTable.dataSource = self
        selectCollectionTable.register(UINib(nibName: "CollectionCustomCell", bundle: nil), forCellReuseIdentifier: "collectionCell")
        configureTableView()
        retrieveCollections()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! CollectionCustomCell
        cell.collectionNameLabel.text = collectionArray[indexPath.row].collectionName
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectionArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reposDB = Database.database().reference().child("collections").child(collectionKeys[indexPath.row]).child("repos")
        reposDB.childByAutoId().setValue(repoToAdd) {
            (error, reference) in
            if error != nil {
                print(error!)
            }
            else {
                print("repo saved successfully")
            }
        }
        performSegue(withIdentifier: "backToRepos", sender: self)
    }
    
    //Configure the Table View cells to have an optimal height
    
    func configureTableView() {
        
        selectCollectionTable.rowHeight = UITableViewAutomaticDimension
        selectCollectionTable.estimatedRowHeight = 60.0
        
    }
    
    //MARK : - Database
    
    func retrieveCollections() {
        let collectionDB =  Database.database().reference().child("collections")
        collectionDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            let collectionName = snapshotValue["name"]
            let newCollection = Collection()
            newCollection.collectionName = collectionName as! String
            self.collectionArray.append(newCollection)
            let key = snapshot.key
            self.collectionKeys.append(key)
            self.configureTableView()
            self.selectCollectionTable.reloadData()
        }
    }

}
