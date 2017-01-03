//
//  Project.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/2/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public class Project: FIRDataObject {
    
    public var name: String

    public var assemblies: [String]
    
    public init?(name: String, assemblies: [String] = []) {
        
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.assemblies = assemblies
        
        super.init()
    }
    
    required public init?(snapshot: FIRDataSnapshot) {

        guard let value = snapshot.value as? [String: Any],
            let name = value[Constants.ProjectFields.Name] as? String,
            let assemblies = value[Constants.ProjectFields.Assemblies] as? [String: Bool] else {

                return nil
        }
        
        self.name = name
        self.assemblies = [String] ( assemblies.keys )
        
        super.init(snapshot: snapshot)
    }
    
    public override func toAnyObject() -> Any {
        let assembly: [String: Bool] = assemblies.reduce([String: Bool](), convertToDict)
        
        return [
            Constants.ProjectFields.Name        : name,
            Constants.ProjectFields.Assemblies  : assembly
        ]
    }
    
    private func convertToDict<T: Hashable>(dict: [String: Bool], e: T) -> [String: Bool] {
        var dict = dict
        dict[String(describing: e)] = true
        return dict
    }
}
