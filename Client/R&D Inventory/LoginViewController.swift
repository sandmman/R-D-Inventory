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
        
        FirebaseDataManager.getProjects {
            projects in
            print(projects.count)
            let segue = projects.count == 0 ? Constants.Segues.SignInToCreateProject : Constants.Segues.SignInToHome
            
            self.performSegue(withIdentifier: segue, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.SignInToCreateProject {
            
            guard let dest = segue.destination as? CreateProjectViewController else {
                return
            }
            
            dest.isInitialForm = true

        } else if segue.identifier == Constants.Segues.SignInToHome {
            
        }
    }
}
