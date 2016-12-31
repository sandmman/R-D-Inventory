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
    
    public init?(scheduledFor date: Date, with assembly: String) {
        
        scheduledDate = date
        assemblyID = assembly

        super.init()
    }
    
    public init(dict: [String: Any]) {
        scheduledDate = Date(timeIntervalSince1970: TimeInterval(dict[Constants.BuildFields.Date] as! Int))
        assemblyID = dict[Constants.BuildFields.AssemblyID] as! String
        
        super.init()
    }
    
    public override init(snapshot: FIRDataSnapshot) {
        
        let value = snapshot.value as! [String: Any]
        scheduledDate = Date(timeIntervalSince1970: TimeInterval(value[Constants.BuildFields.Date] as! Int))
        assemblyID = value[Constants.BuildFields.AssemblyID] as! String

        super.init(snapshot: snapshot)
    }
    
    public func toAnyObject() -> Any {
        return [
            Constants.BuildFields.AssemblyID    : assemblyID,
            Constants.BuildFields.Date          : scheduledDate.timeIntervalSince1970,
        ]
    }
}
