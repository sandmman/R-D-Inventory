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

    private var _leadTime: Int

    private var _countInAssembly: Int

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
    
    public var leadTime: Int {
        return _leadTime
    }
    
    public var countInAssembly: Int {
        get {
            return _countInAssembly
        }
        set {
            _countInAssembly = newValue
        }
    }
    
    public var countInStock: Int {
        return _countInStock
    }
    
    public var countOnOrder: Int {
        return _countOnOrder
    }

    public init?(name: String, uid: Int, manufacturer: String, leadTime: Int, countInAssembly: Int, countInStock: Int, countOnOrder: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // Nothing should be negative
        if (countInAssembly < 0 || countInStock < 0 || countOnOrder < 0) {
            return nil
        }
        
        _name = name
        _uid = uid
        _manufacturer = manufacturer
        _leadTime = leadTime
        _countInAssembly = countInAssembly
        _countInStock = countInStock
        _countOnOrder = countOnOrder
        
        super.init()
    }
    
    public init(dict: [String: Any], countInAssembly: Int) {
        _name = dict[Constants.PartFields.Name] as! String
        _uid = dict[Constants.PartFields.ID] as! Int
        _manufacturer = dict[Constants.PartFields.Manufacturer] as! String
        _leadTime = dict[Constants.PartFields.LeadTime] as! Int
        _countInAssembly = countInAssembly
        _countInStock = dict[Constants.PartFields.CountInStock] as! Int
        _countOnOrder = dict[Constants.PartFields.CountOnOrder] as! Int
        
        super.init()
    }
    
     public override init(snapshot: FIRDataSnapshot) {
        
        let value = snapshot.value as! [String: Any]
        
        _name = value[Constants.PartFields.Name] as! String
        _uid = value[Constants.PartFields.ID] as! Int
        _manufacturer = value[Constants.PartFields.Manufacturer] as! String
        _leadTime = value[Constants.PartFields.LeadTime] as! Int
        _countInAssembly = 0
        _countInStock = value[Constants.PartFields.CountInStock] as! Int
        _countOnOrder = value[Constants.PartFields.CountOnOrder] as! Int
        
        super.init(snapshot: snapshot)
    }

    public func toAnyObject() -> Any {
        return [
            Constants.PartFields.Name             : name,
            Constants.PartFields.ID             : uid,
            Constants.PartFields.Manufacturer   : manufacturer,
            Constants.PartFields.LeadTime       : leadTime,
            Constants.PartFields.CountInStock   : countInStock,
            Constants.PartFields.CountOnOrder   : countOnOrder,
        ]
    }
}
