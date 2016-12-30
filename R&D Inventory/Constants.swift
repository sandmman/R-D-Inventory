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
    
    struct PartFields {
        static let Name = "name"
        static let ID = "id"
        static let Manufacturer = "manufacturer"
        static let NumSubParts = "numSubParts"
        static let NumInStock = "numInStock"
        static let NumOnOrder = "numOnOrder"
        static let LeadTime = "leadTime"
    }
    
    struct TableViewCells {
        static let assembly = "AssemblyTableViewCell"
        static let part = "PartTableViewCell"
    }
}
