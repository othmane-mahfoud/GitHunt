//
//  SignInViewController.swift
//  GitHunt
//
//  Created by Othmane on 6/22/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import p2_OAuth2

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    fileprivate var alamofireManager: SessionManager?
    
    var loader: OAuth2DataLoader?
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "16e2b1b101f77b9ce07e",                         // yes, this client-id and secret will work!
        "client_secret": "110ebfed3aa74fe3e1ad8fc52b56910fbe42fe0c",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "user repo:status",
        "redirect_uris": ["ppoauthapp://oauth/callback"],            // app has registered this scheme
        "secret_in_body": true,                                      // GitHub does not accept client secret in the Authorization header
        "verbose": true,
        ] as OAuth2JSON)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Authentication Error", message: "Your username or password are incorrect", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try again", style: .default, handler: { (UIAlertAction) in
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.performSegue(withIdentifier: "goToRepoList", sender: self)
            }
        }
        
    }
    
    @IBAction func githubSignInPressed(_ sender: Any) {
        
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }
        oauth2.authConfig.authorizeEmbedded = false
        let loader = OAuth2DataLoader(oauth2: oauth2)
        self.loader = loader
        
        loader.perform(request: userDataRequest) { response in
            do {
                let json = try response.responseJSON()
                self.didGetUserdata(dict: json, loader: loader)
            }
            catch let error {
                self.didCancelOrFail(error)
            }
        }
        
    }
    
    var userDataRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func didGetUserdata(dict: [String: Any], loader: OAuth2DataLoader?) {
        DispatchQueue.main.async {
            if (dict["name"] as? String) != nil {
                let credential = GitHubAuthProvider.credential(withToken: self.oauth2.accessToken!)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    self.performSegue(withIdentifier: "goToRepoList", sender: self)
                }
            }
            else{
                print("could not get data")
            }
        }
    }
    
    func didCancelOrFail(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
        }
    }
    
    
}

