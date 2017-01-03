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
    
    override public var hashValue : Int {
        return databaseID.hashValue
    }

    override init() {
        databaseID = UUID().uuidString
        super.init()
    }

    required public init?(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        
        self.databaseID = snapshot.key
        
        super.init()
    }
}

public func ==(lhs: FIRDataObject, rhs: FIRDataObject) -> Bool {
    print(lhs,rhs)
    return lhs.databaseID == rhs.databaseID
}
