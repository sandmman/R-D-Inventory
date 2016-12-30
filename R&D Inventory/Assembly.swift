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

    private var _name: String

    private var _parts: [String: Int] = [:]

    public var name: String {
        return _name
    }
    
    public var parts: [String: Int] {
        return _parts
    }
    
    public init?(name: String, parts: [String: Int]) {
        guard !name.isEmpty else {
            return nil
        }
    
        _name = name

        _parts = parts

        super.init()
    }
    
    public override init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! [String: Any]

        _name = value["_name"] as! String

        _parts = value["_parts"] as? [String: Int] ?? [:]
    
        super.init(snapshot: snapshot)
    }
    
    public func toAnyObject() -> Any {
        return [
            "_name": name,
            "_parts": _parts,
        ]
    }
    
    private func createDict(dict: [String: Bool], partID: String) -> [String: Bool] {
        var dict = dict
        dict[partID] = true
        return dict
    }
}
