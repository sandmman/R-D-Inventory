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
        static let Notifications = "notifications"
    }
    
    struct AssemblyFields {
        static let Name = "name"
        static let Parts = "parts"
    }
    
    struct ProjectFields {
        static let Name = "name"
        static let Assemblies = "assemblies"
        static let Builds = "builds"
        static let Parts = "parts"
    }
    
    struct UserFields {
        static let Name = "name"
        static let Company = "company"
        static let Projects = "projects"
    }
}
