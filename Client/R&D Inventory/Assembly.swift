//
//  Assembly.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

public protocol TableViewCompatible {
    var reuseIdentifier: String { get }
    func cellForTableView(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}

public struct Assembly: FIRDataObject {

    public var key: String = UUID().description
    
    public var ref: FIRDatabaseReference? = nil

    public var name: String

    public var parts: [String: Int] = [:]
    
    public init?(name: String, parts: [String: Int]) {
        guard !name.isEmpty else {
            return nil
        }
    
        self.name = name

        self.parts = parts
    }
    
    public init?(snapshot: FIRDataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let name = value[Constants.AssemblyFields.Name] as? String else {
                return nil
        }

        self.name = name

        self.parts = value[Constants.AssemblyFields.Parts] as? [String: Int] ?? [:]

        self.key = snapshot.key
        
        self.ref = snapshot.ref
    
    }
    
   
    public func delete() {
        guard let ref = self.ref else {
            return
        }

        ref.removeValue()
    }
    
    public func delete<T: FIRDataObject>(obj: T) {
        switch obj {
        case is Part    : Assembly.rootRef().child(Constants.Types.Part).child(obj.key).removeValue()
        case is Build   : Assembly.rootRef().child(Constants.Types.Build).child(obj.key).removeValue()
        default: break
        }
    }

    public func toAnyObject() -> Any {
        return [
            Constants.AssemblyFields.Name: name,
            Constants.AssemblyFields.Parts: parts,
        ]
    }

    public static func rootRef(with project: Project? = nil) -> FIRDatabaseReference {
        guard let proj = project else {
            return FirebaseDataManager.assemblyRef
        }
        return FirebaseDataManager.projectsRef.child(proj.key).child(Constants.Types.Assembly)
    }
}

extension Assembly: TableViewCompatible {
    
    public var reuseIdentifier: String {
        return Constants.TableViewCells.Assembly
    }
    
    public func cellForTableView(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = name
        
        return cell
    }
}
