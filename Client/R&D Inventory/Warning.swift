//
//  Warning.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 2/8/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public struct Warning: FIRDataObject {
    
    public var key: String = UUID().description
    
    public var ref: FIRDatabaseReference? = nil
    
    public var buildKey: String
    
    public var buildDate: Date
    
    // Part ID: (count expected, current count, order-by)
    public var parts: [String: (Int, Int, Date)]

    public init?(snapshot: FIRDataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let build = value[Constants.WarningFields.BuildKey] as? String,
              let timestamp = value[Constants.WarningFields.BuildDate] as? NSNumber,
              let _ = value[Constants.WarningFields.Parts] as? [String: [String: Any]] else {
                
                print("Could not unwrap warning snapshot with key:", snapshot.value)
                
                return nil
        }
        
        self.buildKey = build
        
        self.buildDate = Date(timeIntervalSince1970: TimeInterval(timestamp))

        self.parts = [:]

        key = snapshot.key
        
        ref = snapshot.ref
    }
    
    public func delete() {
    }
    
    public func toAnyObject() -> Any {
        return []
    }
    
    public static func rootRef(with project: Project? = nil) -> FIRDatabaseReference {
        guard let proj = project else {
            return FirebaseDataManager.warningRef
        }
        return FirebaseDataManager.warningRef.child(proj.key).child(Constants.Types.Warning)
    }
}

extension Warning: TableViewCompatible {
    
    public var reuseIdentifier: String {
        return Constants.TableViewCells.Warning
    }
    
    public func cellForTableView(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = "Warning"
        
        return cell
    }
}
