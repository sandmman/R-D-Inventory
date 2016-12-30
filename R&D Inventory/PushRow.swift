//
//  PushRow.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/30/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import Foundation
import Eureka

public final class PartRow: SelectorRow<PushSelectorCell<IntRow>, BuildPartViewController>, RowType {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .show(controllerProvider: ControllerProvider.callback {
            return BuildPartViewController(){ _ in }
            }, onDismiss: { vc in
                _ = vc.navigationController?.popViewController(animated: true)
        })
    }
}
