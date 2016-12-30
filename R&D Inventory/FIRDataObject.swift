//
//  FIRDataObject.swift
//  Pods
//
//  Created by Aaron Liberatore on 12/29/16.
//
//

import UIKit
import Firebase

public class FIRDataObject: NSObject {
    
    public var snapshot: FIRDataSnapshot? = nil

    public var key: String? { return snapshot?.key }

    public var ref: FIRDatabaseReference? { return snapshot?.ref }
    
    public var databaseID: String
    
    override init() {
        databaseID = UUID().uuidString
        super.init()
    }

    public init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        
        self.databaseID = snapshot.key
        
        super.init()
        
        /*for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                setValue(child.value, forKey: child.key)
            }
        }*/

    }
}
