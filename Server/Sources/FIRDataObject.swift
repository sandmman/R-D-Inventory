//
//  FIRDataObject.swift
//  Pods
//
//  Created by Aaron Liberatore on 12/29/16.
//
//
import Foundation
import FirebaseSwift

public protocol FIRDataObject: Equatable {

    var key: String { get }

    init?(key: String, value: Any)
    
    func toAnyObject() -> Any

}

public extension FIRDataObject {
    
    /*public func delete() {
        guard let reference = ref else {
            return
        }
        
        reference.removeValue()
    }*/
}

public func ==<T: FIRDataObject>(lhs: T, rhs: T) -> Bool {
    return lhs.key == rhs.key
}
