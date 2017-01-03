//
//  PartIDField.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/2/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import Eureka

open class PartIDCell : _FieldCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .sentences
        textField.keyboardType = .numberPad
    }
}

public final class PartIDRow: FieldRow<PartIDCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}
