//
//  ObjectMapper.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import Eureka

private protocol Mapper {

    static func createAssembly(from form: Form) -> Assembly?

    static func createBuild(from form: Form) -> Build?

    static func createPart(from form: Form) -> Part?
}

public class ObjectMapper: Mapper {
    
    static func createPart(from form: Form) -> Part? {

        guard form.validate().count == 0 else {
            return nil
        }

        let rows = form.values()

        guard let name = rows[Constants.PartFields.Name] as? String,
              let uid  = rows[Constants.PartFields.ID] as? String,
              let manufacturer = rows[Constants.PartFields.Manufacturer] as? String,
              let leadTime = rows[Constants.PartFields.LeadTime] as? Int,
              let countInAssembly = rows[Constants.PartFields.CountInAssembly] as? Int,
              let countInStock = rows[Constants.PartFields.CountInStock] as? Int,
              let countOnOrder = rows[Constants.PartFields.CountOnOrder] as? Int else {
                print("aahhhh")
                return nil
        }

        return Part(name: name, uid: uid, manufacturer: manufacturer, leadTime: leadTime, countInAssembly: countInAssembly, countInStock: countInStock, countOnOrder: countOnOrder)
    }

    static func createBuild(from form: Form) -> Build? {
        return nil
    }

    static func createAssembly(from form: Form) -> Assembly? {
        return nil
    }
}
