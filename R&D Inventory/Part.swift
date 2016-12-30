//
//  Part.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public class Part: FIRDataObject {
    
    private var _name: String

    private var _uid: Int

    private var _manufacturer: String

    private var _leadTime: Date

    private var _countSubParts: Int

    private var _countInStock: Int

    private var _countOnOrder: Int

    public var name: String {
        return _name
    }
    
    public var uid: Int {
        return _uid
    }
    
    public var manufacturer: String {
        return _manufacturer
    }
    
    public var leadTime: Date {
        return _leadTime
    }
    
    public var countSubParts: Int {
        return _countSubParts
    }
    
    public var countInStock: Int {
        return _countInStock
    }
    
    public var countOnOrder: Int {
        return _countOnOrder
    }

    public init?(name: String, uid: Int, manufacturer: String, leadTime: Date, countSubParts: Int, countInStock: Int, countOnOrder: Int) {
        
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
        
        super.init()
    }
    
    public init(dict: [String: Any]) {

        _name = dict["name"] as! String
        _uid = dict["uid"] as! Int
        _manufacturer = dict["manufacturer"] as! String
        _leadTime =  Date(timeIntervalSince1970: TimeInterval(dict["leadTime"] as! Int))
        _countSubParts = dict["countSubParts"] as! Int
        _countInStock = dict["countInStock"] as! Int
        _countOnOrder = dict["countOnOrder"] as! Int
        
        super.init()
    }
    
     public override init(snapshot: FIRDataSnapshot) {
        
        let value = snapshot.value as! [String: Any]
        
        _name = value["name"] as! String
        _uid = value["uid"] as! Int
        _manufacturer = value["manufacturer"] as! String
        _leadTime =  Date(timeIntervalSince1970: TimeInterval(value["leadTime"] as! Int))
        _countSubParts = value["countSubParts"] as! Int
        _countInStock = value["countInStock"] as! Int
        _countOnOrder = value["countOnOrder"] as! Int
        
        super.init(snapshot: snapshot)
    }

    public func toAnyObject() -> Any {
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
