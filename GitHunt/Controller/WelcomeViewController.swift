//
//  WelcomeViewController.swift
//  GitHunt
//
//  Created by Othmane on 6/21/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit
import Moya

class WelcomeViewController: UIViewController {

    let provider = MoyaProvider<RepoService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK : - Helper functions
    
    func getCurrentDate() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: date)
        return "created:>" + formattedDate
        
    }

}

