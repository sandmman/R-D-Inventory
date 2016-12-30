//
//  FIRDataObject.swift
//  Pods
//
//  Created by Aaron Liberatore on 12/29/16.
//
//

import UIKit
import Firebase

class FIRDataObject: NSObject {
    
    var snapshot: FIRDataSnapshot? = nil
    var key: String? { return snapshot?.key }
    var ref: FIRDatabaseReference? { return snapshot?.ref }
    
    override init() {
        super.init()
    }

    required init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot

        super.init()
        
        /*for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            print(child.value, child.key, responds(to: Selector(child.key)))
            if responds(to: Selector(child.key)) {
                print(2)
                setValue(child.value, forKey: child.key)
            }
        }*/

    }
}

protocol FIRDatabaseReferenceable {
    var ref: FIRDatabaseReference { get }
}

extension FIRDatabaseReferenceable {
    var ref: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
}
