//
//  Part.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class Part: NSObject {

    private var _name: String

    private var _uid: Int

    private var _manufacturer: String

    private var _leadTime: Date

    private var _countSubParts: Int

    private var _countInStock: Int

    private var _countOnOrder: Int
    
    var name: String {
        return _name
    }
    
    var uid: Int {
        return _uid
    }
    
    var manufacturer: String {
        return _manufacturer
    }
    
    var leadTime: Date {
        return _leadTime
    }
    
    var countSubParts: Int {
        return _countSubParts
    }
    
    var countInStock: Int {
        return _countInStock
    }
    
    var countOnOrder: Int {
        return _countOnOrder
    }
    
    init?(name: String, uid: Int, manufacturer: String, leadTime: Date, countSubParts: Int, countInStock: Int, countOnOrder: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // Nothing should be negative
        if (countSubParts < 0 || countInStock < 0 || countOnOrder < 0) {
            return nil
        }
        
        _name = name
        _uid = uid
        _manufacturer = manufacturer
        _leadTime = leadTime
        _countSubParts = countSubParts
        _countInStock = countInStock
        _countOnOrder = countOnOrder

    }
    
    init(dict: [String: Any]) {
        print(dict)
        _name = dict["name"] as! String
        _uid = dict["uid"] as! Int
        _manufacturer = dict["manufacturer"] as! String
        _leadTime =  Date(timeIntervalSince1970: TimeInterval(dict["leadTime"] as! Int))
        _countSubParts = dict["countSubParts"] as! Int
        _countInStock = dict["countInStock"] as! Int
        _countOnOrder = dict["countOnOrder"] as! Int
    }

    func toAnyObject() -> Any {
        return [
            "name": name,
            "uid": uid,
            "manufacturer": manufacturer,
            "leadTime": leadTime.timeIntervalSince1970,
            "countSubParts": countSubParts,
            "countInStock": countInStock,
            "countOnOrder": countOnOrder,
        ]
    }
}
