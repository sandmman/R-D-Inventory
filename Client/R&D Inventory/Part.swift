//
//  Part.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public struct Part: FIRDataObject {
    
    // FIRDataObject
    public var key: String = UUID().description
    
    public var ref: FIRDatabaseReference? = nil

    // Part
    public var name: String

    public var leadTime: Int
    
    public var manufacturer: String

    public var countInStock: Int

    public var countOnOrder: Int
    
    public var countInAssembly: Int

    public init?(name: String, uid: String, manufacturer: String, leadTime: Int, countInAssembly: Int, countInStock: Int, countOnOrder: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // Nothing should be negative
        if (countInAssembly < 0 || countInStock < 0 || countOnOrder < 0) {
            return nil
        }
        
       
        self.key = uid
        self.name = name
        self.leadTime = leadTime
        self.manufacturer = manufacturer
        self.countInStock = countInStock
        self.countOnOrder = countOnOrder
        self.countInAssembly = countInAssembly
        
    }
    
    public init?(snapshot: FIRDataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any] else {
            return nil
        }
        
        self.name = value[Constants.PartFields.Name] as! String
        self.manufacturer = value[Constants.PartFields.Manufacturer] as! String
        self.leadTime = value[Constants.PartFields.LeadTime] as! Int
        self.countInAssembly = 0
        self.countInStock = value[Constants.PartFields.CountInStock] as! Int
        self.countOnOrder = value[Constants.PartFields.CountOnOrder] as! Int
        
        self.key = snapshot.key

        self.ref = snapshot.ref

    }

    public func toAnyObject() -> Any {
        return [
            Constants.PartFields.Name           : name,
            Constants.PartFields.Manufacturer   : manufacturer,
            Constants.PartFields.LeadTime       : leadTime,
            Constants.PartFields.CountInStock   : countInStock,
            Constants.PartFields.CountOnOrder   : countOnOrder,
        ]
    }
    
    public static func rootRef(with project: Project? = nil) -> FIRDatabaseReference {
        guard let proj = project else {
            return FirebaseDataManager.partsRef
        }
        return FirebaseDataManager.projectsRef.child(proj.key).child(Constants.Types.Part)
    }
}

extension Part: TableViewCompatible {
    
    public var reuseIdentifier: String {
        return Constants.TableViewCells.Part
    }
    
    public func cellForTableView(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)

        guard let partCell = cell as? PartTableViewCell, tableView.numberOfSections == 1 else {

            cell.textLabel?.text = name
            cell.detailTextLabel?.text = manufacturer

            return cell
        }

        partCell.nameTextLabel?.text = name
        partCell.manufacturerTextLabel?.text = manufacturer
        partCell.count = countInStock
        
        partCell.indexPath = indexPath
        
        return partCell
    }
}
