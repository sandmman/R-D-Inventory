//
//  Assembly.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class Assembly: NSObject {

    private var _name: String
    
    private var _uid: Int

    private var _parts: [Part]
    
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

    }
    
    init(dict: [String: Any]) {
        
        _name = dict["name"] as! String
        _uid  = dict["uid"] as! Int
        _parts = dict["parts"] as! [Part]
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "uid": uid,
            "parts": parts.reduce([Int: Any]()) { (dict, e) in var dict = dict; dict[e.uid] = e ; return dict}
        ]
    }
}
