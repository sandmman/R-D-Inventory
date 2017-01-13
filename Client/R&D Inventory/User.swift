//
//  User.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/5/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public struct User: FIRDataObject {
    
    public var key: String = UUID().description
    
    public var ref: FIRDatabaseReference? = nil

    public let name: String
    
    public var companies = [String]()

    public init(name: String) {
        self.name = name
    }
    
    public init?(snapshot: FIRDataSnapshot) {

        guard let value = snapshot.value as? [String: Any],
            let name = value[Constants.UserFields.Name] as? String else {
                
                return nil
        }
        
        self.name = name
        
        if let companies = value[Constants.UserFields.Company] as? [String: Bool] {
            self.companies = [String] ( companies.keys )
        }
        
        key = snapshot.key
        
        ref = snapshot.ref
        
    }

    public func toAnyObject() -> Any {
        return [
            Constants.UserFields.Name: name
        ]
    }
    
    public static func rootRef(with project: Project? = nil) -> FIRDatabaseReference {
        return FirebaseDataManager.userRef
    }
}
