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
    
    private var _date: Date
    
    private var _assemblyID: String

    public var assemblyID: String {
        return _assemblyID
    }

    public var scheduledDate: Date {
        return _date
    }
    
    public init?(scheduledFor date: Date, with assembly: String) {
        
        _date = date
        _assemblyID = assembly

        super.init()
    }
    
    public init(dict: [String: Any]) {
        _date = Date(timeIntervalSince1970: TimeInterval(dict[Constants.BuildFields.Date] as! Int))
        _assemblyID = dict[Constants.BuildFields.AssemblyID] as! String
        
        super.init()
    }
    
    public override init(snapshot: FIRDataSnapshot) {
        
        let value = snapshot.value as! [String: Any]
        _date = Date(timeIntervalSince1970: TimeInterval(value[Constants.BuildFields.Date] as! Int))
        _assemblyID = value[Constants.BuildFields.AssemblyID] as! String

        super.init(snapshot: snapshot)
    }
    
    public func toAnyObject() -> Any {
        return [
            Constants.BuildFields.AssemblyID    : _assemblyID,
            Constants.BuildFields.Date          : _date.timeIntervalSince1970,
        ]
    }
}
