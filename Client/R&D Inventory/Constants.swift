//
//  Constants.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/29/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Types {
        static var Assembly = "assemblies"
        static var Build = "builds"
        static var Part = "parts"
        static var Project = "projects"
        static var User = "users"
    }

    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Patterns {
        static let PartID = "[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]"
    }

    struct Segues {
        static let SignInToHome = "SignInToHomeSegue"
        static let SignInToCreateProject = "SignInToCreateProjectSegue"
        static let HomeToSignIn = "HomeToSignInSegue"
        static let ToHome = "ToHomeSegue"
        
        static let PartDetail = "PartDetailSegue"
        static let BuildDetail = "BuildDetailSegue"
        static let ProjectDetail = "ProjectDetailSegue"
        static let AssemblyDetail = "AssemblyDetailSegue"

        static let CreateBuild = "CreateBuildSegue"
        static let CreatePart = "CreatePartSegue"
        static let CreateAssembly = "CreateAssemblySegue"
        static let CreateProject = "CreateProjectSegue"
    
        static let TabBarController = "TabBarControllerSegue"

        static let UnwindToProjectDetail = "UnwindToProjectDetailSegue"
        static let UnwindToAssemblyDetail = "UnwindToAssemblyDetailSegue"
        static let UnwindToBuildCalendar = "UnwindToBuildCalendarSegue"
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
        static let Quantity = "quantity"
        static let BType = "type"
        static let Location = "location"
        static let AssemblyID = "assemblyID"
        static let Date = "date"
        static let Notes = "notes"
        static let PartsNeeded = "parts"
    }
    
    struct AssemblyFields {
        static let Name = "name"
        static let Parts = "parts"
    }
    
    struct ProjectFields {
        static let Name = "name"
        static let Assemblies = "assemblies"
    }
    
    struct UserFields {
        static let Name = "name"
        static let Company = "company"
        static let Projects = "projects"
    }

    struct TableViewCells {
        static let Assembly = "AssemblyTableViewCell"
        static let Part = "PartTableViewCell"
        static let Project = "ProjectTableViewCell"
        static let BuildWarning = "BuildWarningTableViewCell"
        static let Build = "BuildTableViewCell"
    }
}
