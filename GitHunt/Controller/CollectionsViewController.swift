//
//  CollectionsViewController.swift
//  GitHunt
//
//  Created by Othmane on 6/29/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit
import Firebase

class CollectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var collectionTableView: UITableView!
    
    var collectionArray : [Collection] = [Collection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionTableView.delegate = self
        collectionTableView.dataSource = self
        collectionTableView.register(UINib(nibName: "CollectionCustomCell", bundle: nil), forCellReuseIdentifier: "collectionCell")
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
        let borderColor : UIColor = .black
        cell.layer.borderColor = borderColor.cgColor
        cell.collectionNameLabel.text = collectionArray[indexPath.row].collectionName
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectionArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //Configure the Table View cells to have an optimal height
    
    func configureTableView() {
        
        collectionTableView.rowHeight = UITableViewAutomaticDimension
        collectionTableView.estimatedRowHeight = 60.0
        
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
    
    @IBAction func newButtonPressed(_ sender: Any) {
    
        var textField = UITextField()
        let alert = UIAlertController(title: "Create new collection", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != "" {
                let newCollection = Collection()
                newCollection.collectionName = textField.text!
                self.saveCollection(newCollection: newCollection)
                self.collectionTableView.reloadData()
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Please enter a valid collection name", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Collection"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Database
    
    func saveCollection(newCollection : Collection) {
        let collectionDB =  Database.database().reference().child("collections")
        let collectionDictionary = ["user": Auth.auth().currentUser?.email as Any,
                                    "name": newCollection.collectionName]
        collectionDB.childByAutoId().setValue(collectionDictionary) {
            (error, reference) in
            if error != nil {
                print(error!)
            }
            else {
                print("collection saved successfully")
            }
        }
        self.collectionTableView.reloadData()
        self.configureTableView()
    }
    
    func retrieveCollections() {
        let collectionDB =  Database.database().reference().child("collections")
        collectionDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            let collectionName = snapshotValue["name"]
            let newCollection = Collection()
            newCollection.collectionName = collectionName as! String
            self.collectionArray.append(newCollection)
            self.configureTableView()
            self.collectionTableView.reloadData()
        }
    }
    
    
}
