//
//  Assembly.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public struct Assembly: FIRDataObject {
    
    // FIRDataObject
    public var key: String = UUID().description
    
    public var ref: FIRDatabaseReference? = nil

    public var name: String

    public var parts: [String: Int] = [:]
    
    public init?(name: String, parts: [String: Int]) {
        guard !name.isEmpty else {
            return nil
        }
    
        self.name = name

        self.parts = parts
    }
    
    public init?(snapshot: FIRDataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let name = value[Constants.AssemblyFields.Name] as? String else {
                return nil
        }

        self.name = name

        self.parts = value[Constants.AssemblyFields.Parts] as? [String: Int] ?? [:]

        self.key = snapshot.key
        
        self.ref = snapshot.ref
    
    }
    
    public func toAnyObject() -> Any {
        return [
            Constants.AssemblyFields.Name: name,
            Constants.AssemblyFields.Parts: parts,
        ]
    }
}
