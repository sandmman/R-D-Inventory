//
//  Constants.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/29/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import Foundation

struct Constants {
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let SignInToHome = "SignInToHome"
        static let HomeToSignIn = "HomeToSignIn"
        static let PartDetail = "PartDetailSegue"
        static let AssemblyDetail = "AssemblyDetailSegue"
        
    }
    
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let photoURL = "photoURL"
        static let imageURL = "imageURL"
    }
    
    struct TableViewCells {
        static let assembly = "AssemblyTableViewCell"
        static let part = "PartTableViewCell"
    }
}
