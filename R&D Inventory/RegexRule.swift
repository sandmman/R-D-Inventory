//
//  RegexRule.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import Eureka

public class RegexRule: RuleType {
    
    public var regExpr: String = ""
    public var id: String?
    public var validationError = ValidationError(msg: "Invalid Part ID Format!")
    public var allowsEmpty = true
    
    public init(regExpr: String, allowsEmpty: Bool = true){
        self.regExpr = regExpr
        self.allowsEmpty = allowsEmpty
    }
    
    public func isValid(value: Int?) -> ValidationError? {
        print("testing", value)
        if let v = value {
            print("testing", v)
            let value = String(v)
            let predicate = NSPredicate(format: "SELF MATCHES %@", regExpr)
            print(value, predicate)
            guard predicate.evaluate(with: value) else {
                return validationError
            }
            return nil
        }
        else if !allowsEmpty {
            return validationError
        }
        return nil
    }
}
