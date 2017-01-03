//
//  Validator.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/2/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import Eureka

public class Validator {
    
    public static func checkPartIDFormat(field: UITextField, string: String?, str: String?) -> Bool {
        
        if string == "" {
            
            return true
            
        } else if str!.characters.count == 4 {
            
            field.text = field.text! + "-"
            
        } else if str!.characters.count == 10 {
            
            field.text = field.text! + "-"
            
        } else if str!.characters.count > 12 {
            
            return false
        }
        
        return true
    }

    public static func onValidationChanged(cell: PartIDCell, row: PartIDRow) {
        let rowIndex = row.indexPath!.row
        
        while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
            row.section?.remove(at: rowIndex + 1)
        }
        
        if !row.isValid {
            for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                let labelRow = LabelRow() {
                    $0.title = validationMsg
                    $0.cell.height = { 30 }
                }
                row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
            }
        }
    }
    
    public static func onValidationChanged(cell: TextCell, row: TextRow) {
        if !row.isValid {
            for (_, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                row.placeholder = validationMsg
                row.placeholderColor = UIColor.red
            }
        }
    }
    
    public static func onValidationChanged(cell: IntCell, row: IntRow) {
        let rowIndex = row.indexPath!.row
        
        while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
            row.section?.remove(at: rowIndex + 1)
        }
        
        if !row.isValid {
            for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                let labelRow = LabelRow() {
                    $0.title = validationMsg
                    $0.cell.height = { 30 }
                }
                row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
            }
        }
    }
}
