//
//  SignUpViewController.swift
//  GitHunt
//
//  Created by Othmane on 6/22/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Sign Up Error", message: "We're sorry, there was an error registrating you to the app. Make sure you enter a valid email and a password of 6 characters minimum then try a again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try again", style: .default, handler: { (UIAlertAction) in
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.performSegue(withIdentifier: "goToRepoList", sender: self)
            }
        }
    }
    
}

