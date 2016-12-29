//
//  Part.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class Part: NSObject {

    let name: String

    let uid: Int

    let manufacturer: String

    let leadTime: Date

    let countSubParts: Int

    let countInStock: Int

    let countOnOrder: Int
    
    init?(name: String, uid: Int, manufacturer: String, leadTime: Date, countSubParts: Int, countInStock: Int, countOnOrder: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // Nothing should be negative
        if (countSubParts < 0 || countInStock < 0 || countOnOrder < 0) {
            return nil
        }
        
        self.name = name
        self.uid = uid
        self.manufacturer = manufacturer
        self.leadTime = leadTime
        self.countSubParts = countSubParts
        self.countInStock = countInStock
        self.countOnOrder = countOnOrder

    }
    
    
}
