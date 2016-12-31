//
//  Build.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/30/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public class Build: FIRDataObject {
    
    public var scheduledDate: Date
    
    public var assemblyID: String
    
    public var partsNeeded: [String: Int]

    public init?(partsNeeded: [String: Int], scheduledFor date: Date, withAssembly: String) {
        
        self.scheduledDate = date
        self.assemblyID = withAssembly
        self.partsNeeded = partsNeeded

        super.init()
    }
    
    public override init?(snapshot: FIRDataSnapshot) {
        
        let value = snapshot.value as! [String: Any]
        
        guard let timestamp = value[Constants.BuildFields.Date] as? Int,
              let uid = value[Constants.BuildFields.AssemblyID] as? String else {
                return nil
        }

        scheduledDate = Date(timeIntervalSince1970: TimeInterval(timestamp))

        assemblyID = uid

        partsNeeded = (value[Constants.BuildFields.PartsNeeded] as? [String: Int]) ?? [:]

        super.init(snapshot: snapshot)
    }
    
    public func toAnyObject() -> Any {
        return [
            Constants.BuildFields.AssemblyID    : assemblyID,
            Constants.BuildFields.Date          : scheduledDate.timeIntervalSince1970,
            Constants.BuildFields.PartsNeeded   : partsNeeded
        ]
    }
}
