//
//  CurrentUser.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/5/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import Firebase

class CurrentUser: NSObject {
    
    fileprivate static let googleUserIDKey = "google_user_id"
    fileprivate static let fullNameKey = "user_full_name"
    fileprivate static let emailKey = "user_email"

    /// Grab facebook user id of user from UserDefaults
    class var googleUserId: String {
        get {
            if let userId = UserDefaults.standard.object(forKey: googleUserIDKey) as? String {
                return userId
            } else {
                return "anonymous"
            }
        }
        set(userId) {
            
            UserDefaults.standard.set(userId, forKey: googleUserIDKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// grab full name of user from UserDefaults
    class var fullName: String {
        get {
            if let full_name = UserDefaults.standard.object(forKey: fullNameKey) as? String {
                return full_name
            } else {
                return "Anonymous"
            }
        }
        set(user_full_name) {
            
            UserDefaults.standard.set(user_full_name, forKey: fullNameKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// grab full name of user from UserDefaults
    class var email: String {
        get {
            if let user_email = UserDefaults.standard.object(forKey: emailKey) as? String {
                return user_email
            } else {
                return "Anonymous"
            }
        }
        set(user_email) {
            
            UserDefaults.standard.set(user_email, forKey: emailKey)
            UserDefaults.standard.synchronize()
        }
    }

    /**
     Method resets the CurrentUser to log out
     */
    class func logOut() {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()

        } catch let signOutError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}
