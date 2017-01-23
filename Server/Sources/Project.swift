//
//  Project.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/2/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import FirebaseSwift

public struct Project: FIRDataObject {
    
    public var key: String = UUID().description
    
    public var name: String

    public var assemblies = [String]()
    
    public var builds = [String]()
    
    public var parts = [String]()

    public init?(name: String, assemblies: [String] = []) {
        
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.assemblies = assemblies        
    }
    
    public init?(key: String, value: Any) {

        guard let value = value as? [String: Any],
            let name = value[Constants.ProjectFields.Name] as? String else {

                return nil
        }
        
        self.name = name
        
        if let assemblies = value[Constants.ProjectFields.Assemblies] as? [String: Bool] {
            self.assemblies = [String] ( assemblies.keys )
        }
        if let builds = value[Constants.ProjectFields.Builds] as? [String: Bool] {
            self.builds = [String] ( builds.keys )
        }
        if let parts = value[Constants.ProjectFields.Parts] as? [String: Bool] {
            self.parts = [String] ( parts.keys )
        }
        
        self.key = key
        
    }

    public func toAnyObject() -> Any {
        let assembly: [String: Bool] = assemblies.reduce([String: Bool](), convertToDict)
        let build: [String: Bool] = builds.reduce([String: Bool](), convertToDict)
        let part: [String: Bool] = parts.reduce([String: Bool](), convertToDict)

        return [
            Constants.ProjectFields.Name        : name,
            Constants.ProjectFields.Assemblies  : assembly,
            Constants.ProjectFields.Builds      : build,
            Constants.ProjectFields.Parts       : part
        ]
    }
    
    private func convertToDict<T: Hashable>(dict: [String: Bool], e: T) -> [String: Bool] {
        var dict = dict
        dict[String(describing: e)] = true
        return dict
    }
}

extension Project {
    
    /*public func delete<T: FIRDataObject>(obj: T) {
        guard let r = ref else {
            return
        }

        switch obj {
        case is Part: r.child(Constants.Types.Part).child(obj.key).removeValue()
        case is Build: r.child(Constants.Types.Build).child(obj.key).removeValue()
        case is Assembly: r.child(Constants.Types.Assembly).child(obj.key).removeValue()
        default: break
        }
        
    }*/
}
