//
//  Assembly.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public class Assembly: FIRDataObject {

    public var name: String

    public var parts: [String: Int] = [:]
    
    public init?(name: String, parts: [String: Int]) {
        guard !name.isEmpty else {
            return nil
        }
    
        self.name = name

        self.parts = parts

        super.init()
    }
    
    required public init?(snapshot: FIRDataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let name = value[Constants.AssemblyFields.Name] as? String else {
                return nil
        }

        self.name = name

        self.parts = value[Constants.AssemblyFields.Parts] as? [String: Int] ?? [:]
    
        super.init(snapshot: snapshot)
    }
    
    public override func toAnyObject() -> Any {
        return [
            Constants.AssemblyFields.Name: name,
            Constants.AssemblyFields.Parts: parts,
        ]
    }
}
