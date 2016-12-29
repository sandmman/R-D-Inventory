//
//  Assembly.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class Assembly: NSObject {

    let name: String
    
    let identifier: Int

    let parts: [Part]
    
    init?(name: String, parts: [Part]) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
    
        self.name = name
        // Auto generated? user generated?
        self.identifier = 0

        self.parts = parts

    }
    
}
