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

    static func createBuild(from form: Form, parts: [Part]) -> Build?

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

                return nil
        }

        return Part(name: name, uid: uid, manufacturer: manufacturer, leadTime: leadTime, countInAssembly: countInAssembly, countInStock: countInStock, countOnOrder: countOnOrder)
    }

    static func createBuild(from form: Form, parts: [Part]) -> Build? {

        guard let dateRow: DateInlineRow = form.rowBy(tag: Constants.BuildFields.Date),
            let quantityRow: IntRow = form.rowBy(tag: Constants.BuildFields.Quantity),
            let titleRow: TextRow = form.rowBy(tag: Constants.BuildFields.Title),
            let checkRow: SwitchRow = form.rowBy(tag: Constants.BuildFields.BType),
            let pushRow: PushRow<Assembly> = form.rowBy(tag: Constants.BuildFields.AssemblyID) else {
                return nil
        }

        guard let date = dateRow.value, let title = titleRow.value, let quantity = quantityRow.value, let type_bool = checkRow.value, let assembly = pushRow.value else {
            return nil
        }
        
        let type = type_bool ? BuildType.Custom : BuildType.Standard
        
        var partsNeeded = [String: Int]()
        
        for part in parts {
            if let row = form.rowBy(tag: part.key) as? StepperRow, let value = row.value {
                partsNeeded[part.key] = Int(value)
            }
        }
        
        return Build(type: type, title: title, quantity: quantity, partsNeeded: partsNeeded, scheduledFor: date, withAssembly: assembly.key)
    }

    static func createAssembly(from form: Form) -> Assembly? {
        return nil
    }
}

extension ObjectMapper {
    
    internal static func buildPartDict(dict: [String: Int], row: BaseRow, form: Form) -> [String: Int] {
        
        /*guard let count = (row as! StepperRow).value else {
            return dict
        }
        
        var dict = dict
        
        dict[row.key] = Int(count)*/
        
        return dict
    }
}
