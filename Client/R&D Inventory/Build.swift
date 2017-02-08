//
//  Build.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/30/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public enum BuildType: String {
    case Standard = "standard"
    case Custom = "custom"
}

public struct Build: FIRDataObject {
    
    public var key: String = UUID().description
    
    public var ref: FIRDatabaseReference? = nil

    public var type: BuildType

    public var title: String
    
    public var quantity: Int

    public var assemblyID: String
    
    public var scheduledDate: Date
    
    public var displayDate: String {
        return scheduledDate.display
    }
    
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
    
    public init?(snapshot: FIRDataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let str_type = value[Constants.BuildFields.BType] as? String,
              let type = BuildType(rawValue: str_type),
              let quantity = value[Constants.BuildFields.Quantity] as? Int,
              let timestamp = value[Constants.BuildFields.Date] as? NSNumber,
              let uid = value[Constants.BuildFields.AssemblyID] as? String,
              let title = value[Constants.BuildFields.Title] as? String else {
                
                print("Could not unwrap build snapshot with key:", snapshot.value)
                
                return nil
        }
        
        self.type = type
        
        self.title = title
        
        self.quantity = quantity

        scheduledDate = Date(timeIntervalSince1970: TimeInterval(timestamp))

        assemblyID = uid

        partsNeeded = (value[Constants.BuildFields.PartsNeeded] as? [String: Int]) ?? [:]

        key = snapshot.key
        
        ref = snapshot.ref        
    }
    
    public func delete() {
        guard let ref = self.ref else {
            return
        }

        Assembly.rootRef().child(assemblyID).child(Constants.Types.Build).child(key).removeValue()

        ref.removeValue()
    }

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
    
    public static func rootRef(with project: Project? = nil) -> FIRDatabaseReference {
        guard let proj = project else {
            return FirebaseDataManager.buildsRef
        }
        return FirebaseDataManager.projectsRef.child(proj.key).child(Constants.Types.Build)
    }
}

extension Build: TableViewCompatible {
    
    public var reuseIdentifier: String {
        return Constants.TableViewCells.Build
    }
    
    public func cellForTableView(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = type.rawValue
        
        return cell
    }
}
