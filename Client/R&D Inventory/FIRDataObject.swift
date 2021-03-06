//
//  FIRDataObject.swift
//  Pods
//
//  Created by Aaron Liberatore on 12/29/16.
//
//

import UIKit
import Firebase

public protocol FIRDataObject: Equatable {

    var key: String { get }

    var ref: FIRDatabaseReference? { get }

    init?(snapshot: FIRDataSnapshot)
    
    func toAnyObject() -> Any

    static func rootRef(with project: Project?) -> FIRDatabaseReference
}

public extension FIRDataObject {
    
    public func delete() {
        guard let reference = ref else {
            return
        }
        
        reference.removeValue()
    }
}

public func ==<T: FIRDataObject>(lhs: T, rhs: T) -> Bool {
    return lhs.key == rhs.key
}
