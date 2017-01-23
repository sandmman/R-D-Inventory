//
//  FirebaseTableViewDelegateProtocol.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/17/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

protocol FirebaseTableViewDelegate: class {

    var tableView: UITableView! { get set }
    
    func indexAdded<T: FIRDataObject>(at indexPath: IndexPath, data: T)

    func indexChanged<T: FIRDataObject>(at indexPath: IndexPath, data: T)

    func indexRemoved(at indexPath: IndexPath, key: String)

    func indexMoved<T: FIRDataObject>(at indexPath: IndexPath, to toIndexPath: IndexPath, data: T)
}

extension FirebaseTableViewDelegate {

    func indexAdded<T: FIRDataObject>(at indexPath: IndexPath, data: T) {
        tableView.insertRows(at: [indexPath], with: .none)
    }
    
    func indexChanged<T: FIRDataObject>(at indexPath: IndexPath, data: T) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func indexRemoved(at indexPath: IndexPath, key: String) {
        tableView.deleteRows(at: [indexPath], with: .none)
    }
    
    func indexMoved<T: FIRDataObject>(at indexPath: IndexPath, to toIndexPath: IndexPath, data: T) {
        tableView.moveRow(at: indexPath, to: toIndexPath)
    }
}
