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
    
    static func update(part: Part, from form: Form) -> Part?
    
    static func update(build: Build, from form: Form, parts: [Part]) -> Build?
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
        
        guard let row: TextRow = form.rowBy(tag: Constants.AssemblyFields.Name),
              let name = row.value,
              let assem = Assembly(name: name, parts: self.getAssemblyParts(form)) else {
                return nil
        }
        
        return assem
    }
    
    static func update(part: Part, from form: Form) -> Part? {
        
        var part = part
        var didUpdate = false

        let rows = form.values()
        
        if let name = rows[Constants.PartFields.Name] as? String {
            part.name = name
            didUpdate = true
        }
        if let uid  = rows[Constants.PartFields.ID] as? String {
            part.key = uid
            didUpdate = true
        }
        if let manufacturer = rows[Constants.PartFields.Manufacturer] as? String {
            part.manufacturer = manufacturer
            didUpdate = true
        }
        if let leadTime = rows[Constants.PartFields.LeadTime] as? Int {
            part.leadTime = leadTime
            didUpdate = true
        }
        if let countInAssembly = rows[Constants.PartFields.CountInAssembly] as? Int {
            part.countInAssembly = countInAssembly
            didUpdate = true
        }
        if let countInStock = rows[Constants.PartFields.CountInStock] as? Int {
            part.countInStock = countInStock
            didUpdate = true
        }
        if let countOnOrder = rows[Constants.PartFields.CountOnOrder] as? Int {
            part.countOnOrder = countOnOrder
            didUpdate = true
        }
        
        return didUpdate ? part : nil
        
    }

    static func update(build: Build, from form: Form, parts: [Part]) -> Build? {
        
        var build = build
        var didUpdate = false

        guard let dateRow: DateInlineRow = form.rowBy(tag: Constants.BuildFields.Date),
            let quantityRow: IntRow = form.rowBy(tag: Constants.BuildFields.Quantity),
            let titleRow: TextRow = form.rowBy(tag: Constants.BuildFields.Title),
            let checkRow: SwitchRow = form.rowBy(tag: Constants.BuildFields.BType) else {                return nil
            }
        
        if let title = titleRow.value {
            if build.title != title {
                build.title = title
                didUpdate = true
            }
        }
        if let quantity = quantityRow.value {
            if build.quantity != quantity {
                build.quantity = quantity
                didUpdate = true
            }
        }
        if let date = dateRow.value {
            if build.scheduledDate != date {
                build.scheduledDate = date
                didUpdate = true
            }
        }
        if let type_bool = checkRow.value {
            let type = type_bool ? BuildType.Custom : BuildType.Standard
            if build.type != type {
                build.type = type
                didUpdate = true
            }
            if type_bool {
                var partsNeeded = [String: Int]()
                
                for part in parts {
                    if let row = form.rowBy(tag: part.key) as? StepperRow, let value = row.value {
                        partsNeeded[part.key] = Int(value)
                    }
                }
                if build.partsNeeded != partsNeeded {
                    build.partsNeeded = partsNeeded
                    didUpdate = true
                }
            }
        }
        
        return didUpdate ? build : nil
    }
}

extension ObjectMapper {
    
    // Helper
    
    fileprivate static func getAssemblyParts(_ form: Form) -> [String: Int] {
        
        guard let partRows = form.allSections.last else {
            return [:]
        }
        return partRows.reduce([String: Int](), createPartDict)
    }
    
    fileprivate static func createPartDict(dict: [String: Int], nextPartRow: BaseRow) -> [String: Int] {
        guard let partRow = nextPartRow as? PartRow, let part = partRow.value else {
            return dict
        }
        
        var dict = dict
        
        dict[part.key] = part.countInAssembly
        
        return dict
        
    }
}
