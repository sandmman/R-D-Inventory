//
//  PartTableViewCell.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

import UIKit

protocol PartTableViewCellDelegate {
    func didIncrementCellAtIndexPath(indexPath: IndexPath)
    func didDecrementCellAtIndexPath(indexPath: IndexPath)
}

class PartTableViewCell: UITableViewCell {
    
    @IBOutlet var partCountLabel: UILabel!
    
    var delegate: PartTableViewCellDelegate?
    var indexPath: IndexPath?
    
    @IBAction func incrementButtonPressed(sender: UIButton) {
        if let indexPath = indexPath, let delegate = delegate {
            delegate.didIncrementCellAtIndexPath(indexPath: indexPath)
        }
    }
    @IBAction func decrementButtonPressed(sender: UIButton) {
        if let indexPath = indexPath, let delegate = delegate {
            delegate.didDecrementCellAtIndexPath(indexPath: indexPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
