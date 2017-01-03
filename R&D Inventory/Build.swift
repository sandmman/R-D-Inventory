//
//  Build.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/30/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public struct Build: FIRDataObject {
    
    public var key: String = UUID().description
    
    public var ref: FIRDatabaseReference? = nil

    public var scheduledDate: Date
    
    public var title: String

    public var assemblyID: String
    
    public var partsNeeded = [String: Int]()

    public init?(title: String, partsNeeded: [String: Int], scheduledFor date: Date, withAssembly: String) {
        
        guard date >= Date() else {
            return nil
        }
        
        self.title = title
        self.scheduledDate = date
        self.assemblyID = withAssembly
        self.partsNeeded = partsNeeded

    }
    
    public init?(snapshot: FIRDataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let timestamp = value[Constants.BuildFields.Date] as? Int,
              let uid = value[Constants.BuildFields.AssemblyID] as? String,
              let title = value[Constants.BuildFields.Title] as? String else {
                return nil
        }
        
        self.title = title

        scheduledDate = Date(timeIntervalSince1970: TimeInterval(timestamp))

        assemblyID = uid

        partsNeeded = (value[Constants.BuildFields.PartsNeeded] as? [String: Int]) ?? [:]

        key = snapshot.key
        
        ref = snapshot.ref        
    }
    
    public func toAnyObject() -> Any {
        return [
            Constants.BuildFields.AssemblyID    : assemblyID,
            Constants.BuildFields.Date          : scheduledDate.timeIntervalSince1970,
            Constants.BuildFields.PartsNeeded   : partsNeeded,
            Constants.BuildFields.Title         : title
        ]
    }
}
