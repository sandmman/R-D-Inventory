//
//  Extension.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 2/8/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation

func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach{ result[$0] = $1 }
    return result
}

extension Date {
    
    public var display: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        return formatter.string(from: self)
    }
    
    public var day: Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    public var month: Int? {
        return Calendar.current.dateComponents([.month], from: self).month
    }
}
