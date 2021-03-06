//
//  Build.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/30/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//
import Foundation
import FirebaseSwift

public enum BuildType: String {
    case Standard = "standard"
    case Custom = "custom"
}

public struct Build: FIRDataObject {
    
    public var key: String = UUID().description

    public var type: BuildType

    public var title: String
    
    public var quantity: Int

    public var assemblyID: String
    
    public var scheduledDate: Date
    
    public var partsNeeded = [String: Int]()

    public init?(type: BuildType, title: String, quantity: Int, partsNeeded: [String: Int], scheduledFor date: Date, withAssembly: String) {
        
        guard Calendar.current.compare(date, to: Date(), toGranularity: .day) != .orderedAscending else {
            return nil
        }
        
        self.type = type
        self.title = title
        self.quantity = quantity
        self.scheduledDate = date
        self.assemblyID = withAssembly
        self.partsNeeded = partsNeeded

    }
    
    public init?(key: String, value: Any) {

        guard let value = value as? [String: Any],
              let str_type = value[Constants.BuildFields.BType] as? String,
              let type = BuildType(rawValue: str_type),
              let quantity = value[Constants.BuildFields.Quantity] as? Int,
              let timestamp = value[Constants.BuildFields.Date] as? Int,
              let uid = value[Constants.BuildFields.AssemblyID] as? String,
              let title = value[Constants.BuildFields.Title] as? String else {
                return nil
        }
        
        self.type = type
        
        self.title = title
        
        self.quantity = quantity

        scheduledDate = Date(timeIntervalSince1970: TimeInterval(timestamp))

        assemblyID = uid

        partsNeeded = (value[Constants.BuildFields.PartsNeeded] as? [String: Int]) ?? [:]

        self.key = key
        
    }
    
    /*public func delete() {
        guard let ref = self.ref else {
            return
        }

        Assembly.rootRef().child(assemblyID).child(Constants.Types.Build).child(key).removeValue()

        ref.removeValue()
    }*/

    public func toAnyObject() -> Any {
        return [
            Constants.BuildFields.AssemblyID    : assemblyID,
            Constants.BuildFields.Date          : scheduledDate.timeIntervalSince1970,
            Constants.BuildFields.PartsNeeded   : partsNeeded,
            Constants.BuildFields.Title         : title,
            Constants.BuildFields.BType         : type.rawValue,
            Constants.BuildFields.Quantity      : quantity,
        ]
    }
}
