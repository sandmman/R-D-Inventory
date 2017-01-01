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
    
    public var name: String

    public var uid: Int

    public var manufacturer: String

    public var leadTime: Int

    public var countInAssembly: Int

    public var countInStock: Int

    public var countOnOrder: Int

    public init?(name: String, uid: Int, manufacturer: String, leadTime: Int, countInAssembly: Int, countInStock: Int, countOnOrder: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // Nothing should be negative
        if (countInAssembly < 0 || countInStock < 0 || countOnOrder < 0) {
            return nil
        }
        
        self.name = name
        self.uid = uid
        self.manufacturer = manufacturer
        self.leadTime = leadTime
        self.countInAssembly = countInAssembly
        self.countInStock = countInStock
        self.countOnOrder = countOnOrder
        
        super.init()
    }
    
     required public init?(snapshot: FIRDataSnapshot) {
        
        let value = snapshot.value as! [String: Any]
        
        self.name = value[Constants.PartFields.Name] as! String
        self.uid = value[Constants.PartFields.ID] as! Int
        self.manufacturer = value[Constants.PartFields.Manufacturer] as! String
        self.leadTime = value[Constants.PartFields.LeadTime] as! Int
        self.countInAssembly = 0
        self.countInStock = value[Constants.PartFields.CountInStock] as! Int
        self.countOnOrder = value[Constants.PartFields.CountOnOrder] as! Int
        
        super.init(snapshot: snapshot)
    }

    public func toAnyObject() -> Any {
        return [
            Constants.PartFields.Name           : name,
            Constants.PartFields.ID             : uid,
            Constants.PartFields.Manufacturer   : manufacturer,
            Constants.PartFields.LeadTime       : leadTime,
            Constants.PartFields.CountInStock   : countInStock,
            Constants.PartFields.CountOnOrder   : countOnOrder,
        ]
    }
}
