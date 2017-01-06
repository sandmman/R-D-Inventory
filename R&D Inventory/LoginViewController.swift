//
//  LoginViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/5/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    
    @IBOutlet weak var signInButton: GIDSignInButton!

    @IBAction func loginButton(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn();
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    private func onSignInApproved(user: FIRUser) {
        if let name = user.displayName {
            CurrentUser.fullName = name
        }
        if let email = user.email {
            CurrentUser.email = email
        }
        
        performSegue(withIdentifier: Constants.Segues.SignInToHome, sender: nil)
    }
}
