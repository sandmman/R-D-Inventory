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
        static let BuildDetail = "BuildDetailSegue"
        static let AssemblyDetail = "AssemblyDetailSegue"
        static let CreateBuild = "CreateBuildSegue"
    }
    
    struct PartFields {
        static let Name = "name"
        static let ID = "uid"
        static let Manufacturer = "manufacturer"
        static let CountInAssembly = "countInAssembly"
        static let CountInStock = "countInStock"
        static let CountOnOrder = "countOnOrder"
        static let LeadTime = "leadTime"
    }
    
    struct BuildFields {
        static let Title = "title"
        static let Location = "location"
        static let AssemblyID = "assemblyID"
        static let Date = "date"
        static let Notes = "notes"
    }
    
    struct AssemblyFields {
        static let Name = "name"
        static let Parts = "parts"
    }

    struct TableViewCells {
        static let assembly = "AssemblyTableViewCell"
        static let part = "PartTableViewCell"
    }
}
