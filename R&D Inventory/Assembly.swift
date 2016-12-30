//
//  Assembly.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

class Assembly: FIRDataObject {

    private var _name: String = ""
    
    private var _uid: Int = -1

    private var _parts: [Part] = []

    var name: String {
        return _name
    }
    
    var uid: Int {
        return _uid
    }
    
    var parts: [Part] {
        return _parts
    }
    
    init?(name: String, parts: [Part]) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
    
        _name = name

        _uid = 0 // Auto generated? user generated?

        _parts = parts

        super.init()
    }
    
    required init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! [String: Any]

        _name = value["_name"] as! String
        _uid = value["_uid"] as! Int
        var partsDict = value["_parts"] as! [String: [String: Any]]
        for (key,value) in partsDict {
            _parts.append(Part(dict: value))
        }
        
        super.init(snapshot: snapshot)
    }
    
    func toAnyObject() -> Any {
        return [
            "_name": name,
            "_uid": uid,
            "_parts": parts.reduce([String: Any]()) { (dict, e) in var dict = dict; dict[String(e.uid)] = e.toAnyObject() ; return dict}
        ]
    }
}
