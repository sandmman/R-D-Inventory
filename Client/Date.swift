//
//  Date.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/11/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation

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