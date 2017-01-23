//
//  Assembly.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//
import Foundation
import FirebaseSwift

public struct Assembly: FIRDataObject {

    public var key: String = UUID().description

    public var name: String

    public var parts: [String: Int] = [:]
    
    public var builds: [String] = []

    public init?(name: String, parts: [String: Int]) {
        guard !name.isEmpty else {
            return nil
        }
    
        self.name = name

        self.parts = parts
    }
    
    public init?(key: String, value: Any) {
        
        guard let value = value as? [String: Any],
              let name = value[Constants.AssemblyFields.Name] as? String else {
                return nil
        }

        self.name = name

        self.parts = value[Constants.AssemblyFields.Parts] as? [String: Int] ?? [:]

        self.key = key

    }
    
   
    /*public func delete() {
        guard let ref = self.ref else {
            return
        }

        ref.removeValue()
    }
    
    public func delete<T: FIRDataObject>(obj: T) {
        switch obj {
        case is Part    : Assembly.rootRef().child(Constants.Types.Part).child(obj.key).removeValue()
        case is Build   : Assembly.rootRef().child(Constants.Types.Build).child(obj.key).removeValue()
        default: break
        }
    }*/

    public func toAnyObject() -> Any {
        return [
            Constants.AssemblyFields.Name: name,
            Constants.AssemblyFields.Parts: parts,
        ]
    }
}

