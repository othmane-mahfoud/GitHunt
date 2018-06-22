//
//  RepoListViewController.swift
//  GitHunt
//
//  Created by Othmane on 6/22/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit
import Firebase

class RepoListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("There was an error signing out")
        }
    }
}
